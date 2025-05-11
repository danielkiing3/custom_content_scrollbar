import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedCircularProgress extends StatelessWidget {

  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.size = 30,
    this.color = Colors.white,
    this.strokeWidth = 4.0,
  });
  final double progress;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CircularProgressPainter(progress: progress, color: color, strokeWidth: strokeWidth),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {

  _CircularProgressPainter({required this.progress, required this.color, required this.strokeWidth});
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint =
        Paint()
          ..color = color.withValues(alpha: .4)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final Paint foregroundPaint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Offset center = size.center(Offset.zero);
    final double radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
