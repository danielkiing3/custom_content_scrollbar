import '../control_input_enum.dart';
import 'custom_list_wheel_scroll_view.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'portrait_linear_progress_indicator.dart';
import 'portrait_scroll_container.dart';
import 'portrait_scroll_header.dart';

class PortraitScrollSelector extends StatefulWidget {
  const PortraitScrollSelector({
    super.key,
    required this.progressNotifier,
    required this.articleDurationLength,
    required this.title,
    required this.authorName,
    required this.contentHeader,
    required this.currentSectionIndex,
    required this.contentKeys,
    required this.fixedExtentScrollController,
    required this.interactionSource,
    required this.debouncer,
  });

  final ValueNotifier<double> progressNotifier;
  final Duration articleDurationLength;
  final String title;
  final String authorName;
  final List<String> contentHeader;
  final ValueNotifier<int> currentSectionIndex;
  final List<GlobalKey> contentKeys;
  final FixedExtentScrollController fixedExtentScrollController;
  final ValueNotifier<ScrollInput> interactionSource;
  final VoidCallback debouncer;

  @override
  State<PortraitScrollSelector> createState() => _PortraitScrollSelectorState();
}

class _PortraitScrollSelectorState extends State<PortraitScrollSelector> with SingleTickerProviderStateMixin {
  static const double closedHeight = 54;
  static const double expandedHeight = 280;
  static const Duration duration = Duration(milliseconds: 300);

  late final AnimationController _controller;
  late final _PortraitScrollAnimations animations;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    animations = _PortraitScrollAnimations.fromController(
      controller: _controller,
      closedHeight: closedHeight,
      expandedHeight: expandedHeight,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Callback to toggle the expand state
  void toggleExpanded() {
    if (isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    // Update the state of [isExpanded]
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpanded,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return PortraitScrollContainer(
            margin: EdgeInsets.symmetric(horizontal: animations.margin.value),
            padding: EdgeInsets.all(animations.padding.value),
            height: animations.contentHeight.value,
            maxHeight: math.max(closedHeight, expandedHeight),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // -- Top header row with avatar and title
                PortraitScrollHeader(
                  title: widget.title,
                  authorName: widget.authorName,
                  avatarSize: animations.avatarSize.value,
                  avatarBorderRadius: animations.avatarRadius.value,
                  circularOpacity: animations.circularIndicatorOpacity.value,
                  authorOpacity: animations.authorOpacity.value,
                  progressNotifier: widget.progressNotifier,
                ),

                // -- Article Sub content heading
                if (child case final Widget widget?) widget,
              ],
            ),
          );
        },
        child: Column(
          spacing: 20,
          children: <Widget>[
            // -- Custom List Wheel
            SizedBox(
              height: 102,
              child: CustomListWheelScrollView(
                contentHeaders: widget.contentHeader,
                currentSubContentIndexNotifier: widget.currentSectionIndex,
                contentKeys: widget.contentKeys,
                customListWheelController: widget.fixedExtentScrollController,
                activeControlNotifier: widget.interactionSource,
                debouncer: widget.debouncer,
              ),
            ),

            // -- Linear Progress
            PortraitLinearProgressIndicator(
              progressNotifier: widget.progressNotifier,
              articleDurationLength: widget.articleDurationLength,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom class for easier management of [PortraitScrollSelector] animation
class _PortraitScrollAnimations {
  const _PortraitScrollAnimations({
    required this.contentHeight,
    required this.margin,
    required this.padding,
    required this.avatarSize,
    required this.avatarRadius,
    required this.circularIndicatorOpacity,
    required this.authorOpacity,
  });
  factory _PortraitScrollAnimations.fromController({
    required AnimationController controller,
    required double closedHeight,
    required double expandedHeight,
  }) {
    final CurvedAnimation curved = CurvedAnimation(parent: controller, curve: curve);
    return _PortraitScrollAnimations(
      contentHeight: Tween<double>(begin: closedHeight, end: expandedHeight).animate(curved),
      margin: Tween<double>(begin: 40, end: 20).animate(curved),
      padding: Tween<double>(begin: 12, end: 24).animate(curved),
      avatarSize: Tween<double>(begin: 30, end: 60).animate(curved),
      avatarRadius: Tween<double>(begin: 100, end: 12).animate(curved),
      circularIndicatorOpacity: Tween<double>(begin: 1, end: 0).animate(curved),
      authorOpacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Interval(0.2, 1, curve: curve))),
    );
  }

  static Curve curve = Curves.easeInOut;

  final Animation<double> contentHeight;
  final Animation<double> margin;
  final Animation<double> padding;
  final Animation<double> avatarSize;
  final Animation<double> avatarRadius;
  final Animation<double> circularIndicatorOpacity;
  final Animation<double> authorOpacity;
}
