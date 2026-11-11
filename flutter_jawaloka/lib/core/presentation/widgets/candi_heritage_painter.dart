import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Authentic hand-crafted vector painter rendering an ancient Javanese Candi (temple stupa):
///
/// Filosofi & Makna Budaya Jawa:
/// - "Padmasana": Landasan teratai berlekuk ganda, simbol kesucian jiwa yang mekar dari lumpur duniawi.
/// - "Stupa Terawang": Cungkup genta berongga belah ketupat (khas Borobudur), melambangkan tingkatan Arupadhatu (alam tanpa wujud, puncak kebijaksanaan).
/// - "Ratna & Chhatra": Puncak stupa bertingkat menunjuk ke angkasa, simbol keluhuran cita-cita dan hubungan vertikal dengan Sang Hyang Widhi.
class CandiHeritagePainter extends CustomPainter {
  final Color baseColor;

  const CandiHeritagePainter({this.baseColor = AppColors.ink});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;
    final sx = w / 100.0;
    final sy = h / 100.0;

    canvas.save();

    final paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = baseColor
      ..strokeWidth = 1.2 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // ── 1. Padmasana (Curving Lotus Petal Foundation) ─────────────────────────
    final plinthPath = Path()
      ..moveTo(8 * sx, 92 * sy)
      ..cubicTo(14 * sx, 87 * sy, 24 * sx, 86 * sy, 50 * sx, 86 * sy)
      ..cubicTo(76 * sx, 86 * sy, 86 * sx, 87 * sy, 92 * sx, 92 * sy)
      ..lineTo(94 * sx, 95 * sy)
      ..lineTo(6 * sx, 95 * sy)
      ..close();
    canvas.drawPath(plinthPath, paint);

    // Kelopak Teratai (Padma) berlekuk halus
    for (int i = 0; i < 5; i++) {
      final cx = (20 + i * 15) * sx;
      final petal = Path()
        ..moveTo(cx - 5 * sx, 91 * sy)
        ..cubicTo(
          cx - 3 * sx,
          87 * sy,
          cx + 3 * sx,
          87 * sy,
          cx + 5 * sx,
          91 * sy,
        )
        ..close();
      canvas.drawPath(petal, linePaint);
    }

    // ── 2. Rupadhatu Terraces (Undakan Berpelipit Anggun) ────────────────────
    final t2Path = Path()
      ..moveTo(16 * sx, 86 * sy)
      ..cubicTo(18 * sx, 78 * sy, 24 * sx, 76 * sy, 28 * sx, 75 * sy)
      ..lineTo(72 * sx, 75 * sy)
      ..cubicTo(76 * sx, 76 * sy, 82 * sx, 78 * sy, 84 * sx, 86 * sy)
      ..close();
    canvas.drawPath(t2Path, paint);

    final t3Path = Path()
      ..moveTo(24 * sx, 75 * sy)
      ..cubicTo(26 * sx, 68 * sy, 30 * sx, 66 * sy, 34 * sx, 65 * sy)
      ..lineTo(66 * sx, 65 * sy)
      ..cubicTo(70 * sx, 66 * sy, 74 * sx, 68 * sy, 76 * sx, 75 * sy)
      ..close();
    canvas.drawPath(t3Path, paint);

    // ── 3. Stupa Genta Utama Berlekuk Parabolik Luwes ─────────────────────────
    final stupaDome = Path()
      ..moveTo(28 * sx, 65 * sy)
      ..cubicTo(27 * sx, 46 * sy, 36 * sx, 32 * sy, 50 * sx, 28 * sy)
      ..cubicTo(64 * sx, 32 * sy, 73 * sx, 46 * sy, 72 * sx, 65 * sy)
      ..close();
    canvas.drawPath(stupaDome, paint);

    // Rongga Belah Ketupat Stupa Terawang (Jali-Jali Borobudur)
    final holePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;

    _drawDiamondHole(
      canvas,
      Offset(50 * sx, 42 * sy),
      4 * sx,
      6 * sy,
      holePaint,
    );
    _drawDiamondHole(
      canvas,
      Offset(42 * sx, 49 * sy),
      3.5 * sx,
      5.5 * sy,
      holePaint,
    );
    _drawDiamondHole(
      canvas,
      Offset(58 * sx, 49 * sy),
      3.5 * sx,
      5.5 * sy,
      holePaint,
    );
    _drawDiamondHole(
      canvas,
      Offset(50 * sx, 56 * sy),
      4 * sx,
      6 * sy,
      holePaint,
    );

    // ── 4. Stupa Pengapit Kiri & Kanan (Stupa Cilik) ──────────────────────────
    _drawFlankStupa(canvas, Offset(23 * sx, 75 * sy), 10 * sx, 18 * sy, paint);
    _drawFlankStupa(canvas, Offset(77 * sx, 75 * sy), 10 * sx, 18 * sy, paint);

    // ── 5. Harmika & Chhatra (Puncak Bertingkat dan Jarum Ratna) ─────────────
    // Landasan Harmika
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(50 * sx, 25 * sy),
          width: 12 * sx,
          height: 4 * sy,
        ),
        Radius.circular(1 * sx),
      ),
      paint,
    );

    // Piringan Payung Bertingkat (Chhatra)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(50 * sx, 21 * sy),
          width: 8 * sx,
          height: 2.5 * sy,
        ),
        Radius.circular(1 * sx),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(50 * sx, 17 * sy),
          width: 5 * sx,
          height: 2 * sy,
        ),
        Radius.circular(1 * sx),
      ),
      paint,
    );

    // Jarum Mastaka & Permata Puncak
    final spire = Path()
      ..moveTo(48.8 * sx, 16 * sy)
      ..cubicTo(49.2 * sx, 10 * sy, 49.5 * sx, 7 * sy, 50 * sx, 4 * sy)
      ..cubicTo(50.5 * sx, 7 * sy, 50.8 * sx, 10 * sy, 51.2 * sx, 16 * sy)
      ..close();
    canvas.drawPath(spire, paint);

    // Mustika permata puncak
    canvas.drawCircle(Offset(50 * sx, 3.5 * sy), 2 * sx, paint);

    canvas.restore();
  }

  void _drawDiamondHole(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    final path = Path()
      ..moveTo(center.dx, center.dy - h / 2)
      ..lineTo(center.dx + w / 2, center.dy)
      ..lineTo(center.dx, center.dy + h / 2)
      ..lineTo(center.dx - w / 2, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawFlankStupa(
    Canvas canvas,
    Offset base,
    double w,
    double h,
    Paint paint,
  ) {
    final halfW = w / 2;
    final path = Path()
      ..moveTo(base.dx - halfW, base.dy)
      ..cubicTo(
        base.dx - halfW * 0.9,
        base.dy - h * 0.55,
        base.dx - halfW * 0.4,
        base.dy - h * 0.85,
        base.dx,
        base.dy - h,
      )
      ..cubicTo(
        base.dx + halfW * 0.4,
        base.dy - h * 0.85,
        base.dx + halfW * 0.9,
        base.dy - h * 0.55,
        base.dx + halfW,
        base.dy,
      )
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(base.dx, base.dy - h - 1.5), 1.2, paint);
  }

  @override
  bool shouldRepaint(covariant CandiHeritagePainter oldDelegate) {
    return oldDelegate.baseColor != baseColor;
  }
}
