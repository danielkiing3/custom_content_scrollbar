import 'dart:async';

import 'models/article.dart';
import 'models/article_subcontent.dart';
import 'utils/constants/breakpoint.dart';
import 'widgets/article_content_body.dart';
import 'widgets/control_input_enum.dart';
import 'widgets/landspace_scroll_selector/landspace_scroll_selector.dart';
import 'widgets/portrait_scroll_selector/portrait_scroll_selector.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.article});

  final Article article;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> with ArticleScrollSyncController<ArticleScreen> {
  @override
  void initState() {
    super.initState();
    initScrollSync(widget.article.subContent);
  }

  @override
  void dispose() {
    disposeScrollSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const BackButton(), surfaceTintColor: Colors.transparent, backgroundColor: Colors.white),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isTablet = constraints.maxWidth > kLargeScreenExtent;

            return Stack(
              children: <Widget>[
                // -- Article Content
                ArticleContentList(
                  scrollController: _scrollController,
                  subContentKeys: _subContentKey,
                  articleTitle: widget.article.title,
                  subContent: widget.article.subContent,
                ),

                // -- Portrait Scroll Selector
                if (!isTablet)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: PortraitScrollSelector(
                      title: widget.article.title,
                      authorName: widget.article.author,
                      progressNotifier: _progressNotifier,
                      contentHeader: _subContentHeaderList,
                      articleDurationLength: widget.article.articleTime,
                      contentKeys: _subContentKey,
                      fixedExtentScrollController: _wheelController,
                      interactionSource: _interactionSource,
                      debouncer: _debounceScrollInputReset,
                    ),
                  ),

                // -- Landspace Scroll Selector
                if (isTablet)
                  Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: LandspaceScrollSelector(
                      progressNotifier: _progressNotifier,
                      currentSectionIndex: _currentSectionIndex,
                      contentHeader: _subContentHeaderList,
                      activeControlNotifier: _interactionSource,
                      debouncer: _debounceScrollInputReset,
                      contentKeys: _subContentKey,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Mixin to manage all controller and notifiers
// Handling deboucning as well
mixin ArticleScrollSyncController<T extends StatefulWidget> on State<T> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<int> _currentSectionIndex = ValueNotifier<int>(0);
  final ValueNotifier<ScrollInput> _interactionSource = ValueNotifier<ScrollInput>(ScrollInput.none);
  final FixedExtentScrollController _wheelController = FixedExtentScrollController();

  Timer? _scrollInputCooldown;
  late final List<GlobalKey> _subContentKey;
  late final List<String> _subContentHeaderList;

  static Duration debounceDuration = const Duration(milliseconds: 300);
  static Duration wheelScrollDuration = const Duration(milliseconds: 300);
  static Curve wheelScrollCurve = Curves.easeOut;

  void initScrollSync(List<ArticleSubcontent> subContent) {
    _scrollController
      ..addListener(_updateCurrentContentIndex)
      ..addListener(_updateProgressNotifier);

    _subContentKey = List<GlobalKey>.generate(subContent.length, (int index) => GlobalKey());

    _subContentHeaderList = subContent.map((ArticleSubcontent e) => e.heading).toList();
  }

  /// Updating the current sub content index
  void _updateCurrentContentIndex() {
    if (_interactionSource.value == ScrollInput.wheel) return;
    _interactionSource.value = ScrollInput.article;

    final int bestIndex = _calculateVisibleSectionIndex();

    if (_currentSectionIndex.value != bestIndex) {
      _currentSectionIndex.value = bestIndex;
      _wheelController.animateToItem(bestIndex, duration: wheelScrollDuration, curve: wheelScrollCurve);
    }

    _debounceScrollInputReset();
  }

  /// Callback to update the [_progressNotifier] with value from
  /// [_scrollController] current offset value
  void _updateProgressNotifier() {
    if (!_scrollController.hasClients || !_scrollController.position.hasContentDimensions) {
      return;
    }

    final double max = _scrollController.position.maxScrollExtent;
    final double current = _scrollController.position.pixels;
    final double progress = (current / max).clamp(0.0, 1.0);

    _progressNotifier.value = progress;
  }

  /// Debouncing the [ScrollInput] change
  void _debounceScrollInputReset() {
    _scrollInputCooldown?.cancel();
    _scrollInputCooldown = Timer(debounceDuration, () {
      _interactionSource.value = ScrollInput.none;
    });
  }

  /// Calculate the most visible section of sub content by tapping into the render box and doing some basic math
  int _calculateVisibleSectionIndex() {
    final double screenHeight = MediaQuery.sizeOf(context).height;

    double bestVisibility = 0.0;
    int bestIndex = 0;

    for (int i = 0; i < _subContentKey.length; i++) {
      final BuildContext? context = _subContentKey[i].currentContext;
      if (context == null) continue;

      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) continue;

      final double yPos = renderBox.localToGlobal(Offset.zero).dy;
      final Size size = renderBox.size;

      final double visibleTop = yPos.clamp(0.0, screenHeight);
      final double visibleBottom = (yPos + size.height).clamp(0.0, screenHeight);
      final double visibleHeight = visibleBottom - visibleTop;
      final double visibilityFraction = visibleHeight / size.height;

      // 0.05 to buffer value
      if (visibilityFraction > bestVisibility + 0.05) {
        bestVisibility = visibilityFraction;
        bestIndex = i;
      }
    }

    return bestIndex;
  }

  /// Resource cleanup
  void disposeScrollSync() {
    _scrollController
      ..removeListener(_updateCurrentContentIndex)
      ..removeListener(_updateProgressNotifier)
      ..dispose();
    _progressNotifier.dispose();
    _interactionSource.dispose();
    _currentSectionIndex.dispose();
    super.dispose();
  }
}
