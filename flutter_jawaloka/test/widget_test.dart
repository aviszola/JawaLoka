import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/main.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/get_started_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/main_shell_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/learn_hub_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'helpers/pump_app.dart';

void main() {
  testWidgets('JawaLoka app smoke test', (WidgetTester tester) async {
    final controller = LocaleController(
      preferences: InMemoryLocalePreferences(),
    );
    await controller.loadSavedLocale();
    await tester.pumpWidget(
      LocaleScope(
        controller: controller,
        child: const JawaLokaApp(initialRoute: AppRouter.getStarted),
      ),
    );

    // Verify that the GetStarted Screen is present.
    expect(find.byType(GetStartedScreen), findsOneWidget);
    expect(find.text('JawaLoka'), findsOneWidget);
  });

  // ─── Test (a): 5 Bottom Navigation items ─────────────────────────────────
  testWidgets(
    'Bottom nav has exactly 5 items labeled Beranda, Belajar, Latihan, Misi, Profil',
    (WidgetTester tester) async {
      await tester.pumpApp(const MainShellScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Belajar'), findsOneWidget);
      expect(find.text('Latihan'), findsOneWidget);
      expect(find.text('Misi'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    },
  );

  // ─── Test (b): Tapping each tab switches screens ───────────────────────────
  testWidgets('Tapping each tab displays the correct screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(const MainShellScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Default tab: Beranda
    expect(find.byType(HomeScreen), findsOneWidget);

    // Tap Belajar
    await tester.tap(find.text('Belajar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LearnHubScreen), findsOneWidget);

    // Tap Misi
    await tester.tap(find.text('Misi'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(QuizPathScreen), findsOneWidget);

    // Tap Profil
    await tester.tap(find.text('Profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ProfileScreen), findsOneWidget);

    // Tap Beranda
    await tester.tap(find.text('Beranda'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  // ─── Test (c): Quest button opens canvas without changing tab index ────────
  testWidgets('Tapping Quest opens canvas without changing the active tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(
      const SizedBox.shrink(),
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify initially on Beranda
    expect(find.byType(HomeScreen), findsOneWidget);

    // Tap Latihan (practice) button
    await tester.tap(find.text('Latihan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Opens DrawingCanvasScreen
    expect(find.byType(DrawingCanvasScreen), findsOneWidget);

    // Pop back from DrawingCanvasScreen
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify returned to Beranda and tab index remained 0
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  // ─── Test (d): Belajar tab contains required learning cards ────────────────
  testWidgets(
    'Tab Belajar displays Aksara, Kosa Kata, Penerjemah, Penggunaan Bahasa, and Peribahasa cards',
    (WidgetTester tester) async {
      await tester.pumpApp(const MainShellScreen(initialIndex: 1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Aksara Jawa Dhasar'), findsOneWidget);
      expect(find.textContaining('Kosa Kata (Kamus)'), findsOneWidget);
      expect(find.textContaining('Penerjemah Bahasa'), findsOneWidget);
      expect(find.textContaining('Penggunaan Bahasa'), findsWidgets);
      expect(find.textContaining('Peribahasa & Saloka'), findsOneWidget);
    },
  );

  // ─── Test (e): Quiz Path displays 3 Tingkat chips and unit topics ──────────
  testWidgets(
    'QuizPathScreen displays unit topics without difficulty chips',
    (WidgetTester tester) async {
      await tester.pumpApp(const QuizPathScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Difficulty chips removed (Butir 5)
      expect(find.byType(ChoiceChip), findsNothing);
      // Unit 1 topics visible at top
      expect(
        find.text('Unit 1: Sapaan dan Unggah-Ungguh Awal'),
        findsOneWidget,
      );
      expect(find.text('Salam'), findsOneWidget);
      expect(find.text('Pamit'), findsOneWidget);
      expect(find.text('Tanya kabar'), findsOneWidget);

      // Scroll down to see remaining topics in Unit 1 and Unit 2
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Perkenalan'), findsOneWidget);
      expect(find.text('Menyapa Orang Lain'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Unit 2: Aksara Jawa Dasar (Legena) (Terkunci)'),
        200,
      );
      expect(
        find.text('Unit 2: Aksara Jawa Dasar (Legena) (Terkunci)'),
        findsOneWidget,
      );
    },
  );

  // ─── Test (f): Quiz session has 10 questions with 4 options (A-D) ─────────
  testWidgets('Quiz question default has 10 questions with 4 options', (
    WidgetTester tester,
  ) async {
    expect(QuizQuestionScreen.defaultQuestions.length, 10);
    for (final q in QuizQuestionScreen.defaultQuestions) {
      expect(q.options.length, 4);
    }

    await tester.pumpApp(const QuizQuestionScreen());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('1/10'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  // ─── Test (g): QuizResultScreen shows real score and streak banner ─────────
  testWidgets(
    'QuizResultScreen displays real score and streak banner without threshold',
    (WidgetTester tester) async {
      const testResult = QuizResult(
        score: 90,
        maxScore: 100,
        correctCount: 9,
        totalQuestions: 10,
        accuracy: 90,
        isStreakAchievedToday: true,
        currentStreak: 5,
      );

      await tester.pumpApp(const QuizResultScreen(result: testResult));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('90'), findsOneWidget);
      expect(find.text('9/10'), findsOneWidget);
      expect(find.text('Streak misi aktif: 5 hari'), findsOneWidget);
      expect(find.text('Kembali ke Beranda'), findsOneWidget);
      expect(find.text('Ulangi misi'), findsOneWidget);

      // Verify passing threshold is NOT displayed
      expect(find.textContaining('Target'), findsNothing);
      expect(find.textContaining('≥80%'), findsNothing);
      expect(find.textContaining('Lulus'), findsNothing);
    },
  );

  // ─── Test (h): Answering 10 questions sequentially navigates to result ────
  testWidgets(
    'Behavior: answering 10 questions sequentially navigates to result with correct score',
    (WidgetTester tester) async {
      await tester.pumpApp(
        const QuizQuestionScreen(),
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Answer 10 questions sequentially
      for (int i = 0; i < 10; i++) {
        expect(find.text('${i + 1}/10'), findsOneWidget);

        // Tap option A
        await tester.tap(find.byKey(const Key('quiz_option_0')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Tap Lanjut (or Selesai on question 10)
        if (i < 9) {
          await tester.tap(find.text('Lanjut'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
        } else {
          await tester.tap(find.text('Selesai'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
        }
      }

      // Navigated to QuizResultScreen
      expect(find.byType(QuizResultScreen), findsOneWidget);
      expect(find.text('Kembali ke Beranda'), findsOneWidget);
      expect(find.text('Ulangi misi'), findsOneWidget);
    },
  );

  // ─── Test (i): Streak banner appears only when isStreakAchievedToday is true ─
  testWidgets(
    'Behavior: streak banner appears only when isStreakAchievedToday is true',
    (WidgetTester tester) async {
      // When isStreakAchievedToday is true
      const achievedResult = QuizResult(
        score: 80,
        correctCount: 8,
        totalQuestions: 10,
        accuracy: 80,
        isStreakAchievedToday: true,
        currentStreak: 5,
      );

      await tester.pumpApp(const QuizResultScreen(result: achievedResult));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Streak misi aktif: 5 hari'), findsOneWidget);

      // When isStreakAchievedToday is false
      const notAchievedResult = QuizResult(
        score: 80,
        correctCount: 8,
        totalQuestions: 10,
        accuracy: 80,
        isStreakAchievedToday: false,
        currentStreak: 5,
      );

      await tester.pumpApp(const QuizResultScreen(result: notAchievedResult));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Streak misi aktif: 5 hari'), findsNothing);
    },
  );
}
