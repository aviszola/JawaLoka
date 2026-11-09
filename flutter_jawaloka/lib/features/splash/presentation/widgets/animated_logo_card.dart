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
    // Gentle floating sine wave for alive loading sensation
    final double floatOffset = math.sin(floatPhase * math.pi * 2) * 2.5;

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
            border: Border.all(
              color: AppColors.amberDark.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.09),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: JavaneseGlyphWidget(
              size: 52,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

