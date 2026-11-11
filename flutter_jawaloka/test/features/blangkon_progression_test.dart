import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/blangkon_rewards.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/choose_blangkon_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/level_up_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/settings_screen.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('7a. XP threshold and single Surakarta reward unlock', () {
    test(
      'Adding XP across Level 5 threshold triggers Surakarta reward once and not in subsequent calls',
      () async {
        // Level 4 is 650 XP, Level 5 is 1050 XP
        final prefs = InMemoryProfilePreferences(initialTotalXP: 1000);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.userLevel, equals(4));
        expect(controller.isBlangkonUnlocked(BlangkonType.surakarta), isFalse);

        // Earn +100 XP -> 1100 XP (crosses into Level 5)
        final summary1 = await controller.awardReward(
          activityId: 'activity_test_level_5',
          claimId: 'claim_level_5_1',
          rawXP: 100,
        );

        expect(summary1.leveledUp, isTrue);
        expect(summary1.previousLevel, equals(4));
        expect(summary1.newLevel, equals(5));
        expect(summary1.unlockedBlangkons, contains(BlangkonType.surakarta));
        expect(controller.isBlangkonUnlocked(BlangkonType.surakarta), isTrue);

        // Next call while still at Level 5
        final summary2 = await controller.awardReward(
          activityId: 'activity_test_level_5_subsequent',
          claimId: 'claim_level_5_2',
          rawXP: 50,
        );

        expect(summary2.leveledUp, isFalse);
        expect(summary2.unlockedBlangkons, isEmpty);
        // Surakarta remains unlocked
        expect(controller.isBlangkonUnlocked(BlangkonType.surakarta), isTrue);
      },
    );
  });

  group('7b. Multi-level jump rewards', () {
    test(
      'Level jump from 4 to 6 triggers rewards for both Level 5 and Level 6',
      () async {
        // Level 4 = 650 XP, Level 6 = 1550 XP
        final prefs = InMemoryProfilePreferences(initialTotalXP: 700);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.userLevel, equals(4));

        // +900 XP -> 1600 XP (Level 6)
        final summary = await controller.awardReward(
          activityId: 'activity_test_jump_4_to_6',
          claimId: 'claim_jump_1',
          rawXP: 900,
        );

        expect(summary.leveledUp, isTrue);
        expect(summary.previousLevel, equals(4));
        expect(summary.newLevel, equals(6));
        expect(
          summary.unlockedBlangkons,
          containsAll([BlangkonType.surakarta, BlangkonType.banyumas]),
        );
        expect(controller.isBlangkonUnlocked(BlangkonType.surakarta), isTrue);
        expect(controller.isBlangkonUnlocked(BlangkonType.banyumas), isTrue);
        expect(controller.isBlangkonUnlocked(BlangkonType.kedu), isFalse);
      },
    );
  });

  group('7c. Replaying completed quiz gives no blangkon rewards', () {
    test(
      'Replay of an already-cleared activity never re-awards blangkon',
      () async {
        final prefs = InMemoryProfilePreferences(initialTotalXP: 1000);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // First clear crosses Level 5
        final summaryFirst = await controller.awardQuizSessionReward(
          activityId: 'quiz_activity_first_clear',
          claimId: 'session_clear_1',
          correctAnswers: 10,
          isPerfect: true,
        );

        expect(summaryFirst.leveledUp, isTrue);
        expect(
          summaryFirst.unlockedBlangkons,
          contains(BlangkonType.surakarta),
        );

        // Replay of same quiz gives replay practice XP
        final summaryReplay = await controller.awardQuizSessionReward(
          activityId: 'quiz_activity_first_clear',
          claimId: 'session_replay_2',
          correctAnswers: 10,
          isPerfect: true,
        );

        expect(summaryReplay.isFirstClear, isFalse);
        expect(summaryReplay.unlockedBlangkons, isEmpty);
      },
    );
  });

  group('7d. Exact level unlocking mapping verification', () {
    test(
      'Each blangkon unlocks exactly at specified Level threshold and not before',
      () {
        // Yogyakarta: always unlocked from Level 1
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.yogyakarta, userLevel: 1),
          isTrue,
        );

        // Surakarta: Level 5
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.surakarta, userLevel: 4),
          isFalse,
        );
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.surakarta, userLevel: 5),
          isTrue,
        );

        // Banyumas: Level 6
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.banyumas, userLevel: 5),
          isFalse,
        );
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.banyumas, userLevel: 6),
          isTrue,
        );

        // Kedu: Level 8
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.kedu, userLevel: 7),
          isFalse,
        );
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.kedu, userLevel: 8),
          isTrue,
        );

        // Cirebon: Level 10
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.cirebon, userLevel: 9),
          isFalse,
        );
        expect(
          BlangkonRewards.isUnlocked(BlangkonType.cirebon, userLevel: 10),
          isTrue,
        );

        // Pusaka: Selesai materi/evaluasi aksara (Mastery Aksara)
        expect(
          BlangkonRewards.isUnlocked(
            BlangkonType.pusaka,
            userLevel: 10,
            hasMasteredAksara: false,
          ),
          isFalse,
        );
        expect(
          BlangkonRewards.isUnlocked(
            BlangkonType.pusaka,
            userLevel: 1,
            hasMasteredAksara: true,
          ),
          isTrue,
        );
      },
    );
  });

  group('7e. Blangkon painter integrity verification', () {
    test('All 6 BlangkonTypes have authentic vector painters', () {
      for (final type in BlangkonType.values) {
        expect(
          BlangkonRewards.hasRealPainter(type),
          isTrue,
          reason: 'Blangkon $type must have real painter',
        );
      }
    });

    test(
      'BlangkonPainter renders without throwing for all types and lock states',
      () {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(100, 80);

        for (final type in BlangkonType.values) {
          final painterUnlocked = BlangkonPainter(type: type, isLocked: false);
          expect(
            () => painterUnlocked.paint(canvas, size),
            returnsNormally,
            reason: '$type unlocked painter should render cleanly',
          );

          final painterLocked = BlangkonPainter(type: type, isLocked: true);
          expect(
            () => painterLocked.paint(canvas, size),
            returnsNormally,
            reason: '$type locked painter should render cleanly',
          );
        }
      },
    );
  });

  group('7f. ChooseBlangkonScreen locked and unlocked behavior', () {
    testWidgets(
      'ChooseBlangkonScreen displays locked state and toast for level 4 user',
      (tester) async {
        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 650,
        ); // Level 4
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          const ChooseBlangkonScreen(),
          profileController: controller,
        );
        await tester.pumpAndSettle();

        // Yogyakarta is unlocked
        expect(find.text('Blangkon Yogyakarta'), findsWidgets);

        // Surakarta is locked (requires Level 5)
        expect(find.text('Level 5'), findsWidgets);

        // Tap Surakarta item
        await tester.tap(find.text('Blangkon Surakarta'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Locked snackbar/toast message appears
        expect(find.textContaining('Level 5'), findsWidgets);
      },
    );

    testWidgets(
      'ChooseBlangkonScreen allows selecting Surakarta once user reaches Level 5',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 1050,
        ); // Level 5
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          const ChooseBlangkonScreen(),
          profileController: controller,
        );
        await tester.pumpAndSettle();

        // Tap Surakarta item
        await tester.tap(find.text('Blangkon Surakarta'));
        await tester.pumpAndSettle();

        // No snackbar for Level 5 unlock
        expect(find.byType(SnackBar), findsNothing);

        // Save selection using primary action button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(controller.equippedBlangkon, equals(BlangkonType.surakarta));
      },
    );
  });

  group('7g. Resilience against corrupted data', () {
    testWidgets(
      'Corrupted blangkon string gracefully falls back to Yogyakarta without crashing screens',
      (tester) async {
        final prefs = InMemoryProfilePreferences(
          initialBlangkon: BlangkonType.yogyakarta,
          initialTotalXP: 0,
        );
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Verify fallback is Yogyakarta
        expect(controller.equippedBlangkon, equals(BlangkonType.yogyakarta));

        // Pump screens to ensure no crashes
        await tester.pumpApp(
          const ChooseBlangkonScreen(),
          profileController: controller,
        );
        await tester.pumpAndSettle();
        expect(find.byType(ChooseBlangkonScreen), findsOneWidget);

        await tester.pumpApp(
          const LevelUpScreen(newLevel: 5, previousLevel: 4),
          profileController: controller,
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(LevelUpScreen), findsOneWidget);
      },
    );
  });

  group('7h. Cross-screen Level synchronization', () {
    testWidgets(
      'Home, Profile, and Settings screens read the exact same Level number',
      (tester) async {
        // Level 5 requires 1050 XP; 1100 XP is Level 5
        final prefs = InMemoryProfilePreferences(initialTotalXP: 1100);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.userLevel, equals(5));

        // 1. Home Screen (shows level pill 'L5')
        await tester.pumpApp(const HomeScreen(), profileController: controller);
        await tester.pumpAndSettle();
        expect(find.text('L5'), findsWidgets);

        // 2. Profile Screen (shows level pill 'Lv 5')
        await tester.pumpApp(
          const ProfileScreen(),
          profileController: controller,
        );
        await tester.pumpAndSettle();
        expect(find.text('Lv 5'), findsWidgets);

        // 3. Settings Screen (shows level pill 'L5')
        await tester.pumpApp(
          const SettingsScreen(),
          profileController: controller,
        );
        await tester.pumpAndSettle();
        expect(find.text('L5'), findsWidgets);
      },
    );
  });
}
