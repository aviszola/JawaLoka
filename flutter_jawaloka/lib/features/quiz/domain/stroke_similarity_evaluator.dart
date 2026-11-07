import 'dart:math' as math;
import 'dart:ui';
import '../../../../core/presentation/widgets/javanese_calligraphy_painter.dart';

/// Evaluator comparing user handwritten strokes against authentic Aksara Jawa vector paths.
///
/// Uses deterministic geometric curve matching with aspect ratio preservation,
/// Gaussian distance decay for coverage and precision, spatial grid distribution,
/// and stroke length penalty.
class StrokeSimilarityEvaluator {
  StrokeSimilarityEvaluator._();

  /// Evaluates similarity between user [strokes] and [targetAksara] path.
  ///
  /// Returns a normalized score between 0.0 and 1.0 (e.g. 0.90 = 90%).
  /// Fully deterministic: identical input strokes produce identical output scores.
  static double evaluate({
    required List<List<Offset>> strokes,
    required String targetAksara,
    int targetSamplePoints = 100,
    double sigma = 0.048,
  }) {
    if (strokes.isEmpty) return 0.0;

    // Resample user strokes into uniform points
    final userPoints = _resampleStrokes(strokes, stepDistance: 2.0);
    if (userPoints.length < 5) return 0.0;

    // Get target ground-truth path in 1.0 scale (100x100 virtual coordinate space)
    final targetPath = JavaneseCalligraphyPainter.buildPathForAksara(
      targetAksara,
      1.0,
      1.0,
    );
    final targetPoints = _samplePath(targetPath, targetSamplePoints);
    if (targetPoints.length < 5) return 0.0;

    // Compute bounding boxes
    final userBox = _computeBoundingBox(userPoints);
    final targetBox = _computeBoundingBox(targetPoints);

    final userMaxDim = math.max(userBox.width, userBox.height);
    final targetMaxDim = math.max(targetBox.width, targetBox.height);

    // Degenerate drawing protection (e.g., tap dot without form)
    if (userMaxDim < 8.0 || targetMaxDim <= 0.0) return 0.05;

    // Normalize points: center at (0, 0), scale by max dimension (PRESERVES ASPECT RATIO)
    final normUser = userPoints
        .map((p) {
          return Offset(
            (p.dx - userBox.center.dx) / userMaxDim,
            (p.dy - userBox.center.dy) / userMaxDim,
          );
        })
        .toList(growable: false);

    final normTarget = targetPoints
        .map((p) {
          return Offset(
            (p.dx - targetBox.center.dx) / targetMaxDim,
            (p.dy - targetBox.center.dy) / targetMaxDim,
          );
        })
        .toList(growable: false);

    // Aspect ratio match factor (preserves aspect ratio)
    final userAspect = userBox.height > 0
        ? (userBox.width / userBox.height)
        : 1.0;
    final targetAspect = targetBox.height > 0
        ? (targetBox.width / targetBox.height)
        : 1.0;
    final aspectMatch =
        math.min(userAspect, targetAspect) / math.max(userAspect, targetAspect);

    // Compute tangent vectors for stroke orientation matching
    final userTangents = _computeTangents(normUser);
    final targetTangents = _computeTangents(normTarget);

    // Length comparison & excessive/deficit stroke penalty
    final userLength = _computeStrokeLength(normUser);
    final targetLength = _computePathLength(normTarget);

    double lengthPenalty = 0.0;
    if (targetLength > 0.0 && userLength > 1.35 * targetLength) {
      final excess = (userLength - 1.35 * targetLength) / targetLength;
      lengthPenalty = (excess * 0.30).clamp(0.0, 0.40);
    }

    // Micro-alignment search: accommodates slight drawing offsets (±0.03 normalized)
    final offsets = const [
      Offset(0.0, 0.0),
      Offset(-0.025, 0.0),
      Offset(0.025, 0.0),
      Offset(0.0, -0.025),
      Offset(0.0, 0.025),
    ];

    double bestF1 = 0.0;

    for (final offset in offsets) {
      // 1. Coverage: How well target points are covered by user points
      double covSum = 0.0;
      for (int i = 0; i < normTarget.length; i++) {
        final tp = normTarget[i];
        final tt = targetTangents[i];
        double maxAffinity = 0.0;

        for (int j = 0; j < normUser.length; j++) {
          final up = normUser[j] + offset;
          final ut = userTangents[j];
          final dist = (tp - up).distance;

          // Directional alignment (orientation similarity, independent of forward/backward drawing)
          final dirAlign = (tt.dx * ut.dx + tt.dy * ut.dy).abs();
          final orientWeight = dirAlign;
          final distWeight = math.exp(-0.5 * math.pow(dist / sigma, 2));
          final affinity = distWeight * orientWeight;

          if (affinity > maxAffinity) {
            maxAffinity = affinity;
          }
        }
        covSum += maxAffinity;
      }
      final coverage = covSum / normTarget.length;

      // 2. Precision: How well user points belong to target points
      double precSum = 0.0;
      for (int j = 0; j < normUser.length; j++) {
        final up = normUser[j] + offset;
        final ut = userTangents[j];
        double maxAffinity = 0.0;

        for (int i = 0; i < normTarget.length; i++) {
          final tp = normTarget[i];
          final tt = targetTangents[i];
          final dist = (up - tp).distance;

          final dirAlign = (tt.dx * ut.dx + tt.dy * ut.dy).abs();
          final orientWeight = dirAlign;
          final distWeight = math.exp(-0.5 * math.pow(dist / sigma, 2));
          final affinity = distWeight * orientWeight;

          if (affinity > maxAffinity) {
            maxAffinity = affinity;
          }
        }
        precSum += maxAffinity;
      }
      final precision = precSum / normUser.length;

      // Harmonic mean (F1-score)
      double f1 = 0.0;
      if (coverage + precision > 0.0) {
        f1 = (2 * coverage * precision) / (coverage + precision);
      }

      if (f1 > bestF1) {
        bestF1 = f1;
      }
    }

    // 3. Spatial structural density similarity (4x4 grid distribution)
    final spatialSim = _computeSpatialSimilarity(normUser, normTarget);

    // Composite scoring combining curve similarity, spatial structure, and aspect ratio
    final spatialFactor = 0.18 + 0.82 * math.pow(spatialSim, 1.45);
    final aspectFactor = 0.70 + 0.30 * aspectMatch;
    final baseScore = bestF1 * spatialFactor * aspectFactor;

    final finalScore = (baseScore - lengthPenalty).clamp(0.0, 1.0);

    // Round to 2 decimal places deterministically
    return (finalScore * 100.0).roundToDouble() / 100.0;
  }

