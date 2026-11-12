import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/javanese_calligraphy_painter.dart';
import '../../../../core/validation/validators.dart';

/// Kumpulan parameter konstan yang mengatur penilaian berbasis topeng piksel.
class PixelMaskEvaluatorConfig {
  PixelMaskEvaluatorConfig._();

  /// Ukuran kanvas virtual normalisasi (piksel x piksel) untuk mencocokkan topeng font vs goresan.
  static const int maskSize = 96;

  /// Padding tepi saat memetakan bounding box huruf & goresan ke ruang topeng [maskSize].
  static const double maskPadding = 8.0;

  /// Ambang nilai alpha (0..255) agar piksel font dianggap sebagai tinta aksara.
  static const int alphaThreshold = 25;

  /// Ketebalan pena normalisasi untuk merasterisasi goresan pengguna ke kanvas topeng.
  static const double userStrokeMaskWidth = 3.5;

  /// Toleransi jarak (piksel dalam ruang [maskSize]) agar piksel huruf & goresan dianggap dekat.
  static const double distanceTolerancePx = 2.5;

  /// Ambang minimal rasio cakupan piksel huruf oleh goresan (coverage >= 0.75).
  static const double minCoverageThreshold = 0.75;

  /// Ambang minimal rasio ketepatan piksel goresan terhadap huruf (precision >= 0.75).
  static const double minPrecisionThreshold = 0.75;

  /// Batas toleransi perbedaan rasio aspek lebar/tinggi sebelum penalti diterapkan.
  static const double maxFreeAspectRatioDiff = 1.30;
}
class StrokeSimilarityEvaluator {
  StrokeSimilarityEvaluator._();

  static final Map<String, List<Offset>> _fontMaskPointsCache = {};
  static final Map<String, double> _fontAspectRatioCache = {};
  static final Set<String> _unavailableRasterizerKeys = {};

  /// Memanaskan cache topeng piksel untuk [targetAksara] (berguna saat layar atau huruf dibuka).
  static Future<void> prewarmFontMask(
    String targetAksara, {
    int maskSize = PixelMaskEvaluatorConfig.maskSize,
  }) async {
    await extractNormalizedFontMaskPoints(targetAksara, maskSize: maskSize);
  }

  /// Merender karakter [targetAksara] dengan font `NotoSansJavanese` lewat [ui.PictureRecorder]
  static Future<List<Offset>> extractNormalizedFontMaskPoints(
    String targetAksara, {
    int maskSize = PixelMaskEvaluatorConfig.maskSize,
  }) async {
    final cacheKey = '$targetAksara@$maskSize';
    final cached = _fontMaskPointsCache[cacheKey];
    if (cached != null) return cached;
    if (_unavailableRasterizerKeys.contains(cacheKey)) return const [];

    try {
      final result = await _extractPointsFromFont(targetAksara, maskSize)
          .timeout(const Duration(seconds: 5));
      if (result.points.isNotEmpty) {
        _fontMaskPointsCache[cacheKey] = result.points;
        _fontAspectRatioCache[cacheKey] = result.aspectRatio;
        return result.points;
      }
    } catch (_) {
      // Timeout jika dipanggil di FakeAsync testWidgets tanpa rasterizer thread aktif
      _unavailableRasterizerKeys.add(cacheKey);
    }
    return const [];
  }

