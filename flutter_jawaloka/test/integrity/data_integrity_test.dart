import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/blangkon_rewards.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/data/translation_entries.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';
import 'package:flutter_jawaloka/features/quiz/domain/adaptive_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/curriculum_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';

void main() {
  group('Integrity Fence - Question Banks', () {
    test('Curriculum question bank has complete, valid, and unique questions', () {
      final questions = CurriculumQuizBank.allQuestions;
      expect(questions, isNotEmpty);

      final seenIds = <String>{};
      final optionDistribution = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};

      for (final q in questions) {
        // Unique ID
        expect(
          seenIds.contains(q.id),
          isFalse,
          reason: 'Duplicate question ID found: ${q.id}',
        );
        seenIds.add(q.id);

        // Non-empty prompt or promptKey
        expect(
          q.prompt.trim().isNotEmpty || (q.promptKey != null && q.promptKey!.isNotEmpty),
          isTrue,
          reason: 'Question ${q.id} has empty prompt and promptKey',
        );

        // Exactly 4 options
        expect(
          q.options.length,
          4,
          reason: 'Question ${q.id} must have exactly 4 options',
        );

        // Unique options within the question
        final uniqueOptions = q.options.map((o) => o.trim().toLowerCase()).toSet();
        expect(
          uniqueOptions.length,
          4,
          reason: 'Question ${q.id} has duplicate choices in options',
        );

        // Valid correctIndex
        expect(
          q.correctIndex >= 0 && q.correctIndex < 4,
          isTrue,
          reason: 'Question ${q.id} has invalid correctIndex: ${q.correctIndex}',
        );

        // Non-empty explanation
        expect(
          q.explanation.trim(),
          isNotEmpty,
          reason: 'Question ${q.id} has empty explanation',
        );

        optionDistribution[q.correctIndex] =
            (optionDistribution[q.correctIndex] ?? 0) + 1;
      }

      // Verify that all 4 choices are utilized across the curriculum
      for (int i = 0; i < 4; i++) {
        final count = optionDistribution[i] ?? 0;
        expect(
          count > 0,
          isTrue,
          reason: 'Option $i is never used as correct answer in curriculum',
        );
      }
    });

    test('Adaptive quiz bank and default questions conform to integrity rules', () {
      final banks = [
        AdaptiveQuizBank.pemulaQuestions,
        AdaptiveQuizBank.menengahQuestions,
        AdaptiveQuizBank.mahirQuestions,
        QuizQuestionScreen.defaultQuestions,
      ];

      for (final bank in banks) {
        expect(bank, isNotEmpty);
        final seenIds = <String>{};
        for (final q in bank) {
          if (q.id.isNotEmpty) {
            expect(seenIds.contains(q.id), isFalse);
            seenIds.add(q.id);
          }

          expect(
            q.prompt.trim().isNotEmpty || (q.promptKey != null && q.promptKey!.isNotEmpty),
            isTrue,
          );
          expect(q.options.length, 4);
          expect(q.options.toSet().length, 4);
          expect(q.correctIndex >= 0 && q.correctIndex < 4, isTrue);
        }
      }
    });
  });

  group('Integrity Fence - Translation Entries', () {
    test('All translation entries have non-empty variants and unique source entries', () {
      expect(kTranslationEntries, isNotEmpty);

      final seenIds = <String>{};
      final seenEns = <String>{};

      for (final entry in kTranslationEntries) {
        expect(entry.id.trim(), isNotEmpty);
        expect(entry.en.trim(), isNotEmpty);
        expect(entry.jvNgoko.trim(), isNotEmpty);
        expect(entry.jvKrama.trim(), isNotEmpty);

        final normId = entry.id.trim().toLowerCase();
        expect(
          seenIds.contains(normId),
          isFalse,
          reason: 'Duplicate Indonesian entry: ${entry.id}',
        );
        seenIds.add(normId);

        final normEn = entry.en.trim().toLowerCase();
        expect(
          seenEns.contains(normEn),
          isFalse,
          reason: 'Duplicate English entry: ${entry.en}',
        );
        seenEns.add(normEn);
      }
    });
  });

  group('Integrity Fence - Blangkon Progression Rules', () {
    test('All blangkon types are mapped, have real painters, and valid level order', () {
      for (final type in BlangkonType.values) {
        expect(
          BlangkonRewards.requiredLevels.containsKey(type),
          isTrue,
          reason: '$type is missing from requiredLevels mapping',
        );
        expect(
          BlangkonRewards.hasRealPainter(type),
          isTrue,
          reason: '$type must have hasRealPainter == true',
        );
      }

      // Yogyakarta is unlocked at level 1
      expect(BlangkonRewards.requiredLevels[BlangkonType.yogyakarta], 1);

      // Level requirements for level-gated blangkons must be non-decreasing
      final levelProgression = [
        BlangkonType.yogyakarta,
        BlangkonType.surakarta,
        BlangkonType.banyumas,
        BlangkonType.kedu,
        BlangkonType.cirebon,
      ];

      int prevLevel = 0;
      for (final type in levelProgression) {
        final reqLevel = BlangkonRewards.requiredLevels[type]!;
        expect(reqLevel >= prevLevel, isTrue);
        prevLevel = reqLevel;
      }
    });
  });

  group('Integrity Fence - Assets & Fonts', () {
    test('All required font files exist on disk in assets directory', () {
      final requiredFonts = [
        'assets/fonts/NotoSansJavanese-Regular.ttf',
        'assets/fonts/PlusJakartaSans-Medium.ttf',
        'assets/fonts/PlusJakartaSans-SemiBold.ttf',
        'assets/fonts/PlusJakartaSans-Bold.ttf',
      ];

      for (final fontPath in requiredFonts) {
        final file = File(fontPath);
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Font file missing at path: $fontPath',
        );
      }
    });
  });

  group('Integrity Fence - Router Routes', () {
    test('Every AppRouter constant is registered and produces a valid route', () {
      const allRoutes = [
        AppRouter.splash,
        AppRouter.languageSelection,
        AppRouter.register,
        AppRouter.login,
        AppRouter.home,
        AppRouter.learnHub,
        AppRouter.vocabularyDetail,
        AppRouter.aksaraDetail,
        AppRouter.translator,
        AppRouter.quizPath,
        AppRouter.quizQuestion,
        AppRouter.quizResult,
        AppRouter.drawingCanvas,
        AppRouter.dailyResult,
        AppRouter.chooseBlangkon,
        AppRouter.settings,
        AppRouter.profile,
        AppRouter.levelUp,
      ];

      for (final routeName in allRoutes) {
        final route = AppRouter.generateRoute(RouteSettings(name: routeName));
        expect(route, isNotNull, reason: 'Route $routeName returned null');
        expect(route, isA<PageRoute<dynamic>>());
      }
    });

    test('Unknown routes fallback to error page route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/unknown_nonexistent_route'),
      );
      expect(route, isNotNull);
      expect(route, isA<PageRoute<dynamic>>());
    });
  });
}
