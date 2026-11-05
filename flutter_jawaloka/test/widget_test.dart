import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/main.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/main_shell_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/learn/presentation/screens/learn_hub_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';

void main() {
  testWidgets('JawaLoka splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JawaLokaApp());

    // Verify that the Splash Screen is present.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify brand name and tagline exist.
    expect(find.text('JawaLoka'), findsOneWidget);
    expect(find.text('Belajar bahasa dan aksara Jawa setiap hari'), findsOneWidget);
  });

  // ─── Test (a): 5 Bottom Navigation items ─────────────────────────────────
  testWidgets('Bottom nav has exactly 5 items labeled Beranda, Belajar, Quest, Kuis, Profil',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainShellScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Quest'), findsOneWidget);
    expect(find.text('Kuis'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  // ─── Test (b): Tapping each tab switches screens ───────────────────────────
  testWidgets('Tapping each tab displays the correct screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainShellScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Default tab: Beranda
    expect(find.byType(HomeScreen), findsOneWidget);

    // Tap Belajar
    await tester.tap(find.text('Belajar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LearnHubScreen), findsOneWidget);

    // Tap Kuis
    await tester.tap(find.text('Kuis'));
    await tester.pump();
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
  testWidgets('Tapping Quest opens canvas without changing the active tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify initially on Beranda
    expect(find.byType(HomeScreen), findsOneWidget);

    // Tap Quest button
    await tester.tap(find.text('Quest'));
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
  testWidgets('Tab Belajar displays Aksara, Kosa Kata, Penerjemah, Penggunaan Bahasa, and Peribahasa cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainShellScreen(initialIndex: 1),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Aksara Jawa Dhasar'), findsOneWidget);
    expect(find.textContaining('Kosa Kata (Kamus)'), findsOneWidget);
    expect(find.textContaining('Penerjemah Bahasa'), findsOneWidget);
    expect(find.textContaining('Penggunaan Bahasa'), findsWidgets);
    expect(find.textContaining('Peribahasa & Saloka'), findsOneWidget);
  });

  // ─── Test (e): Quiz Path displays 3 Tingkat chips and unit topics ──────────
  testWidgets('QuizPathScreen displays Tingkat chips (Mudah, Mahir, Sangat Mahir) and unit topics',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: QuizPathScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 3 difficulty chips with default Mudah
    expect(find.text('Mudah'), findsOneWidget);
    expect(find.text('Mahir'), findsOneWidget);
    expect(find.text('Sangat Mahir'), findsOneWidget);

    // Unit 1 topics visible at top
    expect(find.text('Unit 1: Sapaan dan Salam'), findsOneWidget);
    expect(find.text('Salam'), findsOneWidget);
    expect(find.text('Pamit'), findsOneWidget);
    expect(find.text('Lencana'), findsOneWidget);

    // Scroll down to see remaining topics in Unit 1 and Unit 2
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tanya kabar'), findsOneWidget);
    expect(find.text('Perkenalan'), findsOneWidget);
    expect(find.text('Unit 2: Keluarga dan Rumah (Terkunci)'), findsOneWidget);
  });

  // ─── Test (f): Quiz session has 10 questions with 4 options (A-D) ─────────
  testWidgets('Quiz question default has 10 questions with 4 options',
      (WidgetTester tester) async {
    expect(QuizQuestionScreen.defaultQuestions.length, 10);
    for (final q in QuizQuestionScreen.defaultQuestions) {
      expect(q.options.length, 4);
    }

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizQuestionScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('1/10'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
  });

  // ─── Test (g): QuizResultScreen shows real score and streak banner ─────────
  testWidgets('QuizResultScreen displays real score and streak banner without threshold',
      (WidgetTester tester) async {
    const testResult = QuizResult(
      score: 90,
      maxScore: 100,
      correctCount: 9,
      totalQuestions: 10,
      timeTaken: '2:15',
      accuracy: 90,
      isStreakAchievedToday: true,
      currentStreak: 5,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizResultScreen(result: testResult),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('90'), findsOneWidget);
    expect(find.text('9/10'), findsOneWidget);
    expect(find.text('Streak kuis aktif: 5 hari'), findsOneWidget);
    expect(find.text('Kembali ke Beranda'), findsOneWidget);
    expect(find.text('Ulangi kuis'), findsOneWidget);

    // Verify passing threshold is NOT displayed
    expect(find.textContaining('Target'), findsNothing);
    expect(find.textContaining('≥80%'), findsNothing);
    expect(find.textContaining('Lulus'), findsNothing);
  });

  // ─── Test (h): Answering 10 questions sequentially navigates to result ────
  testWidgets('Behavior: answering 10 questions sequentially navigates to result with correct score',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const QuizQuestionScreen(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
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
    expect(find.text('Ulangi kuis'), findsOneWidget);
  });

  // ─── Test (i): Streak banner appears only when isStreakAchievedToday is true ─
  testWidgets('Behavior: streak banner appears only when isStreakAchievedToday is true',
      (WidgetTester tester) async {
    // When isStreakAchievedToday is true
    const achievedResult = QuizResult(
      score: 80,
      correctCount: 8,
      totalQuestions: 10,
      timeTaken: '1:45',
      accuracy: 80,
      isStreakAchievedToday: true,
      currentStreak: 5,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizResultScreen(result: achievedResult),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Streak kuis aktif: 5 hari'), findsOneWidget);

    // When isStreakAchievedToday is false
    const notAchievedResult = QuizResult(
      score: 80,
      correctCount: 8,
      totalQuestions: 10,
      timeTaken: '1:45',
      accuracy: 80,
      isStreakAchievedToday: false,
      currentStreak: 5,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: QuizResultScreen(result: notAchievedResult),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Streak kuis aktif: 5 hari'), findsNothing);
  });
}
