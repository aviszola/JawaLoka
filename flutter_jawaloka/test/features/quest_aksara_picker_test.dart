import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quest_target.dart';
import 'package:flutter_jawaloka/features/quiz/domain/stroke_similarity_evaluator.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/drawing_canvas_painter.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontPath = Directory.current.path.endsWith('flutter_jawaloka')
        ? 'assets/fonts/NotoSansJavanese-Regular.ttf'
        : 'flutter_jawaloka/assets/fonts/NotoSansJavanese-Regular.ttf';
    final fontFile = File(fontPath);
    if (fontFile.existsSync()) {
      final bytes = await fontFile.readAsBytes();
      final loader = FontLoader('NotoSansJavanese');
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
    }
  });

  group('Pemilih 20 Aksara Dasar & Sumber Tunggal Font NotoSansJavanese', () {
    test('hanacarakaAll berisi tepat 20 aksara dasar berurutan dan semuanya terbuka (isSelectable == true)', () {
      expect(QuestTarget.hanacarakaAll.length, equals(20));
      final names = QuestTarget.hanacarakaAll.map((e) => e.aksaraName).toList();
      expect(
        names,
        equals([
          'Ha', 'Na', 'Ca', 'Ra', 'Ka',
          'Da', 'Ta', 'Sa', 'Wa', 'La',
          'Pa', 'Dha', 'Ja', 'Ya', 'Nya',
          'Ma', 'Ga', 'Ba', 'Tha', 'Nga',
        ]),
      );

      final locked = QuestTarget.hanacarakaAll.where((t) => !t.isSelectable).toList();
      expect(locked, isEmpty);
    });

    testWidgets('Setiap dari 20 huruf memakai karakter dan kunci yang sama di ikon atas dan garis bantu kanvas', (tester) async {
      for (final target in QuestTarget.hanacarakaAll) {
        await tester.pumpApp(
          DrawingCanvasScreen(
            aksaraChar: target.aksaraChar,
            aksaraName: target.aksaraName,
          ),
        );
        await tester.pump();

        final headerText = tester.widget<Text>(find.byKey(const Key('quest_header_aksara_glyph')));
        final canvasPainter = tester
            .widgetList<CustomPaint>(find.byType(CustomPaint))
            .map((w) => w.painter)
            .whereType<DrawingCanvasPainter>()
            .first;

        expect(headerText.data, equals(target.aksaraChar));
        expect(headerText.style?.fontFamily, equals('NotoSansJavanese'));
        expect(canvasPainter.targetAksara, equals(target.aksaraChar));
        expect(headerText.data, equals(canvasPainter.targetAksara));
      }
    });

    testWidgets('Grid 20 aksara semuanya terbuka tanpa ikon gembok; memilih Da mengganti ikon atas dan garis bantu', (tester) async {
      final locCtrl = LocaleController(preferences: InMemoryLocalePreferences(initialLocale: 'id'));
      await locCtrl.loadSavedLocale();

      await tester.pumpApp(
        const DrawingCanvasScreen(),
        controller: locCtrl,
      );
      await tester.pumpAndSettle();

      // Awalnya Ha ('ꦲ')
      expect(tester.widget<Text>(find.byKey(const Key('quest_header_aksara_glyph'))).data, equals('ꦲ'));

      // Buka pemilih aksara
      await tester.tap(find.byKey(const Key('open_aksara_picker_button')));
      await tester.pumpAndSettle();

      // Tidak ada ikon gembok sama sekali di grid pemilih
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.lock_rounded), findsNothing);

      // Seluruh 20 item dirender
      for (final target in QuestTarget.hanacarakaAll) {
        expect(find.byKey(Key('aksara_picker_item_${target.aksaraName}')), findsOneWidget);
      }

      // Pilih huruf 'Da' ('ꦢ')
      final daItem = find.byKey(const Key('aksara_picker_item_Da'));
      await tester.ensureVisible(daItem);
      await tester.tap(daItem);
      await tester.pumpAndSettle();

      final headerText = tester.widget<Text>(find.byKey(const Key('quest_header_aksara_glyph')));
      final canvasPainter = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((w) => w.painter)
          .whereType<DrawingCanvasPainter>()
          .first;

      expect(headerText.data, equals('ꦢ'));
      expect(canvasPainter.targetAksara, equals('ꦢ'));
      expect(find.text('Da'), findsWidgets);
    });

    test('Evaluator topeng piksel: lulus untuk goresan sesuai, geser & skala; gagal untuk kosong, acak, dan huruf lain', () async {
      // Uji untuk beberapa huruf mencakup yang lama dan baru terbuka (Ha, Na, Da, Nga)
      for (final char in ['ꦲ', 'ꦤ', 'ꦢ', 'ꦔ']) {
        final maskPoints = await StrokeSimilarityEvaluator.extractNormalizedFontMaskPoints(char);
        expect(maskPoints, isNotEmpty, reason: 'Font mask must not be empty for $char');

        // Buat goresan sintetis menelusuri piksel topeng secara terurut (nearest-neighbor chain agar poligon tidak acak)
        final strokes = _buildTraceStrokesFromMask(maskPoints);

        // 1. Goresan menelusuri topeng huruf -> lulus (>= 0.70)
        final exactScore = await StrokeSimilarityEvaluator.evaluateWithFontMask(
          strokes: strokes,
          targetAksara: char,
        );
        expect(exactScore, greaterThanOrEqualTo(QuestTarget.questPassThreshold), reason: 'Exact mask trace must pass for $char (got $exactScore)');

        // 2. Goresan yang sama digeser dan diskalakan -> lulus (>= 0.70)
        final shiftedScaledStrokes = strokes
            .map((s) => s.map((p) => Offset(p.dx * 1.8 + 45.0, p.dy * 1.8 + 30.0)).toList())
            .toList();
        final shiftedScore = await StrokeSimilarityEvaluator.evaluateWithFontMask(
          strokes: shiftedScaledStrokes,
          targetAksara: char,
        );
        expect(shiftedScore, greaterThanOrEqualTo(QuestTarget.questPassThreshold), reason: 'Shifted & scaled trace must pass for $char (got $shiftedScore)');

        // 3. Kanvas kosong -> gagal (0.0)
        final emptyScore = await StrokeSimilarityEvaluator.evaluateWithFontMask(
          strokes: const [],
          targetAksara: char,
        );
        expect(emptyScore, equals(0.0));
      }

      // 4. Coretan acak pada Ha -> gagal (< 0.70)
      final randomScribble = [
        [
          const Offset(5, 5),
          const Offset(95, 95),
          const Offset(95, 5),
          const Offset(5, 95),
          const Offset(50, 5),
          const Offset(50, 95),
          const Offset(5, 50),
          const Offset(95, 50),
        ],
      ];
      final scribbleScore = await StrokeSimilarityEvaluator.evaluateWithFontMask(
        strokes: randomScribble,
        targetAksara: 'ꦲ',
      );
      expect(scribbleScore, lessThan(QuestTarget.questPassThreshold), reason: 'Random scribble must fail (got $scribbleScore)');

      // 5. Goresan huruf lain (mis. Na digambar saat target Ha) -> gagal (< 0.70)
      final naMask = await StrokeSimilarityEvaluator.extractNormalizedFontMaskPoints('ꦤ');
      final naStrokes = _buildTraceStrokesFromMask(naMask);
      final naOnHaScore = await StrokeSimilarityEvaluator.evaluateWithFontMask(
        strokes: naStrokes,
        targetAksara: 'ꦲ',
      );
      expect(naOnHaScore, lessThan(QuestTarget.questPassThreshold), reason: 'Drawing Na on target Ha must fail (got $naOnHaScore)');
    });

    test('Quest XP mematuhi batas harian (daily practice cap) dan tidak menaikkan streak', () async {
      final now = DateTime(2026, 11, 11, 10, 0);
      final prefs = InMemoryProfilePreferences(
        initialTotalXP: 0,
        initialStreakDays: 0,
        isFreshUser: true,
      );
      final controller = ProfileController(
        preferences: prefs,
        nowProvider: () => now,
      );
      await controller.loadProfile();

      final daMask = await StrokeSimilarityEvaluator.extractNormalizedFontMaskPoints('ꦢ');
      final daStrokes = _buildTraceStrokesFromMask(daMask);
      final sim = await StrokeSimilarityEvaluator.evaluateWithFontMask(
        strokes: daStrokes,
        targetAksara: 'ꦢ',
      );
      expect(sim, greaterThanOrEqualTo(QuestTarget.questPassThreshold));

      final r1 = await controller.awardDrawingChallengeReward(
        activityId: 'drawing_ꦢ',
        claimId: 'claim_da_1',
        similarity: sim,
      );
      expect(r1.xpEarned, greaterThan(0));
      expect(controller.streakDays, equals(0), reason: 'Quest tidak boleh menaikkan streak');

      int replayTotal = 0;
      for (int i = 0; i < 20; i++) {
        final r = await controller.awardDrawingChallengeReward(
          activityId: 'drawing_ꦢ',
          claimId: 'claim_da_replay_$i',
          similarity: 0.95,
        );
        replayTotal += r.xpEarned;
      }
      expect(replayTotal, equals(60), reason: 'Replay quest harian dibatasi 60 XP/hari');
      expect(controller.streakDays, equals(0));
    });
  });
}

