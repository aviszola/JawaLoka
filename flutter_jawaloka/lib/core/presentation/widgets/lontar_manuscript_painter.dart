import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Authentic hand-crafted vector painter rendering an open Javanese Lontar Manuscript:
///
/// Filosofi & Makna Budaya Jawa:
/// - "Ron Tal / Lontar": Media serat daun siwalan/tal tempat para pujangga Jawa menggoreskan serat piwulang luhur, babad, dan tembang macapat.
/// - "Tali Pengikat Sutra (Benang Pengunci)": Simbol jalinan tali silaturahmi dan kesatuan budi pekerti yang tidak terputus antar generasi.
/// - "Goresan Aksara Carakan": Tinta getah damar alami pada lempung lontar, melambangkan ilmu sejati yang tak luntur dimakan zaman (nguri-uri kabudayan).
class LontarManuscriptPainter extends CustomPainter {
  final Color baseColor;

  const LontarManuscriptPainter({this.baseColor = AppColors.ink});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;
    final sx = w / 100.0;
    final sy = h / 100.0;

    canvas.save();

    final leafFill = Paint()
      ..color = const Color(0xFFF1E4C8)
      ..style = PaintingStyle.fill;

    final leafBorder = Paint()
      ..color = baseColor.withValues(alpha: 0.75)
      ..strokeWidth = 1.4 * sx
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = baseColor.withValues(alpha: 0.60)
      ..strokeWidth = 1.0 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // ── 1. Daun Lontar Bawah (Lempir Lontar 1) ─────────────────────────────────
    final leaf1 = Path()
      ..moveTo(8 * sx, 42 * sy)
      ..cubicTo(20 * sx, 38 * sy, 70 * sx, 38 * sy, 92 * sx, 44 * sy)
      ..cubicTo(95 * sx, 45 * sy, 96 * sx, 48 * sy, 94 * sx, 56 * sy)
      ..cubicTo(70 * sx, 52 * sy, 20 * sx, 52 * sy, 6 * sx, 58 * sy)
      ..cubicTo(4 * sx, 50 * sy, 5 * sx, 44 * sy, 8 * sx, 42 * sy)
      ..close();
    canvas.drawPath(leaf1, leafFill);
    canvas.drawPath(leaf1, leafBorder);

    // ── 2. Daun Lontar Atas Utama (Lempir Lontar Terbuka) ─────────────────────
    final leaf2 = Path()
      ..moveTo(10 * sx, 24 * sy)
      ..cubicTo(25 * sx, 20 * sy, 75 * sx, 20 * sy, 90 * sx, 26 * sy)
      ..cubicTo(93 * sx, 28 * sy, 94 * sx, 32 * sy, 92 * sx, 42 * sy)
      ..cubicTo(75 * sx, 36 * sy, 25 * sx, 36 * sy, 8 * sx, 42 * sy)
      ..cubicTo(6 * sx, 32 * sy, 7 * sx, 26 * sy, 10 * sx, 24 * sy)
      ..close();
    canvas.drawPath(leaf2, leafFill);
    canvas.drawPath(leaf2, leafBorder);

    // Lubang tali lontar di tengah (Titik Pengikat Ron Tal)
    final holePaint = Paint()
      ..color = baseColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(22 * sx, 32 * sy), 1.6 * sx, holePaint);
    canvas.drawCircle(Offset(50 * sx, 30 * sy), 1.6 * sx, holePaint);
    canvas.drawCircle(Offset(78 * sx, 32 * sy), 1.6 * sx, holePaint);

    // ── 3. Goresan Baris Aksara Carakan Kuno ─────────────────────────────────
    _drawScriptLine(canvas, 28 * sx, 68 * sx, 28 * sy, linePaint);
    _drawScriptLine(canvas, 14 * sx, 84 * sx, 33 * sy, linePaint);
    _drawScriptLine(canvas, 16 * sx, 82 * sx, 38 * sy, linePaint);

    // ── 4. Tali Sutra Pengikat & Rumbai Ron Tal ──────────────────────────────
    final cordPaint = Paint()
      ..color = const Color(0xFFC04020)
      ..strokeWidth = 1.3 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cordPath = Path()
      ..moveTo(50 * sx, 31 * sy)
      ..cubicTo(52 * sx, 48 * sy, 46 * sx, 64 * sy, 54 * sx, 82 * sy)
      ..cubicTo(56 * sx, 88 * sy, 52 * sx, 94 * sy, 48 * sx, 96 * sy);
    canvas.drawPath(cordPath, cordPaint);

    // Bandul kayu pengunci lontar (Klenting Kayu)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(54 * sx, 82 * sy),
        width: 4 * sx,
        height: 7 * sy,
      ),
      Paint()..color = const Color(0xFF8B4513),
    );

    canvas.restore();
  }

  void _drawScriptLine(
    Canvas canvas,
    double x1,
    double x2,
    double y,
    Paint paint,
  ) {
    final path = Path()..moveTo(x1, y);
    final count = ((x2 - x1) / 3.0).floor();
    for (int i = 0; i < count; i++) {
      final cx = x1 + i * 3.0 + 1.5;
      path.quadraticBezierTo(cx, y - 0.8, x1 + (i + 1) * 3.0, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LontarManuscriptPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor;
  }
}
