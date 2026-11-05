import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable Amber Decorative Banner used across Auth screens (Register, Login).
/// Features kawung batik overlay, ghosted aksara watermark, and mini landscape SVG.
class AuthBanner extends StatelessWidget {
  final String badgeLabel;
  final String title;
  final String subtitle;
  final String glyphWatermark;
  final double height;

  const AuthBanner({
    super.key,
    this.badgeLabel = 'Langkah Awal',
    required this.title,
    required this.subtitle,
    this.glyphWatermark = 'ꦲ',
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.amberDark.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 1. Kawung Batik Pattern Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _KawungMiniPainter(),
            ),
          ),

          // 2. Ghosted Aksara Watermark
          Positioned(
            right: -8,
            top: -12,
            child: Transform.rotate(
              angle: -0.105, // -6 degrees
              child: Text(
                glyphWatermark,
                style: TextStyle(
                  fontSize: 128,
                  color: AppColors.ink.withValues(alpha: 0.08),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // 3. Main Content Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Left: Badge + Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColors.amberDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              badgeLabel.toUpperCase(),
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
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          height: 1.2,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Mini Landscape Illustration
                SizedBox(
                  width: 88,
                  height: height * 0.9,
                  child: const _MiniLandscapeIllustration(),
                ),
              ],
            ),
          ),
        ],
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

        canvas.drawOval(Rect.fromCenter(center: Offset(ox + 14, oy + 7), width: rx * 2, height: ry * 2), paint);
        canvas.drawOval(Rect.fromCenter(center: Offset(ox + 14, oy + 21), width: rx * 2, height: ry * 2), paint);
        canvas.drawOval(Rect.fromCenter(center: Offset(ox + 7, oy + 14), width: ry * 2, height: rx * 2), paint);
        canvas.drawOval(Rect.fromCenter(center: Offset(ox + 21, oy + 14), width: ry * 2, height: rx * 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Compact mini landscape: sun, mountains, terraces
class _MiniLandscapeIllustration extends StatelessWidget {
  const _MiniLandscapeIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MiniLandscapePainter(),
    );
  }
}

class _MiniLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sun glow aura
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.sunHighlight.withValues(alpha: 0.9),
          AppColors.accentOrange.withValues(alpha: 0.5),
          AppColors.amber.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.42), radius: h * 0.28));
    canvas.drawCircle(Offset(w * 0.5, h * 0.42), h * 0.28, glowPaint);

    // Sun disc
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.4),
      h * 0.12,
      Paint()..color = AppColors.sunCore.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.4),
      h * 0.08,
      Paint()..color = AppColors.sunHighlight.withValues(alpha: 0.95),
    );

    // Back mountain
    final mPath1 = Path()
      ..moveTo(w * 0.1, h * 0.78)
      ..lineTo(w * 0.42, h * 0.3)
      ..lineTo(w * 0.74, h * 0.78)
      ..close();
    canvas.drawPath(
      mPath1,
      Paint()..color = AppColors.volcanoFarStart.withValues(alpha: 0.85),
    );

    // Front ridge
    final mPath2 = Path()
      ..moveTo(-w * 0.1, h * 0.8)
      ..lineTo(w * 0.3, h * 0.5)
      ..lineTo(w * 0.7, h * 0.8)
      ..close();
    canvas.drawPath(
      mPath2,
      Paint()..color = AppColors.volcanoNearStart.withValues(alpha: 0.9),
    );

    // Terraces
    final t1 = Path()
      ..moveTo(-w * 0.1, h * 0.76)
      ..quadraticBezierTo(w * 0.3, h * 0.72, w * 0.6, h * 0.75)
      ..quadraticBezierTo(w * 0.8, h * 0.77, w * 1.1, h * 0.74)
      ..lineTo(w * 1.1, h)
      ..lineTo(-w * 0.1, h)
      ..close();
    canvas.drawPath(t1, Paint()..color = AppColors.terraceTier1);

    final t2 = Path()
      ..moveTo(-w * 0.1, h * 0.86)
      ..quadraticBezierTo(w * 0.4, h * 0.82, w * 0.7, h * 0.86)
      ..quadraticBezierTo(w * 0.9, h * 0.89, w * 1.1, h * 0.86)
      ..lineTo(w * 1.1, h)
      ..lineTo(-w * 0.1, h)
      ..close();
    canvas.drawPath(t2, Paint()..color = AppColors.terraceTier2);

    final t3 = Path()
      ..moveTo(-w * 0.1, h * 0.93)
      ..quadraticBezierTo(w * 0.5, h * 0.9, w * 0.8, h * 0.93)
      ..quadraticBezierTo(w, h * 0.95, w * 1.1, h * 0.93)
      ..lineTo(w * 1.1, h)
      ..lineTo(-w * 0.1, h)
      ..close();
    canvas.drawPath(t3, Paint()..color = AppColors.terraceTier3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

