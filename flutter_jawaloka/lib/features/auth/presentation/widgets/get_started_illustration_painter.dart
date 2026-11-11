import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom vector painter depicting children playing traditional Javanese gamelan
/// (Kendang, Saron, and Gong) on a peaceful hillside vista.
///
/// Supports real-time [animationProgress] (0.0 to 1.0) for live ambient animation:
/// - Sun halo breathing
/// - Birds drifting in the morning breeze
/// - Kendang drummer's hands rhythmically tapping
/// - Saron mallet striking bronze keys with sound ripples
/// - Gong beater striking and subtle gong resonance sway
class GetStartedIllustrationPainter extends CustomPainter {
  final double animationProgress;
  final bool drawCharacters;

  const GetStartedIllustrationPainter({
    this.animationProgress = 0.0,
    this.drawCharacters = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Base coordinate space: 360 x 320
    const double refW = 360.0;
    const double refH = 320.0;

    canvas.save();

    // Scale while preserving aspect ratio and anchoring to bottom
    final double scaleX = size.width / refW;
    final double scaleY = size.height / refH;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double offsetX = (size.width - (refW * scale)) / 2;
    final double offsetY = size.height - (refH * scale);

    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    // Continuous radian phase
    final double phase = animationProgress * math.pi * 2;

    // ── 1. Sky, Sun & Birds ─────────────────────────────────────────────────
    _drawSun(canvas, phase);
    _drawBirds(canvas, phase);

    // ── 2. Layered Hills Landscape ──────────────────────────────────────────
    _drawDistantHills(canvas);
    _drawMidgroundHills(canvas);
    _drawForegroundHill(canvas);

    if (drawCharacters) {
      // Left: Child playing Kendang (drum)
      _drawKendangAndPlayer(canvas, phase);

      // Center: Child playing Saron (bronze metallophone with wooden mallet)
      _drawSaronAndPlayer(canvas, phase);

      // Right: Child playing Hanging Gong (Gayor & Gong Ageng)
      _drawGongAndPlayer(canvas, phase);
    }
    canvas.restore();
  }

  void _drawSun(Canvas canvas, double phase) {
    const Offset sunCenter = Offset(280.0, 82.0);
    const double sunRadius = 32.0;

    // Breathing halo radius & opacity
    final double haloRadius = 78.0 + math.sin(phase) * 5.0;
    final double haloAlpha = (0.50 + math.sin(phase) * 0.12).clamp(0.2, 0.7);

    // Ambient soft glow
    final Paint haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.sunriseGlow.withValues(alpha: haloAlpha),
          AppColors.sunriseGlow.withValues(alpha: haloAlpha * 0.35),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: haloRadius));
    canvas.drawCircle(sunCenter, haloRadius, haloPaint);

