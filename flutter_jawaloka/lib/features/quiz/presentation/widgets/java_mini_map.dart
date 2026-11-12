import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Peta mini pulau Jawa (96x48 dp) dengan siluet poligon datar dan titik penanda kerajaan.
class JavaMiniMap extends StatelessWidget {
  final double lon;
  final double lat;

  const JavaMiniMap({super.key, required this.lon, required this.lat});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 48,
      child: CustomPaint(
        painter: JavaMiniMapPainter(lon: lon, lat: lat),
      ),
    );
  }
}

class JavaMiniMapPainter extends CustomPainter {
  final double lon;
  final double lat;

  const JavaMiniMapPainter({required this.lon, required this.lat});

  // BBox Jawa: lon 105.2..114.6, lat -5.9..-8.8
  static const double _minLon = 105.2;
  static const double _maxLon = 114.6;
  static const double _maxLat = -5.9;
  static const double _minLat = -8.8;

  // stilisasi, bukan peta akurat
  static const List<Offset> _javaPolygonLonLat = [
    Offset(105.35, -6.78), // Ujung Kulon
    Offset(105.85, -6.10), // Merak
    Offset(106.85, -6.10), // Jakarta
    Offset(107.60, -6.22), // Karawang / Indramayu
    Offset(108.55, -6.68), // Cirebon
    Offset(109.60, -6.86), // Pekalongan
    Offset(110.42, -6.92), // Semarang
    Offset(110.72, -6.50), // Muria / Jepara
    Offset(111.55, -6.72), // Rembang
    Offset(112.58, -6.90), // Gresik / Tuban
    Offset(112.82, -7.25), // Surabaya
    Offset(113.55, -7.75), // Probolinggo / Situbondo
    Offset(114.42, -7.82), // Baluran
    Offset(114.42, -8.45), // Banyuwangi selatan
    Offset(113.80, -8.45), // Jember selatan
    Offset(112.90, -8.38), // Lumajang / Malang selatan
    Offset(111.80, -8.32), // Tulungagung / Pacitan
    Offset(110.85, -8.20), // Gunungkidul
    Offset(109.95, -7.90), // Kebumen / Purworejo
    Offset(109.00, -7.78), // Cilacap
    Offset(107.80, -7.72), // Garut / Tasik selatan
    Offset(106.52, -7.40), // Sukabumi / Pelabuhan Ratu
    Offset(105.65, -7.02), // Bayah
  ];

  Offset _project(double pointLon, double pointLat, Size size) {
    final x = ((pointLon - _minLon) / (_maxLon - _minLon)) * size.width;
    // Sumbu lat terbalik: utara (-5.9) di atas (y = 0), selatan (-8.8) di bawah (y = height)
    final y = ((_maxLat - pointLat) / (_maxLat - _minLat)) * size.height;
    return Offset(x.clamp(0.0, size.width), y.clamp(0.0, size.height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (int i = 0; i < _javaPolygonLonLat.length; i++) {
      final p = _project(
        _javaPolygonLonLat[i].dx,
        _javaPolygonLonLat[i].dy,
        size,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();

    // Maksimal 2 warna dasar (surfaceWarm + border) + 1 titik penanda (accentOrange)
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.surfaceWarm
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final marker = _project(lon, lat, size);
    canvas.drawCircle(
      marker,
      3.8,
      Paint()
        ..color = AppColors.accentOrange
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant JavaMiniMapPainter oldDelegate) {
    return oldDelegate.lon != lon || oldDelegate.lat != lat;
  }
}
