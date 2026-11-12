import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// CustomPainter ringan bertema arsitektur kerajaan Jawa (siluet candi bentar,
/// gapura, dan lanskap berundak) di belakang jalur kuis 50 node.
///
/// Seluruh elemen hanya memakai token [AppColors] dan diredam lapisan
/// semi-transparan `AppColors.canvas` agar teks jalur kuis tetap berkontras
/// tinggi (>= 4.5:1).
class RoyalKratonBackgroundPainter extends CustomPainter {
  /// Indeks zona aktif 0..4 (Unit 1–5) hasil interpolasi posisi scroll.
  final double scrollFraction;

  const RoyalKratonBackgroundPainter({this.scrollFraction = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Gradien atmosferik lembut sesuai urutan zona draf
    final zoneIndex = (scrollFraction * 4).clamp(0.0, 4.0);
    final Color topTint;
    final Color bottomTint;
    if (zoneIndex < 1.0) {
      // Zona 1: Majapahit (draf) — nuansa terakota hangat & janur
      topTint = AppColors.surfaceWarm;
      bottomTint = AppColors.pastelSand;
    } else if (zoneIndex < 2.0) {
      // Zona 2: Singhasari (draf) — nuansa batu candi lembut & krem
      topTint = AppColors.canvas;
      bottomTint = AppColors.surfaceWarm;
    } else if (zoneIndex < 3.0) {
      // Zona 3: Kediri (draf) — nuansa pastel lembut
      topTint = AppColors.pastelSand;
      bottomTint = AppColors.canvas;
    } else if (zoneIndex < 4.0) {
      // Zona 4: Mataram (draf) — nuansa zamrud tipis & krem
      topTint = AppColors.canvas;
      bottomTint = AppColors.pastelMint;
    } else {
      // Zona 5: Demak (draf) — nuansa emas lembut & krem
      topTint = AppColors.surfaceWarm;
      bottomTint = AppColors.canvas;
    }

    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topTint, bottomTint],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Matahari / aura keraton lembut di kanan atas
    final sunPaint = Paint()
      ..color = AppColors.sunriseGlow.withValues(alpha: 0.35);
    canvas.drawCircle(Offset(w * 0.84, h * 0.14), w * 0.24, sunPaint);

    // 3. Siluet pegunungan berundak jauh (low-opacity vector paths)
    final farMountain = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.28, h * 0.60, w * 0.56, h * 0.70)
      ..quadraticBezierTo(w * 0.80, h * 0.62, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      farMountain,
      Paint()..color = AppColors.volcanoFarStart.withValues(alpha: 0.08),
    );

    // 4. Siluet Gapura / Candi Bentar kembar di kiri & kanan bawah
    _drawCandiBentar(
      canvas,
      baseX: w * 0.14,
      baseY: h * 0.88,
      scale: w * 0.18,
      isLeft: true,
    );
    _drawCandiBentar(
      canvas,
      baseX: w * 0.86,
      baseY: h * 0.88,
      scale: w * 0.18,
      isLeft: false,
    );

    // 5. Siluet Pendopo / Meru keraton tipis di tengah bawah
    final meruPaint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.08);
    final meru = Path()
      ..moveTo(w * 0.34, h * 0.90)
      ..lineTo(w * 0.66, h * 0.90)
      ..lineTo(w * 0.58, h * 0.83)
      ..lineTo(w * 0.42, h * 0.83)
      ..close();
    canvas.drawPath(meru, meruPaint);

    final meruTop = Path()
      ..moveTo(w * 0.40, h * 0.83)
      ..lineTo(w * 0.60, h * 0.83)
      ..lineTo(w * 0.50, h * 0.75)
      ..close();
    canvas.drawPath(meruTop, meruPaint);

    // 6. Lapisan peredam semi-transparan agar teks & node tetap kontras >= 4.5:1
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = AppColors.canvas.withValues(alpha: 0.76),
    );
  }

  void _drawCandiBentar(
    Canvas canvas, {
    required double baseX,
    required double baseY,
    required double scale,
    required bool isLeft,
  }) {
    final paint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.10);
    final dir = isLeft ? 1.0 : -1.0;

    // 3 tingkat undakan gapura candi bentar sederhana
    for (int tier = 0; tier < 3; tier++) {
      final tWidth = scale * (1.0 - tier * 0.24);
      final tHeight = scale * 0.34;
      final yBottom = baseY - tier * (tHeight * 0.9);
      final xInner = baseX + dir * (scale * 0.12);
      final xOuter = xInner - dir * tWidth;

      final rect = Rect.fromLTRB(
        isLeft ? xOuter : xInner,
        yBottom - tHeight,
        isLeft ? xInner : xOuter,
        yBottom,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RoyalKratonBackgroundPainter oldDelegate) {
    return (oldDelegate.scrollFraction - scrollFraction).abs() > 0.02;
  }
}
