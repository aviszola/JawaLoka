import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Calligraphic Drawing Canvas Painter for JawaLoka.
///
/// Features:
/// 1. Traditional Javanese Manuscript Paper Background (Kertas Daluang):
///    - Warm cream canvas background
///    - Authentic writing guidelines (garis wates: dhuwur, tengah, ngisor)
///    - Soft subtle grid dots
/// 2. Calligraphic Ink Engine:
///    - Variable thickness based on stroke direction & velocity
///    - Chiseled nib angle (45-degree angle characteristic of Javanese bamboo kalam)
///    - Fluid bezier curve smoothing
/// 3. Calligraphic Ghost Guide of target Aksara
class DrawingCanvasPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset>? currentStroke;
  final Color strokeColor;
  final double strokeWidth;
  final String targetAksara;
  final bool showGrid;
  final bool showGuideLines;
  final double ghostOpacity;

  const DrawingCanvasPainter({
    required this.strokes,
    this.currentStroke,
    this.strokeColor = AppColors.ink,
    this.strokeWidth = 5.0,
    this.targetAksara = 'ꦲ',
    this.showGrid = true,
    this.showGuideLines = true,
    this.ghostOpacity = 0.16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Grid & Traditional Guidelines (Garis Wates Nulis)
    if (showGrid) {
      _drawManuscriptGrid(canvas, size);
    }
    if (showGuideLines) {
      _drawGuideLines(canvas, size);
    }

    // 2. Ghost Target Aksara (Calligraphic Reference)
    if (targetAksara.isNotEmpty && ghostOpacity > 0.01) {
      _drawGhostReference(canvas, size);
    }

    // 3. User Committed Strokes (Calligraphic Ink Brush)
    for (final stroke in strokes) {
      _drawCalligraphicStroke(canvas, stroke, strokeColor, strokeWidth);
    }

    // 4. Current In-progress Stroke
    if (currentStroke != null && currentStroke!.isNotEmpty) {
      _drawCalligraphicStroke(canvas, currentStroke!, strokeColor, strokeWidth);
    }
  }

  // ─── Manuscript Grid Dots ─────────────────────────────────────────────────
  void _drawManuscriptGrid(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.inkMuted.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    const double spacing = 24.0;
    const double radius = 1.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  // ─── Javanese Calligraphy Guide Lines (Garis Wates) ───────────────────────
  void _drawGuideLines(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = AppColors.amberDark.withValues(alpha: 0.20)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = AppColors.amberDark.withValues(alpha: 0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Top ascender line (garis dhuwur)
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.25),
      dashPaint,
    );

    // Baseline (garis ngisor / dhasar)
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.75),
      Offset(size.width * 0.92, size.height * 0.75),
      guidePaint,
    );

    // Center median line (garis tengah)
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.50),
      Offset(size.width * 0.9, size.height * 0.50),
      dashPaint,
    );

    // Vertical alignment guide
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.18),
      Offset(size.width * 0.50, size.height * 0.82),
      dashPaint,
    );
  }

  // ─── Ghost Reference Aksara ───────────────────────────────────────────────
  void _drawGhostReference(Canvas canvas, Size size) {
    final ghostSize = math.min(size.width, size.height) * 0.65;
    final textPainter = TextPainter(
      text: TextSpan(
        text: targetAksara,
        style: TextStyle(
          fontFamily: 'NotoSansJavanese',
          fontSize: ghostSize * 0.68,
          color: AppColors.amber.withValues(alpha: ghostOpacity),
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  // ─── Calligraphic Ink Engine (Kalam Aksara) ───────────────────────────────
  void _drawCalligraphicStroke(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double baseWidth,
  ) {
    if (points.isEmpty) return;

    if (points.length == 1) {
      // Tap dot with organic ink droplet shape
      canvas.drawCircle(points.first, baseWidth * 0.8, Paint()..color = color);
      return;
    }

    final inkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Build calligraphic ribbon polygon using 45-degree chisel nib offset
    final angle = math.pi / 4; // 45 degrees
    final nibDx = math.cos(angle);
    final nibDy = math.sin(angle);

    final List<Offset> leftEdge = [];
    final List<Offset> rightEdge = [];

    for (int i = 0; i < points.length; i++) {
      final curr = points[i];

      // Calculate direction vector
      double dirX = 0;
      double dirY = 0;
      if (i < points.length - 1) {
        dirX += points[i + 1].dx - curr.dx;
        dirY += points[i + 1].dy - curr.dy;
      }
      if (i > 0) {
        dirX += curr.dx - points[i - 1].dx;
        dirY += curr.dy - points[i - 1].dy;
      }

      final dirLen = math.sqrt(dirX * dirX + dirY * dirY);
      double widthFactor = 1.0;

      if (dirLen > 0.001) {
        final normDirX = dirX / dirLen;
        final normDirY = dirY / dirLen;

        // Dot product with nib normal: perpendicular to nib angle gives maximum thickness
        final dot = (normDirX * -nibDy + normDirY * nibDx).abs();
        widthFactor =
            0.45 +
            (dot * 0.75); // Range from 0.45x (thin hair) to 1.2x (broad stroke)
      }

      // Taper at start and end
      if (i < 3) {
        widthFactor *= (i + 1) / 3.0;
      } else if (i > points.length - 4) {
        widthFactor *= (points.length - i) / 3.0;
      }

      final halfW = (baseWidth * widthFactor).clamp(1.5, baseWidth * 1.5) / 2;
      final offX = -nibDy * halfW;
      final offY = nibDx * halfW;

      leftEdge.add(Offset(curr.dx + offX, curr.dy + offY));
      rightEdge.add(Offset(curr.dx - offX, curr.dy - offY));
    }

    // Assemble smooth closed polygon path
    final ribbonPath = Path()..moveTo(leftEdge.first.dx, leftEdge.first.dy);

    for (int i = 0; i < leftEdge.length - 1; i++) {
      final p0 = leftEdge[i];
      final p1 = leftEdge[i + 1];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      ribbonPath.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    ribbonPath.lineTo(leftEdge.last.dx, leftEdge.last.dy);

    // Connect to right edge in reverse
    ribbonPath.lineTo(rightEdge.last.dx, rightEdge.last.dy);
    for (int i = rightEdge.length - 1; i > 0; i--) {
      final p0 = rightEdge[i];
      final p1 = rightEdge[i - 1];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      ribbonPath.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    ribbonPath.close();

    canvas.drawPath(ribbonPath, inkPaint);

    // Rounded start and end terminals
    canvas.drawCircle(points.first, baseWidth * 0.35, inkPaint);
    canvas.drawCircle(points.last, baseWidth * 0.35, inkPaint);
  }

  @override
  bool shouldRepaint(covariant DrawingCanvasPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.targetAksara != targetAksara ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.ghostOpacity != ghostOpacity;
  }
}
