import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_data.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_models.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Phase 2 — Node Unlock Progression & Sequential Flow', () {
    test(
      '1 & 2. New user starts fresh: Node 1 is current, remaining 49 are locked',
      () async {
        final prefs = InMemoryProfilePreferences(isFreshUser: true);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        expect(controller.totalXP, 0);
        expect(controller.userLevel, 1);
        expect(controller.clearedActivities, isEmpty);

        final units = QuizPathData.resolveCurriculum(
          clearedActivities: controller.clearedActivities,
          isEvaluationPassed: controller.isEvaluationPassed,
        );
        final allNodes = units.expand((u) => u.nodes).toList();

        expect(allNodes.length, 50);
        // Node 1 is current
        expect(allNodes[0].status, NodeStatus.current);
        expect(allNodes[0].id, 'path_node_u1_n01_salam');

        // Remaining 49 nodes are locked
        for (int i = 1; i < 50; i++) {
          expect(
            allNodes[i].status,
            NodeStatus.locked,
            reason:
                'Node ${i + 1} (${allNodes[i].id}) should be locked for new user',
          );
        }

        // Unit 1 unlocked, Units 2-5 locked
        expect(units[0].isLocked, isFalse);
        for (int u = 1; u < 5; u++) {
          expect(
            units[u].isLocked,
            isTrue,
            reason: 'Unit ${u + 1} should be locked',
          );
        }
      },
    );

    test(
      '3 & 4. Completing Node 1 unlocks Node 2 as current; unreached nodes remain locked',
      () async {
        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Clear Node 1
        await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'session_u1_n01_test',
          correctAnswers: 10,
          isPerfect: true,
        );
        await controller.persistenceDone;

        expect(controller.isActivityCleared('path_node_u1_n01_salam'), isTrue);

        final units = QuizPathData.resolveCurriculum(
          clearedActivities: controller.clearedActivities,
          isEvaluationPassed: controller.isEvaluationPassed,
        );
        final allNodes = units.expand((u) => u.nodes).toList();

        // Node 1 is now completed
        expect(allNodes[0].status, NodeStatus.completed);
        // Node 2 is now current
        expect(allNodes[1].status, NodeStatus.current);
        expect(allNodes[1].id, 'path_node_u1_n02_pamit');

        // Nodes 3-50 remain locked
        for (int i = 2; i < 50; i++) {
          expect(
            allNodes[i].status,
            NodeStatus.locked,
            reason: 'Node ${i + 1} should remain locked',
          );
        }

        // Exactly one current node in the entire curriculum
        final currentNodes = allNodes
            .where((n) => n.status == NodeStatus.current)
            .toList();
        expect(currentNodes.length, 1);
        expect(currentNodes.first.nodeNumber, 2);
      },
    );

    test(
      '15. All 50 nodes maintain sequential consistency throughout a learning journey',
      () async {
        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Progress through nodes 1 to 5
        for (int i = 1; i <= 5; i++) {
          final node = QuizPathData.getNodeByNumber(i)!;
          await controller.awardQuizSessionReward(
            activityId: node.id,
            claimId: 'claim_step_$i',
            correctAnswers: 9,
            isPerfect: false,
          );
        }
        await controller.persistenceDone;

        final units = QuizPathData.resolveCurriculum(
          clearedActivities: controller.clearedActivities,
          isEvaluationPassed: controller.isEvaluationPassed,
        );
        final allNodes = units.expand((u) => u.nodes).toList();

        // Nodes 1-5 completed
        for (int i = 0; i < 5; i++) {
          expect(allNodes[i].status, NodeStatus.completed);
        }
        // Node 6 is current
        expect(allNodes[5].status, NodeStatus.current);
        expect(allNodes[5].nodeNumber, 6);

        // Nodes 7-50 locked
        for (int i = 6; i < 50; i++) {
          expect(allNodes[i].status, NodeStatus.locked);
        }

        // Exactly one current node
        expect(allNodes.where((n) => n.status == NodeStatus.current).length, 1);
      },
    );
  });

  group('Phase 2 — Unit Evaluation Gate & 70% Threshold', () {
    test(
      '5. Unit 1 evaluation with score 69% (or 6/10) fails and keeps Unit 2 locked',
      () async {
        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Clear Nodes 1 through 9
        for (int i = 1; i <= 9; i++) {
          final node = QuizPathData.getNodeByNumber(i)!;
          await controller.awardQuizSessionReward(
            activityId: node.id,
            claimId: 'claim_node_$i',
            correctAnswers: 10,
            isPerfect: true,
          );
        }
        await controller.persistenceDone;

        final node10 = QuizPathData.getNodeByNumber(10)!;
        expect(node10.id, 'path_node_u1_n10_evaluasi_unit1');

        // Attempt evaluation with 69% (score below 70%)
        final result = await controller.awardQuizSessionReward(
          activityId: node10.id,
          claimId: 'attempt_eval_fail_1',
          correctAnswers: 6,
          isPerfect: false,
          scorePercentage: 69,
          isEvaluation: true,
        );
        await controller.persistenceDone;

        // Evaluation failed
        expect(result.xpEarned, 0);
        expect(result.isFirstClear, isFalse);
        expect(controller.isActivityCleared(node10.id), isFalse);
        expect(controller.isEvaluationPassed(node10.id), isFalse);
        expect(controller.getEvaluationScore(node10.id), 69);

        final units = QuizPathData.resolveCurriculum(
          clearedActivities: controller.clearedActivities,
          isEvaluationPassed: controller.isEvaluationPassed,
        );
        final allNodes = units.expand((u) => u.nodes).toList();

        // Node 10 remains current for retry
        expect(allNodes[9].status, NodeStatus.current);
        // Unit 2 remains locked
        expect(units[1].isLocked, isTrue);
        // Node 11 remains locked
        expect(allNodes[10].status, NodeStatus.locked);
      },
    );

    test(
      '6 & 7. Unit 1 evaluation with score 70% passes, awards XP, and unlocks Unit 2 (Node 11 current)',
      () async {
        final prefs = InMemoryProfilePreferences();
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Clear Nodes 1 through 9
        for (int i = 1; i <= 9; i++) {
          final node = QuizPathData.getNodeByNumber(i)!;
          await controller.awardQuizSessionReward(
            activityId: node.id,
            claimId: 'claim_node_$i',
            correctAnswers: 10,
            isPerfect: true,
          );
        }
        await controller.persistenceDone;

        final node10 = QuizPathData.getNodeByNumber(10)!;

        // Pass evaluation with 70%
        final result = await controller.awardQuizSessionReward(
          activityId: node10.id,
          claimId: 'attempt_eval_pass_1',
          correctAnswers: 7,
          isPerfect: false,
          scorePercentage: 70,
          isEvaluation: true,
        );
        await controller.persistenceDone;

        // Evaluation passed
        expect(result.xpEarned, 70); // 7 * 10 XP first clear
        expect(result.isFirstClear, isTrue);
        expect(controller.isActivityCleared(node10.id), isTrue);
        expect(controller.isEvaluationPassed(node10.id), isTrue);
        expect(controller.getEvaluationScore(node10.id), 70);

        final units = QuizPathData.resolveCurriculum(
          clearedActivities: controller.clearedActivities,
          isEvaluationPassed: controller.isEvaluationPassed,
        );
        final allNodes = units.expand((u) => u.nodes).toList();

        // Node 10 is completed
        expect(allNodes[9].status, NodeStatus.completed);
        // Unit 2 is unlocked!
        expect(units[1].isLocked, isFalse);
        // Node 11 is now current!
        expect(allNodes[10].status, NodeStatus.current);
        expect(allNodes[10].nodeNumber, 11);
        expect(allNodes[10].id, 'path_node_u2_n11_pengenalan_hanacaraka');

        // Unit 3 remains locked
        expect(units[2].isLocked, isTrue);
      },
    );
  });

  group('Phase 2 — Persistence Across Reload & Restart', () {
    test(
      '8. Progression state and evaluation pass survive loadProfile() reload',
      () async {
        final prefs = InMemoryProfilePreferences(isFreshUser: true);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        // Clear Node 1 & 2
        await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'session_c1',
          correctAnswers: 10,
          isPerfect: true,
        );
        await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n02_pamit',
          claimId: 'session_c2',
          correctAnswers: 8,
          isPerfect: false,
        );
        await controller.recordEvaluationScore(
          activityId: 'path_node_u1_n10_evaluasi_unit1',
          score: 85,
        );
        await controller.persistenceDone;

        final savedXP = controller.totalXP;
        final savedActivities = Set<String>.from(controller.clearedActivities);

        // Reload controller instance
        await controller.loadProfile();

        expect(controller.totalXP, savedXP);
        expect(controller.clearedActivities, savedActivities);
        expect(controller.isActivityCleared('path_node_u1_n01_salam'), isTrue);
        expect(controller.isActivityCleared('path_node_u1_n02_pamit'), isTrue);
        expect(
          controller.isEvaluationPassed('path_node_u1_n10_evaluasi_unit1'),
          isTrue,
        );
        expect(
          controller.getEvaluationScore('path_node_u1_n10_evaluasi_unit1'),
          85,
        );
      },
    );

    test(
      '9. Progression state survives simulated app restart with shared preferences storage',
      () async {
        // Simulate underlying storage shared across process lifetimes
        final storage = InMemoryProfilePreferences(isFreshUser: true);

        // App Session 1
        {
          final session1 = ProfileController(preferences: storage);
          await session1.loadProfile();

          await session1.awardQuizSessionReward(
            activityId: 'path_node_u1_n01_salam',
            claimId: 'sess1_n1',
            correctAnswers: 10,
            isPerfect: true,
          );
          await session1.recordEvaluationScore(
            activityId: 'path_node_u1_n10_evaluasi_unit1',
            score: 75,
          );
          await session1.persistenceDone;
        }

        // App Session 2 (fresh app launch pointing to same storage)
        {
          final session2 = ProfileController(preferences: storage);
          await session2.loadProfile();

          expect(session2.totalXP, 125); // 100 + 25 perfect bonus
          expect(session2.isActivityCleared('path_node_u1_n01_salam'), isTrue);
          expect(
            session2.isEvaluationPassed('path_node_u1_n10_evaluasi_unit1'),
            isTrue,
          );
          expect(
            session2.getEvaluationScore('path_node_u1_n10_evaluasi_unit1'),
            75,
          );

          final units = QuizPathData.resolveCurriculum(
            clearedActivities: session2.clearedActivities,
            isEvaluationPassed: session2.isEvaluationPassed,
          );
          // Node 1 completed
          expect(units[0].nodes[0].status, NodeStatus.completed);
          // Node 10 completed
          expect(units[0].nodes[9].status, NodeStatus.completed);
          // Unit 2 unlocked
          expect(units[1].isLocked, isFalse);
        }
      },
    );
  });

  group('Phase 2 — Reward Integrity & Anti-Exploit', () {
    test('10. First clear awards full XP once', () async {
      final controller = ProfileController(
        preferences: InMemoryProfilePreferences(isFreshUser: true),
      );
      await controller.loadProfile();

      final res = await controller.awardQuizSessionReward(
        activityId: 'path_node_u1_n01_salam',
        claimId: 'c_first_clear',
        correctAnswers: 10,
        isPerfect: true,
      );
      await controller.persistenceDone;

      expect(res.isFirstClear, isTrue);
      expect(res.xpEarned, 125); // 10*10 + 25 bonus
      expect(controller.totalXP, 125);
    });

    test(
      '11. Replay awards practice XP only, respecting daily practice cap (60 XP/day)',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(isFreshUser: true),
        );
        await controller.loadProfile();

        // First clear
        await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'c_fc',
          correctAnswers: 10,
          isPerfect: true,
        );

        // Replay 1: 10 correct = 20 practice XP (10 * 2)
        final replay1 = await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'c_rep_1',
          correctAnswers: 10,
          isPerfect: true, // perfect bonus ignored on replay
        );
        expect(replay1.isFirstClear, isFalse);
        expect(replay1.xpEarned, 20);

        // Replay 2: 10 correct = 20 practice XP (total 40 practice)
        final replay2 = await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'c_rep_2',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(replay2.xpEarned, 20);

        // Replay 3: 10 correct = 20 practice XP (total 60 practice - cap reached)
        final replay3 = await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'c_rep_3',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(replay3.xpEarned, 20);

        // Replay 4: cap is reached (0 XP awarded)
        final replay4 = await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'c_rep_4',
          correctAnswers: 10,
          isPerfect: false,
        );
        expect(replay4.xpEarned, 0);
        expect(replay4.message, contains('Daily practice replay cap reached'));
      },
    );

    test(
      '12. Changing difficulty mode preserves canonical activity ID and prevents duplicate first-clear reward',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(isFreshUser: true),
        );
        await controller.loadProfile();

        const canonicalId = 'path_node_u1_n01_salam';

        // Completed on Mudah
        final resMudah = await controller.awardQuizSessionReward(
          activityId: canonicalId,
          claimId: 'claim_mudah',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(resMudah.isFirstClear, isTrue);
        expect(resMudah.xpEarned, 125);

        // Same node replayed on Mahir (same canonical ID)
        final resMahir = await controller.awardQuizSessionReward(
          activityId: canonicalId,
          claimId: 'claim_mahir',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(resMahir.isFirstClear, isFalse);
        expect(resMahir.xpEarned, 20); // Practice XP only!
      },
    );

    test(
      '13. Milestone evaluation does not yield duplicate first-clear reward on replay',
      () async {
        final controller = ProfileController(
          preferences: InMemoryProfilePreferences(isFreshUser: true),
        );
        await controller.loadProfile();

        const evalId = 'path_node_u1_n10_evaluasi_unit1';

        // Pass 1st time
        final pass1 = await controller.awardQuizSessionReward(
          activityId: evalId,
          claimId: 'eval_attempt_1',
          correctAnswers: 10,
          isPerfect: true,
          scorePercentage: 100,
          isEvaluation: true,
        );
        expect(pass1.isFirstClear, isTrue);
        expect(pass1.xpEarned, 125);

        // Pass 2nd time (replay)
        final pass2 = await controller.awardQuizSessionReward(
          activityId: evalId,
          claimId: 'eval_attempt_2',
          correctAnswers: 10,
          isPerfect: true,
          scorePercentage: 100,
          isEvaluation: true,
        );
        expect(pass2.isFirstClear, isFalse);
        expect(pass2.xpEarned, 20); // Replay practice XP
      },
    );
  });

  group('Phase 2 — UI Reactivity & Screen Integration', () {
    testWidgets('14. ProfileScreen reflects updated XP and level reactively', (
      tester,
    ) async {
      final prefs = InMemoryProfilePreferences(isFreshUser: true);
      final controller = ProfileController(preferences: prefs);
      await controller.loadProfile();

      await tester.pumpApp(
        const ProfileScreen(),
        profileController: controller,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Initial state: Level 1, 0 XP
      expect(find.text('0 XP'), findsOneWidget);
      expect(find.text('Lv 1'), findsOneWidget);

      // Award XP to level up
      await controller.awardQuizSessionReward(
        activityId: 'path_node_u1_n01_salam',
        claimId: 'ui_xp_test',
        correctAnswers: 10,
        isPerfect: true,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('125 XP'), findsOneWidget);

      // Advance to Level 2 (requires 150 XP)
      await controller.awardQuizSessionReward(
        activityId: 'path_node_u1_n02_pamit',
        claimId: 'ui_xp_test_2',
        correctAnswers: 10,
        isPerfect: true,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('250 XP'), findsOneWidget);
      expect(find.text('Lv 2'), findsOneWidget);
    });

    testWidgets(
      'QuizPathScreen reacts dynamically to node completion and shows updated badge',
      (tester) async {
        final prefs = InMemoryProfilePreferences(isFreshUser: true);
        final controller = ProfileController(preferences: prefs);
        await controller.loadProfile();

        await tester.pumpApp(
          const QuizPathScreen(),
          profileController: controller,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Initially Unit 1 header shows 0/10 in viewport
        expect(find.text('0/10'), findsOneWidget);

        // Complete Node 1
        await controller.awardQuizSessionReward(
          activityId: 'path_node_u1_n01_salam',
          claimId: 'ui_node1_clear',
          correctAnswers: 10,
          isPerfect: true,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Unit 1 now displays 1/10 completed
        expect(find.text('1/10'), findsOneWidget);
      },
    );
  });
}
