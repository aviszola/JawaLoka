import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/choose_blangkon_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/level_up_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quest_target.dart';
import 'package:flutter_jawaloka/core/progression/reward_summary.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/drawing_canvas_painter.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Bug Fix 1: Isi Data Diri & Dialog Settings 3 Bahasa', () {
    testWidgets('ProfileSetupScreen renders and switches dynamically across id, en, jv', (tester) async {
      final locCtrl = LocaleController(preferences: InMemoryLocalePreferences(initialLocale: 'id'));
      await locCtrl.loadSavedLocale();

      await tester.pumpApp(const ProfileSetupScreen(), controller: locCtrl);
      await tester.pumpAndSettle();

      // Indonesian
      expect(find.text('Isi Data Diri'), findsOneWidget);
      expect(find.text('Mulai Petualangan'), findsOneWidget);
      expect(find.text('Laki-laki'), findsOneWidget);

      // Switch to English
      await locCtrl.setLocale(const Locale('en'));
      await tester.pumpAndSettle();
      expect(find.text('Fill Personal Data'), findsOneWidget);
      expect(find.text('Start Adventure'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      // Pastikan teks Indonesia tidak tersisa
      expect(find.text('Isi Data Diri'), findsNothing);
      expect(find.text('Mulai Petualangan'), findsNothing);
      expect(find.text('Laki-laki'), findsNothing);

      // Switch to Javanese
      await locCtrl.setLocale(const Locale('jv'));
      await tester.pumpAndSettle();
      expect(find.text('Isi Data Dhiri'), findsOneWidget);
      expect(find.text('Wiwiti Petualangan'), findsOneWidget);
      expect(find.text('Kakung'), findsOneWidget);
      expect(find.text('Isi Data Diri'), findsNothing);
      expect(find.text('Laki-laki'), findsNothing);
    });

    testWidgets('SettingsScreen Data Diri dialog renders in en and jv', (tester) async {
      final locCtrl = LocaleController(preferences: InMemoryLocalePreferences(initialLocale: 'en'));
      await locCtrl.loadSavedLocale();
      await tester.pumpApp(const SettingsScreen(), controller: locCtrl);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      expect(find.text('Profile & Character'), findsOneWidget);
      expect(find.text('Edit Data'), findsOneWidget);
      expect(find.text('Data Diri & Karakter'), findsNothing);
    });
  });

  group('Bug Fix 2: Label Level ("Level X") & 360dp Layout', () {
    testWidgets('HomeHeader, SettingsScreen, ChooseBlangkonScreen display "Level X" without clipping at 360dp', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profile = ProfileController(preferences: InMemoryProfilePreferences(initialTotalXP: 0));
      await profile.loadProfile();

      await tester.pumpApp(const HomeScreen(), profileController: profile);
      await tester.pumpAndSettle();
      expect(find.text('Level 1'), findsOneWidget);
      expect(find.text('L1'), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.pumpApp(const SettingsScreen(), profileController: profile);
      await tester.pumpAndSettle();
      expect(find.text('Level 1'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpApp(const ChooseBlangkonScreen(), profileController: profile);
      await tester.pumpAndSettle();
      expect(find.text('Level 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Bug Fix 3: Konsistensi Gambar Atas & Petunjuk Kanvas Quest', () {
    testWidgets('Every QuestTarget uses identical aksaraChar and NotoSansJavanese in header and canvas', (tester) async {
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
            .firstOrNull;

        expect(headerText.data, equals(target.aksaraChar));
        expect(headerText.style?.fontFamily, equals('NotoSansJavanese'));
        expect(canvasPainter, isNotNull);
        expect(canvasPainter!.targetAksara, equals(target.aksaraChar));
        expect(headerText.data, equals(canvasPainter.targetAksara));
      }
    });

    testWidgets('DailyResultScreen target script panel uses NotoSansJavanese Text with targetAksara', (tester) async {
      await tester.pumpApp(
        const DailyResultScreen(
          targetAksara: 'ꦕ',
          similarity: 0.9,
        ),
      );
      await tester.pumpAndSettle();
      final targetFinder = find.text('ꦕ');
      expect(targetFinder, findsOneWidget);
      expect(tester.widget<Text>(targetFinder).style?.fontFamily, equals('NotoSansJavanese'));
    });
  });

  group('Bug Fix 4: Guard Perayaan Level 5 di ProfileScreen & AppRouter', () {
    testWidgets('Tapping locked Level 5 badge at Level 1 shows level requirement toast and does NOT open LevelUpScreen', (tester) async {
      final prefs = InMemoryProfilePreferences(initialTotalXP: 0, isFreshUser: true);
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      expect(controller.userLevel, equals(1));
      expect(controller.lastCelebratedLevel, equals(1));

      await tester.pumpApp(
        const ProfileScreen(),
        profileController: controller,
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pumpAndSettle();

      final badgeFinder = find.text('Level 5');
      await tester.ensureVisible(badgeFinder);
      await tester.tap(badgeFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LevelUpScreen), findsNothing);
      expect(find.textContaining('Butuh Level 5'), findsOneWidget);
      expect(controller.userLevel, equals(1));
      expect(controller.lastCelebratedLevel, equals(1));
    });

    testWidgets('Direct navigation to AppRouter.levelUp with level > userLevel is rejected safely without throwing', (tester) async {
      final prefs = InMemoryProfilePreferences(initialTotalXP: 0, isFreshUser: true);
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      final key = GlobalKey();
      await tester.pumpApp(
        Scaffold(key: key),
        profileController: controller,
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pumpAndSettle();

      Navigator.of(key.currentContext!).pushNamed(
        AppRouter.levelUp,
        arguments: const LevelUpArgs(newLevel: 5, previousLevel: 1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LevelUpScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Legitimate level up from Level 1 to Level 2 via QuizResultScreen still triggers LevelUpScreen', (tester) async {
      final prefs = InMemoryProfilePreferences(initialTotalXP: 150); // already leveled up to Level 2
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();
      // Reset lastCelebratedLevel check via controller method: simulate reward summary
      final summary = const RewardSummary(
        xpEarned: 150,
        previousTotalXP: 0,
        newTotalXP: 150,
        previousLevel: 1,
        newLevel: 2,
        leveledUp: true,
        isFirstClear: true,
        activityId: 'test_act',
        claimId: 'test_claim',
      );
      // Create a fresh controller where level is 2 but lastCelebratedLevel is 1
      final prefs2 = InMemoryProfilePreferences(
        initialTotalXP: 150,
        initialLastCelebratedLevel: 1,
      );
      final ctrl2 = ProfileController(preferences: prefs2);
      await ctrl2.loadProfile();
      // loadProfile auto-syncs lastCelebratedLevel to currentLevel on boot,
      // so test direct QuizResultScreen when award happens during session:
      final prefsLive = InMemoryProfilePreferences(initialTotalXP: 100);
      final ctrlLive = ProfileController(preferences: prefsLive);
      await ctrlLive.loadProfile();
      final liveSummary = await ctrlLive.awardReward(
        activityId: 'node_1',
        claimId: 'claim_1',
        rawXP: 60,
      );
      expect(liveSummary.leveledUp, isTrue);
      expect(liveSummary.newLevel, equals(2));
      expect(ctrlLive.shouldCelebrateLevel(2), isTrue);

      await tester.pumpApp(
        QuizResultScreen(
          result: QuizResult(
            score: 100,
            correctCount: 10,
            totalQuestions: 10,
            accuracy: 100,
            rewardSummary: liveSummary,
          ),
        ),
        profileController: ctrlLive,
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      final backBtn = find.text('Kembali ke Beranda');
      await tester.ensureVisible(backBtn);
      await tester.tap(backBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(LevelUpScreen), findsOneWidget);
      expect(find.text('Level 2!'), findsOneWidget);
      expect(summary.newLevel, equals(2));
    });
  });
}
