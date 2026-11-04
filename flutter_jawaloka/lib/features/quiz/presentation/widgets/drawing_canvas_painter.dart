import 'dart:math';
import 'package:flutter/material.dart';

/// Holds a single drawn stroke as a list of points.
class DrawnStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  const DrawnStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

/// CustomPainter that renders all drawn strokes and an optional reference ghost.
class DrawingCanvasPainter extends CustomPainter {
  final List<DrawnStroke> strokes;
  final DrawnStroke? currentStroke;
  final String referenceCharacter;
  final bool showReference;
  final double referenceOpacity;
  final bool showGrid;

  const DrawingCanvasPainter({
    required this.strokes,
    this.currentStroke,
    this.referenceCharacter = '',
    this.showReference = true,
    this.referenceOpacity = 0.18,
    this.showGrid = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- Dotted grid background ---
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // --- Ratio hint lines (thirds) ---
    _drawHintLines(canvas, size);

    // --- Reference ghost character ---
    if (showReference && referenceCharacter.isNotEmpty) {
      _drawReferenceGhost(canvas, size);
    }

    // --- Committed strokes ---
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    // --- Current in-progress stroke ---
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCFCABE)
      ..strokeWidth = 1;

    const spacing = 20.0;
    const dotRadius = 1.2;

    double x = spacing;
    while (x < size.width) {
      double y = spacing;
      while (y < size.height) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
        y += spacing;
      }
      x += spacing;
    }
  }

  void _drawHintLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5A31A).withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Horizontal thirds
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );

    // Vertical center
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  void _drawReferenceGhost(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: referenceCharacter,
        style: TextStyle(
          fontSize: size.height * 0.6,
          color: const Color(0xFFF5A31A).withOpacity(referenceOpacity),
          fontFamily: 'NotoSansJavanese',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width);
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  void _drawStroke(Canvas canvas, DrawnStroke stroke) {
    if (stroke.points.length < 2) {
      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first,
          stroke.strokeWidth / 2,
          Paint()..color = stroke.color,
        );
      }
      return;
    }

    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);

    for (int i = 1; i < stroke.points.length - 1; i++) {
      final mid = Offset(
        (stroke.points[i].dx + stroke.points[i + 1].dx) / 2,
        (stroke.points[i].dy + stroke.points[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(
        stroke.points[i].dx,
        stroke.points[i].dy,
        mid.dx,
        mid.dy,
      );
    }
    path.lineTo(stroke.points.last.dx, stroke.points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DrawingCanvasPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.showReference != showReference ||
        oldDelegate.referenceOpacity != referenceOpacity;
  }
}
