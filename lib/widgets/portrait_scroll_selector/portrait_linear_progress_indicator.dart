import 'package:flutter/material.dart';

import '../../utils/helper_function/duration_helper.dart';
import '../../utils/theme/app_text_styles.dart';

class PortraitLinearProgressIndicator extends StatelessWidget {
  const PortraitLinearProgressIndicator({
    super.key,
    required this.progressNotifier,
    required this.articleDurationLength,
  });

  final ValueNotifier<double> progressNotifier;
  final Duration articleDurationLength;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (_, double progress, _) {
          final Duration currentDuration = articleDurationLength * progress;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: <Widget>[
              Text(
                DurationHelper.toMinutesSecondsString(currentDuration),
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),

              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  color: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100),
                  minHeight: 8,
                ),
              ),

              Text(
                DurationHelper.toMinutesSecondsString(articleDurationLength),
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
