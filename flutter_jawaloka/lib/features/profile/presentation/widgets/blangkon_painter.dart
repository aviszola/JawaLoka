import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Blangkon types available in JawaLoka
enum BlangkonType {
  yogyakarta,
  surakarta,
  banyumas,
  kedu,
  cirebon,
  pusaka,
}

/// Renders a traditional Javanese blangkon hat using CustomPainter.
/// Each type has a highly detailed distinct vector shape, lighting,
/// texture detail, and culturally accurate color scheme.
class BlangkonPainter extends CustomPainter {
  final BlangkonType type;
  final bool isLocked;

  const BlangkonPainter({required this.type, this.isLocked = false});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case BlangkonType.yogyakarta:
        _paintYogyakarta(canvas, size);
      case BlangkonType.surakarta:
        _paintSurakarta(canvas, size);
      case BlangkonType.banyumas:
        _paintBanyumas(canvas, size);
      case BlangkonType.kedu:
        _paintKedu(canvas, size);
      case BlangkonType.cirebon:
        _paintCirebon(canvas, size);
      case BlangkonType.pusaka:
        _paintPusaka(canvas, size);
    }

    if (isLocked) {
      _paintLockedOverlay(canvas, size);
    }
  }

  // ─── Yogyakarta Style ───────────────────────────────────────────────────────
  // Characteristics: Rounded dome, prominent mondolan knot, amber-brown batik,
  // classic kawung dot pattern. The most iconic Javanese blangkon.
  void _paintYogyakarta(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Shadow under hat ──
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.78), width: w * 0.82, height: h * 0.1),
      shadowPaint,
    );

    // ── Mondolan (rounded back knot) ──
    final mondolanPath = Path()
      ..moveTo(w * 0.70, h * 0.22)
      ..cubicTo(w * 0.90, h * 0.10, w * 1.08, h * 0.14, w * 1.02, h * 0.38)
      ..cubicTo(w * 0.98, h * 0.52, w * 0.84, h * 0.60, w * 0.74, h * 0.52)
      ..cubicTo(w * 0.70, h * 0.46, w * 0.68, h * 0.36, w * 0.70, h * 0.22)
      ..close();

    final mondolanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.amberDark, const Color(0xFF7A4A18)],
      ).createShader(Rect.fromLTWH(w * 0.65, h * 0.1, w * 0.4, h * 0.5));
    canvas.drawPath(mondolanPath, mondolanPaint);

    // Mondolan highlight
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.74, h * 0.24)
        ..cubicTo(w * 0.84, h * 0.14, w * 0.96, h * 0.18, w * 0.98, h * 0.30),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Mondolan seam/fold detail
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.72, h * 0.30)
        ..cubicTo(w * 0.80, h * 0.24, w * 0.90, h * 0.28, w * 0.94, h * 0.38),
      Paint()
        ..color = const Color(0xFF5A3010).withValues(alpha: 0.6)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );

    // ── Main Dome Body ──
    final bodyPath = Path()
      ..moveTo(w * 0.08, h * 0.64)
      ..cubicTo(w * 0.04, h * 0.38, w * 0.20, h * 0.07, w * 0.50, h * 0.05)
      ..cubicTo(w * 0.78, h * 0.07, w * 0.88, h * 0.33, w * 0.84, h * 0.60)
      ..lineTo(w * 0.84, h * 0.64)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF8B5A2B),
          const Color(0xFF6B3E18),
          const Color(0xFF4E2C0E),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65));
    canvas.drawPath(bodyPath, bodyPaint);

    // Dome top highlight (rim light on left-top)
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, h * 0.42)
        ..cubicTo(w * 0.28, h * 0.22, w * 0.40, h * 0.08, w * 0.52, h * 0.06),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Kawung Batik Pattern on dome ──
    _drawKawungGrid(canvas, w, h);

    // ── Pleat Folds (Wiron) on front ──
    _drawWironFolds(canvas, w, h,
        baseColor: const Color(0xFF3D2010));

    // ── Headband Brim ──
    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF2E1A08),
        trimColor: AppColors.amber,
        trimWidth: 3.0);

    // Gold center ornament badge
    _drawCenterOrnament(canvas, w, h, AppColors.amber);
  }

  // ─── Surakarta (Solo) Style ─────────────────────────────────────────────────
  // Characteristics: Trepes flat back (no mondolan), taller pointed dome,
  // deep maroon/dark-red with subtle gold stripe, refined court aesthetic.
  void _paintSurakarta(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    _drawDropShadow(canvas, w, h);

    // ── Trepes (flat folded back flap) — Surakarta has a rectangular fold ──
    final trepesPath = Path()
      ..moveTo(w * 0.76, h * 0.18)
      ..cubicTo(w * 1.0, h * 0.06, w * 1.12, h * 0.42, w * 0.98, h * 0.60)
      ..cubicTo(w * 0.90, h * 0.68, w * 0.80, h * 0.60, w * 0.78, h * 0.52)
      ..cubicTo(w * 0.76, h * 0.40, w * 0.74, h * 0.28, w * 0.76, h * 0.18)
      ..close();

    final trepesPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF9B2135), const Color(0xFF5C0F1A)],
      ).createShader(Rect.fromLTWH(w * 0.74, h * 0.06, w * 0.4, h * 0.65));
    canvas.drawPath(trepesPath, trepesPaint);

    // Trepes pleat lines
    for (int i = 0; i < 3; i++) {
      canvas.drawPath(
        Path()
          ..moveTo(w * (0.78 + i * 0.03), h * (0.22 + i * 0.04))
          ..cubicTo(
            w * (0.90 + i * 0.03), h * (0.14 + i * 0.04),
            w * (0.98 + i * 0.02), h * (0.36 + i * 0.03),
            w * (0.90 + i * 0.02), h * (0.52 + i * 0.04),
          ),
        Paint()
          ..color = AppColors.amber.withValues(alpha: 0.3 - i * 0.05)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke,
      );
    }

    // ── Main Dome (taller, slightly conical) ──
    final bodyPath = Path()
      ..moveTo(w * 0.10, h * 0.64)
      ..cubicTo(w * 0.06, h * 0.36, w * 0.22, h * 0.04, w * 0.50, h * 0.02)
      ..cubicTo(w * 0.76, h * 0.04, w * 0.86, h * 0.32, w * 0.84, h * 0.60)
      ..lineTo(w * 0.84, h * 0.64)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFA8213A),
          const Color(0xFF8B1428),
          const Color(0xFF5A0C18),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65));
    canvas.drawPath(bodyPath, bodyPaint);

    // Highlight on left of dome
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.20, h * 0.44)
        ..cubicTo(w * 0.26, h * 0.24, w * 0.38, h * 0.08, w * 0.52, h * 0.04),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Parang batik stripes across dome
    _drawParangStripes(canvas, w, h, const Color(0xFF7A1020));

    // ── Headband Brim ──
    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF3A0810),
        trimColor: AppColors.amber,
        trimWidth: 2.5);

    // Top finial jewel
    final finialPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFD97D), AppColors.amberDark],
      ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: 5));
    canvas.save();
    canvas.translate(w * 0.50, h * 0.03);
    canvas.drawCircle(Offset.zero, 4, finialPaint);
    canvas.drawCircle(Offset(-1, -1), 1.5, Paint()..color = Colors.white.withValues(alpha: 0.6));
    canvas.restore();

    _drawCenterOrnament(canvas, w, h, AppColors.amber);
  }

  // ─── Banyumas Style ─────────────────────────────────────────────────────────
  // Characteristics: Earthy dark forest green, bold white/cream geometric diagonal
  // pleat lines, robust silhouette with a small rounded knot.
  void _paintBanyumas(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawDropShadow(canvas, w, h);

    // Small rounded knot
    final knobPath = Path()
      ..moveTo(w * 0.72, h * 0.25)
      ..cubicTo(w * 0.90, h * 0.14, w * 1.04, h * 0.22, w * 0.98, h * 0.44)
      ..cubicTo(w * 0.94, h * 0.56, w * 0.80, h * 0.60, w * 0.74, h * 0.52)
      ..cubicTo(w * 0.70, h * 0.44, w * 0.70, h * 0.34, w * 0.72, h * 0.25)
      ..close();

    canvas.drawPath(
      knobPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFF2A5C38), const Color(0xFF143A22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(w * 0.68, h * 0.14, w * 0.38, h * 0.5)),
    );

    // ── Main dome ──
    final bodyPath = Path()
      ..moveTo(w * 0.07, h * 0.64)
      ..cubicTo(w * 0.03, h * 0.36, w * 0.18, h * 0.07, w * 0.50, h * 0.06)
      ..cubicTo(w * 0.80, h * 0.07, w * 0.90, h * 0.34, w * 0.86, h * 0.60)
      ..lineTo(w * 0.86, h * 0.64)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2D6B3E), const Color(0xFF1B4228)],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65)),
    );

    // Bold diagonal pleat stripes (geometric Banyumas character)
    final pleatColors = [
      const Color(0xFFE8D5A0),
      const Color(0xFF7CA870),
      const Color(0xFFE8D5A0),
      const Color(0xFF7CA870),
      const Color(0xFFE8D5A0),
    ];
    for (int i = 0; i < 5; i++) {
      final x1 = w * (0.18 + i * 0.13);
      final x2 = x1 - w * 0.05;
      canvas.drawPath(
        Path()
          ..moveTo(x1, h * 0.18)
          ..lineTo(x2, h * 0.60)
          ..lineTo(x2 + w * 0.06, h * 0.60)
          ..lineTo(x1 + w * 0.06, h * 0.18)
          ..close(),
        Paint()
          ..color = pleatColors[i].withValues(alpha: 0.28)
          ..style = PaintingStyle.fill,
      );
    }

    // Dome highlight
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.18, h * 0.44)
        ..cubicTo(w * 0.24, h * 0.24, w * 0.36, h * 0.09, w * 0.52, h * 0.07),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Brim ──
    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF102918),
        trimColor: const Color(0xFF7CA870),
        trimWidth: 2.5);

    _drawCenterOrnament(canvas, w, h, const Color(0xFFD4B060));
  }

  // ─── Kedu Style ─────────────────────────────────────────────────────────────
  // Characteristics: Warm chocolate brown, subtle hatched texture, cream trim.
  void _paintKedu(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawDropShadow(canvas, w, h);

    // Back knot (medium)
    final knobPath = Path()
      ..moveTo(w * 0.74, h * 0.24)
      ..cubicTo(w * 0.92, h * 0.14, w * 1.06, h * 0.26, w * 0.98, h * 0.46)
      ..cubicTo(w * 0.92, h * 0.58, w * 0.80, h * 0.60, w * 0.76, h * 0.52)
      ..cubicTo(w * 0.72, h * 0.42, w * 0.72, h * 0.32, w * 0.74, h * 0.24)
      ..close();
    canvas.drawPath(
      knobPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFF7A5035), const Color(0xFF4A2E18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(w * 0.70, h * 0.14, w * 0.38, h * 0.5)),
    );

    // Dome
    final bodyPath = Path()
      ..moveTo(w * 0.09, h * 0.64)
      ..cubicTo(w * 0.05, h * 0.37, w * 0.20, h * 0.07, w * 0.50, h * 0.06)
      ..cubicTo(w * 0.80, h * 0.07, w * 0.92, h * 0.33, w * 0.88, h * 0.60)
      ..lineTo(w * 0.88, h * 0.64)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF8C5C38), const Color(0xFF5A3A1E), const Color(0xFF3E2510)],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65)),
    );

    // Cross-hatch texture lines (Kedu distinctive weave detail)
    final hatchPaint = Paint()
      ..color = const Color(0xFF3A2010).withValues(alpha: 0.22)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(w * (0.14 + i * 0.09), h * 0.14),
        Offset(w * (0.08 + i * 0.09), h * 0.60),
        hatchPaint,
      );
    }
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(w * 0.14, h * (0.20 + i * 0.08)),
        Offset(w * 0.86, h * (0.22 + i * 0.07)),
        Paint()
          ..color = const Color(0xFFD4A875).withValues(alpha: 0.14)
          ..strokeWidth = 0.7
          ..style = PaintingStyle.stroke,
      );
    }

    // Dome highlight
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.20, h * 0.44)
        ..cubicTo(w * 0.26, h * 0.24, w * 0.38, h * 0.09, w * 0.52, h * 0.07),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.16)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Cream trim stripe along lower dome
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.09, h * 0.60)
        ..quadraticBezierTo(w * 0.50, h * 0.52, w * 0.88, h * 0.60),
      Paint()
        ..color = AppColors.amberSoft.withValues(alpha: 0.7)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF2E1C0E),
        trimColor: const Color(0xFFD4A875),
        trimWidth: 2.5);

    _drawCenterOrnament(canvas, w, h, const Color(0xFFD4A875));
  }

  // ─── Cirebon Style ──────────────────────────────────────────────────────────
  // Characteristics: Coastal Javanese — royal blue with gold cloud/wave motifs,
  // asymmetric silhouette influenced by Chinese-Javanese fusion aesthetics.
  void _paintCirebon(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawDropShadow(canvas, w, h);

    // Tail/wing (asymmetric Cirebon flap — slightly forward-angled)
    final wingPath = Path()
      ..moveTo(w * 0.76, h * 0.20)
      ..cubicTo(w * 0.96, h * 0.08, w * 1.10, h * 0.26, w * 1.02, h * 0.46)
      ..cubicTo(w * 0.96, h * 0.60, w * 0.82, h * 0.62, w * 0.78, h * 0.52)
      ..cubicTo(w * 0.74, h * 0.42, w * 0.72, h * 0.30, w * 0.76, h * 0.20)
      ..close();

    canvas.drawPath(
      wingPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFF1E5FA8), const Color(0xFF0D3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(w * 0.70, h * 0.08, w * 0.42, h * 0.56)),
    );

    // Dome
    final bodyPath = Path()
      ..moveTo(w * 0.07, h * 0.64)
      ..cubicTo(w * 0.03, h * 0.36, w * 0.17, h * 0.06, w * 0.46, h * 0.05)
      ..cubicTo(w * 0.70, h * 0.06, w * 0.84, h * 0.26, w * 0.84, h * 0.52)
      ..lineTo(w * 0.84, h * 0.64)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2070CC),
            const Color(0xFF1455A0),
            const Color(0xFF0A3A6E),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65)),
    );

    // Cloud/wave gold motifs (Mega Mendung Cirebon batik influence)
    final cloudPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Three curved cloud shapes
    for (int i = 0; i < 3; i++) {
      final cy = h * (0.22 + i * 0.12);
      final cx = w * (0.20 + i * 0.10);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.22, height: h * 0.14),
        math.pi, math.pi, false, cloudPaint,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.12, cy), width: w * 0.16, height: h * 0.10),
        math.pi, math.pi, false, cloudPaint,
      );
    }

    // Dome highlight
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.16, h * 0.44)
        ..cubicTo(w * 0.22, h * 0.24, w * 0.34, h * 0.09, w * 0.48, h * 0.06),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.16)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF08244E),
        trimColor: AppColors.amber,
        trimWidth: 2.8);

    _drawCenterOrnament(canvas, w, h, AppColors.amber);
  }

  // ─── Pusaka (Heirloom / Premium) Style ──────────────────────────────────────
  // Characteristics: Midnight black with gold filigree detailing, top jewel finial,
  // gemstone band, most elaborate of all — signals elite status.
  void _paintPusaka(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawDropShadow(canvas, w, h);

    // Back knot (ornate, slightly larger)
    final knobPath = Path()
      ..moveTo(w * 0.70, h * 0.20)
      ..cubicTo(w * 0.90, h * 0.08, w * 1.10, h * 0.16, w * 1.04, h * 0.42)
      ..cubicTo(w * 0.98, h * 0.58, w * 0.84, h * 0.64, w * 0.76, h * 0.54)
      ..cubicTo(w * 0.70, h * 0.46, w * 0.68, h * 0.32, w * 0.70, h * 0.20)
      ..close();

    canvas.drawPath(
      knobPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFF2A2A3E), const Color(0xFF0E0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(w * 0.66, h * 0.08, w * 0.42, h * 0.58)),
    );

    // Gold outline on knob
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.72, h * 0.22)
        ..cubicTo(w * 0.86, h * 0.12, w * 1.02, h * 0.20, w * 1.00, h * 0.42),
      Paint()
        ..color = AppColors.amber.withValues(alpha: 0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // ── Main Dome (deep charcoal/near-black) ──
    final bodyPath = Path()
      ..moveTo(w * 0.10, h * 0.64)
      ..cubicTo(w * 0.06, h * 0.36, w * 0.22, h * 0.04, w * 0.50, h * 0.02)
      ..cubicTo(w * 0.78, h * 0.04, w * 0.90, h * 0.32, w * 0.86, h * 0.58)
      ..lineTo(w * 0.86, h * 0.64)
      ..close();

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1C1C30), const Color(0xFF0A0A14)],
        ).createShader(Rect.fromLTWH(0, 0, w, h * 0.65)),
    );

    // ── Gold filigree lines (symmetric ornate pattern) ──
    final filigree = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.75)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Central vertical spine
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.50, h * 0.04)
        ..lineTo(w * 0.50, h * 0.60),
      filigree,
    );

    // Curved branches left & right
    for (int i = 0; i < 4; i++) {
      final t = 0.16 + i * 0.11;
      // Left branch
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.50, h * t)
          ..cubicTo(w * 0.42, h * (t + 0.04), w * 0.28, h * (t + 0.02), w * 0.20, h * (t + 0.06)),
        filigree,
      );
      // Right branch
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.50, h * t)
          ..cubicTo(w * 0.58, h * (t + 0.04), w * 0.72, h * (t + 0.02), w * 0.80, h * (t + 0.06)),
        filigree,
      );
      // End dots
      canvas.drawCircle(Offset(w * 0.20, h * (t + 0.06)), 2, Paint()..color = AppColors.amber);
      canvas.drawCircle(Offset(w * 0.80, h * (t + 0.06)), 2, Paint()..color = AppColors.amber);
    }

    // Rim light on dome
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.18, h * 0.44)
        ..cubicTo(w * 0.24, h * 0.22, w * 0.38, h * 0.06, w * 0.52, h * 0.03),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // ── Gold gemstone brim ──
    _drawBrim(canvas, w, h,
        brimColor: const Color(0xFF0A0A14),
        trimColor: AppColors.amber,
        trimWidth: 4.0);

    // Gemstone dots along brim
    final gemPaint = Paint()..color = AppColors.amber;
    for (int i = 0; i < 7; i++) {
      final gx = w * (0.14 + i * 0.11);
      canvas.drawCircle(Offset(gx, h * 0.68), 2.5, gemPaint);
    }

    // Top jewel finial (double sphere)
    canvas.save();
    canvas.translate(w * 0.50, h * 0.02);
    final jewel = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFE380), AppColors.amberDark],
        center: Alignment(-0.4, -0.4),
        radius: 0.9,
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 6));
    canvas.drawCircle(Offset.zero, 5.5, jewel);
    canvas.drawCircle(const Offset(-1.5, -2), 1.8, Paint()..color = Colors.white.withValues(alpha: 0.5));
    canvas.restore();
  }

  // ─── Shared Helpers ───────────────────────────────────────────────────────

  void _drawDropShadow(Canvas canvas, double w, double h) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.78), width: w * 0.80, height: h * 0.08),
      shadowPaint,
    );
  }

  /// Kawung pattern — four ellipses around a center cross
  void _drawKawungGrid(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = AppColors.kawungStroke.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centers = [
      Offset(w * 0.26, h * 0.28),
      Offset(w * 0.44, h * 0.18),
      Offset(w * 0.62, h * 0.26),
      Offset(w * 0.36, h * 0.44),
      Offset(w * 0.56, h * 0.42),
    ];

    for (final c in centers) {
      final r = w * 0.055;
      final r2 = w * 0.038;
      canvas.drawOval(Rect.fromCenter(center: c.translate(0, -r), width: r2 * 2, height: r * 2.4), paint);
      canvas.drawOval(Rect.fromCenter(center: c.translate(0, r), width: r2 * 2, height: r * 2.4), paint);
      canvas.drawOval(Rect.fromCenter(center: c.translate(-r, 0), width: r * 2.4, height: r2 * 2), paint);
      canvas.drawOval(Rect.fromCenter(center: c.translate(r, 0), width: r * 2.4, height: r2 * 2), paint);
      canvas.drawCircle(c, r2 * 0.4, Paint()..color = AppColors.kawungStroke.withValues(alpha: 0.2));
    }
  }

  /// Parang diagonal stripes (Surakarta motif)
  void _drawParangStripes(Canvas canvas, double w, double h, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Clip to dome area
    canvas.save();
    final domePath = Path()
      ..moveTo(w * 0.10, h * 0.64)
      ..cubicTo(w * 0.06, h * 0.36, w * 0.22, h * 0.04, w * 0.50, h * 0.02)
      ..cubicTo(w * 0.76, h * 0.04, w * 0.86, h * 0.32, w * 0.84, h * 0.60)
      ..close();
    canvas.clipPath(domePath);

    for (int i = -4; i < 10; i++) {
      final startX = w * (0.1 + i * 0.1);
      canvas.drawPath(
        Path()
          ..moveTo(startX, h * 0.04)
          ..cubicTo(startX + w * 0.08, h * 0.14, startX - w * 0.02, h * 0.36, startX + w * 0.06, h * 0.60),
        paint,
      );
    }
    canvas.restore();
  }

  /// Wiron / pleat folds on front face of blangkon
  void _drawWironFolds(Canvas canvas, double w, double h, {required Color baseColor}) {
    final foldPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Three central pleat arcs
    for (int i = -1; i <= 1; i++) {
      canvas.drawPath(
        Path()
          ..moveTo(w * (0.50 + i * 0.10), h * 0.60)
          ..cubicTo(
            w * (0.44 + i * 0.10), h * 0.42,
            w * (0.38 + i * 0.08), h * 0.26,
            w * (0.44 + i * 0.08), h * 0.14,
          ),
        foldPaint,
      );
    }
  }

  /// Headband brim at the bottom of the dome
  void _drawBrim(Canvas canvas, double w, double h, {
    required Color brimColor,
    required Color trimColor,
    required double trimWidth,
  }) {
    final brimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [brimColor.withValues(alpha: 0.9), brimColor],
      ).createShader(Rect.fromLTWH(0, h * 0.63, w, h * 0.16));

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, h * 0.63, w, h * 0.17),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
        bottomLeft: const Radius.circular(5),
        bottomRight: const Radius.circular(5),
      ),
      brimPaint,
    );

    // Trim line at top of brim
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.63)
        ..lineTo(w, h * 0.63),
      Paint()
        ..color = trimColor.withValues(alpha: 0.7)
        ..strokeWidth = trimWidth
        ..style = PaintingStyle.stroke,
    );

    // Brim shine
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.08, h * 0.70)
        ..lineTo(w * 0.42, h * 0.70),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Center front ornament badge
  void _drawCenterOrnament(Canvas canvas, double w, double h, Color color) {
    final cx = w * 0.50;
    final cy = h * 0.60;

    // Diamond shape
    final diamPath = Path()
      ..moveTo(cx, cy - h * 0.05)
      ..lineTo(cx + w * 0.03, cy)
      ..lineTo(cx, cy + h * 0.04)
      ..lineTo(cx - w * 0.03, cy)
      ..close();
    canvas.drawPath(
      diamPath,
      Paint()..color = color.withValues(alpha: 0.85),
    );

    // Inner gem highlight
    canvas.drawCircle(
      Offset(cx - w * 0.006, cy - h * 0.012),
      w * 0.008,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
  }

  void _paintLockedOverlay(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.48);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      overlayPaint,
    );

    // Lock icon drawn as vector
    final lockPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Shackle arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 8), width: 14, height: 12),
      math.pi, math.pi, false, lockPaint,
    );
    // Lock body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 2), width: 18, height: 14), const Radius.circular(3)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.80)
        ..style = PaintingStyle.fill,
    );
    // Keyhole
    canvas.drawCircle(Offset(cx, cy + 1), 3, Paint()..color = Colors.black.withValues(alpha: 0.5));
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + 4.5), width: 2.5, height: 4),
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(BlangkonPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.isLocked != isLocked;
}