  /// Evaluates 4x4 spatial density histogram cosine similarity over [-0.5, 0.5]^2.
  /// Confirms that user strokes populate the same structural regions as the target.
  static double _computeSpatialSimilarity(
    List<Offset> userPoints,
    List<Offset> targetPoints,
  ) {
    const gridSize = 4;
    final userGrid = List<double>.filled(gridSize * gridSize, 0.0);
    final targetGrid = List<double>.filled(gridSize * gridSize, 0.0);

    for (final p in userPoints) {
      final col = ((p.dx + 0.5) * gridSize).floor().clamp(0, gridSize - 1);
      final row = ((p.dy + 0.5) * gridSize).floor().clamp(0, gridSize - 1);
      userGrid[row * gridSize + col] += 1.0;
    }

    for (final p in targetPoints) {
      final col = ((p.dx + 0.5) * gridSize).floor().clamp(0, gridSize - 1);
      final row = ((p.dy + 0.5) * gridSize).floor().clamp(0, gridSize - 1);
      targetGrid[row * gridSize + col] += 1.0;
    }

    // Normalize vectors
    double uNorm = 0.0;
    double tNorm = 0.0;
    for (int i = 0; i < userGrid.length; i++) {
      uNorm += userGrid[i] * userGrid[i];
      tNorm += targetGrid[i] * targetGrid[i];
    }
    uNorm = math.sqrt(uNorm);
    tNorm = math.sqrt(tNorm);

    if (uNorm <= 0.0 || tNorm <= 0.0) return 0.0;

    double dot = 0.0;
    for (int i = 0; i < userGrid.length; i++) {
      dot += (userGrid[i] / uNorm) * (targetGrid[i] / tNorm);
    }

    return dot.clamp(0.0, 1.0);
  }

  static List<Offset> _computeTangents(List<Offset> points) {
    final n = points.length;
    if (n < 2) return List.filled(n, Offset.zero);

    final tangents = List<Offset>.filled(n, Offset.zero);
    for (int i = 0; i < n; i++) {
      Offset dir;
      if (i == 0) {
        dir = points[1] - points[0];
      } else if (i == n - 1) {
        dir = points[n - 1] - points[n - 2];
      } else {
        dir = points[i + 1] - points[i - 1];
      }
      final len = dir.distance;
      tangents[i] = len > 1e-6
          ? Offset(dir.dx / len, dir.dy / len)
          : Offset.zero;
    }
    return tangents;
  }

  static List<Offset> _samplePath(Path path, int targetCount) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return const [];

    double totalLength = 0.0;
    for (final m in metrics) {
      totalLength += m.length;
    }
    if (totalLength <= 0.0) return const [];

    final points = <Offset>[];
    for (final m in metrics) {
      if (m.length <= 0) continue;
      final contourPoints = math.max(
        3,
        (targetCount * (m.length / totalLength)).round(),
      );
      final step = m.length / (contourPoints - 1);
      for (int i = 0; i < contourPoints; i++) {
        final distance = (i * step).clamp(0.0, m.length);
        final tangent = m.getTangentForOffset(distance);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  }

  static List<Offset> _resampleStrokes(
    List<List<Offset>> strokes, {
    double stepDistance = 2.0,
  }) {
    final points = <Offset>[];

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        points.add(stroke.first);
        continue;
      }

      points.add(stroke.first);
      for (int i = 0; i < stroke.length - 1; i++) {
        final p1 = stroke[i];
        final p2 = stroke[i + 1];
        final dist = (p2 - p1).distance;
        if (dist > stepDistance) {
          final steps = (dist / stepDistance).floor();
          for (int s = 1; s <= steps; s++) {
            final t = s * stepDistance / dist;
            points.add(Offset.lerp(p1, p2, t)!);
          }
        }
        points.add(p2);
      }
    }

    return points;
  }

  static Rect _computeBoundingBox(List<Offset> points) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  static double _computeStrokeLength(List<Offset> points) {
    double len = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      len += (points[i + 1] - points[i]).distance;
    }
    return len;
  }

  static double _computePathLength(List<Offset> points) {
    double len = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      len += (points[i + 1] - points[i]).distance;
    }
    return len;
  }
}