/// Membentuk stroke sambung lokal dari sampel titik topeng tanpa membuat garis silang acak.
List<List<Offset>> _buildTraceStrokesFromMask(List<Offset> maskPoints) {
  if (maskPoints.isEmpty) return const [];
  // Ambil setiap titik dengan jarak minimum 3 px untuk mewakili kerangka topeng tanpa beban berlebihan
  final remaining = <Offset>[];
  for (int i = 0; i < maskPoints.length; i += 2) {
    remaining.add(maskPoints[i]);
  }
  final strokes = <List<Offset>>[];
  var currentStroke = <Offset>[remaining.removeAt(0)];

  while (remaining.isNotEmpty) {
    final last = currentStroke.last;
    int bestIdx = 0;
    double bestDistSq = double.infinity;
    for (int i = 0; i < remaining.length; i++) {
      final dx = remaining[i].dx - last.dx;
      final dy = remaining[i].dy - last.dy;
      final dSq = dx * dx + dy * dy;
      if (dSq < bestDistSq) {
        bestDistSq = dSq;
        bestIdx = i;
      }
    }
    final next = remaining.removeAt(bestIdx);
    if (math.sqrt(bestDistSq) > 10.0) {
      if (currentStroke.length >= 2) strokes.add(currentStroke);
      currentStroke = [next];
    } else {
      currentStroke.add(next);
    }
  }
  if (currentStroke.length >= 2) strokes.add(currentStroke);
  return strokes;
}
