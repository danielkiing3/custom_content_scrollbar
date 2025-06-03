import 'package:flutter/material.dart';

class StickIndicator extends StatelessWidget {
  const StickIndicator({
    super.key,
    required this.itemCount,
    required this.currentSectionIndex,
    required this.isVerticalPickerExpanded,
    required this.contentHeight,
  });
  final int itemCount;
  final ValueNotifier<int> currentSectionIndex;
  final ValueNotifier<bool> isVerticalPickerExpanded;
  final double contentHeight;

  static double paddingValue = 24.0;

  double computeOpacity(int distance) {
    const int maxDistance = 3;
    const double minOpacity = 0.4;
    const double maxOpacity = 1.0;

    final int cappedDistance = distance.clamp(0, maxDistance);
    final double t = 1 - (cappedDistance / maxDistance);

    return minOpacity + (maxOpacity - minOpacity) * t;
  }

  @override
  Widget build(BuildContext context) {
    final double contentWidth = (contentHeight - (paddingValue * 2)) / itemCount;

    return Padding(
      padding: EdgeInsets.only(top: paddingValue, bottom: paddingValue, right: 16),
      child: ValueListenableBuilder<int>(
        valueListenable: currentSectionIndex,
        builder: (_, int selectedIndex, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: isVerticalPickerExpanded,
            builder: (_, bool isExpanded, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List<Widget>.generate(itemCount, (int index) {
                  const double lineHeight = 2;
                  final int distance = (index - selectedIndex).abs();

                  final double lineWidth = (distance == 0 && isExpanded) ? 32 : 24;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: (contentWidth - lineHeight) / 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      height: lineHeight,
                      width: lineWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: computeOpacity(distance)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
