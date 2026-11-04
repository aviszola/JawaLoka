import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'javanese_glyph_painter.dart';

/// Interactive & animated central brand logo card for JawaLoka.
/// Features 96x96 tile with 28px radius, diffused soft shadows,
/// floating sine-wave breathing, and stylized Aksara Jawa glyph "ꦗ".
class AnimatedLogoCard extends StatelessWidget {
  final double scaleProgress;
  final double floatPhase;

  const AnimatedLogoCard({
    super.key,
    required this.scaleProgress,
    this.floatPhase = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    // Gentle floating sine wave for floating sensation
    final double floatOffset = math.sin(floatPhase * math.pi * 2) * 3.5;

    return Transform.translate(
      offset: Offset(0, floatOffset),
      child: Transform.scale(
        scale: scaleProgress,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.14),
                blurRadius: 32,
                spreadRadius: 2,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              // Subtle golden aura border reflection
              BoxShadow(
                color: AppColors.amberDark.withValues(alpha: 0.08),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              // Aksara Jawa Glyph "ꦗ" (Ja)
              const JavaneseGlyphWidget(
                size: 50,
                color: AppColors.ink,
              ),
              const SizedBox(height: 2),
              // Tiny stylized logo label
              Text(
                'LOGO',
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.38),
                  fontSize: 9.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

