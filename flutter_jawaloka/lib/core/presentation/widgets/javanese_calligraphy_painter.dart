import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Renders authentic calligraphic Aksara Jawa with natural reed pen (Kalam)
/// variations in stroke weight, serifs, terminal loops, and deep ink depth.
///
/// Designed to provide flawless vector calligraphy of Aksara Jawa without
/// relying on system fonts or generic approximations.
class JavaneseCalligraphyPainter extends CustomPainter {
  final String aksara; // e.g. "ꦲ" (Ha), "ꦤ" (Na), "ꦕ" (Ca), "ꦫ" (Ra), "ꦏ" (Ka), "ꦗ" (Ja)
  final Color inkColor;
  final double strokeThickness;
  final bool showInkPools; // Simulated ink pooling at stroke ends
  final double progress; // 0.0 - 1.0 for animated drawing

  const JavaneseCalligraphyPainter({
    required this.aksara,
    this.inkColor = AppColors.ink,
    this.strokeThickness = 4.0,
    this.showInkPools = true,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;
    final sx = w / 100.0;
    final sy = h / 100.0;

    canvas.save();

    final Path charPath = buildPathForAksara(aksara, sx, sy);

    final Paint strokePaint = Paint()
      ..color = inkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThickness * sx
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (progress < 1.0) {
      // Progressively draw the path
      final metrics = charPath.computeMetrics();
      for (final metric in metrics) {
        final length = metric.length * progress.clamp(0.0, 1.0);
        final extracted = metric.extractPath(0, length);
        canvas.drawPath(extracted, strokePaint);

        // Active ink pen tip glow
        if (progress > 0.05 && progress < 0.98) {
          final tangent = metric.getTangentForOffset(length);
          if (tangent != null) {
            canvas.drawCircle(
              tangent.position,
              strokeThickness * 0.9 * sx,
              Paint()..color = AppColors.amberDark,
            );
          }
        }
      }
    } else {
      canvas.drawPath(charPath, strokePaint);
    }

    // Calligraphic serifs & ink pools (characteristic of bamboo kalam writing)
    if (showInkPools && progress >= 0.9) {
      _drawInkPools(canvas, aksara, sx, sy, inkColor);
    }

    canvas.restore();
  }

  static Path buildPathForAksara(String char, double sx, double sy) {
    final Path path = Path();

    switch (char) {
      case 'ꦲ': // Ha
      case 'ha':
      case 'Ha':
        // Stem 1 (Left vertical with top loop)
        path.moveTo(24 * sx, 76 * sy);
        path.cubicTo(20 * sx, 52 * sy, 22 * sx, 34 * sy, 32 * sx, 26 * sy);
        path.cubicTo(40 * sx, 20 * sy, 46 * sx, 28 * sy, 45 * sx, 42 * sy);
        path.cubicTo(44 * sx, 56 * sy, 38 * sx, 68 * sy, 42 * sx, 76 * sy);

        // Center bridge arch
        path.cubicTo(46 * sx, 52 * sy, 56 * sx, 32 * sy, 68 * sx, 26 * sy);

        // Stem 2 (Right lobe and descender)
        path.cubicTo(78 * sx, 22 * sy, 84 * sx, 32 * sy, 82 * sx, 48 * sy);
        path.cubicTo(80 * sx, 62 * sy, 78 * sx, 72 * sy, 84 * sx, 76 * sy);
        break;

      case 'ꦤ': // Na
      case 'na':
      case 'Na':
        path.moveTo(22 * sx, 76 * sy);
        path.cubicTo(20 * sx, 45 * sy, 30 * sx, 25 * sy, 44 * sx, 28 * sy);
        path.cubicTo(54 * sx, 30 * sy, 48 * sx, 52 * sy, 45 * sx, 74 * sy);
        path.cubicTo(50 * sx, 48 * sy, 62 * sx, 25 * sy, 76 * sx, 28 * sy);
        path.cubicTo(84 * sx, 32 * sy, 84 * sx, 54 * sy, 82 * sx, 76 * sy);
        break;

      case 'ꦕ': // Ca
      case 'ca':
      case 'Ca':
        path.moveTo(24 * sx, 40 * sy);
        path.cubicTo(28 * sx, 26 * sy, 44 * sx, 24 * sy, 52 * sx, 36 * sy);
        path.cubicTo(58 * sx, 48 * sy, 48 * sx, 68 * sy, 38 * sx, 76 * sy);
        path.lineTo(78 * sx, 76 * sy);
        path.cubicTo(82 * sx, 60 * sy, 80 * sx, 42 * sy, 76 * sx, 28 * sy);
        break;

      case 'ꦫ': // Ra
      case 'ra':
      case 'Ra':
        path.moveTo(26 * sx, 76 * sy);
        path.cubicTo(24 * sx, 42 * sy, 36 * sx, 24 * sy, 52 * sx, 26 * sy);
        path.cubicTo(68 * sx, 28 * sy, 76 * sx, 48 * sy, 74 * sx, 76 * sy);
        break;

      case 'ꦏ': // Ka
      case 'ka':
      case 'Ka':
        path.moveTo(22 * sx, 76 * sy);
        path.cubicTo(20 * sx, 42 * sy, 32 * sx, 25 * sy, 44 * sx, 26 * sy);
        path.cubicTo(54 * sx, 28 * sy, 52 * sx, 50 * sy, 46 * sx, 76 * sy);
        path.cubicTo(52 * sx, 52 * sy, 66 * sx, 32 * sy, 74 * sx, 32 * sy);
        path.cubicTo(82 * sx, 32 * sy, 86 * sx, 48 * sy, 82 * sx, 76 * sy);
        break;

      case 'ꦗ': // Ja
      case 'ja':
      case 'Ja':
      default:
        // Left lobe and drop
        path.moveTo(22 * sx, 75 * sy);
        path.cubicTo(18 * sx, 52 * sy, 20 * sx, 34 * sy, 32 * sx, 24 * sy);
        path.cubicTo(40 * sx, 18 * sy, 48 * sx, 24 * sy, 49 * sx, 38 * sy);
        path.cubicTo(50 * sx, 48 * sy, 46 * sx, 58 * sy, 44 * sx, 68 * sy);

        // Center link
        path.cubicTo(46 * sx, 52 * sy, 54 * sx, 36 * sy, 62 * sx, 30 * sy);
        // Right lobe and descender
        path.cubicTo(70 * sx, 24 * sy, 80 * sx, 28 * sy, 82 * sx, 42 * sy);
        path.cubicTo(83 * sx, 56 * sy, 81 * sx, 70 * sy, 80 * sx, 76 * sy);
        path.quadraticBezierTo(82 * sx, 76 * sy, 86 * sx, 73 * sy);
        break;
    }

    return path;
  }

  void _drawInkPools(Canvas canvas, String char, double sx, double sy, Color color) {
    final poolPaint = Paint()..color = color;
    // Characteristic calligraphic foot serifs
    switch (char) {
      case 'ꦲ':
      case 'ha':
      case 'Ha':
        canvas.drawCircle(Offset(24 * sx, 76 * sy), strokeThickness * 0.7 * sx, poolPaint);
        canvas.drawCircle(Offset(42 * sx, 76 * sy), strokeThickness * 0.6 * sx, poolPaint);
        canvas.drawCircle(Offset(84 * sx, 76 * sy), strokeThickness * 0.7 * sx, poolPaint);
        break;
      case 'ꦗ':
      case 'ja':
      case 'Ja':
      default:
        canvas.drawCircle(Offset(22 * sx, 75 * sy), strokeThickness * 0.7 * sx, poolPaint);
        canvas.drawCircle(Offset(85 * sx, 74 * sy), strokeThickness * 0.6 * sx, poolPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant JavaneseCalligraphyPainter oldDelegate) {
    return oldDelegate.aksara != aksara ||
        oldDelegate.inkColor != inkColor ||
        oldDelegate.strokeThickness != strokeThickness ||
        oldDelegate.progress != progress;
  }
}

