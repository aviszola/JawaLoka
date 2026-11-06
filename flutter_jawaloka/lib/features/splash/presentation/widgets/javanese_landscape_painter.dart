import 'package:flutter/material.dart';

/// Custom vector painter for the Javanese panorama on Splash Screen.
/// Features a distinct orange sun (#F5A31A) with soft halo, positioned
/// partially behind the central mountain (gunung menimpa matahari),
/// and 3 unified shades of green for mountain and terraced rice fields.
class JavaneseLandscapePainter extends CustomPainter {
  final double entranceProgress;
  final double shimmerProgress;

  // 3 distinct green shades for mountain and terraces
  static const Color greenMountain = Color(0xFF2D5543);     // Shade 1: Mountain
  static const Color greenTerraceUpper = Color(0xFF3D7152); // Shade 2: Upper terrace
  static const Color greenTerraceLower = Color(0xFF244D36); // Shade 3: Lower terrace
  static const Color sunColor = Color(0xFFF5A31A);          // Orange sun (#F5A31A)

  JavaneseLandscapePainter({
    this.entranceProgress = 1.0,
    this.shimmerProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();

    // Scale canvas coordinates from reference 412x220 to actual size
    final double sx = size.width / 412.0;
    final double sy = size.height / 220.0;
    canvas.scale(sx, sy);

    final double mountainSlide = (1.0 - entranceProgress) * 35.0;
    final double terraceSlide = (1.0 - entranceProgress) * 50.0;
    final double sunSlide = (1.0 - entranceProgress) * 60.0;

    // 1. Matahari Jingga (#F5A31A) dengan halo lembut
    final Offset sunCenter = Offset(206.0, 102.0 + sunSlide);
    const double sunRadius = 28.0;
    const double haloRadius = 76.0;

    // Halo lembut
    final Paint haloPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          sunColor.withValues(alpha: 0.38 * entranceProgress),
          sunColor.withValues(alpha: 0.12 * entranceProgress),
          sunColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: haloRadius));
    canvas.drawCircle(sunCenter, haloRadius, haloPaint);

    // Lingkaran matahari jelas
    final Paint sunPaint = Paint()
      ..color = sunColor.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // 2. Gunung Tengah (Nuansa Hijau 1) — digambar menimpa matahari
    canvas.save();
    canvas.translate(0, mountainSlide);

    final Path mountainPath = Path()
      ..moveTo(105, 165)
      ..lineTo(198, 72)
      ..cubicTo(202, 68, 210, 68, 214, 72)
      ..lineTo(307, 165)
      ..close();

    final Paint mountainPaint = Paint()
      ..color = greenMountain.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(mountainPath, mountainPaint);

    // Gunung samping kiri & kanan dengan nuansa hijau yang sama
    final Path sideRidgeLeft = Path()
      ..moveTo(10, 165)
      ..lineTo(115, 100)
      ..cubicTo(119, 97, 125, 98, 128, 102)
      ..lineTo(195, 165)
      ..close();
    canvas.drawPath(sideRidgeLeft, mountainPaint);

    final Path sideRidgeRight = Path()
      ..moveTo(220, 165)
      ..lineTo(290, 108)
      ..cubicTo(294, 105, 300, 106, 303, 110)
      ..lineTo(402, 165)
      ..close();
    canvas.drawPath(sideRidgeRight, mountainPaint);

    canvas.restore();

    // 3. Terasering Sawah (Nuansa Hijau 2 & 3)
    canvas.save();
    canvas.translate(0, terraceSlide);

    // Terasering Atas (Nuansa Hijau 2)
    final Path upperTerrace = Path()
      ..moveTo(-10, 155)
      ..cubicTo(70, 145, 150, 160, 230, 150)
      ..cubicTo(310, 140, 365, 154, 425, 146)
      ..lineTo(425, 225)
      ..lineTo(-10, 225)
      ..close();

    final Paint upperTerracePaint = Paint()
      ..color = greenTerraceUpper.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(upperTerrace, upperTerracePaint);

    // Terasering Bawah / Foreground (Nuansa Hijau 3)
    final Path lowerTerrace = Path()
      ..moveTo(-10, 182)
      ..cubicTo(95, 174, 195, 188, 280, 180)
      ..cubicTo(345, 172, 385, 180, 425, 176)
      ..lineTo(425, 225)
      ..lineTo(-10, 225)
      ..close();

    final Paint lowerTerracePaint = Paint()
      ..color = greenTerraceLower.withValues(alpha: entranceProgress)
      ..style = PaintingStyle.fill;
    canvas.drawPath(lowerTerrace, lowerTerracePaint);

    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant JavaneseLandscapePainter oldDelegate) {
    return oldDelegate.entranceProgress != entranceProgress ||
        oldDelegate.shimmerProgress != shimmerProgress;
  }
}
