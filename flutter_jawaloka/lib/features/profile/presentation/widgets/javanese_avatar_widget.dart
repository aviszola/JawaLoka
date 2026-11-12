import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import 'blangkon_painter.dart';
import '../../../../core/profile/profile_preferences.dart';
import '../../../../core/profile/profile_scope.dart';

/// Reusable Javanese Cartoon Avatar Widget.
/// Renders a cheerful flat-vector Javanese student character
/// wearing a traditional batik blangkon headdress.
class JavaneseAvatarWidget extends StatelessWidget {
  final double size;
  final BlangkonType blangkonType;
  final UserGender? gender;
  final bool showEditButton;
  final VoidCallback? onEditTap;
  final double? progress; // 0.0 - 1.0 for circular level ring
  final Color backgroundColor;

  const JavaneseAvatarWidget({
    super.key,
    this.size = 92,
    this.blangkonType = BlangkonType.yogyakarta,
    this.gender,
    this.showEditButton = false,
    this.onEditTap,
    this.progress,
    this.backgroundColor = AppColors.surfaceWarm,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGender =
        gender ?? ProfileScope.maybeOf(context)?.gender ?? UserGender.male;

    // Pilih SVG avatar spesifik blangkon/busana; fallback ke avatar generik.
    final String svgAsset;
    if (effectiveGender == UserGender.female) {
      svgAsset =
          blangkonType.putriAvatarAsset ??
          'assets/images/characters/avatar_putri.svg';
    } else {
      svgAsset =
          blangkonType.putraAvatarAsset ??
          'assets/images/characters/avatar_putra.svg';
    }

    Widget avatarCircle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          svgAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );

    if (progress != null) {
      final ringSize = size + 16;
      avatarCircle = SizedBox(
        width: ringSize,
        height: ringSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(ringSize, ringSize),
              painter: _AvatarProgressRingPainter(
                progress: progress!,
                trackColor: AppColors.ink.withValues(alpha: 0.12),
                progressColor: AppColors.amber,
                strokeWidth: 3.5,
              ),
            ),
            avatarCircle,
          ],
        ),
      );
    }

    if (!showEditButton) {
      return avatarCircle;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarCircle,
        Positioned(
          bottom: progress != null ? 2 : -2,
          right: progress != null ? 2 : -2,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                AppIcons.edit,
                size: 14,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter that draws the circular progress ring around the avatar.
class _AvatarProgressRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _AvatarProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc (Starts from top = -pi/2)
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
