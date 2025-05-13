import '../../utils/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../control_input_enum.dart';

/// Custom ListWheelScrollView for selecting the current active content
class CustomListWheelScrollView extends StatelessWidget {
  const CustomListWheelScrollView({
    super.key,
    required this.contentHeaders,
    required this.contentKeys,
    required this.currentSubContentIndexNotifier,
    required this.customListWheelController,
    required this.activeControlNotifier,
    required this.debouncer,
  });

  final List<GlobalKey> contentKeys;
  final List<String> contentHeaders;
  final ValueNotifier<int> currentSubContentIndexNotifier;
  final FixedExtentScrollController customListWheelController;
  final ValueNotifier<ScrollInput> activeControlNotifier;
  final VoidCallback debouncer;

  static const Curve _curve = Curves.easeOut;
  static const Duration _duration = Duration(milliseconds: 400);
  static const double _itemExtent = 34.0;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: customListWheelController,
      itemExtent: _itemExtent,
      overAndUnderCenterOpacity: 0.2,
      diameterRatio: 5,
      onSelectedItemChanged: (int index) {
        // Guard to prevent scroll update when article scroll is ongoing
        if (activeControlNotifier.value == ScrollInput.article) return;
        activeControlNotifier.value = ScrollInput.wheel;

        // Scroll to new active index
        final BuildContext? targetContent = contentKeys[index].currentContext;
        if (targetContent != null) {
          Scrollable.ensureVisible(targetContent, duration: _duration, curve: _curve);
        }

        // Debouncing
        debouncer();
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: contentHeaders.length,
        builder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              contentHeaders[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
