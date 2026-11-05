import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_jawaloka/core/theme/app_colors.dart';

/// Represents a single node on the quiz path.
class PathNode {
  final Offset position;
  final NodeStatus status;
  final String javaScript; // Aksara Jawa character
  final String latinName;
  final String topicName;

  const PathNode({
    required this.position,
    required this.status,
    required this.javaScript,
    required this.latinName,
    this.topicName = '',
  });
}

enum NodeStatus { completed, current, locked }

/// CustomPainter that draws curved connecting lines between quiz path nodes.
class QuizPathPainter extends CustomPainter {
  final List<PathNode> nodes;
  final double animationValue;

  const QuizPathPainter({
    required this.nodes,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;

    for (int i = 0; i < nodes.length - 1; i++) {
      final from = nodes[i].position;
      final to = nodes[i + 1].position;

      final isCompleted = nodes[i].status == NodeStatus.completed &&
          nodes[i + 1].status != NodeStatus.locked;
      final isLocked = nodes[i + 1].status == NodeStatus.locked;

      // Shadow / dashed base track
      _drawTrackLine(canvas, from, to, isLocked);

      // Progress fill on completed segments
      if (isCompleted) {
        _drawProgressLine(canvas, from, to);
      }
    }
  }

  void _drawTrackLine(Canvas canvas, Offset from, Offset to, bool isLocked) {
    final paint = Paint()
      ..color = isLocked
          ? const Color(0xFFD4CAB8)
          : AppColors.amberSoft.withOpacity(0.6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dashed stroke for locked segments
    if (isLocked) {
      _drawDashedCurve(canvas, from, to, paint);
    } else {
      final path = _buildCubicPath(from, to);
      canvas.drawPath(path, paint);
    }
  }

  void _drawProgressLine(Canvas canvas, Offset from, Offset to) {
    final paint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = _buildCubicPath(from, to);
    canvas.drawPath(path, paint);
  }

  Path _buildCubicPath(Offset from, Offset to) {
    final midX = (from.dx + to.dx) / 2;
    final controlPoint1 = Offset(midX + 40, from.dy);
    final controlPoint2 = Offset(midX - 40, to.dy);

    return Path()
      ..moveTo(from.dx, from.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        to.dx,
        to.dy,
      );
  }

  void _drawDashedCurve(
      Canvas canvas, Offset from, Offset to, Paint paint) {
    const dashLength = 10.0;
    const gapLength = 6.0;
    final path = _buildCubicPath(from, to);

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(QuizPathPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.nodes != nodes;
}
