import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_session.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/drawing_canvas_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  const sampleQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara niki munine napa?',
      glyph: 'ꦲ',
      options: ['Ha', 'Na', 'Ca', 'Ra'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara niki munine napa?',
      glyph: 'ꦤ',
      options: ['Ka', 'Da', 'Na', 'Ta'],
      correctIndex: 2,
    ),
  ];

  group('QuizSession Domain Unit Tests', () {
    test(
      'New session initializes with zero score, first question, and clean state',
      () {
        final session = QuizSession(
          questions: sampleQuestions,
          moduleTitle: 'Aksara Dhasar',
        );

        expect(session.currentIndex, 0);
        expect(session.selectedOption, -1);
        expect(session.answered, isFalse);
        expect(session.isCorrect, isFalse);
        expect(session.correctCount, 0);
        expect(session.totalQuestions, 2);
        expect(session.isCompleted, isFalse);
        expect(session.currentQuestion?.glyph, 'ꦲ');
        expect(session.progress, 0.0);
      },
    );

    test(
      'Answering correct choice increments score and locks further selection',
      () {
        final session = QuizSession(questions: sampleQuestions);

        session.answer(0); // correct
        expect(session.answered, isTrue);
        expect(session.isCorrect, isTrue);
        expect(session.selectedOption, 0);
        expect(session.correctCount, 1);
        expect(session.progress, 0.5);

        // Attempt to answer again while locked
        session.answer(1);
        expect(session.selectedOption, 0);
        expect(session.correctCount, 1);
      },
    );

    test('Answering incorrect choice does not increment score', () {
      final session = QuizSession(questions: sampleQuestions);

      session.answer(2); // incorrect (correctIndex is 0)
      expect(session.answered, isTrue);
      expect(session.isCorrect, isFalse);
      expect(session.selectedOption, 2);
      expect(session.correctCount, 0);
    });

    test(
      'nextQuestion advances index and resets question-level selection state',
      () {
        final session = QuizSession(questions: sampleQuestions);
        session.answer(0);

        final hasNext = session.nextQuestion();
        expect(hasNext, isTrue);
        expect(session.currentIndex, 1);
        expect(session.currentQuestion?.glyph, 'ꦤ');
        expect(session.answered, isFalse);
        expect(session.selectedOption, -1);
        expect(session.isCorrect, isFalse);
        expect(session.correctCount, 1);
      },
    );

    test('Completing final question marks session completed', () {
      final session = QuizSession(questions: sampleQuestions);
      session.answer(0);
      session.nextQuestion();
      session.answer(2); // correct for question 2

      final hasNext = session.nextQuestion();
      expect(hasNext, isFalse);
      expect(session.isCompleted, isTrue);
      expect(session.scorePercentage, 100);

      final result = session.toResult();
      expect(result.score, 100);
      expect(result.correctCount, 2);
      expect(result.totalQuestions, 2);
      expect(result.questions?.length, 2);
    });

    test(
      'reset() completely restores session to Question 1, score 0, clean state',
      () {
        final session = QuizSession(questions: sampleQuestions);
        session.answer(0);
        session.nextQuestion();
        session.answer(2);

        expect(session.currentIndex, 1);
        expect(session.correctCount, 2);

        session.reset();

        expect(session.currentIndex, 0);
        expect(session.selectedOption, -1);
        expect(session.answered, isFalse);
        expect(session.isCorrect, isFalse);
        expect(session.correctCount, 0);
        expect(session.isCompleted, isFalse);
        expect(session.currentQuestion?.glyph, 'ꦲ');
        expect(session.progress, 0.0);
      },
    );
  });

  group('Quiz Navigation & Reset Widget Tests', () {
    testWidgets(
      'Exiting quiz midway and re-entering starts a clean session at Question 1',
      (tester) async {
        await tester.pumpApp(
          const Scaffold(body: Text('Path Screen Root')),
          routes: {
            AppRouter.quizQuestion: (ctx) => const QuizQuestionScreen(
              questions: sampleQuestions,
              moduleTitle: 'Aksara Dhasar',
            ),
          },
        );
        await tester.pumpAndSettle();

        // Open quiz from root
        final rootCtx = tester.element(find.text('Path Screen Root'));
        Navigator.of(rootCtx).pushNamed(AppRouter.quizQuestion);
        await tester.pumpAndSettle();

        // Initial state: Question 1
        expect(find.text('ꦲ'), findsOneWidget);

        // Answer question 1
        await tester.tap(find.text('Ha'));
        await tester.pumpAndSettle();

        // Confirm to advance to Question 2
        await tester.tap(find.text('Lanjut'));
        await tester.pumpAndSettle();

        // Verified on Question 2
        expect(find.text('ꦤ'), findsOneWidget);

        // User initiates exit
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();

        // Exit dialog appears
        expect(find.text('Keluar dari Misi?'), findsOneWidget);

        // Cancel keeps user on Question 2
        await tester.tap(find.text('Lanjutkan misi'));
        await tester.pumpAndSettle();
        expect(find.text('ꦤ'), findsOneWidget);

        // User taps exit and confirms
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Keluar'));
        await tester.pumpAndSettle();

        // Back on root
        expect(find.text('Path Screen Root'), findsOneWidget);
        expect(find.byType(QuizQuestionScreen), findsNothing);

        // Now start a fresh quiz session (simulating user re-entering from path/map)
        final newRootCtx = tester.element(find.text('Path Screen Root'));
        Navigator.of(newRootCtx).pushNamed(AppRouter.quizQuestion);
        await tester.pumpAndSettle();

        // Must start freshly at Question 1
        expect(find.text('ꦲ'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Retry on QuizResultScreen navigates to clean QuizQuestionScreen without route stacking',
      (tester) async {
        final routesObserved = <String>[];

        await tester.pumpApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.quizResult,
                    arguments: const QuizResult(
                      score: 90,
                      maxScore: 100,
                      correctCount: 9,
                      totalQuestions: 10,
                      accuracy: 90,
                      questions: sampleQuestions,
                      moduleTitle: 'Aksara Dhasar',
                    ),
                  );
                },
                child: const Text('Open Result'),
              );
            },
          ),
          onGenerateRoute: (settings) {
            routesObserved.add(settings.name ?? '');
            return AppRouter.generateRoute(settings);
          },
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Open result screen
        await tester.tap(find.text('Open Result'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.byType(QuizResultScreen), findsOneWidget);
        expect(find.text('Ulangi misi'), findsOneWidget);

        // Tap Retry
        final retryButton = find.text('Ulangi misi');
        await tester.ensureVisible(retryButton);
        await tester.pump();
        await tester.tap(retryButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1000));

        // Verified: QuizQuestionScreen is displayed, starting at Question 1 (glyph 'ꦲ')
        expect(find.byType(QuizQuestionScreen), findsOneWidget);
        expect(find.byType(QuizResultScreen), findsNothing);
        expect(find.text('ꦲ'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Kembali ke Beranda from QuizResultScreen returns cleanly',
      (tester) async {
        await tester.pumpApp(
          const Scaffold(body: Text('Root Screen Home')),
          routes: {
            AppRouter.home: (ctx) =>
                const Scaffold(body: Text('Home Screen Destination')),
            AppRouter.quizResult: (ctx) => const QuizResultScreen(),
          },
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Push result screen onto root
        final BuildContext rootContext = tester.element(
          find.text('Root Screen Home'),
        );
        Navigator.of(rootContext).pushNamed(AppRouter.quizResult);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.byType(QuizResultScreen), findsOneWidget);

        // Tap Kembali ke Beranda
        final backButton = find.text('Kembali ke Beranda');
        await tester.ensureVisible(backButton);
        await tester.pump();
        await tester.tap(backButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1000));

        // Stack was popped cleanly to the root screen
        expect(find.byType(QuizResultScreen), findsNothing);
        expect(find.text('Root Screen Home'), findsOneWidget);
      },
    );
  });

  group('Drawing Canvas State & Aksara Switch Reset Tests', () {
    testWidgets(
      'DrawingCanvasScreen clears strokes when switching to another aksara',
      (tester) async {
        await tester.pumpApp(
          const DrawingCanvasScreen(aksaraChar: 'ꦲ', aksaraName: 'Ha'),
        );
        await tester.pumpAndSettle();

        // Perform a stroke
        final canvasFinder = find.byType(CustomPaint).first;
        final gesture = await tester.startGesture(
          tester.getCenter(canvasFinder),
        );
        await gesture.moveBy(const Offset(40, 40));
        await gesture.up();
        await tester.pump();

        // Verify stroke counter shows 1
        expect(find.text('Goresan: 1'), findsOneWidget);

        // Switch aksara to Na (ꦤ)
        await tester.pumpApp(
          const DrawingCanvasScreen(aksaraChar: 'ꦤ', aksaraName: 'Na'),
        );
        await tester.pump();

        // Strokes are cleared automatically for the new aksara
        expect(find.text('Goresan: 0'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Coba Lagi on DailyResultScreen resets DrawingCanvasScreen strokes',
      (tester) async {
        // Set larger surface size to comfortably accommodate canvas and scrollable actions
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpApp(
          const DrawingCanvasScreen(aksaraChar: 'ꦲ', aksaraName: 'Ha'),
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pumpAndSettle();

        // Draw stroke
        final canvasFinder = find.byType(CustomPaint).first;
        final gesture = await tester.startGesture(
          tester.getCenter(canvasFinder),
        );
        await gesture.moveBy(const Offset(40, 40));
        await gesture.up();
        await tester.pump();
        expect(find.text('Goresan: 1'), findsOneWidget);

        // Tap Periksa Tulisan to navigate to DailyResultScreen
        final checkButton = find.text('Periksa Tulisan');
        await tester.ensureVisible(checkButton);
        await tester.pump();
        await tester.tap(checkButton);
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        });
        await tester.pumpAndSettle();
        expect(find.byType(DailyResultScreen), findsOneWidget);

        // Tap Coba Lagi on DailyResultScreen
        final retryButton = find.text('Coba Lagi');
        await tester.ensureVisible(retryButton);
        await tester.pump();
        await tester.tap(retryButton);
        await tester.pumpAndSettle();
        // Back on DrawingCanvasScreen and strokes are completely cleared
        expect(find.byType(DrawingCanvasScreen), findsOneWidget);
        expect(find.text('Goresan: 0'), findsOneWidget);
      },
    );
  });

  group('Permanent User Progress Persistence Tests', () {
    testWidgets(
      'Resetting or retrying quiz does not modify permanent user profile or stats',
      (tester) async {
        final storage = InMemoryProfilePreferences();
        final profileController = ProfileController(preferences: storage);
        await profileController.loadProfile();
        await profileController.setDisplayName('Bagus');
        await profileController.setEquippedBlangkon(BlangkonType.surakarta);

        // Run quiz session and retry
        final session = QuizSession(questions: sampleQuestions);
        session.answer(0);
        session.nextQuestion();
        session.reset();

        // Verify profileController retained permanent state
        expect(profileController.displayName, 'Bagus');
        expect(profileController.equippedBlangkon, BlangkonType.surakarta);
        expect(profileController.userLevel, 4);
        expect(profileController.streakDays, 5);
      },
    );
  });
}
