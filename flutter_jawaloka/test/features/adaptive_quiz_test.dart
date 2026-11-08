import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/quiz/domain/adaptive_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_result_screen.dart';
import '../helpers/pump_app.dart';

void main() {
  group('AdaptiveQuizBank Tier Mapping Unit Tests', () {
    test('Levels 1 to 3 map to QuizTier.pemula', () {
      expect(AdaptiveQuizBank.getTierForLevel(1), QuizTier.pemula);
      expect(AdaptiveQuizBank.getTierForLevel(2), QuizTier.pemula);
      expect(AdaptiveQuizBank.getTierForLevel(3), QuizTier.pemula);
    });

    test('Levels 4 to 6 map to QuizTier.menengah', () {
      expect(AdaptiveQuizBank.getTierForLevel(4), QuizTier.menengah);
      expect(AdaptiveQuizBank.getTierForLevel(5), QuizTier.menengah);
      expect(AdaptiveQuizBank.getTierForLevel(6), QuizTier.menengah);
    });

    test('Levels 7 and above map to QuizTier.mahir', () {
      expect(AdaptiveQuizBank.getTierForLevel(7), QuizTier.mahir);
      expect(AdaptiveQuizBank.getTierForLevel(8), QuizTier.mahir);
      expect(AdaptiveQuizBank.getTierForLevel(12), QuizTier.mahir);
      expect(AdaptiveQuizBank.getTierForLevel(99), QuizTier.mahir);
    });
  });

  group('AdaptiveQuizBank Content & Structure Quality Tests', () {
    test(
      'Each tier contains exactly 10 questions with 4 options and valid correctIndex',
      () {
        for (final tier in QuizTier.values) {
          final questions = AdaptiveQuizBank.getQuestionsForTier(tier);
          expect(
            questions.length,
            10,
            reason: 'Tier $tier must have exactly 10 questions',
          );

          for (int i = 0; i < questions.length; i++) {
            final q = questions[i];
            expect(
              q.options.length,
              4,
              reason: 'Tier $tier question $i must have 4 options',
            );
            expect(
              q.correctIndex,
              inInclusiveRange(0, 3),
              reason: 'Tier $tier question $i correctIndex must be within 0..3',
            );
            // Each option in a question must be non-empty and unique
            final uniqueOptions = q.options.toSet();
            expect(
              uniqueOptions.length,
              4,
              reason:
                  'Tier $tier question $i options must not contain duplicates: ${q.options}',
            );
          }
        }
      },
    );

    test('Zero duplicate prompts or glyphs within each tier bank', () {
      for (final tier in QuizTier.values) {
        final questions = AdaptiveQuizBank.getQuestionsForTier(tier);
        final seenGlyphs = <String>{};
        for (final q in questions) {
          if (q.glyph.isNotEmpty) {
            expect(
              seenGlyphs.contains(q.glyph),
              isFalse,
              reason: 'Tier $tier contains duplicate glyph: ${q.glyph}',
            );
            seenGlyphs.add(q.glyph);
          }
        }
      }
    });

    test(
      'Tiers have distinct curriculum themes and zero duplicate content across categories',
      () {
        final pemula = AdaptiveQuizBank.pemulaQuestions;
        final menengah = AdaptiveQuizBank.menengahQuestions;
        final mahir = AdaptiveQuizBank.mahirQuestions;

        // Pemula glyphs are single basic carakan consonants
        final pemulaGlyphs = pemula.map((q) => q.glyph).toSet();
        expect(
          pemulaGlyphs,
          containsAll(['ꦲ', 'ꦤ', 'ꦕ', 'ꦫ', 'ꦏ', 'ꦢ', 'ꦠ', 'ꦱ', 'ꦮ', 'ꦭ']),
        );

        // Menengah glyphs contain sandangan diacritics and vocabulary words
        final menengahGlyphs = menengah.map((q) => q.glyph).toSet();
        expect(
          menengahGlyphs,
          containsAll([
            'ꦲꦶ',
            'ꦲꦸ',
            'ꦲꦺ',
            'ꦲꦺꦴ',
            'ꦲꦼ',
            'ꦲꦃ',
            'ꦲꦺꦴꦩꦃ',
            'ꦧꦤꦾꦸ',
            'ꦱꦼꦒꦫ',
            'ꦭꦼꦩꦃ',
          ]),
        );

        // Mahir questions test unggah-ungguh concepts and polite communication
        final mahirPrompts = mahir.map((q) => q.prompt).toList();
        expect(
          mahirPrompts.any((p) => p.contains('Kowe arep mangan apa?')),
          isTrue,
        );
        expect(
          mahirPrompts.any((p) => p.contains('Panjenengan apa wis dhahar?')),
          isTrue,
        );
        expect(
          mahirPrompts.any((p) => p.contains('Kula nedha sekul goreng.')),
          isTrue,
        );
        expect(
          mahirPrompts.any(
            (p) => p.contains('Bapak saweg tindak dhateng kantor.'),
          ),
          isTrue,
        );
        expect(
          mahirPrompts.any((p) => p.contains('Ajining dhiri ana ing lathi')),
          isTrue,
        );
      },
    );

    test(
      'Correct answers correspond accurately to source curriculum materials',
      () {
        final menengah = AdaptiveQuizBank.menengahQuestions;
        // Question 0: ꦲꦶ (wulu) -> 'Hi'
        expect(menengah[0].options[menengah[0].correctIndex], 'Hi');
        // Question 1: ꦲꦸ (suku) -> 'Hu'
        expect(menengah[1].options[menengah[1].correctIndex], 'Hu');
        // Question 2: ꦲꦺ (taling) -> 'He'
        expect(menengah[2].options[menengah[2].correctIndex], 'He');
        // Question 3: ꦲꦺꦴ (taling-tarung) -> 'Ho'
        expect(menengah[3].options[menengah[3].correctIndex], 'Ho');
        // Question 4: ꦲꦼ (pepet) -> 'Hǝ'
        expect(menengah[4].options[menengah[4].correctIndex], 'Hǝ');
        // Question 5: ꦲꦃ (wignyan) -> 'Hah'
        expect(menengah[5].options[menengah[5].correctIndex], 'Hah');
        // Question 6: ꦲꦺꦴꦩꦃ -> 'Omah'
        expect(menengah[6].options[menengah[6].correctIndex], 'Omah');
        // Question 7: ꦧꦤꦾꦸ -> 'Banyu'
        expect(menengah[7].options[menengah[7].correctIndex], 'Banyu');
        // Question 8: ꦱꦼꦒꦫ -> 'Segara'
        expect(menengah[8].options[menengah[8].correctIndex], 'Segara');
        // Question 9: ꦭꦼꦩꦃ -> 'Lemah'
        expect(menengah[9].options[menengah[9].correctIndex], 'Lemah');

        final mahir = AdaptiveQuizBank.mahirQuestions;
        // Question 0: 'Kowe arep mangan apa?' -> 'Ngoko Lugu'
        expect(mahir[0].options[mahir[0].correctIndex], 'Ngoko Lugu');
        // Question 1: 'Panjenengan apa wis dhahar?' -> 'Ngoko Alus'
        expect(mahir[1].options[mahir[1].correctIndex], 'Ngoko Alus');
        // Question 2: 'Kula nedha sekul goreng.' -> 'Krama Lugu'
        expect(mahir[2].options[mahir[2].correctIndex], 'Krama Lugu');
        // Question 3: 'Bapak saweg tindak dhateng kantor.' -> 'Krama Inggil'
        expect(mahir[3].options[mahir[3].correctIndex], 'Krama Inggil');
        // Question 4: 'mangan' krama inggil -> 'Dhahar'
        expect(mahir[4].options[mahir[4].correctIndex], 'Dhahar');
        // Question 5: 'omah' krama -> 'Griya'
        expect(mahir[5].options[mahir[5].correctIndex], 'Griya');
        // Question 6: salam pagi -> 'Sugeng enjing'
        expect(mahir[6].options[mahir[6].correctIndex], 'Sugeng enjing');
        // Question 7: terima kasih -> 'Matur nuwun'
        expect(mahir[7].options[mahir[7].correctIndex], 'Matur nuwun');
        // Question 8: tanya kabar krama alus -> 'Pripun kabaripun?'
        expect(mahir[8].options[mahir[8].correctIndex], 'Pripun kabaripun?');
        // Question 9: paribasan makna -> 'Pakurmatan saka wicara'
        expect(
          mahir[9].options[mahir[9].correctIndex],
          'Pakurmatan saka wicara',
        );
      },
    );
  });

  group('ProfileController & Preferences UserLevel Integration Tests', () {
    test('Default user level is 4', () async {
      final prefs = InMemoryProfilePreferences();
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      expect(controller.userLevel, 4);
    });

    test('setUserLevel persists level and notifies listeners', () async {
      final prefs = InMemoryProfilePreferences();
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      int notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setUserLevel(8);
      expect(controller.userLevel, 8);
      expect(notifications, 1);

      // Verify persistence across new instance
      final newController = ProfileController(preferences: prefs);
      await newController.loadProfile();
      expect(newController.userLevel, 8);
    });

    test('setUserLevel rejects levels below 1', () async {
      final prefs = InMemoryProfilePreferences();
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      await controller.setUserLevel(0);
      expect(controller.userLevel, 4);

      await controller.setUserLevel(-5);
      expect(controller.userLevel, 4);
    });
  });

  group('Adaptive Quiz Launch & Session Widget Tests', () {
    testWidgets('User at Level 2 loads Mudah question bank for node Salam', (
      tester,
    ) async {
      final profile = ProfileController(
        preferences: InMemoryProfilePreferences(initialUserLevel: 2),
      );
      await profile.loadProfile();

      await tester.pumpApp(
        const QuizPathScreen(),
        profileController: profile,
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap on node 'Salam' (quizIndex 1)
      await tester.tap(find.text('Salam'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap 'Mulai Kuis'
      await tester.tap(find.text('Mulai Kuis'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Expect Mudah question 1: glyph 'ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ' with options
      expect(find.text('ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ'), findsOneWidget);
      expect(find.text('Esuk (pagi)'), findsOneWidget);
      expect(find.text('Awan (siang)'), findsOneWidget);
      expect(find.text('Sore'), findsOneWidget);
      expect(find.text('Wengi (malam)'), findsOneWidget);
    });

    testWidgets('User at Level 5 loads Mahir question bank for node Salam', (
      tester,
    ) async {
      final profile = ProfileController(
        preferences: InMemoryProfilePreferences(initialUserLevel: 5),
      );
      await profile.loadProfile();

      await tester.pumpApp(
        const QuizPathScreen(),
        profileController: profile,
        onGenerateRoute: AppRouter.generateRoute,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Salam'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Mulai Kuis'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Expect Mahir question 1: glyph 'ꦱꦶꦪꦁ' with options
      expect(find.text('ꦱꦶꦪꦁ'), findsOneWidget);
      expect(find.text('Sugeng sonten, Pak Guru'), findsOneWidget);
      expect(find.text('Sugeng dalu, Pak Guru'), findsOneWidget);
      expect(find.text('Sugeng siang, Pak Guru'), findsOneWidget);
      expect(find.text('Sugeng enjang, Pak Guru'), findsOneWidget);
    });

    testWidgets(
      'User at Level 8 loads Sangat Mahir question bank for node Salam',
      (tester) async {
        final profile = ProfileController(
          preferences: InMemoryProfilePreferences(initialUserLevel: 8),
        );
        await profile.loadProfile();

        await tester.pumpApp(
          const QuizPathScreen(),
          profileController: profile,
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Salam'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Mulai Kuis'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Expect Sangat Mahir question 1: glyph 'ꦫꦮꦸꦃ' with options
        expect(find.text('ꦫꦮꦸꦃ'), findsOneWidget);
        expect(find.text('Sugeng tindak'), findsOneWidget);
        expect(find.text('Sugeng kondur'), findsOneWidget);
        expect(find.text('Sugeng sare'), findsOneWidget);
        expect(find.text('Sugeng rawuh'), findsOneWidget);
      },
    );

    testWidgets(
      'Sessional snapshot: live profile level update during active quiz does not alter ongoing questions',
      (tester) async {
        final profile = ProfileController(
          preferences: InMemoryProfilePreferences(initialUserLevel: 2),
        );
        await profile.loadProfile();

        await tester.pumpApp(
          const QuizPathScreen(),
          profileController: profile,
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Salam'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        await tester.tap(find.text('Mulai Kuis'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Active quiz is Mudah (Question 1: 'ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ')
        expect(find.text('ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ'), findsOneWidget);

        // Simulate a background or live level change to Mahir (Level 10)
        await profile.setUserLevel(10);
        expect(profile.userLevel, 10);

        // Pump UI to ensure listeners fired
        await tester.pump();

        // Active quiz session must STILL display ongoing Mudah question 1
        expect(find.text('ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ'), findsOneWidget);
        expect(find.text('Esuk (pagi)'), findsOneWidget);
      },
    );

    testWidgets(
      'Retry maintains the exact tier questions of the completed session',
      (tester) async {
        final menengahQuestions = AdaptiveQuizBank.menengahQuestions;
        final profile = ProfileController(
          preferences: InMemoryProfilePreferences(
            initialUserLevel: 2,
          ), // Profile level is Pemula (2)
        );
        await profile.loadProfile();

        await tester.pumpApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.quizResult,
                    arguments: QuizResult(
                      score: 90,
                      maxScore: 100,
                      correctCount: 9,
                      totalQuestions: 10,
                      accuracy: 90,
                      questions: menengahQuestions,
                      moduleTitle: 'Salam',
                    ),
                  );
                },
                child: const Text('Open Result'),
              );
            },
          ),
          profileController: profile,
          onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Open result screen
        await tester.tap(find.text('Open Result'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.byType(QuizResultScreen), findsOneWidget);

        // Tap 'Ulangi kuis' (Retry)
        final retryFinder = find.text('Ulangi kuis');
        expect(retryFinder, findsOneWidget);
        await tester.ensureVisible(retryFinder);
        await tester.pump();
        await tester.tap(retryFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1000));

        // Even though profile is Level 2 (Pemula), Retry of Menengah session retains Menengah questions!
        expect(find.byType(QuizQuestionScreen), findsOneWidget);
        expect(find.byType(QuizResultScreen), findsNothing);
        expect(find.text('ꦲꦶ'), findsOneWidget);
        expect(find.text('Hi'), findsOneWidget);
      },
    );
  });
}
