import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/presentation/widgets/javanese_calligraphy_painter.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/quiz/domain/stroke_similarity_evaluator.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  group('StrokeSimilarityEvaluator Unit Tests', () {
    // Helper to generate ground-truth points of target Aksara Ha (ꦲ)
    List<Offset> extractTargetPoints(String aksara, {int count = 100}) {
      final path = JavaneseCalligraphyPainter.buildPathForAksara(
        aksara,
        1.0,
        1.0,
      );
      final metrics = path.computeMetrics().toList();
      double totalLength = 0.0;
      for (final m in metrics) {
        totalLength += m.length;
      }

      final points = <Offset>[];
      for (final m in metrics) {
        final contourPoints = math.max(
          3,
          (count * (m.length / totalLength)).round(),
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

    test('Empty strokes evaluate to exactly 0.0', () {
      final score = StrokeSimilarityEvaluator.evaluate(
        strokes: const [],
        targetAksara: 'ꦲ',
      );
      expect(score, 0.0);
    });

    test(
      'Strokes matching target aksara Ha achieve high similarity (>= 85%)',
      () {
        final targetPoints = extractTargetPoints('ꦲ');
        expect(targetPoints.length, greaterThan(20));

        // Simulate a user accurately tracing the target path
        final userStrokes = [targetPoints];
        final score = StrokeSimilarityEvaluator.evaluate(
          strokes: userStrokes,
          targetAksara: 'ꦲ',
        );

        expect(score, greaterThanOrEqualTo(0.85));
      },
    );

    test(
      'Drawing completely different shape (e.g. circle) yields low score (< 30%)',
      () {
        // Circle centered at (50, 50) with radius 35
        final circlePoints = <Offset>[];
        for (int i = 0; i < 60; i++) {
          final angle = (i / 60.0) * 2 * math.pi;
          circlePoints.add(
            Offset(50 + 35 * math.cos(angle), 50 + 35 * math.sin(angle)),
          );
        }

        final score = StrokeSimilarityEvaluator.evaluate(
          strokes: [circlePoints],
          targetAksara: 'ꦲ',
        );

        expect(score, lessThan(0.30));
      },
    );

    test(
      'Incomplete drawing (only first 35% of Ha) yields partial score below 85%',
      () {
        final fullPoints = extractTargetPoints('ꦲ');
        final partialPoints = fullPoints
            .take((fullPoints.length * 0.35).round())
            .toList();

        final score = StrokeSimilarityEvaluator.evaluate(
          strokes: [partialPoints],
          targetAksara: 'ꦲ',
        );

        // Incomplete drawing gets partial score, but does NOT pass threshold
        expect(score, lessThan(0.85));
        expect(score, greaterThan(0.15));
      },
    );

    test('Repeated evaluation on identical strokes is 100% deterministic', () {
      final fullPoints = extractTargetPoints('ꦲ');
      final sampleStrokes = [fullPoints];

      final firstScore = StrokeSimilarityEvaluator.evaluate(
        strokes: sampleStrokes,
        targetAksara: 'ꦲ',
      );

      for (int i = 0; i < 10; i++) {
        final repeatScore = StrokeSimilarityEvaluator.evaluate(
          strokes: sampleStrokes,
          targetAksara: 'ꦲ',
        );
        expect(repeatScore, equals(firstScore));
      }
    });

    test('Excessive random scribbles across canvas are penalized', () {
      final fullPoints = extractTargetPoints('ꦲ');
      // Add huge excessive zigzag scribbles across the canvas
      final scribble = <Offset>[...fullPoints];
      for (int i = 0; i < 150; i++) {
        scribble.add(Offset(i * 1.5, (i % 2 == 0) ? 10.0 : 90.0));
      }

      final cleanScore = StrokeSimilarityEvaluator.evaluate(
        strokes: [fullPoints],
        targetAksara: 'ꦲ',
      );

      final scribbledScore = StrokeSimilarityEvaluator.evaluate(
        strokes: [scribble],
        targetAksara: 'ꦲ',
      );

      expect(scribbledScore, lessThan(cleanScore));
      expect(scribbledScore, lessThan(0.50));
    });

    test(
      'Minor shape variation (natural handwriting with slight curve wobble) scores in 70-84% band',
      () {
        final targetPoints = extractTargetPoints('ꦲ');
        // Simulate authentic handwriting variation: natural cursive wobble +/- 2.5-3 px along stroke
        final variedPoints = <Offset>[];
        for (int i = 0; i < targetPoints.length; i++) {
          final p = targetPoints[i];
          final wobbleX = 2.8 * math.sin(p.dy / 5.5);
          final wobbleY = 2.4 * math.cos(p.dx / 5.5);
          variedPoints.add(Offset(p.dx + wobbleX, p.dy + wobbleY));
        }

        final score = StrokeSimilarityEvaluator.evaluate(
          strokes: [variedPoints],
          targetAksara: 'ꦲ',
        );

        // Retains key features of the aksara -> layak mendapatkan 70-84%
        expect(score, greaterThanOrEqualTo(0.70));
        expect(score, lessThan(0.85));
      },
    );

    test(
      'Drawing with missing parts (incomplete, only first 35%) scores under 50%',
      () {
        final fullPoints = extractTargetPoints('ꦲ');
        final partialPoints = fullPoints
            .take((fullPoints.length * 0.35).round())
            .toList();

        final score = StrokeSimilarityEvaluator.evaluate(
          strokes: [partialPoints],
          targetAksara: 'ꦲ',
        );

        // Major part of shape is missing -> must be under 50%
        expect(score, lessThan(0.50));
        expect(score, greaterThan(0.15));
      },
    );

    test(
      'Drawing completely wrong aksara (e.g. Ra or Ca instead of Ha) scores under 50%',
      () {
        final raPoints = extractTargetPoints('ꦫ');
        final caPoints = extractTargetPoints('ꦕ');
        final raScore = StrokeSimilarityEvaluator.evaluate(
          strokes: [raPoints],
          targetAksara: 'ꦲ',
        );
        final caScore = StrokeSimilarityEvaluator.evaluate(
          strokes: [caPoints],
          targetAksara: 'ꦲ',
        );

        // Entirely different character shapes -> under 50%
        expect(raScore, lessThan(0.50));
        expect(caScore, lessThan(0.50));
      },
    );

    test(
      'Drawing partially distorted aksara (e.g. Ka vs Ha) scores in 50-69% band',
      () {
        final kaPoints = extractTargetPoints('ꦏ');
        final kaScore = StrokeSimilarityEvaluator.evaluate(
          strokes: [kaPoints],
          targetAksara: 'ꦲ',
        );

        // Shares arches but main loop/bridge differs -> 50-69% band
        expect(kaScore, greaterThanOrEqualTo(0.50));
        expect(kaScore, lessThan(0.70));
      },
    );

    test('Drawing random scribbles scores low (under 30%)', () {
      // Chaotic zigzag scribble completely disconnected from character shape
      final randomPoints = <Offset>[];
      for (int i = 0; i < 80; i++) {
        randomPoints.add(Offset((i * 1.2) % 90, ((i * 7) % 85) + 10));
      }

      final score = StrokeSimilarityEvaluator.evaluate(
        strokes: [randomPoints],
        targetAksara: 'ꦲ',
      );

      expect(score, lessThan(0.30));
    });

    test(
      'Drawing with different scale (50% smaller or 150% larger) scores >= 85%',
      () {
        final targetPoints = extractTargetPoints('ꦲ');

        // 50% smaller
        final smallPoints = targetPoints.map((p) => p * 0.5).toList();
        final smallScore = StrokeSimilarityEvaluator.evaluate(
          strokes: [smallPoints],
          targetAksara: 'ꦲ',
        );
        expect(smallScore, greaterThanOrEqualTo(0.85));

        // 150% larger
        final largePoints = targetPoints.map((p) => p * 1.5).toList();
        final largeScore = StrokeSimilarityEvaluator.evaluate(
          strokes: [largePoints],
          targetAksara: 'ꦲ',
        );
        expect(largeScore, greaterThanOrEqualTo(0.85));
      },
    );

    test('Drawing with position offset (translated) scores >= 85%', () {
      final targetPoints = extractTargetPoints('ꦲ');
      // Translated by +45 px X, +35 px Y
      final translatedPoints = targetPoints
          .map((p) => Offset(p.dx + 45.0, p.dy + 35.0))
          .toList();

      final score = StrokeSimilarityEvaluator.evaluate(
        strokes: [translatedPoints],
        targetAksara: 'ꦲ',
      );

      expect(score, greaterThanOrEqualTo(0.85));
    });

    test('Drawing with reversed stroke direction scores >= 85%', () {
      final targetPoints = extractTargetPoints('ꦲ');
      final reversedPoints = targetPoints.reversed.toList();

      final score = StrokeSimilarityEvaluator.evaluate(
        strokes: [reversedPoints],
        targetAksara: 'ꦲ',
      );

      // Invariant to stroke direction when shape and curve are correct
      expect(score, greaterThanOrEqualTo(0.85));
    });
  });

  group('DailyResultScreen User Strokes Rendering Widget Tests', () {
    testWidgets(
      'DailyResultScreen renders UserDrawingThumbnailPainter when userStrokes are present',
      (tester) async {
        final sampleStrokes = [
          [const Offset(20, 20), const Offset(30, 40), const Offset(50, 50)],
        ];

        await tester.pumpApp(
          DailyResultScreen(
            similarity: 0.90,
            userStrokes: sampleStrokes,
            targetAksara: 'ꦲ',
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1500));

        // Verifies UserDrawingThumbnailPainter is active
        final thumbnailFinder = find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter is UserDrawingThumbnailPainter,
        );
        expect(thumbnailFinder, findsOneWidget);

        // Status is passed because similarity >= 0.70
        expect(find.text('Status: Lulus'), findsOneWidget);
        expect(
          find.text('Kemiripan 90% (Syarat lulus: ≥ 70%)'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'DailyResultScreen renders Belum Lulus when similarity is below threshold',
      (tester) async {
        await tester.pumpApp(
          const DailyResultScreen(
            similarity: 0.45,
            userStrokes: [],
            targetAksara: 'ꦲ',
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1500));

        expect(find.text('Status: Belum Lulus'), findsOneWidget);
        expect(
          find.text('Kemiripan 45% (Syarat lulus: ≥ 70%)'),
          findsOneWidget,
        );
        expect(find.text('Coba Lagi'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Lanjutkan Belajar on DailyResultScreen returns to Home and does not pop to LanguageSelectionScreen',
      (tester) async {
        await tester.pumpApp(
          const Scaffold(body: Text('Language Selection Screen')),
          routes: {
            AppRouter.home: (ctx) => const Scaffold(body: Text('Home Screen')),
            AppRouter.drawingCanvas: (ctx) => const DrawingCanvasScreen(),
            AppRouter.dailyResult: (ctx) =>
                const DailyResultScreen(similarity: 0.90, targetAksara: 'ꦲ'),
          },
        );
        await tester.pump();

        final rootContext = tester.element(
          find.text('Language Selection Screen'),
        );
        // Push Home
        Navigator.of(rootContext).pushNamed(AppRouter.home);
        await tester.pumpAndSettle();
        expect(find.text('Home Screen'), findsOneWidget);

        final homeContext = tester.element(find.text('Home Screen'));
        // Push DrawingCanvas
        Navigator.of(homeContext).pushNamed(AppRouter.drawingCanvas);
        await tester.pumpAndSettle();
        expect(find.byType(DrawingCanvasScreen), findsOneWidget);

        final canvasContext = tester.element(find.byType(DrawingCanvasScreen));
        // Push DailyResult
        Navigator.of(canvasContext).pushNamed(
          AppRouter.dailyResult,
          arguments: const DailyResultArgs(
            similarity: 0.90,
            targetAksara: 'ꦲ',
            userStrokes: [],
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));
        expect(find.byType(DailyResultScreen), findsOneWidget);

        // Tap 'Lanjutkan Belajar →'
        final continueBtn = find.text('Lanjutkan Belajar →');
        expect(continueBtn, findsOneWidget);
        await tester.ensureVisible(continueBtn);
        await tester.pump();
        await tester.tap(continueBtn);
        await tester.pumpAndSettle();

        // Must be on Home Screen, NOT Language Selection Screen!
        expect(find.byType(DailyResultScreen), findsNothing);
        expect(find.byType(DrawingCanvasScreen), findsNothing);
        expect(find.text('Home Screen'), findsOneWidget);
        expect(find.text('Language Selection Screen'), findsNothing);
      },
    );
  });
}
