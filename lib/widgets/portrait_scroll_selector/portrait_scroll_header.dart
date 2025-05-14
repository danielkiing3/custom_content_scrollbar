import 'package:flutter/material.dart';

import '../../utils/constants/images.dart';
import '../../utils/theme/app_text_styles.dart';
import 'animated_circular_progress_bar.dart';

class PortraitScrollHeader extends StatelessWidget {
  const PortraitScrollHeader({
    super.key,
    required this.title,
    required this.authorName,
    required this.avatarSize,
    required this.avatarBorderRadius,
    required this.circularOpacity,
    required this.authorOpacity,
    required this.progressNotifier,
  });

  final String title;
  final String authorName;
  final double avatarSize;
  final double avatarBorderRadius;
  final double circularOpacity;
  final double authorOpacity;
  final ValueNotifier<double> progressNotifier;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: avatarSize,
                width: avatarSize,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(avatarBorderRadius)),
                child: Image.asset(AppImages.avaterImage, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // -- Titile
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Opacity(
                    opacity: authorOpacity,
                    child: Text(
                      authorName,
                      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // -- Circular Indicator
          RepaintBoundary(
            child: Opacity(
              opacity: circularOpacity,
              child: ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (_, double progress, _) {
                  return AnimatedCircularProgress(progress: progress);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
