import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Data class describing a single stroke in the aksara writing order.
class AksaraStroke {
  final List<Offset> points; // normalized 0.0–1.0 coordinates
  final String direction;    // "right", "down-right", etc.

  const AksaraStroke({required this.points, this.direction = ''});
}

/// Pre-defined stroke data for Aksara "Ha" (ꦲ).
const List<AksaraStroke> kHaStrokes = [
  AksaraStroke(
    points: [Offset(0.5, 0.15), Offset(0.5, 0.45)],
    direction: 'down',
  ),
  AksaraStroke(
    points: [
      Offset(0.25, 0.3),
      Offset(0.38, 0.45),
      Offset(0.5, 0.45),
      Offset(0.62, 0.45),
      Offset(0.75, 0.3),
    ],
    direction: 'arch',
  ),
  AksaraStroke(
    points: [Offset(0.3, 0.6), Offset(0.5, 0.75), Offset(0.7, 0.6)],
    direction: 'down-curve',
  ),
  AksaraStroke(
    points: [Offset(0.35, 0.82), Offset(0.5, 0.88), Offset(0.65, 0.82)],
    direction: 'tail',
  ),
];

/// Animated stroke order painter for Javanese aksara.
///
/// Pass [animationValue] (0.0 → 1.0) to reveal strokes progressively.
/// Each stroke is revealed across its fraction of the total animation.
class AksaraStrokePainter extends CustomPainter {
  final double animationValue; // 0.0 – 1.0
  final List<AksaraStroke> strokes;
  final Color completedColor;
  final Color activeColor;
  final Color arrowColor;
  final double strokeWidth;

  const AksaraStrokePainter({
    required this.animationValue,
    this.strokes = kHaStrokes,
    this.completedColor = AppColors.ink,
    this.activeColor = AppColors.amberDark,
    this.arrowColor = AppColors.accentOrange,
    this.strokeWidth = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    final int totalStrokes = strokes.length;
    // Each stroke occupies an equal fraction of the animation timeline.
    final double fractionPerStroke = 1.0 / totalStrokes;

    for (int i = 0; i < totalStrokes; i++) {
      final double strokeStart = i * fractionPerStroke;
      final double strokeEnd = (i + 1) * fractionPerStroke;

      // How much of this stroke is revealed (0.0 – 1.0)
      double strokeProgress = 0.0;
      if (animationValue >= strokeEnd) {
        strokeProgress = 1.0;
      } else if (animationValue > strokeStart) {
        strokeProgress = (animationValue - strokeStart) / fractionPerStroke;
      } else {
        // Not yet reached – draw ghost guide if first few strokes are done
        if (i == 0 || animationValue < strokeStart) continue;
      }

      _drawStroke(canvas, size, strokes[i], strokeProgress,
          isActive: animationValue >= strokeStart && animationValue < strokeEnd,
          index: i);
    }

    // Start dot on the very first point of the next upcoming stroke
    final int nextStroke = (animationValue * totalStrokes).floor();
    if (nextStroke < totalStrokes && animationValue < 1.0) {
      final stroke = strokes[nextStroke];
      final startPt = _toCanvas(stroke.points.first, size);
      _drawStartDot(canvas, startPt, nextStroke + 1);
    }
  }

  void _drawStroke(Canvas canvas, Size size, AksaraStroke stroke,
      double progress, {required bool isActive, required int index}) {
    if (stroke.points.length < 2) return;

    final paint = Paint()
      ..color = isActive ? activeColor : completedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isActive ? strokeWidth + 1.5 : strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pts = stroke.points.map((p) => _toCanvas(p, size)).toList();

    // Build path
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int j = 1; j < pts.length; j++) {
      if (j == 1) {
        path.lineTo(pts[j].dx, pts[j].dy);
      } else {
        // Smooth curve through control midpoints
        final prev = pts[j - 1];
        final curr = pts[j];
        final mid = Offset((prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2);
        path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
      }
    }

    // Clip to revealed portion using PathMetric
    final pathMetric = path.computeMetrics().first;
    final revealedPath =
        pathMetric.extractPath(0, pathMetric.length * progress);

    canvas.drawPath(revealedPath, paint);

    // Arrow at the end of the revealed segment
    if (progress > 0.1) {
      final pos =
          pathMetric.getTangentForOffset(pathMetric.length * progress);
      if (pos != null) {
        _drawArrow(canvas, pos.position, pos.angle);
      }
    }
  }

  void _drawStartDot(Canvas canvas, Offset center, int number) {
    final dotPaint = Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 10, dotPaint);

    final borderPaint = Paint()
      ..color = AppColors.amberDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 10, borderPaint);

    // Draw number
    final tp = TextPainter(
      text: TextSpan(
        text: '$number',
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
        canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawArrow(Canvas canvas, Offset tip, double angle) {
    final arrowPaint = Paint()
      ..color = arrowColor
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(tip.dx, tip.dy);
    canvas.rotate(angle);

    final path = Path()
      ..moveTo(10, 0)
      ..lineTo(-4, -5)
      ..lineTo(-4, 5)
      ..close();

    canvas.drawPath(path, arrowPaint);
    canvas.restore();
  }

  Offset _toCanvas(Offset normalized, Size size) =>
      Offset(normalized.dx * size.width, normalized.dy * size.height);

  @override
  bool shouldRepaint(AksaraStrokePainter old) =>
      old.animationValue != animationValue;
}
