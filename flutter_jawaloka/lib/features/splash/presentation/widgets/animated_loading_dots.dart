import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Animated 3-dot loading indicator matching Google Stitch design:
/// Features continuous traveling wave animation with smooth scaling and opacity.
class AnimatedLoadingDots extends StatelessWidget {
  final double animationValue; // 0.0 to 1.0 looped

  const AnimatedLoadingDots({
    super.key,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        // Calculate phase shift for each dot (0, 1, 2)
        // This produces a fluid traveling wave from left to right.
        final double phase = (animationValue - (index * 0.28)) % 1.0;
        final double sinVal = math.sin(phase * math.pi * 2);

        // Map sine wave (-1 to 1) to smooth scaling and opacity
        final double intensity = (sinVal + 1.0) / 2.0; // 0.0 to 1.0
        final double scale = 0.95 + (intensity * 0.40); // 0.95 to 1.35
        final double opacity = 0.38 + (intensity * 0.62); // 0.38 to 1.0

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: opacity),
                shape: BoxShape.circle,
                boxShadow: intensity > 0.6
                    ? [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.18 * intensity),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

