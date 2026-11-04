import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom vector painter for the Javanese panorama:
/// Features Mount Merapi/Lawu silhouette, rising dawn sun with aura,
/// and lush 4-tier terraced rice fields (terasering sawah) with water glints.
class JavaneseLandscapePainter extends CustomPainter {
  final double entranceProgress;
  final double sunPulse;
  final double shimmerProgress;

  JavaneseLandscapePainter({
    this.entranceProgress = 1.0,
    this.sunPulse = 0.0,
    this.shimmerProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();

    // Scale canvas coordinates from reference 412x220 to actual size
    final double sx = size.width / 412.0;
    final double sy = size.height / 220.0;
    canvas.scale(sx, sy);

    // Staggered entrance offsets: elements smoothly slide up into place
    final double mountainSlide = (1.0 - entranceProgress) * 40.0;
    final double terraceSlide = (1.0 - entranceProgress) * 60.0;
    final double sunSlide = (1.0 - entranceProgress) * 80.0;

    // 1. Sunrise Aura & Radiant Glow
    final double pulseFactor = 1.0 + (math.sin(sunPulse * math.pi * 2) * 0.08);
    final double sunGlowRadius = 110.0 * pulseFactor;
    final Offset sunCenter = Offset(206.0, 115.0 + sunSlide);

    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          AppColors.sunriseGlow.withValues(alpha: 0.9 * entranceProgress),
          AppColors.accentOrange.withValues(alpha: 0.35 * entranceProgress),
          AppColors.amber.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunGlowRadius));

    canvas.drawCircle(sunCenter, sunGlowRadius, glowPaint);

    // 2. Rising Sun Disc (Outer & Core)
    final Offset sunDiscCenter = Offset(206.0, 108.0 + sunSlide);
    final Paint sunOuterPaint = Paint()
      ..color = AppColors.sunCore.withValues(alpha: 0.88 * entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunDiscCenter, 32.0, sunOuterPaint);

    final Paint sunInnerPaint = Paint()
      ..color = AppColors.sunHighlight.withValues(alpha: 0.96 * entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunDiscCenter, 26.0, sunInnerPaint);

    // 3. Distant Volcano Silhouette (Merapi / Lawu cone)
    canvas.save();
    canvas.translate(0, mountainSlide * 0.7);

    final Path volcanoFarPath = Path()
      ..moveTo(120, 160)
      ..lineTo(198, 68)
      ..cubicTo(202, 63, 210, 63, 214, 68)
      ..lineTo(292, 160)
      ..close();

