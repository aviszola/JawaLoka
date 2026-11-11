import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Masterful fluid vector painter depicting a poetic Javanese morning vista:
///
/// Filosofi & Makna Budaya Jawa:
/// 1. "Langit Fajar Mawur": Langit fajar lembut melambangkan babak anyar pasinaon (awal pencerahan budi pekerti).
/// 2. "Awan Megamendung Luwes": Lengkungan awan gaya batik Megamendung Cirebon/Jawa pesisiran yang mengalir dinamis tanpa sudut kaku.
/// 3. "Surya Kencana": Matahari fajar emas (#F5B838) dengan pendar cahaya melambangkan sumber urip lan kawruh luhur.
/// 4. "Gunung Merapi & Merbabu": Siluet gunung kembar dengan punggung melengkung anggun berselimut kabut lembut, simbol pasak bumi dan keteguhan iman (Mahameru).
/// 5. "Terasering Alun Toya": Undakan sawah organik bergelombang memantulkan air pagi (Gemah Ripah Loh Jinawi), menyimbolkan ketekunan olah batin setapak demi setapak.
/// 6. "Waringin Kurung & Lung-Lungan": Siluet pohon beringin teduh dengan sulur menjuntai, lambang pangayoman dan keluhuran budi luhur.
/// 7. "Peksi Kuntul Mabur": Burung bangau putih terbang melengkung anggun di atas sawah, perlambang kebebasan jiwa yang berpengetahuan.
class JavaneseScenicIllustrationPainter extends CustomPainter {
  final double progress;

