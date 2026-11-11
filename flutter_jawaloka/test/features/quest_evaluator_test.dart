import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/presentation/widgets/javanese_calligraphy_painter.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quest_target.dart';
import 'package:flutter_jawaloka/features/quiz/domain/stroke_similarity_evaluator.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper to extract trace points directly from authentic vector path
  List<Offset> extractPathPoints(String char, {int count = 100}) {
    final path = JavaneseCalligraphyPainter.buildPathForAksara(char, 1.0, 1.0);
    final metrics = path.computeMetrics().toList();
    final totalLength = metrics.fold(0.0, (sum, m) => sum + m.length);
    final points = <Offset>[];

    for (final metric in metrics) {
      final metricPointCount = (count * (metric.length / totalLength))
          .round()
          .clamp(10, count);
      final step = metric.length / (metricPointCount - 1);
      for (int i = 0; i < metricPointCount; i++) {
        final dist = (i * step).clamp(0.0, metric.length);
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  }

  // Random scribble strokes that do not resemble any authentic character
  final randomScribble = [
    [
      const Offset(10, 10),
      const Offset(90, 90),
      const Offset(90, 10),
      const Offset(10, 90),
      const Offset(50, 10),
      const Offset(50, 90),
    ],
  ];

  group('Quest Stroke Similarity Evaluator - Dynamic & Not Fixed Score', () {
    test('Evaluator produces dynamic scores based on geometric input', () {
      final haTrace = [extractPathPoints('ꦲ')];
      final naTrace = [extractPathPoints('ꦤ')];

      final scoreHaOnHa = StrokeSimilarityEvaluator.evaluate(
        strokes: haTrace,
        targetAksara: 'ꦲ',
      );
      final scoreNaOnHa = StrokeSimilarityEvaluator.evaluate(
        strokes: naTrace,
        targetAksara: 'ꦲ',
      );
      final scoreScribble = StrokeSimilarityEvaluator.evaluate(
        strokes: randomScribble,
        targetAksara: 'ꦲ',
      );

      // Prove evaluator is NOT a fixed score
      expect(scoreHaOnHa, isNot(equals(scoreNaOnHa)));
      expect(scoreHaOnHa, isNot(equals(scoreScribble)));
      expect(scoreHaOnHa, greaterThan(scoreNaOnHa));
      expect(scoreNaOnHa, greaterThan(scoreScribble));
    });
  });

  group(
    'Quest Tests for Letters with Authentic Curves (Ha, Na, Ca, Ra, Ka, Ja)',
    () {
      const authenticChars = [
        'ꦲ', // Ha
        'ꦤ', // Na
        'ꦕ', // Ca
        'ꦫ', // Ra
        'ꦏ', // Ka
        'ꦗ', // Ja
      ];

      for (final char in authenticChars) {
        test('Letter $char: (a) empty canvas evaluates to 0.0', () {
          final emptyScore = StrokeSimilarityEvaluator.evaluate(
            strokes: [],
            targetAksara: char,
          );
          expect(emptyScore, 0.0);
        });

        test('Letter $char: (b) random scribble fails (< 70%)', () {
          final scribbleScore = StrokeSimilarityEvaluator.evaluate(
            strokes: randomScribble,
            targetAksara: char,
          );
          expect(
            scribbleScore,
            lessThan(0.70),
            reason: 'Random scribble must fail evaluation for $char',
          );
        });

        test('Letter $char: (c) correct trace passes (>= 70%)', () {
          final correctTrace = [extractPathPoints(char)];
          final score = StrokeSimilarityEvaluator.evaluate(
            strokes: correctTrace,
            targetAksara: char,
          );
          expect(
            score,
            greaterThanOrEqualTo(0.70),
            reason: 'Correct trace must pass evaluation for $char',
          );
        });
      }

      testWidgets(
        '(a) Empty canvas cannot be submitted in DrawingCanvasScreen',
        (tester) async {
          await tester.pumpApp(const DrawingCanvasScreen(aksaraChar: 'ꦲ'));
          await tester.pumpAndSettle();

          final checkBtnFinder = find.byType(ElevatedButton);
          expect(checkBtnFinder, findsOneWidget);

          final button = tester.widget<ElevatedButton>(checkBtnFinder);
          expect(
            button.onPressed,
            isNull,
            reason: 'Submit button must be disabled when canvas is empty',
          );
        },
      );
    },
  );

  group(
    'Quest Non-Reference Perturbation Tests (2%, 4%, 8% Shift, 70% Scale)',
    () {
      const authenticChars = [
        'ꦲ', // Ha
        'ꦤ', // Na
        'ꦕ', // Ca
        'ꦫ', // Ra
        'ꦏ', // Ka
        'ꦗ', // Ja
      ];

      Rect computeBox(List<Offset> pts) {
        double minX = double.infinity, maxX = -double.infinity;
        double minY = double.infinity, maxY = -double.infinity;
        for (final p in pts) {
          if (p.dx < minX) minX = p.dx;
          if (p.dx > maxX) maxX = p.dx;
          if (p.dy < minY) minY = p.dy;
          if (p.dy > maxY) maxY = p.dy;
        }
        return Rect.fromLTRB(minX, minY, maxX, maxY);
      }

      List<Offset> generateCorrelatedNoise(
        List<Offset> pts,
        double deviationRatio,
        int seed,
      ) {
        final box = computeBox(pts);
        final boxDim = box.width > box.height ? box.width : box.height;
        final sigma = deviationRatio * boxDim;
        final rnd = math.Random(seed);

        double nx = 0.0;
        double ny = 0.0;
        final result = <Offset>[];

        for (int i = 0; i < pts.length; i++) {
          final u1 = math.max(1e-9, rnd.nextDouble());
          final u2 = rnd.nextDouble();
          final z0 =
              math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2);
          final z1 =
              math.sqrt(-2.0 * math.log(u1)) * math.sin(2.0 * math.pi * u2);

          nx = 0.7 * nx + math.sqrt(1 - 0.49) * (z0 * sigma);
          ny = 0.7 * ny + math.sqrt(1 - 0.49) * (z1 * sigma);

          result.add(Offset(pts[i].dx + nx, pts[i].dy + ny));
        }
        return result;
      }

      List<Offset> generateShifted(List<Offset> pts, double shiftRatio) {
        final box = computeBox(pts);
        final boxDim = box.width > box.height ? box.width : box.height;
        final shift = shiftRatio * boxDim;
        return pts.map((p) => Offset(p.dx + shift, p.dy + shift)).toList();
      }

      List<Offset> generateScaled(List<Offset> pts, double scaleRatio) {
        final box = computeBox(pts);
        final center = box.center;
        return pts
            .map(
              (p) => Offset(
                center.dx + (p.dx - center.dx) * scaleRatio,
                center.dy + (p.dy - center.dy) * scaleRatio,
              ),
            )
            .toList();
      }

      test('Perturbation matrix for all 6 authentic curved characters', () {
        final summary = <String, Map<String, double>>{};

        for (final char in authenticChars) {
          final basePoints = extractPathPoints(char);
          final noise2 = generateCorrelatedNoise(basePoints, 0.02, 42);
          final noise4 = generateCorrelatedNoise(basePoints, 0.04, 42);
          final shifted8 = generateShifted(basePoints, 0.08);
          final scaled70 = generateScaled(basePoints, 0.70);

          final scoreBase = StrokeSimilarityEvaluator.evaluate(
            strokes: [basePoints],
            targetAksara: char,
          );
          final scoreNoise2 = StrokeSimilarityEvaluator.evaluate(
            strokes: [noise2],
            targetAksara: char,
          );
          final scoreNoise4 = StrokeSimilarityEvaluator.evaluate(
            strokes: [noise4],
            targetAksara: char,
          );
          final scoreShifted8 = StrokeSimilarityEvaluator.evaluate(
            strokes: [shifted8],
            targetAksara: char,
          );
          final scoreScaled70 = StrokeSimilarityEvaluator.evaluate(
            strokes: [scaled70],
            targetAksara: char,
          );

          summary[char] = {
            'base': scoreBase,
            'noise2%': scoreNoise2,
            'noise4%': scoreNoise4,
            'shifted8%': scoreShifted8,
            'scaled70%': scoreScaled70,
          };

          // Base must pass threshold
          expect(
            scoreBase,
            greaterThanOrEqualTo(QuestTarget.questPassThreshold),
          );
          // Evaluator returns deterministic numbers between 0.0 and 1.0
          expect(scoreNoise2, inInclusiveRange(0.0, 1.0));
          expect(scoreNoise4, inInclusiveRange(0.0, 1.0));
          expect(scoreShifted8, inInclusiveRange(0.0, 1.0));
          expect(scoreScaled70, inInclusiveRange(0.0, 1.0));
        }

        // Print table for execution report
        debugPrint('=== PERTURBATION TEST RESULTS ===');
        summary.forEach((char, scores) {
          debugPrint(
            'Aksara $char: Base=${(scores['base']! * 100).toStringAsFixed(1)}%, '
            'Noise2%=${(scores['noise2%']! * 100).toStringAsFixed(1)}%, '
            'Noise4%=${(scores['noise4%']! * 100).toStringAsFixed(1)}%, '
            'Shift8%=${(scores['shifted8%']! * 100).toStringAsFixed(1)}%, '
            'Scale70%=${(scores['scaled70%']! * 100).toStringAsFixed(1)}%',
          );
        });
      });
    },
  );

  group('Quest Target Character and Word Restrictions', () {
    test('All daily quest targets only use authentic curved letters', () {
      expect(QuestTarget.dailyTargets, isNotEmpty);

      for (final target in QuestTarget.dailyTargets) {
        expect(
          QuestTarget.hasOnlyAuthenticCurves(target.aksaraChar),
          isTrue,
          reason:
              'Target ${target.aksaraName} (${target.aksaraChar}) must only contain curved letters',
        );
      }
    });

    test('No quest target uses fallback letters', () {
      const fallbackLetters = [
        'ꦢ', // Da
        'ꦠ', // Ta
        'ꦱ', // Sa
        'ꦮ', // Wa
        'ꦭ', // La
        'ꦥ', // Pa
        'ꦝ', // Dha
        'ꦪ', // Ya
        'ꦚ', // Nya
        'ꦩ', // Ma
        'ꦒ', // Ga
        'ꦧ', // Ba
        'ꦛ', // Tha
        'ꦔ', // Nga
      ];

      for (final target in QuestTarget.dailyTargets) {
        for (final fallback in fallbackLetters) {
          expect(
            target.aksaraChar.contains(fallback),
            isFalse,
            reason:
                'Target ${target.aksaraChar} should never contain fallback letter $fallback',
          );
        }
      }

      // Explicitly verify validation helper rejects fallback letters
      for (final fallback in fallbackLetters) {
        expect(QuestTarget.hasOnlyAuthenticCurves(fallback), isFalse);
      }
    });
  });
}
