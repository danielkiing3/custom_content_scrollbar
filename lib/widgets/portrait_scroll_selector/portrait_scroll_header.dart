import 'package:flutter/material.dart';

import '../../utils/constants/images.dart';
import '../../utils/theme/app_text_styles.dart';
import 'animated_circular_progress_bar.dart';

class PortraitScrollHeader extends StatelessWidget {
  const PortraitScrollHeader({
    super.key,
    required this.title,
    required this.avatarSize,
    required this.avatarBorderRadius,
    required this.circularOpacity,
    required this.progressNotifier,
  });

  final String title;
  final double avatarSize;
  final double avatarBorderRadius;
  final double circularOpacity;
  final ValueNotifier<double> progressNotifier;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
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

              // -- Titile
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
