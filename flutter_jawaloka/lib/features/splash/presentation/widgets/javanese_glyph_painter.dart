import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Renders the authentic calligraphic Aksara Jawa glyph "ꦗ" (Ja).
///
/// Designed with dual support:
/// 1. Tries standard Javanese font glyph ('ꦗ', unicode \uA997) with fallback.
/// 2. Vector calligraphic path fallback to guarantee pristine rendering on ANY
///    system (even without Noto Sans Javanese installed).
class JavaneseGlyphPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isGhostWatermark;

  JavaneseGlyphPainter({
    required this.color,
    this.strokeWidth = 5.0,
    this.isGhostWatermark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Check if we can render the Unicode glyph cleanly using TextPainter
    const String glyphChar = 'ꦗ';
    final textPainter = TextPainter(
      text: TextSpan(
        text: glyphChar,
        style: TextStyle(
          color: color,
          fontSize: isGhostWatermark ? size.height * 0.95 : size.height * 0.72,
          fontWeight: FontWeight.w700,
          fontFamilyFallback: const [
            'Noto Sans Javanese',
            'NotoSansJavanese',
            'Javanese',
            'sans-serif',
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // If font measurement width > 10, the font glyph is recognized and supported
    if (textPainter.width > 12) {
      final double dx = (size.width - textPainter.width) / 2;
      final double dy = (size.height - textPainter.height) / 2;
      textPainter.paint(canvas, Offset(dx, dy));
      return;
    }

    // Vector calligraphy path fallback for "ꦗ" (Ja)
    final double scale = size.height / 100.0;
    canvas.save();
    canvas.scale(scale, scale);

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path glyphPath = Path();

    // Left stem and first lobe of "ꦗ"
    glyphPath.moveTo(22, 75);
    glyphPath.cubicTo(18, 55, 20, 36, 32, 26);
    glyphPath.cubicTo(40, 20, 48, 25, 50, 40);
    glyphPath.cubicTo(51, 48, 48, 58, 46, 68);

    // Center connecting curve
    glyphPath.cubicTo(47, 54, 55, 38, 62, 32);
    // Right lobe and descender
    glyphPath.cubicTo(70, 25, 80, 28, 82, 42);
    glyphPath.cubicTo(83, 56, 81, 70, 80, 76);
    glyphPath.quadraticBezierTo(82, 76, 86, 73);

    // Calligraphic top flourish
    canvas.drawPath(glyphPath, linePaint);

    // Left initial loop
    canvas.drawCircle(const Offset(22, 74), strokeWidth * 0.65, fillPaint);
    // Right foot terminal
    canvas.drawCircle(const Offset(85, 74), strokeWidth * 0.55, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant JavaneseGlyphPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isGhostWatermark != isGhostWatermark;
  }
}

/// Standalone widget for displaying Aksara Jawa glyph "ꦗ"
class JavaneseGlyphWidget extends StatelessWidget {
  final double size;
  final Color color;
  final bool isGhost;

  const JavaneseGlyphWidget({
    super.key,
    this.size = 56.0,
    this.color = AppColors.ink,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: JavaneseGlyphPainter(
        color: color,
        strokeWidth: isGhost ? size * 0.04 : size * 0.08,
        isGhostWatermark: isGhost,
      ),
    );
  }
}

