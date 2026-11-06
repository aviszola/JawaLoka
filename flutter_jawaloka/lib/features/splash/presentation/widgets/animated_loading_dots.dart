import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Loading indicator for Splash Screen.
/// Replaces static multi-dots with a single, subtle active moving dot (6 dp)
/// on a gentle track. Respects [MediaQuery.disableAnimations] by rendering statically.
class AnimatedLoadingDots extends StatelessWidget {
  final double animationValue; // 0.0 to 1.0 looped

  const AnimatedLoadingDots({
    super.key,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    const double trackWidth = 48.0;
    const double dotSize = 6.0;

    // Smooth sinusoidal movement across track (0.0 to 1.0 back and forth)
    final double normalizedPos = disableAnimations
        ? 0.5
        : (math.sin(animationValue * math.pi * 2 - (math.pi / 2)) + 1.0) / 2.0;

    return Semantics(
      label: AppStrings.loadingLabel,
      child: Container(
        width: trackWidth,
        height: dotSize,
        decoration: BoxDecoration(
          color: AppColors.ink.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(dotSize / 2),
        ),
        child: Align(
          alignment: Alignment(normalizedPos * 2.0 - 1.0, 0.0),
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
