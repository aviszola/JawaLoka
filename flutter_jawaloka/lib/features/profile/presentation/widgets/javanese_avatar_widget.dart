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
  final double? progress; // 0.0 - 1.0 for circular level ring
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

/// Custom vector painter that draws a detailed Javanese character.
/// Uses layered CustomPainter techniques for a polished, hand-crafted illustration look:
/// - Detailed face with shading, proper nose bridge, cupid's bow lips
/// - Layered neck & traditional surjan collar with batik trim detail
/// - Shoulder silhouette for depth
/// - Blangkon hat rendered via BlangkonPainter coordinate system
class _JavaneseCharacterPainter extends CustomPainter {
  final BlangkonType blangkonType;

  _JavaneseCharacterPainter({required this.blangkonType});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sx = w / 100.0;
    final sy = h / 100.0;

    // ── 1. Background wash (soft warm cream oval for face glow) ──────────────
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 0.1),
        radius: 0.75,
        colors: [const Color(0xFFFFF3DA), const Color(0xFFFFF9E9)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // ── 2. Shoulders & Torso (Surjan — traditional Javanese shirt) ───────────
    _drawTorso(canvas, sx, sy);

    // ── 3. Neck ───────────────────────────────────────────────────────────────
    _drawNeck(canvas, sx, sy);

    // ── 4. Head / Face ────────────────────────────────────────────────────────
    _drawFace(canvas, sx, sy);

    // ── 5. Ears ───────────────────────────────────────────────────────────────
    _drawEars(canvas, sx, sy);

    // ── 6. Eyes ───────────────────────────────────────────────────────────────
    _drawEyes(canvas, sx, sy);

    // ── 7. Eyebrows ───────────────────────────────────────────────────────────
    _drawEyebrows(canvas, sx, sy);

    // ── 8. Nose ───────────────────────────────────────────────────────────────
    _drawNose(canvas, sx, sy);

    // ── 9. Mouth & Smile ──────────────────────────────────────────────────────
    _drawMouth(canvas, sx, sy);

    // ── 10. Blush Cheeks ──────────────────────────────────────────────────────
    _drawBlush(canvas, sx, sy);

    // ── 11. Hair strands (peeking from under blangkon) ────────────────────────
    _drawHair(canvas, sx, sy);

    // ── 12. Blangkon Headdress ────────────────────────────────────────────────
    _drawBlangkonOnCharacter(canvas, sx, sy, blangkonType);
  }

  // ─── Torso: Surjan with Batik collar detail ──────────────────────────────
  void _drawTorso(Canvas canvas, double sx, double sy) {
    // Dark shirt base — Surjan Javanese traditional shirt
    final torsoPath = Path()
      ..moveTo(10 * sx, 100 * sy)
      ..lineTo(15 * sx, 78 * sy)
      ..cubicTo(22 * sx, 68 * sy, 36 * sx, 66 * sy, 42 * sx, 68 * sy)
      ..lineTo(44 * sx, 70 * sy)
      ..lineTo(44 * sx, 100 * sy)
      ..close();
    final torsoPath2 = Path()
      ..moveTo(90 * sx, 100 * sy)
      ..lineTo(85 * sx, 78 * sy)
      ..cubicTo(78 * sx, 68 * sy, 64 * sx, 66 * sy, 58 * sx, 68 * sy)
      ..lineTo(56 * sx, 70 * sy)
      ..lineTo(56 * sx, 100 * sy)
      ..close();

    final Paint shirePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3D2B1A), Color(0xFF231C14)],
      ).createShader(Rect.fromLTWH(10, 65, 80, 35));

    canvas.drawPath(torsoPath, shirePaint);
    canvas.drawPath(torsoPath2, shirePaint);

    // Batik collar V-trim (golden ochre piping line on collar edge)
    final trimPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 * sx
      ..strokeCap = StrokeCap.round;

    // Left collar trim
    canvas.drawLine(
      Offset(15 * sx, 78 * sy),
      Offset(44 * sx, 68 * sy),
      trimPaint,
    );
    // Right collar trim
    canvas.drawLine(
      Offset(85 * sx, 78 * sy),
      Offset(56 * sx, 68 * sy),
      trimPaint,
    );

    // Central V-opening of collar
    final vPath = Path()
      ..moveTo(44 * sx, 68 * sy)
      ..lineTo(50 * sx, 76 * sy)
      ..lineTo(56 * sx, 68 * sy);
    canvas.drawPath(vPath, trimPaint);

    // Small batik motif dots on shoulders (decorative detail)
    final dotPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset((18 + i * 5.0) * sx, 82 * sy),
        1.2 * sx,
        dotPaint,
      );
      canvas.drawCircle(
        Offset((82 - i * 5.0) * sx, 82 * sy),
        1.2 * sx,
        dotPaint,
      );
    }
  }

  // ─── Neck ─────────────────────────────────────────────────────────────────
  void _drawNeck(Canvas canvas, double sx, double sy) {
    final neckPaint = Paint()..color = const Color(0xFFF5C9A0);
    final neckShadowPaint = Paint()..color = const Color(0xFFE6B485);

    // Neck cylinder shape
    final neckPath = Path()
      ..moveTo(42 * sx, 68 * sy)
      ..cubicTo(42 * sx, 72 * sy, 44 * sx, 75 * sy, 44 * sx, 76 * sy)
      ..lineTo(56 * sx, 76 * sy)
      ..cubicTo(56 * sx, 75 * sy, 58 * sx, 72 * sy, 58 * sx, 68 * sy)
      ..close();
    canvas.drawPath(neckPath, neckPaint);

    // Neck shadow (right side for depth)
    final neckShadow = Path()
      ..moveTo(53 * sx, 68 * sy)
      ..cubicTo(55 * sx, 69 * sy, 57 * sx, 72 * sy, 57 * sx, 76 * sy)
      ..lineTo(56 * sx, 76 * sy)
      ..cubicTo(56 * sx, 72 * sy, 55 * sx, 69 * sy, 53 * sx, 68 * sy)
      ..close();
    canvas.drawPath(neckShadow, neckShadowPaint);
  }

  // ─── Face ─────────────────────────────────────────────────────────────────
  void _drawFace(Canvas canvas, double sx, double sy) {
    // Face base — slightly rounded oval head
    final faceOvalRect = Rect.fromCenter(
      center: Offset(50 * sx, 51 * sy),
      width: 52 * sx,
      height: 54 * sy,
    );

    // Face shading gradient — adds subtle 3D depth
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.85,
        colors: [
          const Color(0xFFFBDFC0), // bright highlight cheek
          const Color(0xFFF8C99A), // mid-tone
          const Color(0xFFEEAE77), // shadow jaw
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(faceOvalRect);

    canvas.drawOval(faceOvalRect, facePaint);

    // Jaw / chin subtle shadow
    final jawShadowPaint = Paint()
      ..color = const Color(0xFFE9A570).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(50 * sx, 70 * sy),
        width: 36 * sx,
        height: 12 * sy,
      ),
      jawShadowPaint,
    );

    // Cheek highlight oval (left cheek, brighter)
    final cheekHighlight = Paint()
      ..color = const Color(0xFFFFF0D6).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(37 * sx, 52 * sy),
        width: 14 * sx,
        height: 10 * sy,
      ),
      cheekHighlight,
    );
  }

  // ─── Ears ────────────────────────────────────────────────────────────────
  void _drawEars(Canvas canvas, double sx, double sy) {
    final earPaint = Paint()..color = const Color(0xFFF5C090);
    final earShadow = Paint()..color = const Color(0xFFE6A878);

    // Left ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(24 * sx, 51 * sy),
        width: 7 * sx,
        height: 10 * sy,
      ),
      earPaint,
    );
    // Left ear inner
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(25 * sx, 51 * sy),
        width: 3.5 * sx,
        height: 6 * sy,
      ),
      earShadow,
    );

    // Right ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(76 * sx, 51 * sy),
        width: 7 * sx,
        height: 10 * sy,
      ),
      earPaint,
    );
    // Right ear inner
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(75 * sx, 51 * sy),
        width: 3.5 * sx,
        height: 6 * sy,
      ),
      earShadow,
    );
  }

  // ─── Eyes ─────────────────────────────────────────────────────────────────
  void _drawEyes(Canvas canvas, double sx, double sy) {
    final eyePositions = [Offset(37 * sx, 50 * sy), Offset(63 * sx, 50 * sy)];

    for (final center in eyePositions) {
      // Upper eyelid shadow (soft dark crescent above eye)
      final lidShadow = Paint()
        ..color = const Color(0xFF7A4A28).withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, -1 * sy),
          width: 11 * sx,
          height: 6 * sy,
        ),
        lidShadow,
      );

      // Eye white (sclera)
      final scleraPaint = Paint()..color = const Color(0xFFFFFCF5);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: 10 * sx, height: 8 * sy),
        scleraPaint,
      );

      // Iris — warm dark brown
      final irisPaint = Paint()
        ..shader =
            RadialGradient(
              colors: [const Color(0xFF5C3017), const Color(0xFF2E1A0E)],
              center: const Alignment(-0.3, -0.3),
              radius: 0.9,
            ).createShader(
              Rect.fromCenter(center: center, width: 6 * sx, height: 6 * sy),
            );
      canvas.drawCircle(center, 3 * sx, irisPaint);

      // Pupil
      canvas.drawCircle(
        center,
        1.6 * sx,
        Paint()..color = const Color(0xFF0E0906),
      );

      // Catchlight top-left (primary)
      canvas.drawCircle(
        center.translate(-1.2 * sx, -1.4 * sy),
        1.1 * sx,
        Paint()..color = Colors.white,
      );
      // Catchlight tiny bottom-right (secondary specular)
      canvas.drawCircle(
        center.translate(1.3 * sx, 1.2 * sy),
        0.5 * sx,
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      );

      // Upper eyelash line
      final lashPaint = Paint()
        ..color = const Color(0xFF1C1109)
        ..strokeWidth = 1.4 * sx
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final lashPath = Path()
        ..moveTo(center.dx - 5 * sx, center.dy - 2 * sy)
        ..cubicTo(
          center.dx - 2 * sx,
          center.dy - 5 * sy,
          center.dx + 2 * sx,
          center.dy - 5 * sy,
          center.dx + 5 * sx,
          center.dy - 2 * sy,
        );
      canvas.drawPath(lashPath, lashPaint);

      // Lower lash line (lighter)
      final lowerLash = Paint()
        ..color = const Color(0xFF4A2E18).withValues(alpha: 0.5)
        ..strokeWidth = 0.8 * sx
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final lowerLashPath = Path()
        ..moveTo(center.dx - 4 * sx, center.dy + 3 * sy)
        ..quadraticBezierTo(
          center.dx,
          center.dy + 4.5 * sy,
          center.dx + 4 * sx,
          center.dy + 3 * sy,
        );
      canvas.drawPath(lowerLashPath, lowerLash);
    }
  }

  // ─── Eyebrows ─────────────────────────────────────────────────────────────
  void _drawEyebrows(Canvas canvas, double sx, double sy) {
    final browPaint = Paint()
      ..color = const Color(0xFF2A1A0A)
      ..strokeWidth = 2.5 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left brow — natural arch, slightly thick inner, tapered outer
    final leftBrow = Path()
      ..moveTo(29 * sx, 42 * sy)
      ..cubicTo(32 * sx, 39 * sy, 37 * sx, 38 * sy, 43 * sx, 41 * sy);
    canvas.drawPath(leftBrow, browPaint);

    // Left brow fill (soft, slightly wider than stroke)
    final leftBrowFill = Paint()
      ..color = const Color(0xFF2A1A0A).withValues(alpha: 0.15)
      ..strokeWidth = 4.5 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(leftBrow, leftBrowFill);

    // Right brow
    final rightBrow = Path()
      ..moveTo(57 * sx, 41 * sy)
      ..cubicTo(63 * sx, 38 * sy, 68 * sx, 39 * sy, 71 * sx, 42 * sy);
    canvas.drawPath(rightBrow, browPaint);
    canvas.drawPath(rightBrow, leftBrowFill);
  }

  // ─── Nose ──────────────────────────────────────────────────────────────────
  void _drawNose(Canvas canvas, double sx, double sy) {
    // Nose bridge — subtle vertical shading line
    final bridgePaint = Paint()
      ..color = const Color(0xFFCB8C5E).withValues(alpha: 0.5)
      ..strokeWidth = 1.0 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bridgePath = Path()
      ..moveTo(50 * sx, 54 * sy)
      ..cubicTo(48 * sx, 57 * sy, 46 * sx, 59 * sy, 46 * sx, 61 * sy)
      ..cubicTo(47 * sx, 63 * sy, 50 * sx, 63 * sy, 53 * sx, 62 * sy)
      ..cubicTo(55 * sx, 61 * sy, 55 * sx, 59 * sy, 54 * sx, 57 * sy);
    canvas.drawPath(bridgePath, bridgePaint);

    // Nostrils — two soft ellipses
    final nostrilPaint = Paint()
      ..color = const Color(0xFFBB7845).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(46.5 * sx, 62 * sy),
        width: 4 * sx,
        height: 2.8 * sy,
      ),
      nostrilPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(53.5 * sx, 62 * sy),
        width: 4 * sx,
        height: 2.8 * sy,
      ),
      nostrilPaint,
    );
  }

  // ─── Mouth & Smile ─────────────────────────────────────────────────────────
  void _drawMouth(Canvas canvas, double sx, double sy) {
    // Upper lip (cupid's bow shape)
    final upperLipPaint = Paint()
      ..color = const Color(0xFFCC7A56)
      ..style = PaintingStyle.fill;
    final upperLipPath = Path()
      ..moveTo(42 * sx, 68 * sy)
      ..cubicTo(44 * sx, 65 * sy, 47 * sx, 64 * sy, 50 * sx, 65.5 * sy)
      ..cubicTo(53 * sx, 64 * sy, 56 * sx, 65 * sy, 58 * sx, 68 * sy)
      ..cubicTo(55 * sx, 68.5 * sy, 50 * sx, 68.5 * sy, 42 * sx, 68 * sy)
      ..close();
    canvas.drawPath(upperLipPath, upperLipPaint);

    // Smile (open, happy) — reveals top teeth row
    final smilePath = Path()
      ..moveTo(42 * sx, 68 * sy)
      ..cubicTo(44 * sx, 73 * sy, 56 * sx, 73 * sy, 58 * sx, 68 * sy)
      ..close();

    // Mouth opening (dark)
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFF3D1E0C));

    // Teeth row — white band inside smile
    final teethPath = Path()
      ..moveTo(43.5 * sx, 68.5 * sy)
      ..cubicTo(45 * sx, 71 * sy, 55 * sx, 71 * sy, 56.5 * sx, 68.5 * sy)
      ..close();
    canvas.drawPath(teethPath, Paint()..color = const Color(0xFFFFF8F0));

    // Tooth dividers (subtle)
    final toothDivPaint = Paint()
      ..color = const Color(0xFFE0D4C0).withValues(alpha: 0.6)
      ..strokeWidth = 0.7 * sx
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(49 * sx, 68.5 * sy),
      Offset(49.5 * sx, 71 * sy),
      toothDivPaint,
    );
    canvas.drawLine(
      Offset(51 * sx, 68.5 * sy),
      Offset(51.5 * sx, 71 * sy),
      toothDivPaint,
    );

    // Lower lip
    final lowerLipPath = Path()
      ..moveTo(42 * sx, 68 * sy)
      ..cubicTo(45 * sx, 74.5 * sy, 55 * sx, 74.5 * sy, 58 * sx, 68 * sy)
      ..cubicTo(56 * sx, 75.5 * sy, 44 * sx, 75.5 * sy, 42 * sx, 68 * sy)
      ..close();
    canvas.drawPath(
      lowerLipPath,
      Paint()..color = const Color(0xFFD48A63).withValues(alpha: 0.6),
    );

    // Chin dimple line
    final chinPaint = Paint()
      ..color = const Color(0xFFCB8056).withValues(alpha: 0.4)
      ..strokeWidth = 0.9 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(50 * sx, 76 * sy),
        width: 8 * sx,
        height: 6 * sy,
      ),
      0.3,
      math.pi - 0.6,
      false,
      chinPaint,
    );
  }

  // ─── Blush Cheeks ─────────────────────────────────────────────────────────
  void _drawBlush(Canvas canvas, double sx, double sy) {
    final blushPaint = Paint()
      ..color = const Color(0xFFFF9B84).withValues(alpha: 0.38)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(31 * sx, 59 * sy),
        width: 14 * sx,
        height: 8 * sy,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(69 * sx, 59 * sy),
        width: 14 * sx,
        height: 8 * sy,
      ),
      blushPaint,
    );
  }

  // ─── Hair strands peeking from under blangkon ─────────────────────────────
  void _drawHair(Canvas canvas, double sx, double sy) {
    final hairPaint = Paint()..color = const Color(0xFF1A0E06);
    // Tiny hair strands on temples
    final leftHair = Path()
      ..moveTo(24 * sx, 42 * sy)
      ..cubicTo(26 * sx, 36 * sy, 30 * sx, 33 * sy, 34 * sx, 35 * sy);
    final rightHair = Path()
      ..moveTo(76 * sx, 42 * sy)
      ..cubicTo(74 * sx, 36 * sy, 70 * sx, 33 * sy, 66 * sx, 35 * sy);
    final hairLinePaint = Paint()
      ..color = const Color(0xFF1A0E06)
      ..strokeWidth = 2.5 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(leftHair, hairLinePaint);
    canvas.drawPath(rightHair, hairLinePaint);

    // Hair mass behind blangkon (top of head, peeking at sides)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(50 * sx, 32 * sy),
        width: 54 * sx,
        height: 20 * sy,
      ),
      hairPaint,
    );
  }

  // ─── Blangkon Headdress ───────────────────────────────────────────────────
  void _drawBlangkonOnCharacter(
    Canvas canvas,
    double sx,
    double sy,
    BlangkonType type,
  ) {
    // Blangkon sits on top of head. Clipped to character canvas (100x100 coords).
    // We scale the BlangkonPainter coordinate space to fit the hat region.
    final hatRect = Rect.fromLTWH(14 * sx, 2 * sy, 72 * sx, 42 * sy);
    canvas.save();
    canvas.translate(hatRect.left, hatRect.top);

    final hatPainter = BlangkonPainter(type: type);
    hatPainter.paint(canvas, Size(hatRect.width, hatRect.height));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _JavaneseCharacterPainter oldDelegate) {
    return oldDelegate.blangkonType != blangkonType;
  }
}
