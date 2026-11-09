import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Single particle model for celebratory floating confetti.
class ConfettiParticle {
  final double x; // Normalized 0.0 – 1.0 horizontal position
  final double yStart; // Normalized vertical start (can be negative for staggered entry)
  final double speed; // Vertical speed multiplier
  final double size; // Particle diameter / width
  final Color color;
  final bool isCircle;
  final double rotationSpeed; // Multiplier for rotation, 0.0 for static orientation

  const ConfettiParticle({
    required this.x,
    required this.yStart,
    required this.speed,
    required this.size,
    required this.color,
    required this.isCircle,
    this.rotationSpeed = 0.0,
  });
}

/// Shared celebration confetti painter for QuizResultScreen and LevelUpScreen.
/// Renders falling, rotating festive particles with gentle bottom fading.
class CelebrationConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress; // 0.0 – 1.0 from AnimationController

  /// Curated palette for JawaLoka celebration moments
  static const List<Color> defaultPalette = [
    AppColors.amber,
    AppColors.pastelMint,
    AppColors.pastelLavender,
    AppColors.pastelBlush,
    Colors.white,
    AppColors.accentOrange,
    AppColors.amberDark,
  ];

  const CelebrationConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final double normY = (p.yStart + progress * p.speed) % 1.2;
      // Fade out smoothly near bottom to prevent abrupt pop
      final double opacity = normY > 0.85
          ? (1.0 - (normY - 0.85) / 0.35).clamp(0.0, 1.0)
          : 1.0;
      if (opacity <= 0.0) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill;

      final double cx = p.x * size.width;
      final double cy = normY * size.height;

      if (p.isCircle) {
        canvas.drawCircle(Offset(cx, cy), p.size / 2, paint);
      } else {
        if (p.rotationSpeed != 0.0) {
          canvas.save();
          canvas.translate(cx, cy);
          canvas.rotate(progress * p.rotationSpeed * math.pi);
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.65,
            ),
            paint,
          );
          canvas.restore();
        } else {
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(cx, cy),
              width: p.size,
              height: p.size * 0.6,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CelebrationConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

