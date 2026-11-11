import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_data.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_models.dart';

void main() {
  group('JAWALOKA Phase 3.1 Legacy Progress Migration Audit Suite', () {
    test(
      '1. Old Node 3 completion: maps semantically to Node 8 (ungkapan_sopan), not Node 3',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n02_pamit',
            'path_node_u1_n03_lencana',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Node 8 (ungkapan_sopan) must be recognized as cleared via alias
        expect(
          profile.isActivityCleared('path_node_u1_n08_ungkapan_sopan'),
          isTrue,
        );

        // Node 3 (tanya_kabar) must NOT be marked cleared because user only did subasita/trapsila
        expect(
          profile.isActivityCleared('path_node_u1_n03_tanya_kabar'),
          isFalse,
        );

        // Path layout: Node 3 should be current (uncompleted), Node 8 should be completed
        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
        );
        final unit1Nodes = resolved[0].nodes;
        expect(unit1Nodes[2].id, 'path_node_u1_n03_tanya_kabar');
        expect(unit1Nodes[2].status, NodeStatus.current);
        expect(unit1Nodes[7].id, 'path_node_u1_n08_ungkapan_sopan');
        expect(unit1Nodes[7].status, NodeStatus.completed);
      },
    );

    test(
      '2. Old Node 4 completion: maps semantically to new Node 3 (tanya_kabar)',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n02_pamit',
            'path_node_u1_n04_tanya_kabar',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // New Node 3 (tanya_kabar) is cleared because old Node 4 was tanya_kabar
        expect(
          profile.isActivityCleared('path_node_u1_n03_tanya_kabar'),
          isTrue,
        );
        // New Node 4 (perkenalan) is NOT cleared
        expect(
          profile.isActivityCleared('path_node_u1_n04_perkenalan'),
          isFalse,
        );

        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
        );
        final unit1Nodes = resolved[0].nodes;
        expect(unit1Nodes[2].status, NodeStatus.completed); // Node 3 completed
        expect(unit1Nodes[3].status, NodeStatus.current); // Node 4 current
      },
    );

    test(
      '3. Multiple completed old nodes: semantic progression without gap-skipping',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n02_pamit',
            'path_node_u1_n03_lencana', // maps to n08 ungkapan_sopan
            'path_node_u1_n04_tanya_kabar', // maps to n03 tanya_kabar
            'path_node_u1_n05_perkenalan', // maps to n04 perkenalan
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(profile.isActivityCleared('path_node_u1_n01_salam'), isTrue);
        expect(profile.isActivityCleared('path_node_u1_n02_pamit'), isTrue);
        expect(
          profile.isActivityCleared('path_node_u1_n03_tanya_kabar'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u1_n04_perkenalan'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u1_n05_sapa_wong'),
          isFalse,
        );
        expect(
          profile.isActivityCleared('path_node_u1_n08_ungkapan_sopan'),
          isTrue,
        );

        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
        );
        final unit1Nodes = resolved[0].nodes;
        // Node 5 should be the active (current) node
        expect(unit1Nodes[4].id, 'path_node_u1_n05_sapa_wong');
        expect(unit1Nodes[4].status, NodeStatus.current);
        // Node 6 and 7 remain locked
        expect(unit1Nodes[5].status, NodeStatus.locked);
        expect(unit1Nodes[6].status, NodeStatus.locked);
        // Node 8 is completed
        expect(unit1Nodes[7].status, NodeStatus.completed);
      },
    );

    test(
      '4. Existing evaluation scores: retrieved via canonical or legacy prefix',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'eval_score:path_node_u1_n10_evaluasi_unit1:85',
            'eval_passed:path_node_u1_n10_evaluasi_unit1',
            'path_node_u1_n10_evaluasi_unit1',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(
          profile.getEvaluationScore('path_node_u1_n10_evaluasi_unit1'),
          85,
        );
        expect(
          profile.isEvaluationPassed('path_node_u1_n10_evaluasi_unit1'),
          isTrue,
        );
      },
    );

    test(
      '5. Existing evaluation pass markers: fail score does not pass',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'eval_score:path_node_u2_n20_evaluasi_unit2:60',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(
          profile.getEvaluationScore('path_node_u2_n20_evaluasi_unit2'),
          60,
        );
        expect(
          profile.isEvaluationPassed('path_node_u2_n20_evaluasi_unit2'),
          isFalse,
        );
      },
    );

    test(
      '6. Repeated migration / loadProfile: idempotent with zero state mutation',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 350,
          initialUserLevel: 3,
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n03_lencana',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        final xpBefore = profile.totalXP;
        final levelBefore = profile.userLevel;
        final clearedBefore = Set<String>.from(profile.clearedActivities);

        // Call repeatedly
        await profile.loadProfile();
        await profile.loadProfile();

        expect(profile.totalXP, xpBefore);
        expect(profile.userLevel, levelBefore);
        expect(profile.clearedActivities, clearedBefore);
      },
    );

    test(
      '7. Fresh installation with no legacy data: starts at Node 1 current and 0 XP',
      () async {
        final prefs = InMemoryProfilePreferences(isFreshUser: true);
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(profile.totalXP, 0);
        expect(profile.userLevel, 1);
        expect(profile.clearedActivities, isEmpty);

        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
        );
        expect(resolved[0].nodes[0].status, NodeStatus.current);
        for (int i = 1; i < 50; i++) {
          final node = resolved[i ~/ 10].nodes[i % 10];
          expect(
            node.status,
            NodeStatus.locked,
            reason: 'Node ${i + 1} must be locked',
          );
        }
      },
    );

    test(
      '8. Gen 1 Unit 1 & Unit 4 legacy IDs correctly unlock canonical counterpart nodes',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u1_n06_terima_kasih',
            'path_node_u1_n07_minta_maaf',
            'path_node_u4_n31_kosakata_omah',
            'path_node_u4_n32_kosakata_kegiatan',
            'path_node_u4_n34_ngoko_lugu',
            'path_node_u4_n37_krama_inggil',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Unit 1 mappings
        expect(
          profile.isActivityCleared('path_node_u1_n06_matur_nuwun'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u1_n07_nyuwun_pangapunten'),
          isTrue,
        );

        // Unit 4 mappings
        expect(
          profile.isActivityCleared('path_node_u4_n32_nama_benda'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u4_n33_nama_kegiatan'),
          isTrue,
        );
        expect(profile.isActivityCleared('path_node_u4_n34_ngoko'), isTrue);
        expect(
          profile.isActivityCleared(
            'path_node_u4_n37_perbedaan_tingkatan_bahasa',
          ),
          isTrue,
        );

        // Calling with legacy ID also returns true
        expect(
          profile.isActivityCleared('path_node_u1_n06_terima_kasih'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u4_n31_kosakata_omah'),
          isTrue,
        );
      },
    );

    test(
      '9. Evaluation Scope Isolation: historical Unit 5 eval does not grant Final Exam pass',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u5_n41_paribasan_lathi',
            'path_node_u5_n42_filosofi_jawa',
            'path_node_u5_n43_tradisi_jawa',
            'path_node_u5_n44_seni_budaya',
            'path_node_u5_n45_kearifan_lokal',
            'path_node_u5_n46_unggah_ungguh',
            'path_node_u5_n47_tantangan_budaya',
            'path_node_u5_n48_tantangan_akhir',
            'path_node_u5_n49_evaluasi_unit5',
            'eval_passed:path_node_u5_n49_evaluasi_unit5',
            'eval_score:path_node_u5_n49_evaluasi_unit5:85',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Regular activity completion is safely preserved for Node 41..49
        expect(
          profile.isActivityCleared('path_node_u5_n41_tata_krama_jawa'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n44_filosofi_kehidupan'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n45_tradisi_jawa'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n46_budaya_kesenian'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n42_unggah_ungguh_basa'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n48_tantangan_budaya'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n49_tantangan_akhir'),
          isTrue,
        );

        // CRITICAL EVALUATION SCOPE ISOLATION:
        // Node 50 (Final Exam) MUST NOT be passed by historical Unit 5 evaluation
        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isFalse,
        );
        expect(
          profile.getEvaluationScore('path_node_u5_n50_evaluasi_akhir'),
          isNull,
        );

        // Historical Unit 5 evaluation identity and score remain intact under historical query
        expect(
          profile.isEvaluationPassed('path_node_u5_n49_evaluasi_unit5'),
          isTrue,
        );
        expect(
          profile.getEvaluationScore('path_node_u5_n49_evaluasi_unit5'),
          85,
        );

        // Path layout progression gate:
        // Node 49 is completed, and Node 50 is CURRENT (unlocked, ready to take, not completed)
        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );
        final unit5Nodes = resolved[4].nodes;
        expect(unit5Nodes[8].id, 'path_node_u5_n49_tantangan_akhir');
        expect(unit5Nodes[8].status, NodeStatus.completed);
        expect(unit5Nodes[9].id, 'path_node_u5_n50_evaluasi_akhir');
        expect(
          unit5Nodes[9].status,
          NodeStatus.locked,
          reason:
              'Final exam must remain uncompleted (locked because earlier units not completed)',
        );
        expect(unit5Nodes[9].status != NodeStatus.completed, isTrue);
      },
    );

    test(
      '10. QuizPathData.resolveCanonicalActivityId is idempotent and cycle-free',
      () {
        for (final entry in QuizPathData.legacyActivityAliases.entries) {
          final legacy = entry.key;
          final canonical = entry.value;

          // Legacy resolves to canonical
          expect(QuizPathData.resolveCanonicalActivityId(legacy), canonical);

          // Canonical resolves to itself
          expect(QuizPathData.resolveCanonicalActivityId(canonical), canonical);

          // Idempotency: f(f(x)) == f(x)
          expect(
            QuizPathData.resolveCanonicalActivityId(
              QuizPathData.resolveCanonicalActivityId(legacy),
            ),
            canonical,
          );

          // Verify target canonical node actually exists in 50 nodes
          expect(QuizPathData.getNodeById(canonical), isNotNull);
          // Verify getNodeById handles legacy lookup directly
          expect(QuizPathData.getNodeById(legacy), isNotNull);
        }
      },
    );

    test(
      '11. Genuine canonical Final Exam pass marks Node 50 completed and preserves score',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'eval_passed:path_node_u5_n50_evaluasi_akhir',
            'path_node_u5_n50_evaluasi_akhir',
            'eval_score:path_node_u5_n50_evaluasi_akhir:95',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isTrue,
        );
        expect(
          profile.getEvaluationScore('path_node_u5_n50_evaluasi_akhir'),
          95,
        );

        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );
        expect(resolved[4].nodes[9].status, NodeStatus.completed);
      },
    );

    test(
      '12. Replaying legacy activity under canonical ID enforces replay rules and daily cap',
      () async {
        // User previously cleared legacy Node 6 (terima_kasih)
        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 100,
          initialUserLevel: 1,
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n06_terima_kasih',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Node 6 is recognized as cleared
        expect(
          profile.isActivityCleared('path_node_u1_n06_matur_nuwun'),
          isTrue,
        );

        // Replaying under canonical ID 'path_node_u1_n06_matur_nuwun':
        // 10 correct answers, isPerfect true.
        // Must NOT receive first-clear reward (first-clear is 50+ XP).
        // Must receive replay practice reward (+2 per correct answer = 20 XP, no perfect bonus).
        final reward1 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u1_n06_matur_nuwun',
          claimId: 'session_claim_replay_1',
          correctAnswers: 10,
          isPerfect: true,
        );

        expect(
          reward1.isFirstClear,
          isFalse,
          reason: 'Must be classified as replay, not first-clear',
        );
        expect(reward1.xpEarned, 20);
        expect(profile.totalXP, 120);

        // Second replay in same day: awards 20 XP (total practice XP today: 40 / 60)
        final reward2 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u1_n06_matur_nuwun',
          claimId: 'session_claim_replay_2',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(reward2.isFirstClear, isFalse);
        expect(reward2.xpEarned, 20);
        expect(profile.totalXP, 140);

        // Third replay in same day: awards 20 XP (reaches daily cap: 60 / 60)
        final reward3 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u1_n06_matur_nuwun',
          claimId: 'session_claim_replay_3',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(reward3.xpEarned, 20);
        expect(profile.totalXP, 160);

        // Fourth replay in same day: daily practice cap (60 XP) exhausted!
        final reward4 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u1_n06_matur_nuwun',
          claimId: 'session_claim_replay_4',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(
          reward4.xpEarned,
          0,
          reason: 'Daily practice cap reached, must award 0 XP',
        );
        expect(profile.totalXP, 160);

        // Duplicate submission of same claimId: rejected idempotently
        final dupReward = await profile.awardQuizSessionReward(
          activityId: 'path_node_u1_n06_matur_nuwun',
          claimId: 'session_claim_replay_1',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(dupReward.xpEarned, 0);
        expect(profile.totalXP, 160);
      },
    );

    test(
      '13. Unit 1-4 evaluation migration remains intact and isolated',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'eval_passed:path_node_u1_n10_evaluasi_unit1',
            'eval_score:path_node_u1_n10_evaluasi_unit1:88',
            'eval_passed:path_node_u2_n20_evaluasi_unit2',
            'eval_score:path_node_u2_n20_evaluasi_unit2:72',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        expect(
          profile.isEvaluationPassed('path_node_u1_n10_evaluasi_unit1'),
          isTrue,
        );
        expect(
          profile.getEvaluationScore('path_node_u1_n10_evaluasi_unit1'),
          88,
        );
        expect(
          profile.isEvaluationPassed('path_node_u2_n20_evaluasi_unit2'),
          isTrue,
        );
        expect(
          profile.getEvaluationScore('path_node_u2_n20_evaluasi_unit2'),
          72,
        );

        // Unit 3 and 4 remain unpassed
        expect(
          profile.isEvaluationPassed('path_node_u3_n30_evaluasi_unit3'),
          isFalse,
        );
        expect(
          profile.getEvaluationScore('path_node_u3_n30_evaluasi_unit3'),
          isNull,
        );
      },
    );

    test(
      '14. Full path completion 1-49 unlocks Node 50 as current; genuine exam pass completes journey',
      () async {
        // Simulate user who completed all nodes 1 to 49, including historical Unit 5 eval
        final allNodes1to48 = QuizPathData.allNodes
            .take(48)
            .map((n) => n.id)
            .toSet();
        final evalPassed1to4 = {
          'eval_passed:path_node_u1_n10_evaluasi_unit1',
          'eval_passed:path_node_u2_n20_evaluasi_unit2',
          'eval_passed:path_node_u3_n30_evaluasi_unit3',
          'eval_passed:path_node_u4_n40_evaluasi_unit4',
        };

        final initialCleared = {
          ...allNodes1to48,
          ...evalPassed1to4,
          'path_node_u5_n49_evaluasi_unit5', // historical Node 49
          'eval_passed:path_node_u5_n49_evaluasi_unit5',
        };

        final profile = ProfileController(
          preferences: InMemoryProfilePreferences(
            initialClearedActivities: initialCleared,
          ),
        );
        await profile.loadProfile();

        // Historical Unit 5 eval record is preserved in storage
        expect(
          profile.isActivityCleared('path_node_u5_n49_evaluasi_unit5'),
          isTrue,
        );
        // But because it is CONDITIONAL, it does not grant canonical mastery to Node 49
        expect(
          profile.isCanonicalMastered('path_node_u5_n49_tantangan_akhir'),
          isFalse,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n49_tantangan_akhir'),
          isFalse,
        );
        // Final exam is NOT passed
        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isFalse,
        );

        // In curriculum layout, Node 49 is CURRENT (awaiting canonical mastery proof)
        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );
        expect(resolved[4].nodes[8].status, NodeStatus.current);
        expect(resolved[4].nodes[9].status, NodeStatus.locked);

        // User proves competence on Node 49 by completing it
        final reward49 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u5_n49_tantangan_akhir',
          claimId: 'claim_step_node49',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(
          reward49.isFirstClear,
          isFalse,
          reason: 'Historical completion prevents duplicate first-clear bonus',
        );
        expect(
          profile.isCanonicalMastered('path_node_u5_n49_tantangan_akhir'),
          isTrue,
        );

        // Now Node 49 is completed and Node 50 (Final Exam) unlocks as CURRENT
        final resolvedAfterNode49 = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );
        expect(resolvedAfterNode49[4].nodes[8].status, NodeStatus.completed);
        expect(resolvedAfterNode49[4].nodes[9].status, NodeStatus.current);

        // Now user takes the genuine Final Exam and passes with 80%
        await profile.recordEvaluationScore(
          activityId: 'path_node_u5_n50_evaluasi_akhir',
          score: 80,
        );

        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isTrue,
        );
        expect(
          profile.getEvaluationScore('path_node_u5_n50_evaluasi_akhir'),
          80,
        );

        // Now the journey is 100% completed
        final resolvedAfterPass = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );
        expect(resolvedAfterPass[4].nodes[9].status, NodeStatus.completed);
      },
    );
  });

  group('JAWALOKA Phase 3.2.4 — Final Legacy Migration Fix Suite', () {
    test(
      '1. Riwayat aktivitas lama tetap tersimpan di SharedPreferences',
      () async {
        final initialData = {
          'path_node_u4_n35_ngoko_alus',
          'path_node_u4_n36_krama_lugu',
          'path_node_u4_n38_bandhingan_tingkat_basa',
          'path_node_u5_n46_tembang_dolanan',
          'path_node_u5_n47_tembang_dolanan',
          'path_node_u5_n49_evaluasi_unit5',
          'eval_passed:path_node_u5_n49_evaluasi_unit5',
          'eval_score:path_node_u5_n49_evaluasi_unit5:85',
        };
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: initialData,
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        for (final key in initialData) {
          expect(
            profile.clearedActivities.contains(key),
            isTrue,
            reason: 'Historical key $key must remain in clearedActivities',
          );
        }

        // Querying historical IDs returns true
        expect(
          profile.isActivityCleared('path_node_u4_n35_ngoko_alus'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u4_n36_krama_lugu'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u4_n38_bandhingan_tingkat_basa'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n46_tembang_dolanan'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n47_tembang_dolanan'),
          isTrue,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n49_evaluasi_unit5'),
          isTrue,
        );
      },
    );

    test(
      '2. Alias UNSAFE dan CONDITIONAL tidak otomatis memberikan canonical mastery',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u4_n35_ngoko_alus',
            'path_node_u4_n36_krama_lugu',
            'path_node_u4_n38_bandhingan_tingkat_basa',
            'path_node_u5_n46_tembang_dolanan',
            'path_node_u5_n49_evaluasi_unit5',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // None of the canonical target nodes should have canonical mastery
        expect(profile.isCanonicalMastered('path_node_u4_n35_krama'), isFalse);
        expect(
          profile.isCanonicalMastered('path_node_u4_n36_krama_inggil'),
          isFalse,
        );
        expect(
          profile.isCanonicalMastered('path_node_u4_n38_percakapan_teman'),
          isFalse,
        );
        expect(
          profile.isCanonicalMastered('path_node_u5_n47_situasi_padinan'),
          isFalse,
        );
        expect(
          profile.isCanonicalMastered('path_node_u5_n49_tantangan_akhir'),
          isFalse,
        );

        expect(profile.isActivityCleared('path_node_u4_n35_krama'), isFalse);
        expect(
          profile.isActivityCleared('path_node_u4_n36_krama_inggil'),
          isFalse,
        );
        expect(
          profile.isActivityCleared('path_node_u4_n38_percakapan_teman'),
          isFalse,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n47_situasi_padinan'),
          isFalse,
        );
        expect(
          profile.isActivityCleared('path_node_u5_n49_tantangan_akhir'),
          isFalse,
        );
      },
    );

    test('3. Alias SAFE tetap memberikan completion credit otomatis', () async {
      final prefs = InMemoryProfilePreferences(
        initialClearedActivities: {
          'path_node_u1_n06_terima_kasih', // -> n06_matur_nuwun
          'path_node_u1_n07_minta_maaf', // -> n07_nyuwun_pangapunten
          'path_node_u4_n31_kosakata_omah', // -> n32_nama_benda
          'path_node_u4_n34_ngoko_alus', // -> n34_ngoko
          'path_node_u4_n35_krama_lugu', // -> n35_krama (safe)
          'path_node_u4_n38_wicara_marang_kanca', // -> n38_percakapan_teman (safe)
        },
      );
      final profile = ProfileController(preferences: prefs);
      await profile.loadProfile();

      expect(
        profile.isCanonicalMastered('path_node_u1_n06_matur_nuwun'),
        isTrue,
      );
      expect(
        profile.isCanonicalMastered('path_node_u1_n07_nyuwun_pangapunten'),
        isTrue,
      );
      expect(
        profile.isCanonicalMastered('path_node_u4_n32_nama_benda'),
        isTrue,
      );
      expect(profile.isCanonicalMastered('path_node_u4_n34_ngoko'), isTrue);
      expect(profile.isCanonicalMastered('path_node_u4_n35_krama'), isTrue);
      expect(
        profile.isCanonicalMastered('path_node_u4_n38_percakapan_teman'),
        isTrue,
      );

      expect(profile.isActivityCleared('path_node_u1_n06_matur_nuwun'), isTrue);
      expect(profile.isActivityCleared('path_node_u4_n35_krama'), isTrue);
    });

    test(
      '4. Pengguna lama tetap bisa melanjutkan progression tanpa terjebak gate',
      () async {
        // User who completed all of Unit 1-3, and in Unit 4 had completed nodes including legacy n35
        final nodes1to34 = QuizPathData.allNodes
            .take(34)
            .map((n) => n.id)
            .toSet();
        final evalPassed1to3 = {
          'eval_passed:path_node_u1_n10_evaluasi_unit1',
          'eval_passed:path_node_u2_n20_evaluasi_unit2',
          'eval_passed:path_node_u3_n30_evaluasi_unit3',
        };
        final initialCleared = {
          ...nodes1to34,
          ...evalPassed1to3,
          'path_node_u4_n35_ngoko_alus', // legacy UNSAFE
        };

        final profile = ProfileController(
          preferences: InMemoryProfilePreferences(
            initialClearedActivities: initialCleared,
          ),
        );
        await profile.loadProfile();

        final resolved = QuizPathData.resolveCurriculum(
          clearedActivities: profile.clearedActivities,
          isEvaluationPassed: profile.isEvaluationPassed,
        );

        // Node 35 is CURRENT (playable, not stuck behind locked gate)
        final node35 = resolved[3].nodes[4];
        expect(node35.id, 'path_node_u4_n35_krama');
        expect(node35.status, NodeStatus.current);

        // Exactly 1 current node on the path
        final currentNodes = resolved
            .expand((u) => u.nodes)
            .where((n) => n.status == NodeStatus.current)
            .toList();
        expect(currentNodes.length, 1);
      },
    );

    test(
      '5. Tidak ada first-clear XP ganda saat menyelesaikan ulang node historis',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 500,
          initialUserLevel: 3,
          initialClearedActivities: {
            'path_node_u4_n35_ngoko_alus', // UNSAFE legacy alias for Node 35
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Node 35 does NOT have canonical mastery
        expect(profile.isCanonicalMastered('path_node_u4_n35_krama'), isFalse);
        // But has historical completion
        expect(
          profile.hasHistoricalCompletion('path_node_u4_n35_krama'),
          isTrue,
        );

        // Playing canonical Node 35
        final reward = await profile.awardQuizSessionReward(
          activityId: 'path_node_u4_n35_krama',
          claimId: 'claim_u4_n35_proof',
          correctAnswers: 10,
          isPerfect: true,
        );

        // Must NOT be first-clear
        expect(reward.isFirstClear, isFalse);
        // Awards replay practice XP (20 XP)
        expect(reward.xpEarned, 20);
        expect(profile.totalXP, 520);

        // Now canonical mastery is registered in profile
        expect(profile.isCanonicalMastered('path_node_u4_n35_krama'), isTrue);
        expect(profile.isActivityCleared('path_node_u4_n35_krama'), isTrue);
      },
    );

    test(
      '6. Daily cap 60 XP ditegakkan ketat pada replay node historis',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialTotalXP: 100,
          initialUserLevel: 1,
          initialClearedActivities: {'path_node_u4_n35_ngoko_alus'},
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Attempt 1: +20 XP (total 20/60)
        final r1 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u4_n35_krama',
          claimId: 'c1',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(r1.xpEarned, 20);

        // Attempt 2: +20 XP (total 40/60)
        final r2 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u4_n35_krama',
          claimId: 'c2',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(r2.xpEarned, 20);

        // Attempt 3: +20 XP (total 60/60 - cap reached)
        final r3 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u4_n35_krama',
          claimId: 'c3',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(r3.xpEarned, 20);

        // Attempt 4: 0 XP (daily cap exhausted)
        final r4 = await profile.awardQuizSessionReward(
          activityId: 'path_node_u4_n35_krama',
          claimId: 'c4',
          correctAnswers: 10,
          isPerfect: true,
        );
        expect(r4.xpEarned, 0);
        expect(profile.totalXP, 160);
      },
    );

    test(
      '7. Final Exam Node 50 hanya lulus melalui evaluasi kanonikal yang sah',
      () async {
        final prefs = InMemoryProfilePreferences(
          initialClearedActivities: {
            'eval_passed:path_node_u5_n49_evaluasi_unit5',
            'eval_score:path_node_u5_n49_evaluasi_unit5:95',
          },
        );
        final profile = ProfileController(preferences: prefs);
        await profile.loadProfile();

        // Node 50 must NOT be passed via historical Unit 5 eval
        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isFalse,
        );

        // Passing genuine Node 50
        await profile.recordEvaluationScore(
          activityId: 'path_node_u5_n50_evaluasi_akhir',
          score: 75,
        );
        expect(
          profile.isEvaluationPassed('path_node_u5_n50_evaluasi_akhir'),
          isTrue,
        );
      },
    );

    test('8. Skor evaluasi lama tidak mencemari skor Final Exam', () async {
      final prefs = InMemoryProfilePreferences(
        initialClearedActivities: {
          'eval_score:path_node_u5_n49_evaluasi_unit5:88',
        },
      );
      final profile = ProfileController(preferences: prefs);
      await profile.loadProfile();

      // Legacy Unit 5 eval score is preserved under historical identity
      expect(profile.getEvaluationScore('path_node_u5_n49_evaluasi_unit5'), 88);
      // Final exam score is strictly null
      expect(
        profile.getEvaluationScore('path_node_u5_n50_evaluasi_akhir'),
        isNull,
      );
    });
  });
}
