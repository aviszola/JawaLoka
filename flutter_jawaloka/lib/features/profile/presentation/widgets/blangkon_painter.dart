import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Blangkon types available in JawaLoka
// PERLU VALIDASI BUDAYA
enum BlangkonType {
  yogyakarta,
  surakarta,
  banyumas,
  kedu,
  cirebon,
  pusaka,
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
      case BlangkonType.yogyakarta:
        _paintYogyakarta(canvas, size);
        break;
      case BlangkonType.surakarta:
        _paintSurakarta(canvas, size);
        break;
      case BlangkonType.banyumas:
        _paintBanyumas(canvas, size);
        break;
      case BlangkonType.kedu:
        _paintKedu(canvas, size);
        break;
      case BlangkonType.cirebon:
        _paintCirebon(canvas, size);
        break;
      case BlangkonType.pusaka:
        _paintPusaka(canvas, size);
        break;
    }

    if (isLocked) {
      _paintLockedOverlay(canvas, size);
    }
  }

  // ─── Yogyakarta Style ─────────────────────────────────────────────────────
  // Characteristics: Rounded dome, flat front, amber/gold with kawung pattern, mondolan rounded knot
  void _paintYogyakarta(Canvas canvas, Size size) {
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

    // Mondolan (rounded knot at the back)
    final knobPaint = Paint()..color = AppColors.amberDark;
    final knobPath = Path()
      ..moveTo(w * 0.78, h * 0.28)
      ..quadraticBezierTo(w * 1.0, h * 0.18, w * 0.92, h * 0.42)
      ..quadraticBezierTo(w * 0.85, h * 0.52, w * 0.78, h * 0.42)
      ..close();
    canvas.drawPath(knobPath, knobPaint);

    // Kawung dot pattern on dome
    _drawKawungPattern(canvas, Offset(w * 0.3, h * 0.35), 5, AppColors.kawungStroke.withValues(alpha: 0.5));
    _drawKawungPattern(canvas, Offset(w * 0.5, h * 0.22), 5, AppColors.kawungStroke.withValues(alpha: 0.5));
    _drawKawungPattern(canvas, Offset(w * 0.65, h * 0.38), 5, AppColors.kawungStroke.withValues(alpha: 0.5));

    // Top highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.08), width: w * 0.6, height: h * 0.4),
      3.5, 2.4, false, highlightPaint,
    );
  }

  // ─── Surakarta Style ──────────────────────────────────────────────────────
  // Characteristics: Flat trepes back (no rounded mondolan), maroon/dark red, gold trim stripe
  void _paintSurakarta(Canvas canvas, Size size) {
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

    // Trepes Surakarta (flatter folded back)
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

  // ─── Banyumas Style ───────────────────────────────────────────────────────
  // Characteristics: Bold dark-blue pattern with earth tone trim
  void _paintBanyumas(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF1B3B2B), const Color(0xFF0F241A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.08, h * 0.65)
      ..quadraticBezierTo(w * 0.05, h * 0.32, w * 0.5, h * 0.10)
      ..quadraticBezierTo(w * 0.95, h * 0.32, w * 0.92, h * 0.65)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Diagonal pleat lines
    final pleatPaint = Paint()
      ..color = const Color(0xFF7CA982)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(
        Offset(w * (0.2 + i * 0.12), h * 0.25),
        Offset(w * (0.15 + i * 0.12), h * 0.60),
        pleatPaint,
      );
    }

    // Brim
    final brimPaint = Paint()..color = const Color(0xFF0D1F16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(4)),
      brimPaint,
    );
  }

  // ─── Kedu Style ───────────────────────────────────────────────────────────
  // Characteristics: Bagelen traditional style, warm umber and gold accents
  void _paintKedu(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF5D4037), const Color(0xFF3E2723)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.10, h * 0.65)
      ..cubicTo(w * 0.06, h * 0.36, w * 0.22, h * 0.08, w * 0.5, h * 0.06)
      ..cubicTo(w * 0.78, h * 0.08, w * 0.94, h * 0.36, w * 0.90, h * 0.65)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    final trimPaint = Paint()
      ..color = AppColors.amberSoft
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.10, h * 0.65), Offset(w * 0.90, h * 0.65), trimPaint);

    final brimPaint = Paint()..color = const Color(0xFF2E1C14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(4)),
      brimPaint,
    );
  }

  // ─── Cirebon Style ────────────────────────────────────────────────────────
  // Characteristics: Coastal Javanese influence with dynamic wave-inspired pleats
  void _paintCirebon(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      ..moveTo(w * 0.08, h * 0.65)
      ..cubicTo(w * 0.04, h * 0.35, w * 0.18, h * 0.05, w * 0.45, h * 0.08)
      ..cubicTo(w * 0.65, h * 0.10, w * 0.80, h * 0.22, w * 0.90, h * 0.42)
      ..quadraticBezierTo(w * 0.92, h * 0.55, w * 0.92, h * 0.65)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    final accentPaint = Paint()
      ..color = const Color(0xFF90CAF9)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final accentPath = Path()
      ..moveTo(w * 0.15, h * 0.48)
      ..cubicTo(w * 0.3, h * 0.28, w * 0.6, h * 0.22, w * 0.82, h * 0.44);
    canvas.drawPath(accentPath, accentPaint);

    final brimPaint = Paint()..color = const Color(0xFF0A2E63);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(3)),
      brimPaint,
    );
  }

  // ─── Pusaka Style ─────────────────────────────────────────────────────────
  // Characteristics: Deep charcoal batik with royal gold filigree
  void _paintPusaka(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

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

    final filigreePaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final leftLine = Path()
      ..moveTo(w * 0.25, h * 0.60)
      ..cubicTo(w * 0.18, h * 0.40, w * 0.28, h * 0.22, w * 0.5, h * 0.12);
    canvas.drawPath(leftLine, filigreePaint);

    final rightLine = Path()
      ..moveTo(w * 0.75, h * 0.60)
      ..cubicTo(w * 0.82, h * 0.40, w * 0.72, h * 0.22, w * 0.5, h * 0.12);
    canvas.drawPath(rightLine, filigreePaint);

    canvas.drawLine(Offset(w * 0.5, h * 0.12), Offset(w * 0.5, h * 0.65), filigreePaint);

    final brimPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.amberDark, AppColors.amber, AppColors.amberDark],
      ).createShader(Rect.fromLTWH(0, h * 0.65, w, h * 0.14));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.65, w, h * 0.14), const Radius.circular(4)),
      brimPaint,
    );

    final finialPaint = Paint()..color = AppColors.amber;
    canvas.drawCircle(Offset(w * 0.5, h * 0.03), 4, finialPaint);
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
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)),
      overlayPaint,
    );
  }

  @override
  bool shouldRepaint(BlangkonPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.isLocked != isLocked;
}
