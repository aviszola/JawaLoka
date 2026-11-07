import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/profile/profile_scope.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_session.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/daily_result_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_header.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/javanese_avatar_widget.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Progression & Reward UI Integration Tests', () {
    testWidgets(
      'Quiz Question completion awards XP and displays it on QuizResultScreen',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences(initialTotalXP: 0);
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        expect(profileController.totalXP, equals(0));
        expect(profileController.userLevel, equals(1));

        final testQuestions = [
          const QuizQuestion(
            type: QuestionType.glyphIdentify,
            prompt: 'What glyph is this?',
            glyph: 'ꦲ',
            options: ['Ha', 'Na', 'Ca', 'Ra'],
            correctIndex: 0,
          ),
        ];

        final session = QuizSession(
          questions: testQuestions,
          moduleTitle: 'Test Aksara',
        );

        // User answers correctly
        session.answer(0);
        expect(session.isCorrect, isTrue);

        // Award reward
        final summary = await profileController.awardQuizSessionReward(
          activityId: session.activityId,
          claimId: session.sessionId,
          correctAnswers: session.correctCount,
          isPerfect: true,
        );

        expect(summary.xpEarned, equals(35)); // 10*1 + 25 perfect bonus
        expect(profileController.totalXP, equals(35));

        final result = session.toResult(rewardSummary: summary);

        await tester.pumpApp(
          ProfileScope(
            controller: profileController,
            child: QuizResultScreen(result: result),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Verify that XP Diperoleh is displayed
        expect(find.text('XP Diperoleh'), findsOneWidget);
        expect(find.text('+35 XP (Bonus Pertama)'), findsOneWidget);

        // Re-pumping screen does NOT increase XP (idempotency)
        await tester.pump();
        expect(profileController.totalXP, equals(35));
      },
    );

    testWidgets(
      'Replay quiz session awards practice XP and displays practice label',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences(initialTotalXP: 0);
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        // First clear
        await profileController.awardQuizSessionReward(
          activityId: 'quiz_test_aksara',
          claimId: 'session_clear_1',
          correctAnswers: 1,
          isPerfect: true,
        );
        expect(profileController.totalXP, equals(35));

        // Replay attempt
        final replaySummary = await profileController.awardQuizSessionReward(
          activityId: 'quiz_test_aksara',
          claimId: 'session_replay_2',
          correctAnswers: 1,
          isPerfect: true,
        );

        expect(
          replaySummary.xpEarned,
          equals(2),
        ); // Replay: 1*2 = 2 XP, no bonus
        expect(profileController.totalXP, equals(37));

        final session = QuizSession(
          questions: const [
            QuizQuestion(
              type: QuestionType.glyphIdentify,
              prompt: 'Test',
              glyph: 'ꦲ',
              options: ['Ha', 'Na'],
              correctIndex: 0,
            ),
          ],
          moduleTitle: 'Test Aksara',
        );

        final result = session.toResult(rewardSummary: replaySummary);

        await tester.pumpApp(
          ProfileScope(
            controller: profileController,
            child: QuizResultScreen(result: result),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('XP Diperoleh'), findsOneWidget);
        expect(find.text('+2 XP (Latihan)'), findsOneWidget);
      },
    );

    testWidgets(
      'DailyResultScreen displays earned XP and first-clear/practice pill',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences(initialTotalXP: 0);
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        // Award Drawing Challenge reward (similarity >= 0.85 -> +30 XP)
        final summary = await profileController.awardDrawingChallengeReward(
          activityId: 'drawing_ha',
          claimId: 'drawing_session_1',
          similarity: 0.90,
        );

        expect(summary.xpEarned, equals(30));
        expect(profileController.totalXP, equals(30));

        await tester.pumpApp(
          ProfileScope(
            controller: profileController,
            child: DailyResultScreen(
              similarity: 0.90,
              targetAksara: 'ꦲ',
              rewardSummary: summary,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('+30 XP (Misi Selesai)'), findsOneWidget);
      },
    );

    testWidgets(
      'HomeHeader updates level pill dynamically when ProfileController levels up',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences(initialTotalXP: 0);
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        expect(profileController.userLevel, equals(1));

        await tester.pumpApp(
          ProfileScope(
            controller: profileController,
            child: const HomeHeader(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Initially Level 1 ("L1" in HomeHeader)
        expect(find.text('L1'), findsOneWidget);

        // Award 150 XP -> User levels up to Level 2
        await profileController.awardReward(
          activityId: 'level_jump',
          claimId: 'claim_jump',
          rawXP: 150,
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // HomeHeader automatically updates to L2
        expect(find.text('L2'), findsOneWidget);
      },
    );

    testWidgets(
      'ProfileScreen displays single XP pill and dynamic avatar progress ring',
      (tester) async {
        final profilePrefs = InMemoryProfilePreferences(initialTotalXP: 0);
        final profileController = ProfileController(preferences: profilePrefs);
        await profileController.loadProfile();

        expect(profileController.totalXP, equals(0));
        expect(profileController.levelProgress, equals(0.0));

        await tester.pumpApp(
          ProfileScope(
            controller: profileController,
            child: const ProfileScreen(),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));

        // 1. Verify single XP pill is rendered (0 XP)
        expect(find.text('0 XP'), findsOneWidget);

        // 2. Verify avatar progress ring receives initial levelProgress (0.0)
        final avatarFinder = find.byType(JavaneseAvatarWidget);
        expect(avatarFinder, findsOneWidget);
        var avatarWidget = tester.widget<JavaneseAvatarWidget>(avatarFinder);
        expect(avatarWidget.progress, equals(0.0));

        // 3. Award 75 XP (Midpoint of Level 1 -> Level 2, 75/150 = 0.5)
        await profileController.awardReward(
          activityId: 'xp_progress_boost',
          claimId: 'claim_progress_1',
          rawXP: 75,
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // 4. Verify single XP pill updates to 75 XP (and old 0 XP is gone)
        expect(find.text('75 XP'), findsOneWidget);
        expect(find.text('0 XP'), findsNothing);

        // 5. Verify avatar progress ring dynamically updates to 0.5
        avatarWidget = tester.widget<JavaneseAvatarWidget>(avatarFinder);
        expect(avatarWidget.progress, equals(0.5));
      },
    );
  });
}