    // Sun core
    final Paint sunPaint = Paint()
      ..color = AppColors.sunCore
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);
  }

  void _drawBirds(Canvas canvas, double phase) {
    final Paint birdPaint = Paint()
      ..color = AppColors.inkSecondary.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // Bird 1 (Left) with subtle floating offset
    final double b1x = 56.0 + math.cos(phase) * 2.5;
    final double b1y = 92.0 + math.sin(phase) * 2.0;
    final Path b1 = Path();
    b1.moveTo(b1x, b1y);
    b1.quadraticBezierTo(b1x + 8, b1y - 7, b1x + 15, b1y);
    b1.quadraticBezierTo(b1x + 22, b1y - 7, b1x + 30, b1y);
    canvas.drawPath(b1, birdPaint);

    // Bird 2 (Right, slightly higher) with phase shift
    final double b2x = 92.0 + math.cos(phase + 1.2) * 2.2;
    final double b2y = 84.0 + math.sin(phase + 1.2) * 2.2;
    final Path b2 = Path();
    b2.moveTo(b2x, b2y);
    b2.quadraticBezierTo(b2x + 6, b2y - 6, b2x + 12, b2y);
    b2.quadraticBezierTo(b2x + 18, b2y - 6, b2x + 24, b2y);
    canvas.drawPath(b2, birdPaint);
  }

  void _drawDistantHills(Canvas canvas) {
    final Paint distantPaint = Paint()
      ..color = AppColors.terraceTier1.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final Path distantPath = Path();
    distantPath.moveTo(-20, 195);
    distantPath.quadraticBezierTo(90, 165, 200, 185);
    distantPath.quadraticBezierTo(290, 195, 380, 178);
    distantPath.lineTo(380, 340);
    distantPath.lineTo(-20, 340);
    distantPath.close();
    canvas.drawPath(distantPath, distantPaint);
  }

  void _drawMidgroundHills(Canvas canvas) {
    // Soft bushes on sides
    final Paint foliagePaint = Paint()
      ..color = AppColors.terraceTier4.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(40, 215), 24, foliagePaint);
    canvas.drawCircle(const Offset(62, 222), 18, foliagePaint);
    canvas.drawCircle(const Offset(335, 210), 22, foliagePaint);
    canvas.drawCircle(const Offset(355, 218), 16, foliagePaint);

    // Midground rolling meadow
    final Paint midPaint = Paint()
      ..color = AppColors.terraceTier2.withValues(alpha: 0.82)
      ..style = PaintingStyle.fill;

    final Path midPath = Path();
    midPath.moveTo(-20, 225);
    midPath.quadraticBezierTo(100, 195, 210, 212);
    midPath.quadraticBezierTo(300, 225, 380, 205);
    midPath.lineTo(380, 340);
    midPath.lineTo(-20, 340);
    midPath.close();
    canvas.drawPath(midPath, midPaint);
  }

  void _drawForegroundHill(Canvas canvas) {
    // Main foreground crest where the gamelan ensemble sits
    final Paint forePaint = Paint()
      ..color = AppColors.terraceTier3
      ..style = PaintingStyle.fill;

    final Path forePath = Path();
    forePath.moveTo(-20, 252);
    forePath.quadraticBezierTo(100, 226, 180, 226);
    forePath.quadraticBezierTo(260, 226, 380, 252);
    forePath.lineTo(380, 340);
    forePath.lineTo(-20, 340);
    forePath.close();
    canvas.drawPath(forePath, forePaint);

    // Bottom terrace / ground curve
    final Paint groundPaint = Paint()
      ..color = AppColors.terraceTier4.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final Path groundPath = Path();
    groundPath.moveTo(-20, 275);
    groundPath.quadraticBezierTo(180, 255, 380, 272);
    groundPath.lineTo(380, 340);
    groundPath.lineTo(-20, 340);
    groundPath.close();
    canvas.drawPath(groundPath, groundPaint);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //   1. LEFT: CHILD PLAYING KENDANG (Animated Drumming)
  // ═══════════════════════════════════════════════════════════════════════════
  void _drawKendangAndPlayer(Canvas canvas, double phase) {
    const double cx = 95.0;
    const double cy = 188.0;

    final Paint skinPaint = Paint()..color = AppColors.pastelSand;
    final Paint inkPaint = Paint()..color = AppColors.ink;
    final Paint surjanPaint = Paint()..color = AppColors.amberDark;
    final Paint pantsPaint = Paint()..color = AppColors.terraceTier4;

    // ── Child Body (sitting cross-legged behind Kendang) ──────────────────────
    final RRect legs = RRect.fromRectAndRadius(
      const Rect.fromLTWH(cx - 20, cy + 32, 40, 16),
      const Radius.circular(8),
    );
    canvas.drawRRect(legs, pantsPaint);

    // Torso (AmberDark Surjan)
    final RRect torso = RRect.fromRectAndRadius(
      const Rect.fromLTWH(cx - 14, cy + 10, 28, 25),
      const Radius.circular(8),
    );
    canvas.drawRRect(torso, surjanPaint);

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, cy), width: 20, height: 24),
      skinPaint,
    );

    // Child Blangkon / Ikat Kepala
    final Path blangkon = Path();
    blangkon.moveTo(cx - 12, cy - 1);
    blangkon.quadraticBezierTo(cx - 13, cy - 13, cx, cy - 14);
    blangkon.quadraticBezierTo(cx + 13, cy - 13, cx + 12, cy - 1);
    blangkon.quadraticBezierTo(cx + 8, cy - 5, cx, cy - 4);
    blangkon.quadraticBezierTo(cx - 8, cy - 5, cx - 12, cy - 1);
    blangkon.close();
    canvas.drawPath(blangkon, inkPaint);
    canvas.drawCircle(const Offset(cx - 10, cy - 4), 3.5, inkPaint);

    // ── Kendang Instrument (in front of the child) ───────────────────────────
    const double kx = cx;
    const double ky = cy + 28.0;

    // Wooden Stand (Plangkan / X-legs in AppColors.ink)
    final Paint standPaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(kx - 16, ky + 13),
      const Offset(kx - 8, ky + 25),
      standPaint,
    );
    canvas.drawLine(
      const Offset(kx - 8, ky + 13),
      const Offset(kx - 16, ky + 25),
      standPaint,
    );
    canvas.drawLine(
      const Offset(kx + 8, ky + 13),
      const Offset(kx + 16, ky + 25),
      standPaint,
    );
    canvas.drawLine(
      const Offset(kx + 16, ky + 13),
      const Offset(kx + 8, ky + 25),
      standPaint,
    );

    // Drum Barrel Body
    final Path drumBody = Path();
    drumBody.moveTo(kx - 18, ky + 7);
    drumBody.quadraticBezierTo(kx, ky + 3, kx + 18, ky + 7);
    drumBody.lineTo(kx + 18, ky + 20);
    drumBody.quadraticBezierTo(kx, ky + 24, kx - 18, ky + 20);
    drumBody.close();
    canvas.drawPath(drumBody, surjanPaint);

    // Drum Cords (Janget)
    final Paint cordPaint = Paint()
      ..color = AppColors.amberSoft.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(kx - 16, ky + 8),
      Offset(kx - 4, ky + 21),
      cordPaint,
    );
    canvas.drawLine(Offset(kx - 4, ky + 6), Offset(kx + 8, ky + 21), cordPaint);
    canvas.drawLine(
      Offset(kx + 8, ky + 6),
      Offset(kx + 17, ky + 20),
      cordPaint,
    );

    // Drum Heads
    final Paint headPaint = Paint()..color = AppColors.pastelSand;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx - 18, ky + 13.5), width: 7, height: 13),
      headPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(kx + 18, ky + 13.5), width: 7, height: 13),
      headPaint,
    );

    // ── Animated Rhythmic Drumming Hands ─────────────────────────────────────
    // Alternating drum tap rhythm
    final double tapLeft = (math.sin(phase * 3.0)).clamp(-1.0, 1.0) * 2.2;
    final double tapRight = (math.cos(phase * 3.0)).clamp(-1.0, 1.0) * 2.2;

    final Paint armPaint = Paint()
      ..color = AppColors.amberDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    // Left arm reaching to left drumhead
    final Path leftArm = Path();
    leftArm.moveTo(cx - 13, cy + 14);
    leftArm.quadraticBezierTo(cx - 24, cy + 22, kx - 18 + tapLeft, ky + 11);
    canvas.drawPath(leftArm, armPaint);

    // Right arm reaching to right drumhead
    final Path rightArm = Path();
    rightArm.moveTo(cx + 13, cy + 14);
    rightArm.quadraticBezierTo(cx + 24, cy + 22, kx + 18 - tapRight, ky + 11);
    canvas.drawPath(rightArm, armPaint);

    // Hands tapping
    canvas.drawCircle(Offset(kx - 18 + tapLeft, ky + 11), 3.5, skinPaint);
    canvas.drawCircle(Offset(kx + 18 - tapRight, ky + 11), 3.5, skinPaint);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //   2. CENTER: CHILD PLAYING SARON (Animated Mallet Striking)
  // ═══════════════════════════════════════════════════════════════════════════
  void _drawSaronAndPlayer(Canvas canvas, double phase) {
    const double cx = 180.0;
    const double cy = 185.0;

    final Paint skinPaint = Paint()..color = AppColors.pastelSand;
    final Paint hairPaint = Paint()..color = AppColors.ink;
    final Paint tunicPaint = Paint()..color = AppColors.amberSoft;
    final Paint dressPaint = Paint()..color = AppColors.terraceTier1;

    // ── Child Body (sitting cross-legged behind Saron) ────────────────────────
    final RRect skirt = RRect.fromRectAndRadius(
      const Rect.fromLTWH(cx - 22, cy + 31, 44, 16),
      const Radius.circular(8),
    );
    canvas.drawRRect(skirt, dressPaint);

    // Torso
    final RRect torso = RRect.fromRectAndRadius(
      const Rect.fromLTWH(cx - 13, cy + 11, 26, 23),
      const Radius.circular(8),
    );
    canvas.drawRRect(torso, tunicPaint);

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(cx, cy), width: 19, height: 23),
      skinPaint,
    );

    // Child hair with bun and hair ornament
    final Path hair = Path();
    hair.moveTo(cx - 11, cy);
    hair.quadraticBezierTo(cx - 12, cy - 12, cx, cy - 13);
    hair.quadraticBezierTo(cx + 12, cy - 12, cx + 11, cy);
    hair.quadraticBezierTo(cx, cy - 5, cx - 11, cy);
    hair.close();
    canvas.drawPath(hair, hairPaint);

    // Topknot bun & flower pin
    canvas.drawCircle(Offset(cx, cy - 14), 4.5, hairPaint);
    canvas.drawCircle(
      Offset(cx + 4, cy - 14),
      2.2,
      Paint()..color = AppColors.accentOrange,
    );

    // ── Saron Instrument (in front of the child) ─────────────────────────────
    const double sx = cx;
    const double sy = cy + 28.0;

    // Rancakan (carved wooden base)
    final RRect rancakanBase = RRect.fromRectAndRadius(
      const Rect.fromLTWH(sx - 26, sy + 7, 52, 10),
      const Radius.circular(4),
    );
    canvas.drawRRect(rancakanBase, Paint()..color = AppColors.ink);

    final RRect rancakanTop = RRect.fromRectAndRadius(
      const Rect.fromLTWH(sx - 24, sy + 5, 48, 4),
      const Radius.circular(2),
    );
    canvas.drawRRect(rancakanTop, Paint()..color = AppColors.amberDark);

    // Wilahan (7 Bronze Keys)
    final Paint keyPaint = Paint()..color = AppColors.amber;
    final Paint keyShadow = Paint()..color = AppColors.amberDark;

    const double keyW = 5.2;
    const double keyGap = 1.3;
    const double startX = sx - 23.0;

    for (int i = 0; i < 7; i++) {
      final double kx = startX + i * (keyW + keyGap);
      final double keyH = 10.0 - (i * 0.4);
      final RRect keyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(kx, sy - 2.0, keyW, keyH),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(keyRect, keyPaint);

      canvas.drawCircle(Offset(kx + keyW / 2, sy + 0.5), 0.7, keyShadow);
      canvas.drawCircle(Offset(kx + keyW / 2, sy + keyH - 4), 0.7, keyShadow);
    }

    // ── Animated Mallet Striking & Key Ripple ────────────────────────────────
    // Mallet rhythmically lifts up and strikes key #4
    final double strikeCycle = (math.sin(phase * 4.0)).abs();
    final double malletLift =
        strikeCycle * 6.5; // lifts up to 6.5px and taps key

    final Paint armPaint = Paint()
      ..color = AppColors.amberSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.6
      ..strokeCap = StrokeCap.round;

    // Left hand damping key #2
    final Path leftArm = Path();
    leftArm.moveTo(cx - 12, cy + 14);
    leftArm.quadraticBezierTo(cx - 18, cy + 22, sx - 10, sy + 1);
    canvas.drawPath(leftArm, armPaint);
    canvas.drawCircle(Offset(sx - 10, sy + 1), 3.0, skinPaint);

    // Right arm holding mallet
    final double handX = sx + 8;
    final double handY = sy - 3 - malletLift * 0.6;
    final Path rightArm = Path();
    rightArm.moveTo(cx + 12, cy + 14);
    rightArm.quadraticBezierTo(cx + 20, cy + 18, handX, handY);
    canvas.drawPath(rightArm, armPaint);
    canvas.drawCircle(Offset(handX, handY), 3.0, skinPaint);

    // Tabuh Saron (mallet angled down towards key)
    final double malletHeadX = sx + 5;
    final double malletHeadY = sy + 2 - malletLift;
    final Paint malletPaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawLine(
      Offset(handX, handY),
      Offset(malletHeadX, malletHeadY),
      malletPaint,
    );
    canvas.drawCircle(
      Offset(malletHeadX, malletHeadY),
      2.8,
      Paint()..color = AppColors.amberDark,
    );

    // Gentle musical sparkle/ripple when mallet strikes down
    if (malletLift < 1.8) {
      final Paint ripplePaint = Paint()
        ..color = AppColors.sunriseGlow.withValues(
          alpha: (1.8 - malletLift) * 0.5,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(Offset(malletHeadX, sy + 1), 4.5, ripplePaint);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //   3. RIGHT: CHILD PLAYING GONG (Animated Beater & Gong Resonance Sway)
  // ═══════════════════════════════════════════════════════════════════════════
  void _drawGongAndPlayer(Canvas canvas, double phase) {
    const double gx = 250.0; // Gong position
    const double gy = 188.0;

    const double px = 282.0; // Player position
    const double py = 190.0;

    final Paint inkPaint = Paint()..color = AppColors.ink;
    final Paint skinPaint = Paint()..color = AppColors.pastelSand;
    final Paint pantsPaint = Paint()..color = AppColors.terraceTier4;

    // ── Gayor (Carved Wooden Hanging Frame) ──────────────────────────────────
    final Paint gayorPaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    // Two vertical posts
    canvas.drawLine(
      const Offset(gx - 20, gy - 16),
      const Offset(gx - 20, gy + 45),
      gayorPaint,
    );
    canvas.drawLine(
      const Offset(gx + 20, gy - 16),
      const Offset(gx + 20, gy + 45),
      gayorPaint,
    );

    // Post finials
    canvas.drawCircle(
      const Offset(gx - 20, gy - 18),
      3.0,
      Paint()..color = AppColors.amberDark,
    );
    canvas.drawCircle(
      const Offset(gx + 20, gy - 18),
      3.0,
      Paint()..color = AppColors.amberDark,
    );

    // Carved arch crossbeam
    final Path archBeam = Path();
    archBeam.moveTo(gx - 22, gy - 12);
    archBeam.quadraticBezierTo(gx, gy - 20, gx + 22, gy - 12);
    canvas.drawPath(archBeam, gayorPaint);
    canvas.drawCircle(
      const Offset(gx, gy - 16),
      3.2,
      Paint()..color = AppColors.amberDark,
    );

    // ── Gong Animated Swing & Resonance ──────────────────────────────────────
    // Gentle sway of the suspended gong
    final double gongSway = math.sin(phase * 1.5 - 0.5) * 1.8;
    final Offset gongCenter = Offset(gx + gongSway * 0.4, gy + 12.0);

    // Suspension cords (Tali Pluntur)
    final Paint ropePaint = Paint()
      ..color = AppColors.inkSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawLine(
      const Offset(gx - 8, gy - 13),
      Offset(gongCenter.dx - 8, gy - 3),
      ropePaint,
    );
    canvas.drawLine(
      const Offset(gx + 8, gy - 13),
      Offset(gongCenter.dx + 8, gy - 3),
      ropePaint,
    );

    // Outer bronze rim
    canvas.drawCircle(gongCenter, 17.0, Paint()..color = AppColors.amberDark);
    // Inner bronze face
    canvas.drawCircle(gongCenter, 14.5, Paint()..color = AppColors.amber);
    // Gong Pencu (Center Boss / Nipple)
    canvas.drawCircle(gongCenter, 4.6, Paint()..color = AppColors.sunCore);
    canvas.drawCircle(gongCenter, 2.2, Paint()..color = AppColors.sunriseGlow);

    // ── Child Gong Player ───────────────────────────────────────────────────
    final RRect legs = RRect.fromRectAndRadius(
      const Rect.fromLTWH(px - 14, py + 31, 28, 16),
      const Radius.circular(8),
    );
    canvas.drawRRect(legs, pantsPaint);

    // Torso (Surface white top)
    final RRect torso = RRect.fromRectAndRadius(
      const Rect.fromLTWH(px - 12, py + 11, 24, 24),
      const Radius.circular(8),
    );
    canvas.drawRRect(torso, Paint()..color = AppColors.surface);

    // Waist sash in AppColors.accentOrange
    canvas.drawRect(
      Rect.fromLTWH(px - 12, py + 26, 24, 4),
      Paint()..color = AppColors.accentOrange,
    );

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(px, py), width: 19, height: 23),
      skinPaint,
    );

    // Hair silhouette
    final Path hair = Path();
    hair.moveTo(px - 10, py);
    hair.quadraticBezierTo(px - 12, py - 12, px, py - 13);
    hair.quadraticBezierTo(px + 12, py - 12, px + 10, py);
    hair.quadraticBezierTo(px, py - 5, px - 10, py);
    hair.close();
    canvas.drawPath(hair, inkPaint);

    // ── Animated Arm holding Tabuh Gong (striking rhythm) ────────────────────
    final double beaterStroke = math.sin(phase * 1.5) * 4.5;

    final Paint armPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.6
      ..strokeCap = StrokeCap.round;

    final double handX = gx + 13 + beaterStroke;
    final double handY = gongCenter.dy - 2;

    final Path arm = Path();
    arm.moveTo(px - 8, py + 15);
    arm.quadraticBezierTo(px - 18, py + 18, handX, handY);
    canvas.drawPath(arm, armPaint);
    canvas.drawCircle(Offset(handX, handY), 3.0, skinPaint);

    // Tabuh Gong Stick & Padded Head
    final Paint beaterStick = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final double beaterHeadX = gongCenter.dx + 4.5 + beaterStroke * 0.7;
    final double beaterHeadY = gongCenter.dy;

    canvas.drawLine(
      Offset(handX, handY),
      Offset(beaterHeadX, beaterHeadY),
      beaterStick,
    );
    canvas.drawCircle(
      Offset(beaterHeadX, beaterHeadY),
      3.8,
      Paint()..color = AppColors.amberDark,
    );
  }

  @override
  bool shouldRepaint(covariant GetStartedIllustrationPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}
