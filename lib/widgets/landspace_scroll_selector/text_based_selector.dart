import 'package:flutter/material.dart';

import '../../utils/theme/app_text_styles.dart';
import '../control_input_enum.dart';

class TextBasedSelector extends StatelessWidget {
  const TextBasedSelector({
    super.key,
    required this.currentSectionIndex,
    required this.contentHeader,
    required this.activeControlNotifier,
    required this.debouncer,
    required this.contentKeys,
    required this.contentHeight,
  });

  final ValueNotifier<int> currentSectionIndex;
  final List<String> contentHeader;
  final ValueNotifier<ScrollInput> activeControlNotifier;
  final VoidCallback debouncer;
  final List<GlobalKey> contentKeys;
  final double contentHeight;

  static const Curve _curve = Curves.easeOut;
  static const Duration _duration = Duration(milliseconds: 400);
  static const double paddingValue = 24.0;

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (contentHeight - (2 * paddingValue)) / contentHeader.length;

    return Padding(
      padding: const EdgeInsets.only(top: paddingValue, left: paddingValue, bottom: paddingValue),
      child: ValueListenableBuilder<int>(
        valueListenable: currentSectionIndex,
        builder: (_, int selectedIndex, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(contentHeader.length, (int index) {
              final bool isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  if (activeControlNotifier.value == ScrollInput.article) return;

                  activeControlNotifier.value = ScrollInput.wheel;

                  // Scroll to new active index
                  final BuildContext? targetContent = contentKeys[index].currentContext;
                  if (targetContent != null) {
                    Scrollable.ensureVisible(targetContent, duration: _duration, curve: _curve);
                  }

                  debouncer();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: itemHeight,
                  child: Text(
                    contentHeader[index],
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.5),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
