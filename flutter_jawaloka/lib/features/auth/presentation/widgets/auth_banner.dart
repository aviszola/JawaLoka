import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable Amber Decorative Banner used across Auth screens (Register, Login).
/// Features ClipRRect radius 28, kawung batik overlay, ghosted aksara watermark (<= 0.06 opacity),
/// and an integrated Javanese panorama illustration that seamlessly blends without square cutouts.
class AuthBanner extends StatelessWidget {
  final String? badgeLabel;
  final String title;
  final String subtitle;
  final String glyphWatermark;
  final double height;

  const AuthBanner({
    super.key,
    this.badgeLabel,
    required this.title,
    required this.subtitle,
    this.glyphWatermark = 'ꦲ',
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.amber,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.amberDark.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. Kawung Batik Pattern Overlay
            Positioned.fill(child: CustomPaint(painter: _KawungMiniPainter())),

            // 2. Ghosted Aksara Watermark (opasitas <= 0.06 di latar kanan)
            Positioned(
              right: 12,
              top: -14,
              child: Transform.rotate(
                angle: -0.105,
                child: Text(
                  glyphWatermark,
                  style: TextStyle(
                    fontSize: 110,
                    color: AppColors.ink.withValues(alpha: 0.05),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // 3. Mini Panorama Illustration (Utuh di kanan, tidak terpotong kotak)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 130,
              child: const _MiniLandscapeIllustration(),
            ),

            // 4. Main Content (Badge bila ada + Judul + Subjudul, tidak menimpa ilustrasi)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 110, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (badgeLabel != null && badgeLabel!.trim().isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.06),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.amberDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            badgeLabel!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal Kawung pattern for small banner area.
class _KawungMiniPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kawungStroke.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    const double tile = 28.0;
    const double rx = 7.0;
    const double ry = 11.0;

    final int cols = (size.width / tile).ceil() + 1;
    final int rows = (size.height / tile).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final ox = c * tile;
        final oy = r * tile;

        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 14, oy + 7),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 14, oy + 21),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 7, oy + 14),
            width: ry * 2,
            height: rx * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 21, oy + 14),
            width: ry * 2,
            height: rx * 2,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Compact mini landscape: sun (#F5A31A), mountain and terraces seamlessly drawn in banner
class _MiniLandscapeIllustration extends StatelessWidget {
  const _MiniLandscapeIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MiniLandscapePainter());
  }
}

class _MiniLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Sun (#F5A31A) with soft halo
    const sunColor = Color(0xFFF5A31A);
    final sunCenter = Offset(w * 0.58, h * 0.38);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          sunColor.withValues(alpha: 0.4),
          sunColor.withValues(alpha: 0.1),
          AppColors.amber.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: h * 0.35));
    canvas.drawCircle(sunCenter, h * 0.35, glowPaint);

    final sunPaint = Paint()
      ..color = sunColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, h * 0.14, sunPaint);

    // 2. Central mountain (overlapping lower half of the sun)
    final mPath1 = Path()
      ..moveTo(w * 0.15, h * 0.85)
      ..lineTo(w * 0.56, h * 0.28)
      ..lineTo(w * 0.95, h * 0.85)
      ..close();
    canvas.drawPath(mPath1, Paint()..color = const Color(0xFF2D5543));

    // Side ridge
    final mPath2 = Path()
      ..moveTo(w * 0.0, h * 0.88)
      ..lineTo(w * 0.35, h * 0.48)
      ..lineTo(w * 0.75, h * 0.88)
      ..close();
    canvas.drawPath(mPath2, Paint()..color = const Color(0xFF3C6E57));

    // 3. Rice Terraces (Terasering) sweeping to bottom right
    final t1 = Path()
      ..moveTo(0, h * 0.74)
      ..quadraticBezierTo(w * 0.4, h * 0.70, w * 0.7, h * 0.75)
      ..quadraticBezierTo(w * 0.9, h * 0.78, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(t1, Paint()..color = const Color(0xFF3D7152));

    final t2 = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.45, h * 0.82, w * 0.8, h * 0.87)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(t2, Paint()..color = const Color(0xFF244D36));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
