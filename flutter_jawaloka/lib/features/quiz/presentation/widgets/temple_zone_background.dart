import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Band latar bertema satu landmark arsitektur kerajaan Jawa per zona unit (1–5).
///
/// Prinsip desain:
/// - Satu landmark flat 2–3 lapis (lapis belakang, tengah, depan) dengan palet
///   krem, pasir hangat, emas, dan cokelat tua (tone-on-tone).
/// - Ditempatkan di sisi kosong jalur (kanan pada zona 1, 3, 5; kiri pada zona
///   2, 4) agar tidak menimpa node maupun label, serta tidak terpotong tepi layar.
/// - Tidak ada elemen dekoratif pengisi ruang kosong (tanpa blob atau pohon abstrak).
class TempleZoneBackgroundPainter extends CustomPainter {
  /// Indeks zona 0..4 (0=Kediri, 1=Singosari, 2=Majapahit, 3=Demak, 4=Mataram Islam).
  final int zoneIndex;

  const TempleZoneBackgroundPainter({required this.zoneIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    // Latar kanvas lembut antar-unit agar batas zona terasa rapi tanpa gradasi mencolok.
    if (zoneIndex.isOdd) {
      final bandPaint = Paint()
        ..color = AppColors.pastelSand.withValues(alpha: 0.22)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bandPaint);
    }

    // 3 Lapis warna tone-on-tone murni dari token AppColors.
    final Color backColor = Color.lerp(
      AppColors.canvas,
      AppColors.pastelSand,
      0.92,
    )!;
    final Color midColor = Color.lerp(
      AppColors.pastelSand,
      AppColors.primaryDark,
      0.20,
    )!;
    final Color frontColor = Color.lerp(
      AppColors.pastelSand,
      AppColors.primaryDark,
      0.38,
    )!;
    final Color groundColor = Color.lerp(
      AppColors.pastelSand,
      AppColors.primaryDark,
      0.28,
    )!;
    final Color recessColor = Color.lerp(
      AppColors.canvas,
      AppColors.surfaceWarm,
      0.65,
    )!;

    final backPaint = Paint()
      ..color = backColor
      ..style = PaintingStyle.fill;
    final midPaint = Paint()
      ..color = midColor
      ..style = PaintingStyle.fill;
    final frontPaint = Paint()
      ..color = frontColor
      ..style = PaintingStyle.fill;
    final groundPaint = Paint()
      ..color = groundColor
      ..style = PaintingStyle.fill;
    final recessPaint = Paint()
      ..color = recessColor
      ..style = PaintingStyle.fill;
    final accentLinePaint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    // Sisi kosong jalur:
    // - Unit 1, 3, 5 (node 1 di kiri): sisi kosong di KANAN.
    // - Unit 2, 4 (node 2 di kanan): sisi kosong di KIRI.
    final bool onRight = zoneIndex.isEven;
    final double landmarkWidth = (w * 0.30).clamp(112.0, 160.0);
    final double edgeMargin = (w * 0.045).clamp(16.0, 40.0);
    final double cx = onRight
        ? w - edgeMargin - landmarkWidth / 2
        : edgeMargin + landmarkWidth / 2;

    // Ditempatkan di teluk kosong setelah header unit (zona ganjil sejajar node 1,
    // zona genap sejajar node 2) agar tidak menimpa node atau label.
    final double bottomY = onRight ? min(268.0, h * 0.85) : min(418.0, h * 0.85);

    switch (zoneIndex % 5) {
      case 0:
        _drawKediriSimpangLimaGumul(
          canvas,
          cx: cx,
          bottomY: bottomY,
          width: landmarkWidth,
          backPaint: backPaint,
          midPaint: midPaint,
          frontPaint: frontPaint,
          groundPaint: groundPaint,
          recessPaint: recessPaint,
          linePaint: accentLinePaint,
        );
      case 1:
        _drawSingosariCandi(
          canvas,
          cx: cx,
          bottomY: bottomY,
          width: landmarkWidth,
          backPaint: backPaint,
          midPaint: midPaint,
          frontPaint: frontPaint,
          groundPaint: groundPaint,
          recessPaint: recessPaint,
          linePaint: accentLinePaint,
        );
      case 2:
        _drawMajapahitCandiBentar(
          canvas,
          cx: cx,
          bottomY: bottomY,
          width: landmarkWidth,
          backPaint: backPaint,
          midPaint: midPaint,
          frontPaint: frontPaint,
          groundPaint: groundPaint,
          recessPaint: recessPaint,
          linePaint: accentLinePaint,
        );
      case 3:
        _drawDemakMosque(
          canvas,
          cx: cx,
          bottomY: bottomY,
          width: landmarkWidth,
          backPaint: backPaint,
          midPaint: midPaint,
          frontPaint: frontPaint,
          groundPaint: groundPaint,
          recessPaint: recessPaint,
          linePaint: accentLinePaint,
        );
      default:
        _drawMataramPendopoJoglo(
          canvas,
          cx: cx,
          bottomY: bottomY,
          width: landmarkWidth,
          backPaint: backPaint,
          midPaint: midPaint,
          frontPaint: frontPaint,
          groundPaint: groundPaint,
          recessPaint: recessPaint,
          linePaint: accentLinePaint,
        );
    }
  }

