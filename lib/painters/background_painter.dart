import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BackgroundPainter extends CustomPainter {
  final double progress;

  BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final gradH = size.height * 0.52;
    final rect = Rect.fromLTWH(0, 0, size.width, gradH);

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.bgDotGradientStart.withValues(alpha: progress),
        AppColors.bgDotGradientMid.withValues(alpha: progress * 0.75),
        Colors.transparent,
      ],
      stops: const [0.0, 0.55, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    const spacing = 20.0;
    const dotR = 1.3;
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final cx = size.width / 2;

    for (double dy = 0; dy < gradH; dy += spacing) {
      for (double dx = 0; dx < size.width + spacing; dx += spacing) {
        final distFromCenter = math.sqrt((dx - cx) * (dx - cx) + dy * dy);
        final maxDist = math.sqrt(cx * cx + gradH * gradH);
        final distRatio = (distFromCenter / maxDist).clamp(0.0, 1.0);
        final verticalFade = (1.0 - (dy / gradH)).clamp(0.0, 1.0);
        final opacity = distRatio * 0.55 * verticalFade * 0.45 * progress;
        if (opacity < 0.015) continue;
        dotPaint.color = AppColors.bgDot.withValues(alpha: opacity);
        canvas.drawCircle(Offset(dx, dy), dotR, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter old) => old.progress != progress;
}