    final Paint volcanoFarPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.volcanoFarStart, AppColors.volcanoFarEnd],
      ).createShader(const Rect.fromLTWH(120, 50, 172, 110))
      ..color = Colors.white.withValues(alpha: 0.88 * entranceProgress);
    canvas.drawPath(volcanoFarPath, volcanoFarPaint);

    // Volcano Crater Notch Detail
    final Path craterPath = Path()
      ..moveTo(201, 72)
      ..quadraticBezierTo(206, 75, 211, 72)
      ..lineTo(214, 68)
      ..lineTo(198, 68)
      ..close();
    final Paint craterPaint = Paint()
      ..color = AppColors.sunCore.withValues(alpha: 0.35 * entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(craterPath, craterPaint);

    // Secondary Mountain Ridges
    final Path ridgeLeft = Path()
      ..moveTo(30, 165)
      ..lineTo(125, 95)
      ..cubicTo(129, 92, 135, 93, 138, 97)
      ..lineTo(215, 165)
      ..close();
    final Paint ridgePaint1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.volcanoNearStart, AppColors.volcanoNearEnd],
      ).createShader(const Rect.fromLTWH(30, 90, 185, 75))
      ..color = Colors.white.withValues(alpha: 0.92 * entranceProgress);
    canvas.drawPath(ridgeLeft, ridgePaint1);

    final Path ridgeRight = Path()
      ..moveTo(225, 165)
      ..lineTo(295, 105)
      ..cubicTo(298, 102, 304, 103, 307, 107)
      ..lineTo(385, 165)
      ..close();
    final Paint ridgePaint2 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.volcanoNearStart, AppColors.volcanoNearEnd],
      ).createShader(const Rect.fromLTWH(225, 100, 160, 65))
      ..color = Colors.white.withValues(alpha: 0.78 * entranceProgress);
    canvas.drawPath(ridgeRight, ridgePaint2);

    canvas.restore();

    // 4. Rice Terraces (Terasering) - 4 Tiers
    canvas.save();
    canvas.translate(0, terraceSlide);

    // Tier 1 (Soft warm olive green)
    final Path terrace1 = Path()
      ..moveTo(-10, 148)
      ..cubicTo(60, 140, 130, 152, 210, 142)
      ..cubicTo(290, 132, 355, 146, 422, 138)
      ..lineTo(422, 222)
      ..lineTo(-10, 222)
      ..close();
    final Paint terracePaint1 = Paint()
      ..color = AppColors.terraceTier1.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(terrace1, terracePaint1);

    // Tier 2 (Fresh leafy green)
    final Path terrace2 = Path()
      ..moveTo(-10, 168)
      ..cubicTo(75, 160, 165, 174, 250, 162)
      ..cubicTo(330, 150, 375, 166, 425, 158)
      ..lineTo(425, 222)
      ..lineTo(-10, 222)
      ..close();
    final Paint terracePaint2 = Paint()
      ..color = AppColors.terraceTier2.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(terrace2, terracePaint2);

    // Tier 3 (Lush deep terrace contour)
    final Path terrace3 = Path()
      ..moveTo(-10, 186)
      ..cubicTo(90, 180, 180, 192, 270, 182)
      ..cubicTo(340, 174, 380, 184, 425, 180)
      ..lineTo(425, 222)
      ..lineTo(-10, 222)
      ..close();
    final Paint terracePaint3 = Paint()
      ..color = AppColors.terraceTier3.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(terrace3, terracePaint3);

    // Tier 4 (Foreground slope)
    final Path terrace4 = Path()
      ..moveTo(-10, 202)
      ..cubicTo(110, 196, 220, 206, 310, 198)
      ..cubicTo(365, 194, 395, 200, 425, 198)
      ..lineTo(425, 222)
      ..lineTo(-10, 222)
      ..close();
    final Paint terracePaint4 = Paint()
      ..color = AppColors.terraceTier4.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(terrace4, terracePaint4);

    // 5. Water Paddy Glints (Reflective water highlights with gentle shimmer)
    final double shimmerOscillation = (math.sin(shimmerProgress * math.pi * 2) * 0.15);

    final Paint glintPaint1 = Paint()
      ..color = AppColors.waterGlint.withValues(
        alpha: (0.42 + shimmerOscillation).clamp(0.1, 0.7) * entranceProgress,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final Path glintPath1 = Path()
      ..moveTo(40, 162)
      ..cubicTo(80, 160, 110, 162, 130, 164);
    canvas.drawPath(glintPath1, glintPaint1);

    final Paint glintPaint2 = Paint()
      ..color = AppColors.waterGlint.withValues(
        alpha: (0.36 + shimmerOscillation).clamp(0.1, 0.6) * entranceProgress,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final Path glintPath2 = Path()
      ..moveTo(280, 155)
      ..cubicTo(310, 153, 340, 156, 360, 157);
    canvas.drawPath(glintPath2, glintPaint2);

    final Paint glintPaint3 = Paint()
      ..color = AppColors.waterGlint.withValues(
        alpha: (0.32 + shimmerOscillation).clamp(0.1, 0.5) * entranceProgress,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final Path glintPath3 = Path()
      ..moveTo(160, 180)
      ..cubicTo(200, 178, 230, 181, 250, 182);
    canvas.drawPath(glintPath3, glintPaint3);

    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant JavaneseLandscapePainter oldDelegate) {
    return oldDelegate.entranceProgress != entranceProgress ||
        oldDelegate.sunPulse != sunPulse ||
        oldDelegate.shimmerProgress != shimmerProgress;
  }
}