  /// Pita tanah dasar datar + tangga pelataran agar monumen kokoh membumi.
  void _drawGroundedPlinth(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint groundPaint,
    required Paint backPaint,
    required Paint linePaint,
  }) {
    // Lapis belakang pelataran halus
    final groundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - width * 0.56, bottomY - 5, width * 1.12, 7),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(groundRect, backPaint);

    // Garis tanah utuh
    canvas.drawLine(
      Offset(cx - width * 0.56, bottomY + 2),
      Offset(cx + width * 0.56, bottomY + 2),
      linePaint,
    );

    // Batur dasar monumen
    final plinth = Rect.fromLTWH(cx - width * 0.46, bottomY - 9, width * 0.92, 9);
    canvas.drawRect(plinth, groundPaint);
  }

  /// Zona 1: Kediri — Monumen Simpang Lima Gumul yang utuh dan proporsional.
  void _drawKediriSimpangLimaGumul(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint backPaint,
    required Paint midPaint,
    required Paint frontPaint,
    required Paint groundPaint,
    required Paint recessPaint,
    required Paint linePaint,
  }) {
    _drawGroundedPlinth(
      canvas,
      cx: cx,
      bottomY: bottomY,
      width: width,
      groundPaint: groundPaint,
      backPaint: backPaint,
      linePaint: linePaint,
    );

    final double baseTopY = bottomY - 9;
    final double bodyW = width * 0.78;
    final double bodyH = 68.0;

    // Lapis belakang: sayap sisi pelengkap kedalaman monumen
    canvas.drawRect(
      Rect.fromLTWH(
        cx - bodyW * 0.56,
        baseTopY - bodyH * 0.94,
        bodyW * 1.12,
        bodyH * 0.94,
      ),
      backPaint,
    );

    // Lapis tengah: badan kubus proporsional Simpang Lima Gumul
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW / 2, baseTopY - bodyH, bodyW, bodyH),
      midPaint,
    );

    // Lapis depan: dua pilar pengapit lengkung + cornice mahkota bertingkat
    final double pillarW = bodyW * 0.24;
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW / 2, baseTopY - bodyH, pillarW, bodyH),
      frontPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx + bodyW / 2 - pillarW, baseTopY - bodyH, pillarW, bodyH),
      frontPaint,
    );

    // Sabuk relief di atas lengkungan
    final double friezeY = baseTopY - bodyH + 10;
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW * 0.52, friezeY, bodyW * 1.04, 8),
      frontPaint,
    );

    // Cornice & atap berundak atas
    final double crownY = baseTopY - bodyH;
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW * 0.55, crownY - 7, bodyW * 1.10, 7),
      frontPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW * 0.40, crownY - 14, bodyW * 0.80, 7),
      midPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW * 0.22, crownY - 19, bodyW * 0.44, 5),
      frontPaint,
    );

    // Pelengkung gerbang utama di tengah (proporsional, tidak memotong)
    final double archW = bodyW * 0.36;
    final double archH = 40.0;
    final archPath = Path()
      ..moveTo(cx - archW / 2, baseTopY)
      ..lineTo(cx - archW / 2, baseTopY - archH * 0.58)
      ..arcToPoint(
        Offset(cx + archW / 2, baseTopY - archH * 0.58),
        radius: Radius.circular(archW / 2),
      )
      ..lineTo(cx + archW / 2, baseTopY)
      ..close();
    canvas.drawPath(archPath, recessPaint);
    canvas.drawPath(archPath, linePaint);

    // Tangga masuk tengah di dasar gerbang
    for (int s = 0; s < 3; s++) {
      final double stepW = archW * (1.28 - s * 0.12);
      final double stepY = bottomY - s * 3.0;
      canvas.drawRect(
        Rect.fromLTWH(cx - stepW / 2, stepY - 3, stepW, 3),
        s.isEven ? frontPaint : midPaint,
      );
    }
  }

  /// Zona 2: Singosari — Candi berbadan persegi tinggi, relung kala, atap bertingkat.
  void _drawSingosariCandi(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint backPaint,
    required Paint midPaint,
    required Paint frontPaint,
    required Paint groundPaint,
    required Paint recessPaint,
    required Paint linePaint,
  }) {
    _drawGroundedPlinth(
      canvas,
      cx: cx,
      bottomY: bottomY,
      width: width,
      groundPaint: groundPaint,
      backPaint: backPaint,
      linePaint: linePaint,
    );

    final double baseTopY = bottomY - 9;

    // Lapis belakang: teras batur berundak 2 tingkat
    canvas.drawRect(
      Rect.fromLTWH(cx - width * 0.38, baseTopY - 8, width * 0.76, 8),
      backPaint,
    );
    final double yBodyBase = baseTopY - 8;

    // Lapis tengah: tubuh candi persegi tinggi
    final double bodyW = width * 0.52;
    final double bodyH = 44.0;
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW / 2, yBodyBase - bodyH, bodyW, bodyH),
      midPaint,
    );

    // Atap bertingkat 4 menyempit + puncak ratna
    double currY = yBodyBase - bodyH;
    final tiers = [
      (w: bodyW * 0.88, h: 10.0),
      (w: bodyW * 0.68, h: 9.0),
      (w: bodyW * 0.48, h: 8.0),
      (w: bodyW * 0.30, h: 7.0),
    ];
    for (int i = 0; i < tiers.length; i++) {
      final t = tiers[i];
      canvas.drawRect(
        Rect.fromLTWH(cx - t.w / 2, currY - t.h, t.w, t.h),
        i.isEven ? frontPaint : midPaint,
      );
      currY -= t.h;
    }

    // Finial puncak kecil
    final peak = Path()
      ..moveTo(cx - 5, currY)
      ..lineTo(cx, currY - 9)
      ..lineTo(cx + 5, currY)
      ..close();
    canvas.drawPath(peak, frontPaint);

    // Lapis depan: bilik penampil pintu + relung lengkung + tangga depan
    final double porchW = bodyW * 0.54;
    final double porchH = 30.0;
    canvas.drawRect(
      Rect.fromLTWH(cx - porchW / 2, yBodyBase - porchH, porchW, porchH),
      frontPaint,
    );

    final niche = Path()
      ..moveTo(cx - 7, yBodyBase)
      ..lineTo(cx - 7, yBodyBase - 16)
      ..quadraticBezierTo(cx, yBodyBase - 23, cx + 7, yBodyBase - 16)
      ..lineTo(cx + 7, yBodyBase)
      ..close();
    canvas.drawPath(niche, recessPaint);

    // Tangga depan berundak menuju batur
    for (int s = 0; s < 3; s++) {
      final double sw = porchW * (1.20 - s * 0.12);
      canvas.drawRect(
        Rect.fromLTWH(cx - sw / 2, bottomY - 3 - s * 4.0, sw, 4),
        s.isEven ? frontPaint : midPaint,
      );
    }
  }

  /// Zona 3: Majapahit — Candi Bentar utuh dengan tanah & tangga di dasarnya
  /// (terhubung oleh batur dasar bersama dan tangga tengah, tidak melayang).
  void _drawMajapahitCandiBentar(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint backPaint,
    required Paint midPaint,
    required Paint frontPaint,
    required Paint groundPaint,
    required Paint recessPaint,
    required Paint linePaint,
  }) {
    // 1. Tanah & pelataran dasar utuh menyatukan kedua sayap gapura
    _drawGroundedPlinth(
      canvas,
      cx: cx,
      bottomY: bottomY,
      width: width,
      groundPaint: groundPaint,
      backPaint: backPaint,
      linePaint: linePaint,
    );

    final double platformY = bottomY - 9;
    final double gateW = width * 0.88;
    final double gapW = gateW * 0.22;
    final double wingW = (gateW - gapW) / 2;
    final double wingH = 82.0;

    // 2. Lapis belakang: pelataran dalam & batur sambung di balik celah tengah
    canvas.drawRect(
      Rect.fromLTWH(cx - gateW * 0.44, platformY - 14, gateW * 0.88, 14),
      backPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - gapW * 0.55, platformY - 14, gapW * 1.10, 14),
      recessPaint,
    );

    // 3. Kedua sayap Candi Bentar berpijak kokoh di atas batur platformY
    for (final isLeft in [true, false]) {
      final double dir = isLeft ? -1.0 : 1.0;
      final double innerX = cx + dir * (gapW / 2);

      // Badan utama sayap (lapis tengah)
      final wingPath = Path()
        ..moveTo(innerX, platformY)
        ..lineTo(innerX, platformY - wingH)
        ..lineTo(innerX + dir * (wingW * 0.24), platformY - wingH)
        ..lineTo(innerX + dir * (wingW * 0.42), platformY - wingH * 0.78)
        ..lineTo(innerX + dir * (wingW * 0.62), platformY - wingH * 0.56)
        ..lineTo(innerX + dir * (wingW * 0.82), platformY - wingH * 0.32)
        ..lineTo(innerX + dir * wingW, platformY - wingH * 0.14)
        ..lineTo(innerX + dir * wingW, platformY)
        ..close();
      canvas.drawPath(wingPath, midPaint);

      // Lapis depan: pelipit sabuk & tepi dalam tegak bata terakota Majapahit
      final double innerStripW = wingW * 0.18;
      canvas.drawRect(
        Rect.fromLTWH(
          isLeft ? innerX - innerStripW : innerX,
          platformY - wingH,
          innerStripW,
          wingH,
        ),
        frontPaint,
      );

      // Pelipit horizontal penegas tingkatan undak
      for (final frac in [0.22, 0.48, 0.74]) {
        final double yBand = platformY - wingH * frac;
        final double bandLen = wingW * (1.0 - frac * 0.65);
        canvas.drawRect(
          Rect.fromLTWH(
            isLeft ? innerX - bandLen : innerX,
            yBand,
            bandLen,
            4.5,
          ),
          frontPaint,
        );
      }

      canvas.drawPath(wingPath, linePaint);
    }

    // 4. Tangga tengah & pipi tangga (makara/pembatas tangga) di dasar celah
    final double stairBaseW = gapW * 1.70;
    final double stairTopW = gapW * 1.10;
    final double stairH = 17.0;

    // Pipi tangga kiri & kanan
    canvas.drawRect(
      Rect.fromLTWH(cx - stairBaseW / 2 - 4, bottomY - stairH, 5, stairH),
      frontPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx + stairBaseW / 2 - 1, bottomY - stairH, 5, stairH),
      frontPaint,
    );

    // 4 anak tangga menyempit naik ke ambang gapura
    for (int s = 0; s < 4; s++) {
      final double t = s / 3.0;
      final double sw = stairBaseW + (stairTopW - stairBaseW) * t;
      final double sy = bottomY - s * 4.2;
      canvas.drawRect(
        Rect.fromLTWH(cx - sw / 2, sy - 4.2, sw, 4.2),
        s.isEven ? frontPaint : midPaint,
      );
      canvas.drawLine(
        Offset(cx - sw / 2, sy - 4.2),
        Offset(cx + sw / 2, sy - 4.2),
        linePaint,
      );
    }
  }

  /// Zona 4: Demak — Masjid beratap tumpang 3 dengan serambi bertiang dan tangga.
  void _drawDemakMosque(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint backPaint,
    required Paint midPaint,
    required Paint frontPaint,
    required Paint groundPaint,
    required Paint recessPaint,
    required Paint linePaint,
  }) {
    _drawGroundedPlinth(
      canvas,
      cx: cx,
      bottomY: bottomY,
      width: width,
      groundPaint: groundPaint,
      backPaint: backPaint,
      linePaint: linePaint,
    );

    final double yBodyBase = bottomY - 9;
    final double bodyW = width * 0.72;
    final double bodyH = 28.0;

    // Lapis belakang: bayangan serambi dalam
    canvas.drawRect(
      Rect.fromLTWH(cx - bodyW / 2, yBodyBase - bodyH, bodyW, bodyH),
      backPaint,
    );

    // 3 lengkung serambi & 4 tiang soko di lapis depan
    final double bayW = bodyW * 0.22;
    for (int i = -1; i <= 1; i++) {
      final double bx = cx + i * (bodyW * 0.27);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(bx - bayW / 2, yBodyBase - 19, bayW, 19),
          topLeft: const Radius.circular(5),
          topRight: const Radius.circular(5),
        ),
        recessPaint,
      );
    }
    for (int i = 0; i < 4; i++) {
      final double px = cx - bodyW * 0.42 + i * (bodyW * 0.28);
      canvas.drawRect(
        Rect.fromLTWH(px - 2, yBodyBase - bodyH, 4, bodyH),
        frontPaint,
      );
    }

    // 3 Atap Trapesium Tumpang (lapis tengah & depan bergantian)
    double currY = yBodyBase - bodyH;
    final roofs = [
      (b: width * 0.86, t: width * 0.56, h: 18.0),
      (b: width * 0.58, t: width * 0.36, h: 16.0),
      (b: width * 0.36, t: width * 0.14, h: 15.0),
    ];

    for (int r = 0; r < roofs.length; r++) {
      final item = roofs[r];
      if (r > 0) {
        canvas.drawRect(
          Rect.fromLTWH(cx - item.b * 0.38, currY - 4, item.b * 0.76, 4),
          backPaint,
        );
        currY -= 4;
      }
      final roof = Path()
        ..moveTo(cx - item.b / 2, currY)
        ..quadraticBezierTo(cx, currY - 2, cx + item.b / 2, currY)
        ..lineTo(cx + item.t / 2, currY - item.h)
        ..lineTo(cx - item.t / 2, currY - item.h)
        ..close();
      canvas.drawPath(roof, r.isEven ? midPaint : frontPaint);
      canvas.drawPath(roof, linePaint);
      currY -= item.h;
    }

    // Mustaka puncak
    final mustaka = Path()
      ..moveTo(cx - 4, currY)
      ..quadraticBezierTo(cx, currY - 10, cx, currY - 13)
      ..quadraticBezierTo(cx, currY - 10, cx + 4, currY)
      ..close();
    canvas.drawPath(mustaka, frontPaint);
  }

  /// Zona 5: Mataram Islam — Pendopo Joglo dengan soko guru & lantai berundak.
  void _drawMataramPendopoJoglo(
    Canvas canvas, {
    required double cx,
    required double bottomY,
    required double width,
    required Paint backPaint,
    required Paint midPaint,
    required Paint frontPaint,
    required Paint groundPaint,
    required Paint recessPaint,
    required Paint linePaint,
  }) {
    _drawGroundedPlinth(
      canvas,
      cx: cx,
      bottomY: bottomY,
      width: width,
      groundPaint: groundPaint,
      backPaint: backPaint,
      linePaint: linePaint,
    );

    final double yFloor = bottomY - 9;
    final double pillarH = 34.0;
    final double spreadW = width * 0.72;

    // Lapis belakang: bayangan ruang pendopo terbuka
    canvas.drawRect(
      Rect.fromLTWH(cx - spreadW * 0.45, yFloor - pillarH, spreadW * 0.90, pillarH),
      recessPaint,
    );

    // 4 Tiang Soko + Umpak batu di lapis depan
    for (int i = 0; i < 4; i++) {
      final double px = cx - spreadW / 2 + i * (spreadW / 3);
      canvas.drawRect(
        Rect.fromLTWH(px - 2.2, yFloor - pillarH, 4.4, pillarH),
        frontPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(px - 3.6, yFloor - 4, 7.2, 4),
        groundPaint,
      );
    }

    // Atap Joglo Tingkat 1 (penangkil landai melebar)
    final double yEaves = yFloor - pillarH;
    final double eaveW = width * 0.92;
    final double midW = width * 0.50;
    final lowerRoof = Path()
      ..moveTo(cx - eaveW / 2, yEaves)
      ..lineTo(cx + eaveW / 2, yEaves)
      ..lineTo(cx + midW / 2, yEaves - 17)
      ..lineTo(cx - midW / 2, yEaves - 17)
      ..close();
    canvas.drawPath(lowerRoof, midPaint);
    canvas.drawPath(lowerRoof, linePaint);

    // Atap Joglo Tingkat 2 (brunjung curam)
    final double yBrunjung = yEaves - 17;
    final double peakW = width * 0.18;
    final brunjung = Path()
      ..moveTo(cx - midW * 0.46, yBrunjung)
      ..lineTo(cx + midW * 0.46, yBrunjung)
      ..lineTo(cx + peakW / 2, yBrunjung - 26)
      ..lineTo(cx - peakW / 2, yBrunjung - 26)
      ..close();
    canvas.drawPath(brunjung, frontPaint);
    canvas.drawPath(brunjung, linePaint);

    // Bubungan molo datar
    canvas.drawRect(
      Rect.fromLTWH(cx - peakW / 2 - 2, yBrunjung - 29, peakW + 4, 3),
      frontPaint,
    );

    // Tangga pendopo di tengah dasar
    for (int s = 0; s < 2; s++) {
      final double sw = width * (0.28 - s * 0.06);
      canvas.drawRect(
        Rect.fromLTWH(cx - sw / 2, bottomY - 3 - s * 3.5, sw, 3.5),
        s.isEven ? frontPaint : midPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TempleZoneBackgroundPainter oldDelegate) =>
      oldDelegate.zoneIndex != zoneIndex;
}
