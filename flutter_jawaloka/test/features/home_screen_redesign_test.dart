import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_header.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_hero_quest_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_continue_quiz_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_weekly_quiz_strip.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_cultural_wisdom_card.dart';
import 'package:flutter_jawaloka/features/home/presentation/widgets/home_quick_learn_section.dart';
import 'package:flutter_jawaloka/core/profile/profile_scope.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import '../helpers/pump_app.dart';

void main() {
  group('HomeScreen Redesign (iPhone 16 Reference Visuals)', () {
    testWidgets('HomeScreen renders all 5 main sections cleanly', (
      tester,
    ) async {
      final prefs = InMemoryProfilePreferences(
        initialDisplayName: 'Dimas',
        initialTotalXP: 650,
        initialStreakDays: 5,
        initialQuizzesThisWeek: 4,
      );
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      await tester.pumpApp(
        ProfileScope(controller: controller, child: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      // 1. Verify Header
      expect(find.byType(HomeHeader), findsOneWidget);
      expect(find.text('Halo, Dimas!'), findsOneWidget);
      expect(find.text('Level 4'), findsOneWidget);
      // 2. Verify Hero Quest Card
      expect(find.byType(HomeHeroQuestCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(HomeHeroQuestCard),
          matching: find.text('Aksara Jawa'),
        ),
        findsOneWidget,
      );
      expect(find.text('3 dari 5 aksara selesai'), findsOneWidget);

      // 3. Verify Continue Quiz Card
      expect(find.byType(HomeContinueQuizCard), findsOneWidget);

      // 4. Verify Weekly Strip
      expect(find.byType(HomeWeeklyQuizStrip), findsOneWidget);

      // 5. Verify Cultural Wisdom Card
      expect(find.byType(HomeCulturalWisdomCard), findsOneWidget);

      // 6. Verify Quick Learn Section
      expect(find.byType(HomeQuickLearnSection), findsOneWidget);
    });

    testWidgets('Tapping ContinueQuizCard opens the active node bottom sheet', (
      tester,
    ) async {
      final prefs = InMemoryProfilePreferences();
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      await tester.pumpApp(
        ProfileScope(controller: controller, child: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      final continueCard = find.byType(HomeContinueQuizCard);
      expect(continueCard, findsOneWidget);
      await tester.tap(continueCard);
      await tester.pumpAndSettle();

      // Bottom sheet is displayed with "Mulai Kuis"
      expect(find.text('Mulai Kuis'), findsOneWidget);
    });
    testWidgets(
      'HomeScreen has no layout overflows at 360dp width and textScale 1.3',
      (tester) async {
        tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: ProfileScope(
              controller: controller,
              child: const HomeScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