  const JavaneseScenicIllustrationPainter({this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;
    final sx = w / 100.0;
    final sy = h / 100.0;

    canvas.save();

    // ── 1. Langit Fajar Mawur (Soft Dawn Gradient) ───────────────────────────
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFF8EC), Color(0xFFFFF0D4), Color(0xFFFFE6B8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // ── 2. Awan Megamendung Luwes (Stylized Javanese Cloud Curls) ─────────────
    _drawBatikCloud(canvas, Offset(22 * sx, 20 * sy), 22 * sx, 9 * sy);
    _drawBatikCloud(canvas, Offset(80 * sx, 16 * sy), 18 * sx, 7 * sy);

    // ── 3. Surya Kencana (Golden Rising Sun with Soft Ambient Halo) ───────────
    final sunCenter = Offset(66 * sx, 34 * sy);
    final sunRadius = 14 * sy;

    // Ambient radial halo
    final haloPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFFF5B838).withValues(alpha: 0.32),
              const Color(0xFFFFA834).withValues(alpha: 0.10),
              Colors.transparent,
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(
            Rect.fromCircle(center: sunCenter, radius: sunRadius * 2.8),
          );
    canvas.drawCircle(sunCenter, sunRadius * 2.8, haloPaint);

    // Inner glowing sun disk
    final sunPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFF2D0), Color(0xFFF5B838)],
        center: Alignment(-0.2, -0.2),
        radius: 0.9,
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius));
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // ── 4. Gunung Kembar Merapi & Merbabu (Organic Curving Silhouettes) ───────
    // Gunung Belakang (Merbabu / Lawu) - lebih lembut dengan kabut fajar
    final Path farMountain = Path()
      ..moveTo(8 * sx, 75 * sy)
      ..cubicTo(20 * sx, 52 * sy, 32 * sx, 38 * sy, 44 * sx, 28 * sy)
      ..cubicTo(48 * sx, 25 * sy, 54 * sx, 25 * sy, 58 * sx, 30 * sy)
      ..cubicTo(68 * sx, 42 * sy, 78 * sx, 58 * sy, 90 * sx, 75 * sy)
      ..close();

    final farMountainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B6852), Color(0xFF284D3C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 25 * sy, 95 * sx, 50 * sy));
    canvas.drawPath(farMountain, farMountainPaint);

    // Kabut Fajar di sela lembah
    final mistPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.45),
          Colors.white.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 48 * sy, w, 20 * sy));
    final mistPath = Path()
      ..moveTo(0, 62 * sy)
      ..cubicTo(30 * sx, 56 * sy, 60 * sx, 64 * sy, 100 * sx, 58 * sy)
      ..lineTo(100 * sx, 68 * sy)
      ..cubicTo(60 * sx, 72 * sy, 30 * sx, 66 * sy, 0, 72 * sy)
      ..close();
    canvas.drawPath(mistPath, mistPaint);

    // Gunung Depan Utama (Merapi) - siluet megah dan tegas namun berlekuk alami
    final Path nearMountain = Path()
      ..moveTo(-5 * sx, 80 * sy)
      ..cubicTo(8 * sx, 64 * sy, 18 * sx, 48 * sy, 26 * sx, 34 * sy)
      ..cubicTo(29 * sx, 29 * sy, 34 * sx, 29 * sy, 38 * sx, 35 * sy)
      ..cubicTo(48 * sx, 50 * sy, 62 * sx, 66 * sy, 76 * sx, 80 * sy)
      ..close();

    final nearMountainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF224A37), Color(0xFF163527)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 28 * sy, 80 * sx, 55 * sy));
    canvas.drawPath(nearMountain, nearMountainPaint);

    // Lembah bayangan Merapi (Punggung Gunung Berlapis)
    final Path mountainRidge = Path()
      ..moveTo(33 * sx, 30 * sy)
      ..cubicTo(36 * sx, 44 * sy, 43 * sx, 58 * sy, 55 * sx, 80 * sy)
      ..lineTo(76 * sx, 80 * sy)
      ..cubicTo(62 * sx, 66 * sy, 48 * sx, 50 * sy, 38 * sx, 35 * sy)
      ..close();
    canvas.drawPath(
      mountainRidge,
      Paint()
        ..color = const Color(0xFF10281D).withValues(alpha: 0.5)
        ..style = PaintingStyle.fill,
    );

    // ── 5. Terasering Alun Toya (Graceful Undulating Rice Field Terraces) ─────
    // Tingkat 1 (Perbukitan sawah tengah)
    final Path tier1 = Path()
      ..moveTo(-5 * sx, 78 * sy)
      ..cubicTo(18 * sx, 65 * sy, 42 * sx, 67 * sy, 68 * sx, 74 * sy)
      ..cubicTo(84 * sx, 68 * sy, 94 * sx, 66 * sy, 105 * sx, 72 * sy)
      ..lineTo(105 * sx, 105 * sy)
      ..lineTo(-5 * sx, 105 * sy)
      ..close();
    canvas.drawPath(tier1, Paint()..color = const Color(0xFF316146));

    // Kilau air terasering 1 (Air fajar jernih)
    final Path waterCurve1 = Path()
      ..moveTo(0, 75 * sy)
      ..cubicTo(24 * sx, 68 * sy, 52 * sx, 71 * sy, 78 * sx, 78 * sy)
      ..cubicTo(52 * sx, 73 * sy, 24 * sx, 71 * sy, 0, 77 * sy)
      ..close();
    canvas.drawPath(
      waterCurve1,
      Paint()..color = const Color(0xFFFFF4DA).withValues(alpha: 0.70),
    );

    // Tingkat 2 (Terasering tengah depan)
    final Path tier2 = Path()
      ..moveTo(-5 * sx, 85 * sy)
      ..cubicTo(22 * sx, 76 * sy, 54 * sx, 78 * sy, 82 * sx, 83 * sy)
      ..cubicTo(92 * sx, 81 * sy, 98 * sx, 79 * sy, 105 * sx, 82 * sy)
      ..lineTo(105 * sx, 105 * sy)
      ..lineTo(-5 * sx, 105 * sy)
      ..close();
    canvas.drawPath(tier2, Paint()..color = const Color(0xFF244F37));

    // Kilau air terasering 2
    final Path waterCurve2 = Path()
      ..moveTo(8 * sx, 84 * sy)
      ..cubicTo(36 * sx, 78 * sy, 68 * sx, 81 * sy, 98 * sx, 85 * sy)
      ..cubicTo(68 * sx, 83 * sy, 36 * sx, 80 * sy, 8 * sx, 86 * sy)
      ..close();
    canvas.drawPath(
      waterCurve2,
      Paint()..color = const Color(0xFFFFF6DF).withValues(alpha: 0.55),
    );

    // Tingkat 3 (Dasar sawah subur depan)
    final Path tier3 = Path()
      ..moveTo(-5 * sx, 93 * sy)
      ..cubicTo(32 * sx, 86 * sy, 70 * sx, 88 * sy, 105 * sx, 92 * sy)
      ..lineTo(105 * sx, 105 * sy)
      ..lineTo(-5 * sx, 105 * sy)
      ..close();
    canvas.drawPath(tier3, Paint()..color = const Color(0xFF1B3D2B));

    // ── 6. Waringin Kurung / Pohon Hayat (Organic Sacred Banyan Silhouette) ────
    _drawBanyanTree(canvas, Offset(86 * sx, 88 * sy), 18 * sx, 42 * sy);

    // ── 7. Peksi Kuntul Mabur (Graceful Egrets in Flight) ─────────────────────
    final birdPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..strokeWidth = 1.4 * sx
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawGracefulEgret(canvas, Offset(24 * sx, 30 * sy), 3.2 * sx, birdPaint);
    _drawGracefulEgret(canvas, Offset(31 * sx, 24 * sy), 2.5 * sx, birdPaint);
    _drawGracefulEgret(canvas, Offset(38 * sx, 32 * sy), 2.0 * sx, birdPaint);

    canvas.restore();
  }

  /// Menggambar awan berlekuk luwes khas ornamen Megamendung
  void _drawBatikCloud(Canvas canvas, Offset center, double w, double h) {
    final path = Path();
    final halfW = w / 2;

    path.moveTo(center.dx - halfW, center.dy);
    // Lengkungan bawah
    path.cubicTo(
      center.dx - halfW * 0.6,
      center.dy + h * 0.45,
      center.dx + halfW * 0.4,
      center.dy + h * 0.40,
      center.dx + halfW,
      center.dy,
    );
    // Lengkungan atas bergulung
    path.cubicTo(
      center.dx + halfW * 0.6,
      center.dy - h * 0.60,
      center.dx + halfW * 0.1,
      center.dy - h * 0.50,
      center.dx,
      center.dy - h * 0.25,
    );
    path.cubicTo(
      center.dx - halfW * 0.2,
      center.dy - h * 0.60,
      center.dx - halfW * 0.7,
      center.dy - h * 0.45,
      center.dx - halfW,
      center.dy,
    );
    path.close();

    final cloudPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.38),
          Colors.white.withValues(alpha: 0.08),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCenter(center: center, width: w, height: h));
    canvas.drawPath(path, cloudPaint);
  }

  /// Menggambar Pohon Beringin / Pohon Hayat dengan kanopi organik dan sulur menjuntai
  void _drawBanyanTree(Canvas canvas, Offset base, double w, double h) {
    final treePaint = Paint()
      ..color = const Color(0xFF143022)
      ..style = PaintingStyle.fill;

    // Batang pohon berkontur alami
    final trunkPath = Path()
      ..moveTo(base.dx - w * 0.18, base.dy)
      ..cubicTo(
        base.dx - w * 0.14,
        base.dy - h * 0.35,
        base.dx - w * 0.08,
        base.dy - h * 0.55,
        base.dx,
        base.dy - h * 0.65,
      )
      ..cubicTo(
        base.dx + w * 0.08,
        base.dy - h * 0.55,
        base.dx + w * 0.14,
        base.dy - h * 0.35,
        base.dx + w * 0.18,
        base.dy,
      )
      ..close();
    canvas.drawPath(trunkPath, treePaint);

    // Kanopi rimbun berlapis (simbol pangayoman)
    final canopyCenter = Offset(base.dx, base.dy - h * 0.75);

    // Menggambar bentuk kanopi bergelombang awan
    const count = 7;
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      final radius = (w * 0.45) + (i % 2 == 0 ? w * 0.12 : -w * 0.05);
      final cx = canopyCenter.dx + math.cos(angle) * (w * 0.28);
      final cy = canopyCenter.dy + math.sin(angle) * (h * 0.20);
      canvas.drawCircle(Offset(cx, cy), radius, treePaint);
    }
    canvas.drawCircle(canopyCenter, w * 0.40, treePaint);

    // Sulur-sulur gantung khas beringin (akar gantung yang luwes)
    final sulurPaint = Paint()
      ..color = const Color(0xFF143022)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawWeepingTendril(
      canvas,
      Offset(base.dx - w * 0.25, base.dy - h * 0.65),
      h * 0.35,
      sulurPaint,
    );
    _drawWeepingTendril(
      canvas,
      Offset(base.dx - w * 0.10, base.dy - h * 0.60),
      h * 0.28,
      sulurPaint,
    );
    _drawWeepingTendril(
      canvas,
      Offset(base.dx + w * 0.12, base.dy - h * 0.62),
      h * 0.32,
      sulurPaint,
    );
    _drawWeepingTendril(
      canvas,
      Offset(base.dx + w * 0.26, base.dy - h * 0.66),
      h * 0.30,
      sulurPaint,
    );
  }

  void _drawWeepingTendril(
    Canvas canvas,
    Offset start,
    double length,
    Paint paint,
  ) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + 2,
        start.dy + length * 0.4,
        start.dx - 2,
        start.dy + length * 0.7,
        start.dx,
        start.dy + length,
      );
    canvas.drawPath(path, paint);
  }

  /// Menggambar burung bangau putih (Kuntul) dengan sayap melengkung anggun
  void _drawGracefulEgret(Canvas canvas, Offset pos, double span, Paint paint) {
    final path = Path()
      // Sayap kiri melengkung aerodinamis
      ..moveTo(pos.dx - span, pos.dy + span * 0.5)
      ..cubicTo(
        pos.dx - span * 0.6,
        pos.dy - span * 0.7,
        pos.dx - span * 0.2,
        pos.dy - span * 0.6,
        pos.dx,
        pos.dy,
      )
      // Sayap kanan melengkung anggun
      ..cubicTo(
        pos.dx + span * 0.2,
        pos.dy - span * 0.6,
        pos.dx + span * 0.6,
        pos.dy - span * 0.7,
        pos.dx + span,
        pos.dy + span * 0.5,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant JavaneseScenicIllustrationPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