  static Future<({List<Offset> points, double aspectRatio})> _extractPointsFromFont(
    String targetAksara,
    int maskSize,
  ) async {
    final textPainter = TextPainter(
      text: TextSpan(
        text: targetAksara,
        style: TextStyle(
          fontFamily: 'NotoSansJavanese',
          fontSize: maskSize * 0.72,
          color: Colors.black,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final renderW = math.max(1, textPainter.width.ceil());
    final renderH = math.max(1, textPainter.height.ceil());
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    textPainter.paint(canvas, Offset.zero);
    final picture = recorder.endRecording();
    final image = await picture.toImage(renderW, renderH);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    picture.dispose();

    if (byteData == null) return (points: const <Offset>[], aspectRatio: 1.0);
    final bytes = byteData.buffer.asUint8List();

    final rawPoints = <Offset>[];
    for (int y = 0; y < renderH; y++) {
      for (int x = 0; x < renderW; x++) {
        final alpha = bytes[(y * renderW + x) * 4 + 3];
        if (alpha > PixelMaskEvaluatorConfig.alphaThreshold) {
          rawPoints.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }
    if (rawPoints.isEmpty) return (points: const <Offset>[], aspectRatio: 1.0);

    final box = _computeBoundingBox(rawPoints);
    final maxDim = math.max(box.width, box.height);
    if (maxDim <= 0) return (points: const <Offset>[], aspectRatio: 1.0);
    final aspectRatio = box.width / math.max(1.0, box.height);

    final targetInner = maskSize - 2 * PixelMaskEvaluatorConfig.maskPadding;
    final scale = targetInner / maxDim;
    final cx = maskSize / 2.0;
    final cy = maskSize / 2.0;

    // Deduplikasi ke grid [maskSize x maskSize] setelah normalisasi skala & geser
    final occupied = Uint8List(maskSize * maskSize);
    final normalized = <Offset>[];
    for (final p in rawPoints) {
      final nx = (cx + (p.dx - box.center.dx) * scale).round().clamp(0, maskSize - 1);
      final ny = (cy + (p.dy - box.center.dy) * scale).round().clamp(0, maskSize - 1);
      final idx = ny * maskSize + nx;
      if (occupied[idx] == 0) {
        occupied[idx] = 1;
        normalized.add(Offset(nx.toDouble(), ny.toDouble()));
      }
    }

    return (points: normalized, aspectRatio: aspectRatio);
  }

  /// Mengevaluasi kecocokan goresan pengguna terhadap topeng piksel huruf [targetAksara]
  /// dari font `NotoSansJavanese` dengan normalisasi geser dan skala.
  /// Mengembalikan skor `[0.0, 1.0]`. Tidak mempedulikan urutan goresan.
  static Future<double> evaluateWithFontMask({
    required List<List<Offset>> strokes,
    required String targetAksara,
  }) async {
    if (Validators.validateQuestStrokes(strokes).isInvalid) return 0.0;

    final targetPoints = await extractNormalizedFontMaskPoints(targetAksara);
    if (targetPoints.isEmpty) return 0.0;

    // Kumpulkan seluruh titik goresan (tanpa memperhatikan urutan goresan)
    final allUserPoints = <Offset>[];
    for (final stroke in strokes) {
      allUserPoints.addAll(stroke);
    }
    if (allUserPoints.length < 2) return 0.0;

    final userBox = _computeBoundingBox(allUserPoints);
    final userMaxDim = math.max(userBox.width, userBox.height);
    if (userMaxDim < 8.0) return 0.05;

    final maskSize = PixelMaskEvaluatorConfig.maskSize;
    final targetInner = maskSize - 2 * PixelMaskEvaluatorConfig.maskPadding;
    final scale = targetInner / userMaxDim;
    final cx = maskSize / 2.0;
    final cy = maskSize / 2.0;
    // Rasterisasi goresan pengguna langsung di Dart ke kanvas topeng virtual
    final userGrid = Uint8List(maskSize * maskSize);
    final userPoints = <Offset>[];
    final radius = PixelMaskEvaluatorConfig.userStrokeMaskWidth / 2.0;
    final radiusSq = radius * radius;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      for (int i = 0; i < stroke.length; i++) {
        final p1 = stroke[i];
        final nx1 = cx + (p1.dx - userBox.center.dx) * scale;
        final ny1 = cy + (p1.dy - userBox.center.dy) * scale;

        if (i == 0 && stroke.length == 1) {
          _rasterizeCircleToGrid(userGrid, maskSize, nx1, ny1, radius, radiusSq, userPoints);
        } else if (i > 0) {
          final p0 = stroke[i - 1];
          final nx0 = cx + (p0.dx - userBox.center.dx) * scale;
          final ny0 = cy + (p0.dy - userBox.center.dy) * scale;
          _rasterizeSegmentToGrid(userGrid, maskSize, nx0, ny0, nx1, ny1, radius, radiusSq, userPoints);
        }
      }
    }
    if (userPoints.isEmpty) return 0.0;
    final targetGrid = Uint8List(maskSize * maskSize);
    for (final tp in targetPoints) {
      targetGrid[tp.dy.toInt() * maskSize + tp.dx.toInt()] = 1;
    }

    final tol = PixelMaskEvaluatorConfig.distanceTolerancePx.ceil();
    final tolSq = PixelMaskEvaluatorConfig.distanceTolerancePx *
        PixelMaskEvaluatorConfig.distanceTolerancePx;

    bool hasNeighbor(Uint8List grid, int px, int py) {
      final minX = math.max(0, px - tol);
      final maxX = math.min(maskSize - 1, px + tol);
      final minY = math.max(0, py - tol);
      final maxY = math.min(maskSize - 1, py + tol);
      for (int y = minY; y <= maxY; y++) {
        final dy = y - py;
        final rowOffset = y * maskSize;
        for (int x = minX; x <= maxX; x++) {
          if (grid[rowOffset + x] == 1) {
            final dx = x - px;
            if (dx * dx + dy * dy <= tolSq) return true;
          }
        }
      }
      return false;
    }

    int coveredTarget = 0;
    for (final tp in targetPoints) {
      if (hasNeighbor(userGrid, tp.dx.toInt(), tp.dy.toInt())) {
        coveredTarget++;
      }
    }
    final coverage = coveredTarget / targetPoints.length;

    int matchedUser = 0;
    for (final up in userPoints) {
      if (hasNeighbor(targetGrid, up.dx.toInt(), up.dy.toInt())) {
        matchedUser++;
      }
    }
    final precision = matchedUser / userPoints.length;

    // Jika salah satu di bawah ambang minimum, skor tetap di bawah questPassThreshold (0.70)
    double f1 = (2 * coverage * precision) / (coverage + precision);

    // Penalti proporsional jika rasio aspek lebar/tinggi jauh menyimpang dari glyph font
    final cacheKey = '$targetAksara@$maskSize';
    final targetAspect = _fontAspectRatioCache[cacheKey] ?? 1.0;
    final userAspect = userBox.width / math.max(1.0, userBox.height);
    final aspectDiff = math.max(targetAspect, userAspect) /
        math.max(0.01, math.min(targetAspect, userAspect));
    if (aspectDiff > PixelMaskEvaluatorConfig.maxFreeAspectRatioDiff) {
      final excess = aspectDiff - PixelMaskEvaluatorConfig.maxFreeAspectRatioDiff;
      final penalty = (1.0 - excess * 0.45).clamp(0.4, 1.0);
      f1 *= penalty;
    }

    if (coverage < PixelMaskEvaluatorConfig.minCoverageThreshold ||
        precision < PixelMaskEvaluatorConfig.minPrecisionThreshold) {
      final capped = math.min(f1, 0.65);
      return (capped * 100.0).roundToDouble() / 100.0;
    }
    return (f1 * 100.0).roundToDouble() / 100.0;
  }

  static void _rasterizeCircleToGrid(
    Uint8List grid,
    int maskSize,
    double cx,
    double cy,
    double radius,
    double radiusSq,
    List<Offset> outPoints,
  ) {
    final minX = (cx - radius).floor().clamp(0, maskSize - 1);
    final maxX = (cx + radius).ceil().clamp(0, maskSize - 1);
    final minY = (cy - radius).floor().clamp(0, maskSize - 1);
    final maxY = (cy + radius).ceil().clamp(0, maskSize - 1);

    for (int y = minY; y <= maxY; y++) {
      final dy = y - cy;
      final rowOffset = y * maskSize;
      for (int x = minX; x <= maxX; x++) {
        final dx = x - cx;
        if (dx * dx + dy * dy <= radiusSq) {
          final idx = rowOffset + x;
          if (grid[idx] == 0) {
            grid[idx] = 1;
            outPoints.add(Offset(x.toDouble(), y.toDouble()));
          }
        }
      }
    }
  }

  static void _rasterizeSegmentToGrid(
    Uint8List grid,
    int maskSize,
    double x0,
    double y0,
    double x1,
    double y1,
    double radius,
    double radiusSq,
    List<Offset> outPoints,
  ) {
    final minX = (math.min(x0, x1) - radius).floor().clamp(0, maskSize - 1);
    final maxX = (math.max(x0, x1) + radius).ceil().clamp(0, maskSize - 1);
    final minY = (math.min(y0, y1) - radius).floor().clamp(0, maskSize - 1);
    final maxY = (math.max(y0, y1) + radius).ceil().clamp(0, maskSize - 1);

    final segDx = x1 - x0;
    final segDy = y1 - y0;
    final lenSq = segDx * segDx + segDy * segDy;

    for (int y = minY; y <= maxY; y++) {
      final rowOffset = y * maskSize;
      for (int x = minX; x <= maxX; x++) {
        double distSq;
        if (lenSq == 0) {
          final dx = x - x0;
          final dy = y - y0;
          distSq = dx * dx + dy * dy;
        } else {
          final t = (((x - x0) * segDx + (y - y0) * segDy) / lenSq).clamp(0.0, 1.0);
          final projX = x0 + t * segDx;
          final projY = y0 + t * segDy;
          final dx = x - projX;
          final dy = y - projY;
          distSq = dx * dx + dy * dy;
        }

        if (distSq <= radiusSq) {
          final idx = rowOffset + x;
          if (grid[idx] == 0) {
            grid[idx] = 1;
            outPoints.add(Offset(x.toDouble(), y.toDouble()));
          }
        }
      }
    }
  }
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
