import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/core/progression/reward_summary.dart';
import 'package:flutter_jawaloka/features/profile/presentation/widgets/blangkon_painter.dart';

void main() {
  group('Profile Migration & Backward Compatibility Tests', () {
    test(
      'Legacy user with saved level 4 migrates to 650 XP and level 4',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialDisplayName: 'Budi',
          initialBlangkon: BlangkonType.surakarta,
          initialLegacyUserLevel: 4,
          initialTotalXP: null,
        );

        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.displayName, equals('Budi'));
        expect(controller.equippedBlangkon, equals(BlangkonType.surakarta));
        expect(controller.totalXP, equals(650));
        expect(controller.userLevel, equals(4));
        expect(controller.tier, equals(ProgressionTier.menengah));
      },
    );

    test(
      'Legacy user with saved level 7 migrates to 2150 XP and level 7',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialDisplayName: 'Siti',
          initialLegacyUserLevel: 7,
          initialTotalXP: null,
        );

        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.totalXP, equals(2150));
        expect(controller.userLevel, equals(7));
        expect(controller.tier, equals(ProgressionTier.mahir));
      },
    );

    test('Brand new user starts at 0 XP and Level 1 (Pemula)', () async {
      final prefs = InMemoryProfilePreferences(
        initialDisplayName: 'Dimas',
        isFreshUser: true,
      );

      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      expect(controller.totalXP, equals(0));
      expect(controller.userLevel, equals(1));
      expect(controller.tier, equals(ProgressionTier.pemula));
    });

    test(
      'Repeated loadProfile calls are idempotent and do not alter state',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialLegacyUserLevel: 4,
          initialTotalXP: null,
        );

        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();
        final firstXP = controller.totalXP;
        final firstLevel = controller.userLevel;

        await controller.loadProfile();
        expect(controller.totalXP, equals(firstXP));
        expect(controller.userLevel, equals(firstLevel));
      },
    );
  });

  group('ProfileController Reward & Anti-Farming Tests', () {
    test(
      'First clear quiz gives full XP and registers activity as cleared',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        final summary = await controller.awardQuizSessionReward(
          activityId: 'quiz_pemula_aksara_ha',
          claimId: 'session_1',
          correctAnswers: 10,
          isPerfect: true,
        );

        expect(summary.xpEarned, equals(125)); // 10*10 + 25
        expect(summary.isFirstClear, isTrue);
        expect(
          summary.leveledUp,
          isFalse,
        ); // Level 1 base is 0, level 2 needs 150
        expect(controller.totalXP, equals(125));
        expect(controller.isActivityCleared('quiz_pemula_aksara_ha'), isTrue);
      },
    );

    test(
      'Replay of same quiz gives practice XP (+2/correct, no perfect bonus)',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        // First clear
        await controller.awardQuizSessionReward(
          activityId: 'quiz_pemula_aksara_ha',
          claimId: 'session_1',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(controller.totalXP, equals(125));

        // Replay session
        final replaySummary = await controller.awardQuizSessionReward(
          activityId: 'quiz_pemula_aksara_ha',
          claimId: 'session_2',
          correctAnswers: 10,
          isPerfect: true,
        );

        expect(replaySummary.xpEarned, equals(20)); // 10 * 2, no perfect bonus
        expect(replaySummary.isFirstClear, isFalse);
        expect(controller.totalXP, equals(145));
      },
    );

    test(
      'Claiming with identical claimId is rejected idempotently (0 XP)',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        final first = await controller.awardQuizSessionReward(
          activityId: 'quiz_pemula_1',
          claimId: 'attempt_abc',
          correctAnswers: 5,
          isPerfect: false,
        );
        expect(first.xpEarned, equals(50));

        final second = await controller.awardQuizSessionReward(
          activityId: 'quiz_pemula_1',
          claimId: 'attempt_abc',
          correctAnswers: 5,
          isPerfect: false,
        );

        expect(second.xpEarned, equals(0));
        expect(controller.totalXP, equals(50)); // Unchanged
      },
    );

    test(
      'Daily practice replay cap enforces maximum 60 XP per calendar day',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        // Mark activity as already cleared
        await controller.awardQuizSessionReward(
          activityId: 'quiz_repeatable',
          claimId: 'first_clear',
          correctAnswers: 10,
          isPerfect: true,
        );
        final baseXP = controller.totalXP; // 125

        // Replay 1: 10 correct = 20 XP (Daily practice: 20 / 60)
        final r1 = await controller.awardQuizSessionReward(
          activityId: 'quiz_repeatable',
          claimId: 'replay_1',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(r1.xpEarned, equals(20));

        // Replay 2: 10 correct = 20 XP (Daily practice: 40 / 60)
        final r2 = await controller.awardQuizSessionReward(
          activityId: 'quiz_repeatable',
          claimId: 'replay_2',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(r2.xpEarned, equals(20));

        // Replay 3: 10 correct = 20 XP (Daily practice: 60 / 60)
        final r3 = await controller.awardQuizSessionReward(
          activityId: 'quiz_repeatable',
          claimId: 'replay_3',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(r3.xpEarned, equals(20));

        // Replay 4: Quota exhausted! Must award 0 XP
        final r4 = await controller.awardQuizSessionReward(
          activityId: 'quiz_repeatable',
          claimId: 'replay_4',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(r4.xpEarned, equals(0));
        expect(controller.totalXP, equals(baseXP + 60));
      },
    );

    test(
      'Drawing Challenge awards XP based on similarity thresholds',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        // < 70% yields 0 XP
        final failResult = await controller.awardDrawingChallengeReward(
          activityId: 'drawing_ha',
          claimId: 'attempt_fail',
          similarity: 0.65,
        );
        expect(failResult.xpEarned, equals(0));
        expect(controller.isActivityCleared('drawing_ha'), isFalse);

        // 70% – 84% yields +15 XP
        final fairResult = await controller.awardDrawingChallengeReward(
          activityId: 'drawing_ha',
          claimId: 'attempt_fair',
          similarity: 0.75,
        );
        expect(fairResult.xpEarned, equals(15));
        expect(controller.isActivityCleared('drawing_ha'), isTrue);

        // Subsequent attempt is replay: >= 85% yields +5 XP (replay)
        final replayResult = await controller.awardDrawingChallengeReward(
          activityId: 'drawing_ha',
          claimId: 'attempt_replay',
          similarity: 0.90,
        );
        expect(replayResult.xpEarned, equals(5));
        expect(replayResult.isFirstClear, isFalse);
      },
    );

    test(
      'One-time milestones (node, boss, chest) cannot be claimed twice',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        // Boss battle first clear: +150 XP
        final boss1 = await controller.awardOneTimeActivityReward(
          activityId: 'boss_yogyakarta',
          claimId: 'claim_boss_1',
          type: ActivityType.bossBattle,
        );
        expect(boss1.xpEarned, equals(150));
        expect(controller.isActivityCleared('boss_yogyakarta'), isTrue);

        // Boss battle attempt 2: 0 XP
        final boss2 = await controller.awardOneTimeActivityReward(
          activityId: 'boss_yogyakarta',
          claimId: 'claim_boss_2',
          type: ActivityType.bossBattle,
        );
        expect(boss2.xpEarned, equals(0));
      },
    );

    test(
      'Level up detection triggers correctly across XP thresholds',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();
        expect(controller.userLevel, equals(1));

        // Award 150 XP -> reaches Level 2
        final summary = await controller.awardReward(
          activityId: 'bonus_xp',
          claimId: 'bonus_1',
          rawXP: 150,
        );

        expect(summary.leveledUp, isTrue);
        expect(summary.previousLevel, equals(1));
        expect(summary.newLevel, equals(2));
        expect(controller.userLevel, equals(2));
      },
    );

    test(
      'Concurrent async awards are serialized without race conditions',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
        );
        await controller.loadProfile();

        // Fire 5 distinct first-clear claims simultaneously
        await Future.wait([
          controller.awardReward(activityId: 'act_1', claimId: 'c1', rawXP: 10),
          controller.awardReward(activityId: 'act_2', claimId: 'c2', rawXP: 20),
          controller.awardReward(activityId: 'act_3', claimId: 'c3', rawXP: 30),
          controller.awardReward(activityId: 'act_4', claimId: 'c4', rawXP: 40),
          controller.awardReward(activityId: 'act_5', claimId: 'c5', rawXP: 50),
        ]);

        expect(controller.totalXP, equals(150));
        expect(controller.userLevel, equals(2));
      },
    );

    test(
      'Daily Practice Replay Cap resets on date rollover via clock injection',
      () async {
        DateTime simulatedTime = DateTime(2026, 11, 7, 10, 0, 0);

        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(initialTotalXP: 0),
          nowProvider: () => simulatedTime,
        );
        await controller.loadProfile();

        // 1. Clear activity first
        await controller.awardQuizSessionReward(
          activityId: 'quiz_daily_repeatable',
          claimId: 'day1_clear',
          correctAnswers: 10,
          isPerfect: true,
        );
        final baseXP = controller.totalXP; // 125 XP

        // 2. Consume full 60 XP replay cap on Day 1 (3 x 20 XP)
        for (int i = 1; i <= 3; i++) {
          final res = await controller.awardQuizSessionReward(
            activityId: 'quiz_daily_repeatable',
            claimId: 'day1_replay_$i',
            correctAnswers: 10,
            isPerfect: false,
          );
          expect(res.xpEarned, equals(20));
        }
        expect(controller.totalXP, equals(baseXP + 60));

        // 3. 4th replay on same day is capped at 0 XP
        final cappedSameDay = await controller.awardQuizSessionReward(
          activityId: 'quiz_daily_repeatable',
          claimId: 'day1_replay_4',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(cappedSameDay.xpEarned, equals(0));
        expect(controller.totalXP, equals(baseXP + 60));

        // 4. Advance clock by 1 day (rollover to 2026-11-08)
        simulatedTime = simulatedTime.add(const Duration(days: 1));

        // 5. Replay on Day 2: Quota resets to 0! Replay awards 20 XP
        final day2Replay = await controller.awardQuizSessionReward(
          activityId: 'quiz_daily_repeatable',
          claimId: 'day2_replay_1',
          correctAnswers: 10,
          isPerfect:
              true, // Should still be treated as replay, no perfect bonus
        );
        expect(
          day2Replay.xpEarned,
          equals(20),
        ); // Replay: 10 * 2 = 20, no bonus
        expect(day2Replay.isFirstClear, isFalse); // Remained cleared!
        expect(controller.totalXP, equals(baseXP + 60 + 20));
      },
    );

    test(
      'Persistence restart: reloading profile from same storage restores complete progression state',
      () async {
        // Shared in-memory storage simulating disk persistence across app restarts
        final sharedStorage = InMemoryProfilePreferences(initialTotalXP: 0);

        final controller1 = ProfileController(preferences: sharedStorage);
        await controller1.loadProfile();

        // Award first clear reward
        await controller1.awardQuizSessionReward(
          activityId: 'quiz_persisted_node',
          claimId: 'session_persisted_1',
          correctAnswers: 10,
          isPerfect: true,
        );
        // Award replay practice reward
        await controller1.awardQuizSessionReward(
          activityId: 'quiz_persisted_node',
          claimId: 'session_persisted_2',
          correctAnswers: 5,
          isPerfect: false,
        );
        // Wait for asynchronous persistence queue to settle
        await controller1.persistenceDone;

        final savedXP = controller1.totalXP;
        final savedLevel = controller1.userLevel;
        expect(savedXP, equals(125 + 10)); // 135 XP

        // Simulate app termination and new app launch: create new ProfileController
        // Note: This tests the reload lifecycle from the storage layer (in-memory mock / prefs),
        // not OS kill signals or hardware durability.
        final controller2 = ProfileController(preferences: sharedStorage);
        await controller2.loadProfile();

        // Verify state is completely restored
        expect(controller2.totalXP, equals(savedXP));
        expect(controller2.userLevel, equals(savedLevel));
        expect(controller2.isActivityCleared('quiz_persisted_node'), isTrue);

        // Attempting to reuse an old claim ID on the new instance must be rejected
        final doubleClaim = await controller2.awardQuizSessionReward(
          activityId: 'quiz_persisted_node',
          claimId: 'session_persisted_1',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(doubleClaim.xpEarned, equals(0));
        expect(controller2.totalXP, equals(savedXP));
      },
    );

    test(
      'Persistence queue error recovery: failures do not permanently stall subsequent saves',
      () async {
        final faultyStorage = _FaultyProfilePreferences();
        Object? reportedError;

        final controller = ProfileController(
          preferences: faultyStorage,
          onPersistenceError: (err, _) => reportedError = err,
        );
        await controller.loadProfile();

        // 1. Enable fault injection: next save throws
        faultyStorage.shouldThrowOnSave = true;

        await controller.awardReward(
          activityId: 'fail_act',
          claimId: 'fail_c1',
          rawXP: 50,
        );
        await controller.persistenceDone;

        // Error was recorded and reported, not swallowed silently
        expect(controller.lastPersistenceError, isNotNull);
        expect(reportedError, isNotNull);

        // 2. Disable fault injection: storage recovers
        faultyStorage.shouldThrowOnSave = false;

        // 3. Award second reward: queue MUST still process this operation!
        await controller.awardReward(
          activityId: 'recover_act',
          claimId: 'recover_c2',
          rawXP: 50,
        );
        await controller.persistenceDone;

        // Verify queue recovered and successfully persisted final total XP (100)
        expect(controller.lastPersistenceError, isNull);
        expect(faultyStorage.savedTotalXP, equals(100));
      },
    );
  });
  group('Profile Gender & Age Configuration Tests', () {
    test('User gender and age default correctly and can be updated', () async {
      final prefs = InMemoryProfilePreferences();
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      expect(controller.gender, equals(UserGender.male));
      expect(controller.age, equals(17));

      await controller.setGender(UserGender.female);
      expect(controller.gender, equals(UserGender.female));
      expect(await prefs.loadGender(), equals(UserGender.female));

      await controller.setAge(21);
      expect(controller.age, equals(21));
      expect(await prefs.loadAge(), equals(21));
    });
  });
}

class _FaultyProfilePreferences extends InMemoryProfilePreferences {
  bool shouldThrowOnSave = false;
  int? savedTotalXP;

  _FaultyProfilePreferences() : super(initialTotalXP: 0);

  @override
  Future<void> saveTotalXP(int xp) async {
    if (shouldThrowOnSave) {
      throw Exception('Simulated disk I/O failure');
    }
    savedTotalXP = xp;
    await super.saveTotalXP(xp);
  }
}
