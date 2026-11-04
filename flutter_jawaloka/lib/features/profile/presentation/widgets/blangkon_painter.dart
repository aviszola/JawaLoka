import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Blangkon types available in JawaLoka
enum BlangkonType {
  jogja,
  solo,
  betawi,
  madura,
  premium,
}

/// Renders a traditional Javanese blangkon hat using CustomPainter.
/// Each type has a distinct vector shape and color scheme.
class BlangkonPainter extends CustomPainter {
  final BlangkonType type;
  final bool isLocked;

  const BlangkonPainter({required this.type, this.isLocked = false});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case BlangkonType.jogja:
        _paintJogja(canvas, size);
        break;
      case BlangkonType.solo:
        _paintSolo(canvas, size);
        break;
      case BlangkonType.betawi:
        _paintBetawi(canvas, size);
        break;
      case BlangkonType.madura:
        _paintMadura(canvas, size);
        break;
      case BlangkonType.premium:
        _paintPremium(canvas, size);
        break;
    }

    if (isLocked) {
      _paintLockedOverlay(canvas, size);
    }
  }

  // ─── Jogja Style ──────────────────────────────────────────────────────────
  // Characteristics: Rounded dome, flat front, amber/gold with kawung pattern
  void _paintJogja(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base dome body
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.amber, AppColors.amberDark],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.1, h * 0.65)
      ..quadraticBezierTo(w * 0.05, h * 0.35, w * 0.5, h * 0.08)
      ..quadraticBezierTo(w * 0.95, h * 0.35, w * 0.9, h * 0.65)
      ..lineTo(w, h * 0.68)
      ..lineTo(0, h * 0.68)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Brim band
    final brimPaint = Paint()..color = AppColors.kawungStroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * 0.65, w, h * 0.14),
        const Radius.circular(4),
      ),
      brimPaint,
    );

    // Mondolan (the knot/bow at the back – shown as a teardrop on right)
    final knobPaint = Paint()..color = AppColors.amberDark;
    final knobPath = Path()
      ..moveTo(w * 0.78, h * 0.28)
      ..quadraticBezierTo(w * 1.0, h * 0.18, w * 0.92, h * 0.42)
      ..quadraticBezierTo(w * 0.85, h * 0.52, w * 0.78, h * 0.42)
      ..close();
    canvas.drawPath(knobPath, knobPaint);

    // Kawung dot pattern on dome
    _drawKawungPattern(canvas, Offset(w * 0.3, h * 0.35), 5, AppColors.kawungStroke.withOpacity(0.5));
    _drawKawungPattern(canvas, Offset(w * 0.5, h * 0.22), 5, AppColors.kawungStroke.withOpacity(0.5));
    _drawKawungPattern(canvas, Offset(w * 0.65, h * 0.38), 5, AppColors.kawungStroke.withOpacity(0.5));

    // Top highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.08), width: w * 0.6, height: h * 0.4),
      3.5, 2.4, false, highlightPaint,
    );
  }

  // ─── Solo Style ───────────────────────────────────────────────────────────
  // Characteristics: Taller pointed crown, maroon/dark red, gold trim stripe
  void _paintSolo(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF8B1A2A), const Color(0xFF5C0F1A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Taller, slightly pointed dome
    final bodyPath = Path()
      ..moveTo(w * 0.12, h * 0.65)
      ..cubicTo(w * 0.08, h * 0.40, w * 0.25, h * 0.05, w * 0.5, h * 0.03)
      ..cubicTo(w * 0.75, h * 0.05, w * 0.92, h * 0.40, w * 0.88, h * 0.65)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Gold trim stripe
    final trimPaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final trimPath = Path()
      ..moveTo(w * 0.12, h * 0.65)
      ..quadraticBezierTo(w * 0.5, h * 0.72, w * 0.88, h * 0.65);
    canvas.drawPath(trimPath, trimPaint);

    // Brim
    final brimPaint = Paint()..color = const Color(0xFF3A0A10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(3)),
      brimPaint,
    );

    // Mondolan Solo (longer, pointed)
    final knobPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF8B1A2A), const Color(0xFF5C0F1A)],
      ).createShader(Rect.fromLTWH(w * 0.75, h * 0.1, w * 0.3, h * 0.5));
    final knobPath = Path()
      ..moveTo(w * 0.80, h * 0.22)
      ..cubicTo(w * 1.05, h * 0.08, w * 1.1, h * 0.5, w * 0.88, h * 0.58)
      ..quadraticBezierTo(w * 0.80, h * 0.52, w * 0.80, h * 0.38)
      ..close();
    canvas.drawPath(knobPath, knobPaint);

    // Gold line on knob
    final knobTrimPaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.80, h * 0.30)
        ..cubicTo(w * 0.95, h * 0.18, w * 1.0, h * 0.44, w * 0.88, h * 0.52),
      knobTrimPaint,
    );

    // Decorative top finial
    final finialPaint = Paint()..color = AppColors.amber;
    canvas.drawCircle(Offset(w * 0.5, h * 0.03), 5, finialPaint);
  }

  // ─── Betawi Style ─────────────────────────────────────────────────────────
  // Characteristics: Flatter, wide brim, colorful multicolor stripes
  void _paintBetawi(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Wide flat-ish dome
    final domePaint = Paint()..color = const Color(0xFF1A6B3A);
    final domePath = Path()
      ..moveTo(w * 0.05, h * 0.60)
      ..quadraticBezierTo(w * 0.02, h * 0.30, w * 0.5, h * 0.12)
      ..quadraticBezierTo(w * 0.98, h * 0.30, w * 0.95, h * 0.60)
      ..close();
    canvas.drawPath(domePath, domePaint);

    // Colorful horizontal stripe bands
    final stripeColors = [
      const Color(0xFFE63946),
      const Color(0xFFFFD166),
      const Color(0xFF06D6A0),
      const Color(0xFF118AB2),
    ];
    for (int i = 0; i < stripeColors.length; i++) {
      final yTop = h * (0.42 + i * 0.045);
      final stripePaint = Paint()
        ..color = stripeColors[i]
        ..strokeWidth = h * 0.04
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(w * (0.07 + i * 0.02), yTop),
        Offset(w * (0.93 - i * 0.02), yTop),
        stripePaint,
      );
    }

    // Wide brim
    final brimPaint = Paint()..color = const Color(0xFF0D4A28);
    final brimPath = Path()
      ..moveTo(-w * 0.1, h * 0.60)
      ..lineTo(w * 1.1, h * 0.60)
      ..lineTo(w * 1.05, h * 0.76)
      ..lineTo(-w * 0.05, h * 0.76)
      ..close();
    canvas.drawPath(brimPath, brimPaint);

    // Gold brim edge
    final brimEdgePaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(-w * 0.1, h * 0.60), Offset(w * 1.1, h * 0.60), brimEdgePaint);
    canvas.drawLine(Offset(-w * 0.05, h * 0.76), Offset(w * 1.05, h * 0.76), brimEdgePaint);
  }

  // ─── Madura Style ─────────────────────────────────────────────────────────
  // Characteristics: Asymmetric dome with one raised side, blue-green (locked)
  void _paintMadura(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Asymmetric dome (left side taller)
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF1565C0), const Color(0xFF004D7A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.08, h * 0.65)
      ..cubicTo(w * 0.04, h * 0.35, w * 0.18, h * 0.05, w * 0.42, h * 0.08)
      ..cubicTo(w * 0.62, h * 0.10, w * 0.78, h * 0.22, w * 0.88, h * 0.40)
      ..quadraticBezierTo(w * 0.92, h * 0.55, w * 0.92, h * 0.65)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Teal accent stripe
    final accentPaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final accentPath = Path()
      ..moveTo(w * 0.15, h * 0.45)
      ..cubicTo(w * 0.3, h * 0.25, w * 0.6, h * 0.20, w * 0.80, h * 0.42);
    canvas.drawPath(accentPath, accentPaint);

    // Brim
    final brimPaint = Paint()..color = const Color(0xFF003058);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(3)),
      brimPaint,
    );

    // Red decorative triangle motif (Madura flag colors)
    final motifPaint = Paint()..color = const Color(0xFFE53935).withOpacity(0.7);
    final trianglePath = Path()
      ..moveTo(w * 0.42, h * 0.25)
      ..lineTo(w * 0.52, h * 0.42)
      ..lineTo(w * 0.32, h * 0.42)
      ..close();
    canvas.drawPath(trianglePath, motifPaint);
  }

  // ─── Premium Style ────────────────────────────────────────────────────────
  // Characteristics: Tall, sleek, black with gold filigree, gem at top
  void _paintPremium(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sleek tall dome – near-black
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF1A1A2E), const Color(0xFF0D0D1A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.12, h * 0.65)
      ..cubicTo(w * 0.08, h * 0.38, w * 0.28, h * 0.04, w * 0.5, h * 0.02)
      ..cubicTo(w * 0.72, h * 0.04, w * 0.92, h * 0.38, w * 0.88, h * 0.65)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Gold filigree lines
    final filigreeePaint = Paint()
      ..color = AppColors.amber.withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Left spiral line
    final leftLine = Path()
      ..moveTo(w * 0.25, h * 0.60)
      ..cubicTo(w * 0.18, h * 0.40, w * 0.28, h * 0.22, w * 0.5, h * 0.12);
    canvas.drawPath(leftLine, filigreeePaint);

    // Right spiral line
    final rightLine = Path()
      ..moveTo(w * 0.75, h * 0.60)
      ..cubicTo(w * 0.82, h * 0.40, w * 0.72, h * 0.22, w * 0.5, h * 0.12);
    canvas.drawPath(rightLine, filigreeePaint);

    // Center vertical line
    canvas.drawLine(Offset(w * 0.5, h * 0.12), Offset(w * 0.5, h * 0.65), filigreeePaint);

    // Gold brim
    final brimPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.amberDark, AppColors.amber, AppColors.amberDark],
      ).createShader(Rect.fromLTWH(0, h * 0.65, w, h * 0.14));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(4)),
      brimPaint,
    );

    // Gem/jewel at top
    final gemPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFE040FB), const Color(0xFF7B1FA2)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.02), radius: 8));
    canvas.drawCircle(Offset(w * 0.5, h * 0.02), 7, gemPaint);

    final gemHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.02), width: 8, height: 8),
      3.9, 1.6, false, gemHighlightPaint,
    );

    // Mondolan premium (long elegant tail)
    final tailPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF1A1A2E), AppColors.amberDark.withOpacity(0.6)],
      ).createShader(Rect.fromLTWH(w * 0.7, h * 0.1, w * 0.4, h * 0.5));
    final tailPath = Path()
      ..moveTo(w * 0.80, h * 0.18)
      ..cubicTo(w * 1.08, h * 0.05, w * 1.12, h * 0.55, w * 0.90, h * 0.60)
      ..cubicTo(w * 0.85, h * 0.60, w * 0.82, h * 0.50, w * 0.80, h * 0.38)
      ..close();
    canvas.drawPath(tailPath, tailPaint);

    // Gold trim on tail
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.80, h * 0.28)
        ..cubicTo(w * 0.98, h * 0.12, w * 1.05, h * 0.50, w * 0.90, h * 0.56),
      filigreeePaint,
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _drawKawungPattern(Canvas canvas, Offset center, double r, Color color) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center.translate(-r, 0), r, p);
    canvas.drawCircle(center.translate(r, 0), r, p);
    canvas.drawCircle(center.translate(0, -r), r, p);
    canvas.drawCircle(center.translate(0, r), r, p);
  }

  void _paintLockedOverlay(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)),
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(BlangkonPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.isLocked != isLocked;
}
