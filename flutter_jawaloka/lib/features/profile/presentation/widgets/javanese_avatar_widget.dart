import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'blangkon_painter.dart';

/// Reusable Javanese Cartoon Avatar Widget.
/// Renders a cheerful flat-vector Javanese student character
/// wearing a traditional batik blangkon headdress.
class JavaneseAvatarWidget extends StatelessWidget {
  final double size;
  final BlangkonType blangkonType;
  final bool showEditButton;
  final VoidCallback? onEditTap;
  final double? progress; // 0.0 - 1.0 for circular level ring (e.g. 0.75 for 75%)
  final Color backgroundColor;

  const JavaneseAvatarWidget({
    super.key,
    this.size = 92,
    this.blangkonType = BlangkonType.yogyakarta,
    this.showEditButton = false,
    this.onEditTap,
    this.progress,
    this.backgroundColor = const Color(0xFFFFF9E9),
  });

  @override
  Widget build(BuildContext context) {
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
        child: CustomPaint(
          size: Size(size, size),
          painter: _JavaneseCharacterPainter(blangkonType: blangkonType),
        ),
      ),
    );

    // If progress ring is specified, wrap in circular progress painter
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
                progressColor: AppColors.ink,
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
                border: Border.all(color: const Color(0xFFE0D5C3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
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

/// Custom vector painter that draws the charming Javanese character
/// with accurate facial features, eyes, blush, and blangkon.
class _JavaneseCharacterPainter extends CustomPainter {
  final BlangkonType blangkonType;

  _JavaneseCharacterPainter({required this.blangkonType});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Scale reference coordinates from 100x100
    final sx = w / 100.0;
    final sy = h / 100.0;

    // 1. Surjan / Collar at bottom
    final collarPaint = Paint()..color = const Color(0xFF2E2419);
    final collarPath = Path()
      ..moveTo(30 * sx, 84 * sy)
      ..cubicTo(30 * sx, 74 * sy, 42 * sx, 72 * sy, 50 * sx, 73 * sy)
      ..cubicTo(58 * sx, 72 * sy, 70 * sx, 74 * sy, 70 * sx, 84 * sy)
      ..lineTo(70 * sx, 100 * sy)
      ..lineTo(30 * sx, 100 * sy)
      ..close();
    canvas.drawPath(collarPath, collarPaint);

    // Inner neck / V-opening
    final neckV = Path()
      ..moveTo(45 * sx, 73 * sy)
      ..lineTo(50 * sx, 79 * sy)
      ..lineTo(55 * sx, 73 * sy)
      ..close();
    canvas.drawPath(neckV, Paint()..color = const Color(0xFFFBD5B2));

    // 2. Face Base Circle
    final facePaint = Paint()..color = const Color(0xFFFBD5B2);
    canvas.drawCircle(Offset(50 * sx, 58 * sy), 28 * sx, facePaint);

    // 3. Eyes (friendly expressive pupils with catchlight reflection)
    final eyePaint = Paint()..color = const Color(0xFF231C14);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(40 * sx, 58 * sy), width: 5 * sx, height: 7 * sy),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * sx, 58 * sy), width: 5 * sx, height: 7 * sy),
      eyePaint,
    );

    // White eye catchlight glints
    final glintPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(41 * sx, 56.5 * sy), 1.5 * sx, glintPaint);
    canvas.drawCircle(Offset(61 * sx, 56.5 * sy), 1.5 * sx, glintPaint);

    // Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF231C14)
      ..strokeWidth = 2 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final leftBrow = Path()
      ..moveTo(36 * sx, 51 * sy)
      ..quadraticBezierTo(40 * sx, 48 * sy, 44 * sx, 51 * sy);
    canvas.drawPath(leftBrow, browPaint);

    final rightBrow = Path()
      ..moveTo(56 * sx, 51 * sy)
      ..quadraticBezierTo(60 * sx, 48 * sy, 64 * sx, 51 * sy);
    canvas.drawPath(rightBrow, browPaint);

    // 4. Rosy Blush Cheeks
    final blushPaint = Paint()
      ..color = const Color(0xFFFFA390).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(34 * sx, 64 * sy), 5 * sx, blushPaint);
    canvas.drawCircle(Offset(66 * sx, 64 * sy), 5 * sx, blushPaint);

    // 5. Joyful Smile Curve
    final mouthPaint = Paint()
      ..color = const Color(0xFF231C14)
      ..strokeWidth = 2.4 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final mouthPath = Path()
      ..moveTo(43 * sx, 65 * sy)
      ..quadraticBezierTo(50 * sx, 72 * sy, 57 * sx, 65 * sy);
    canvas.drawPath(mouthPath, mouthPaint);

    // Red tongue accent inside smile
    final tonguePath = Path()
      ..moveTo(46 * sx, 67 * sy)
      ..quadraticBezierTo(50 * sx, 71 * sy, 54 * sx, 67 * sy)
      ..close();
    canvas.drawPath(tonguePath, Paint()..color = const Color(0xFFE24B4B));

    // 6. Blangkon Headdress on top of head
    _drawBlangkonHeaddress(canvas, sx, sy, blangkonType);
  }

  void _drawBlangkonHeaddress(Canvas canvas, double sx, double sy, BlangkonType type) {
    // Determine colors based on blangkon style
    Color baseColor;
    Color highlightColor;
    Color bandColor;

    switch (type) {
      case BlangkonType.surakarta:
        // Surakarta: Deep rich brown batik with refined golden-brown pleats
        baseColor = const Color(0xFF3B2215);
        highlightColor = const Color(0xFF825232);
        bandColor = const Color(0xFFA5734A);
        break;
      case BlangkonType.banyumas:
        baseColor = const Color(0xFF8B2500);
        highlightColor = const Color(0xFFD35400);
        bandColor = const Color(0xFFE67E22);
        break;
      case BlangkonType.kedu:
        baseColor = const Color(0xFF1F2937);
        highlightColor = const Color(0xFF4B5563);
        bandColor = const Color(0xFFDC2626);
        break;
      case BlangkonType.cirebon:
        baseColor = const Color(0xFF231C14);
        highlightColor = const Color(0xFFD4AF37);
        bandColor = const Color(0xFFFFC247);
        break;
      case BlangkonType.pusaka:
        baseColor = const Color(0xFF231C14);
        highlightColor = const Color(0xFFD4AF37);
        bandColor = const Color(0xFFFFC247);
        break;
      case BlangkonType.yogyakarta:
        baseColor = const Color(0xFF4B2E1E);
        highlightColor = const Color(0xFF68422A);
        bandColor = const Color(0xFF9C6B46);
        break;
    }

    // Main Crown / Cap dome
    final capPaint = Paint()..color = baseColor;
    final capPath = Path()
      ..moveTo(22 * sx, 48 * sy)
      ..cubicTo(22 * sx, 27 * sy, 78 * sx, 27 * sy, 78 * sx, 48 * sy)
      ..cubicTo(78 * sx, 50 * sy, 22 * sx, 50 * sy, 22 * sx, 48 * sy)
      ..close();
    canvas.drawPath(capPath, capPaint);

    // Batik pleats (Wiron lines)
    final pleatPaint = Paint()
      ..color = highlightColor
      ..strokeWidth = 2.2 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leftPleat = Path()
      ..moveTo(25 * sx, 45 * sy)
      ..cubicTo(33 * sx, 34 * sy, 48 * sx, 37 * sy, 50 * sx, 49 * sy);
    canvas.drawPath(leftPleat, pleatPaint);

    final rightPleat = Path()
      ..moveTo(75 * sx, 45 * sy)
      ..cubicTo(67 * sx, 34 * sy, 52 * sx, 37 * sy, 50 * sx, 49 * sy);
    canvas.drawPath(rightPleat, pleatPaint);

    // Front headband trim
    final bandPaint = Paint()
      ..color = bandColor
      ..strokeWidth = 3.5 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bandPath = Path()
      ..moveTo(23 * sx, 48 * sy)
      ..quadraticBezierTo(50 * sx, 43 * sy, 77 * sx, 48 * sy);
    canvas.drawPath(bandPath, bandPaint);

    // Dotted detail on top of headband
    final stitchPaint = Paint()
      ..color = highlightColor.withValues(alpha: 0.8)
      ..strokeWidth = 1.4 * sx
      ..style = PaintingStyle.stroke;
    final stitchPath = Path()
      ..moveTo(29 * sx, 40 * sy)
      ..quadraticBezierTo(50 * sx, 35 * sy, 71 * sx, 40 * sy);
    canvas.drawPath(stitchPath, stitchPaint);

    // Left Mondolan / Knot (characteristic back bulge seen in profile/perspective)
    final mondolanPaint = Paint()..color = baseColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(23 * sx, 46 * sy), width: 7 * sx, height: 9 * sy),
      mondolanPaint,
    );

    // Center jewel / tie badge
    final tiePaint = Paint()..color = highlightColor;
    final tiePath = Path()
      ..moveTo(48 * sx, 43 * sy)
      ..lineTo(52 * sx, 43 * sy)
      ..lineTo(50 * sx, 48 * sy)
      ..close();
    canvas.drawPath(tiePath, tiePaint);
  }

  @override
  bool shouldRepaint(covariant _JavaneseCharacterPainter oldDelegate) {
    return oldDelegate.blangkonType != blangkonType;
  }
}


