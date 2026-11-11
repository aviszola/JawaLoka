import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Renders an authentic geometric Kawung Batik pattern overlay.
///
/// The Kawung motif is one of the oldest sacred Javanese batik patterns,
/// symbolizing wisdom, self-control, and purity.
class BatikKawungPainter extends CustomPainter {
  final double animationProgress;
  final double opacity;

  BatikKawungPainter({this.animationProgress = 1.0, this.opacity = 0.035});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Strict maximum effective opacity <= 0.04
    final effectiveOpacity = opacity.clamp(0.0, 0.04);

    final paint = Paint()
      ..color = AppColors.kawungStroke.withValues(
        alpha: (effectiveOpacity * animationProgress).clamp(0.0, 0.04),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const double tileSize = 64.0;
    const double rx = 10.0;
    const double ry = 16.0;

    final int cols = (size.width / tileSize).ceil() + 2;
    final int rows = (size.height / tileSize).ceil() + 2;

    // Apply radial gradient mask:
    // subtle fade towards center and bottom to keep logo and text ultra clean without batik behind text.
    final maskShader = RadialGradient(
      center: const Alignment(0.7, -0.6), // Upper right focal point
      radius: 1.2,
      colors: [
        AppColors.kawungStroke.withValues(
          alpha: (effectiveOpacity * animationProgress).clamp(0.0, 0.04),
        ),
        AppColors.kawungStroke.withValues(
          alpha: (effectiveOpacity * 0.5 * animationProgress).clamp(0.0, 0.04),
        ),
        AppColors.kawungStroke.withValues(
          alpha: 0.0,
        ), // Completely transparent behind text
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = maskShader;

    canvas.save();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double ox = c * tileSize;
        final double oy = r * tileSize;

        // Center cross petals
        // Vertical petals
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 32, oy + 16),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 32, oy + 48),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
        // Horizontal petals
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 16, oy + 32),
            width: ry * 2,
            height: rx * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 48, oy + 32),
            width: ry * 2,
            height: rx * 2,
          ),
          paint,
        );

        // Corner intersections (completes the 4-petaled motif at grid corners)
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox, oy),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox + 32, oy),
            width: ry * 2,
            height: rx * 2,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(ox, oy + 32),
            width: rx * 2,
            height: ry * 2,
          ),
          paint,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BatikKawungPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.opacity != opacity;
  }
}
