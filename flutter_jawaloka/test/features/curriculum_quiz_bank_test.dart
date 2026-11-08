import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/curriculum_quiz_bank.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/unit1_questions.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/unit2_questions.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/unit3_questions.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/unit4_questions.dart';
import 'package:flutter_jawaloka/features/quiz/domain/curriculum/unit5_questions.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_data.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_models.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_session.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_question_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  group('CurriculumQuizBank Architecture & Integrity Tests', () {
    test('Total questions across all 5 units is exactly 320 questions', () {
      final all = CurriculumQuizBank.allQuestions;
      expect(all.length, 320);

      expect(Unit1Questions.allQuestions.length, 64);
      expect(Unit2Questions.allQuestions.length, 64);
      expect(Unit3Questions.allQuestions.length, 64);
      expect(Unit4Questions.allQuestions.length, 64);
      expect(Unit5Questions.allQuestions.length, 64);
    });

    test('Zero duplicate question IDs across the entire question bank', () {
      final all = CurriculumQuizBank.allQuestions;
      final seen = <String>{};
      final duplicates = <String>[];

      for (final q in all) {
        expect(q.id.isNotEmpty, isTrue, reason: 'Found question with empty ID');
        if (seen.contains(q.id)) {
          duplicates.add(q.id);
        }
        seen.add(q.id);
      }

      expect(duplicates, isEmpty,
          reason: 'Duplicate question IDs found: $duplicates');
    });

    test('All 50 nodes in QuizPathData have matching questions in bank', () {
      final expectedTopicKeys =
          QuizPathData.allNodes.map((n) => n.topicKey).toList();
      expect(expectedTopicKeys.length, 50);

      final report = CurriculumQuizBank.validateBank(
        expectedTopicKeys: expectedTopicKeys,
      );

      expect(report['isValid'], isTrue,
          reason: 'Validation failed with report: $report');
      expect(report['missingTopics'], isEmpty);
      expect(report['duplicateIds'], isEmpty);
      expect(report['invalidOptionCounts'], isEmpty);
      expect(report['invalidIndices'], isEmpty);
      expect(report['missingExplanations'], isEmpty);
      expect(report['missingSources'], isEmpty);
    });

    test('Every question has exactly 4 options and valid correctIndex (0..3)',
        () {
      for (final q in CurriculumQuizBank.allQuestions) {
        expect(q.options.length, 4,
            reason: 'Question ${q.id} does not have 4 options');
        expect(q.correctIndex, inInclusiveRange(0, 3),
            reason: 'Question ${q.id} has invalid correctIndex');

        // Verify options are non-empty strings
        for (final opt in q.options) {
          expect(opt.trim().isNotEmpty, isTrue,
              reason: 'Question ${q.id} has empty option');
        }
      }
    });

    test('Every question has educational explanation and source citation', () {
      for (final q in CurriculumQuizBank.allQuestions) {
        expect(q.explanation.trim().isNotEmpty, isTrue,
            reason: 'Question ${q.id} is missing explanation');
        expect(q.sourceReference.trim().isNotEmpty, isTrue,
            reason: 'Question ${q.id} is missing sourceReference');
      }
    });

    test('Three difficulty levels (mudah, mahir, sangatMahir) exist per regular node',
        () {
      // 45 regular nodes should each have 2 mudah, 2 mahir, and 2 sangatMahir
      final regularNodes =
          QuizPathData.allNodes.where((n) => !n.isMilestone && n.type != QuizNodeType.finalExam);

      for (final node in regularNodes) {
        final topicQuestions = CurriculumQuizBank.allQuestions
            .where((q) => q.topicKey == node.topicKey)
            .toList();

        expect(topicQuestions.length, 6,
            reason: 'Node ${node.id} (${node.topicKey}) does not have 6 questions');

        final mudah = topicQuestions
            .where((q) => q.difficulty == QuizDifficulty.mudah)
            .toList();
        final mahir = topicQuestions
            .where((q) => q.difficulty == QuizDifficulty.mahir)
            .toList();
        final sangatMahir = topicQuestions
            .where((q) => q.difficulty == QuizDifficulty.sangatMahir)
            .toList();

        expect(mudah.length, 2,
            reason: 'Node ${node.topicKey} has ${mudah.length} mudah questions');
        expect(mahir.length, 2,
            reason: 'Node ${node.topicKey} has ${mahir.length} mahir questions');
        expect(sangatMahir.length, 2,
            reason:
                'Node ${node.topicKey} has ${sangatMahir.length} sangatMahir questions');
      }
    });
  });

  group('Unit Evaluation Scope Tests', () {
    test('Unit 1 Evaluation (Node 10) questions strictly test Unit 1 concepts', () {
      final u1Node = QuizPathData.allNodes.firstWhere((n) => n.nodeNumber == 10);
      final questions = CurriculumQuizBank.getQuestionsForNode(u1Node);

      expect(questions.length, 10);
      for (final q in questions) {
        expect(q.topicKey, 'evaluasi_unit1');
        expect(q.id.startsWith('u1_n10_'), isTrue);
      }
    });

    test('Unit 2 Evaluation (Node 20) questions strictly test Unit 2 concepts', () {
      final u2Node = QuizPathData.allNodes.firstWhere((n) => n.nodeNumber == 20);
      final questions = CurriculumQuizBank.getQuestionsForNode(u2Node);

      expect(questions.length, 10);
      for (final q in questions) {
        expect(q.topicKey, 'evaluasi_unit2');
        expect(q.id.startsWith('u2_n20_'), isTrue);
      }
    });

    test('Unit 3 Evaluation (Node 30) questions strictly test Unit 3 concepts', () {
      final u3Node = QuizPathData.allNodes.firstWhere((n) => n.nodeNumber == 30);
      final questions = CurriculumQuizBank.getQuestionsForNode(u3Node);

      expect(questions.length, 10);
      for (final q in questions) {
        expect(q.topicKey, 'evaluasi_unit3');
        expect(q.id.startsWith('u3_n30_'), isTrue);
      }
    });

    test('Unit 4 Evaluation (Node 40) questions strictly test Unit 4 concepts', () {
      final u4Node = QuizPathData.allNodes.firstWhere((n) => n.nodeNumber == 40);
      final questions = CurriculumQuizBank.getQuestionsForNode(u4Node);

      expect(questions.length, 10);
      for (final q in questions) {
        expect(q.topicKey, 'evaluasi_unit4');
        expect(q.id.startsWith('u4_n40_'), isTrue);
      }
    });

    test('Unit 5 Final Evaluation (Node 50) comprehensively tests all units', () {
      final u5Node = QuizPathData.allNodes.firstWhere((n) => n.nodeNumber == 50);
      final questions = CurriculumQuizBank.getQuestionsForNode(u5Node);

      expect(questions.length, 10);
      expect(u5Node.type, QuizNodeType.finalExam);

      for (final q in questions) {
        expect(q.topicKey, 'evaluasi_akhir');
        expect(q.id.startsWith('u5_n50_'), isTrue);
      }

      // Verify that questions reference Unit 1, 2, 3, 4, and 5 in source references
      final sources = questions.map((q) => q.sourceReference).join(' ');
      expect(sources.contains('Unit 1'), isTrue);
      expect(sources.contains('Unit 2'), isTrue);
      expect(sources.contains('Unit 3'), isTrue);
      expect(sources.contains('Unit 4'), isTrue);
      expect(sources.contains('Unit 5'), isTrue);
    });
  });

  group('Difficulty Filtering & Prioritization Tests', () {
    test('getQuestionsForNode prioritizes matching difficulty first', () {
      final node = QuizPathData.allNodes.firstWhere((n) => n.topicKey == 'salam');

      final mudahQuestions = CurriculumQuizBank.getQuestionsForNode(
        node,
        difficulty: QuizDifficulty.mudah,
      );
      expect(mudahQuestions.first.difficulty, QuizDifficulty.mudah);

      final mahirQuestions = CurriculumQuizBank.getQuestionsForNode(
        node,
        difficulty: QuizDifficulty.mahir,
      );
      expect(mahirQuestions.first.difficulty, QuizDifficulty.mahir);

      final sangatMahirQuestions = CurriculumQuizBank.getQuestionsForNode(
        node,
        difficulty: QuizDifficulty.sangatMahir,
      );
      expect(sangatMahirQuestions.first.difficulty, QuizDifficulty.sangatMahir);
    });

    test('strictDifficulty filters only exact difficulty', () {
      final node = QuizPathData.allNodes.firstWhere((n) => n.topicKey == 'pamit');

      final strictMudah = CurriculumQuizBank.getQuestionsForNode(
        node,
        difficulty: QuizDifficulty.mudah,
        strictDifficulty: true,
      );
      expect(strictMudah.length, 2);
      for (final q in strictMudah) {
        expect(q.difficulty, QuizDifficulty.mudah);
      }
    });
  });

  group('QuizSession & Result Integration Tests', () {
    test('QuizSession computes scorePercentage and correctCount correctly with curriculum questions',
        () {
      final node = QuizPathData.allNodes.firstWhere((n) => n.topicKey == 'salam');
      final questions = CurriculumQuizBank.getQuestionsForNode(node);

      final session = QuizSession(
        questions: questions,
        moduleTitle: 'Salam',
        activityId: node.id,
      );

      expect(session.totalQuestions, 6);
      expect(session.correctCount, 0);

      // Answer first 4 correctly, last 2 incorrectly
      for (int i = 0; i < questions.length; i++) {
        final correct = questions[i].correctIndex;
        if (i < 4) {
          session.answer(correct);
        } else {
          session.answer((correct + 1) % 4);
        }
        if (i < questions.length - 1) {
          session.nextQuestion();
        }
      }

      expect(session.correctCount, 4);
      // 4 out of 6 = 66.666%
      expect(session.scorePercentage, closeTo(66.6, 0.5));

      final result = session.toResult();
      expect(result.accuracy, 67);
      expect(result.correctCount, 4);
      expect(result.totalQuestions, 6);
      expect(result.questions?.length, 6);
    });

    test('Retry maintains identical questions and canonical activity ID', () {
      final node = QuizPathData.allNodes.firstWhere((n) => n.topicKey == 'pamit');
      final questions = CurriculumQuizBank.getQuestionsForNode(node);

      final session1 = QuizSession(
        questions: questions,
        moduleTitle: 'Pamit',
        activityId: node.id,
      );

      final result1 = session1.toResult();
      expect(result1.questions, questions);

      // Emulate retry with same arguments
      final session2 = QuizSession(
        questions: result1.questions ?? [],
        moduleTitle: result1.moduleTitle ?? 'Pamit',
        activityId: node.id,
      );

      expect(session2.activityId, session1.activityId);
      expect(session2.questions, session1.questions);
      expect(session2.sessionId != session1.sessionId, isTrue,
          reason: 'Retry session must have unique attempt session ID');
    });
  });

  group('Curriculum Quiz UI & Explanation Widget Test', () {
    testWidgets(
        'QuizQuestionScreen renders authentic curriculum prompt, options, and explanation upon answer',
        (tester) async {
      final node = QuizPathData.allNodes.firstWhere((n) => n.topicKey == 'salam');
      final questions = CurriculumQuizBank.getQuestionsForNode(
        node,
        difficulty: QuizDifficulty.mudah,
      );

      await tester.pumpApp(
        QuizQuestionScreen(
          questions: questions,
          moduleTitle: 'Salam',
          activityId: node.id,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Question 1 of Salam Mudah:
      // prompt: 'Ukara "Sugeng enjang" diucapake nalika wayah apa?'
      // glyph: 'ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ'
      // options: ['Esuk (pagi)', 'Awan (siang)', 'Sore', 'Wengi (malam)']
      expect(
        find.text('Ukara "Sugeng enjang" diucapake nalika wayah apa?'),
        findsOneWidget,
      );
      expect(find.text('ꦱꦸꦒꦼꦁꦲꦺꦚ꧀ꦗꦁ'), findsOneWidget);

      // Select correct option: 'Esuk (pagi)' (index 0)
      await tester.tap(find.text('Esuk (pagi)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Explanation must now be rendered on the bottom bar!
      expect(
        find.text('"Sugeng enjang" tegese selamat pagi ing basa Jawa krama.'),
        findsOneWidget,
      );

      // Confirm and continue
      await tester.tap(find.text('Lanjut'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Should advance to Question 2 of Salam:
      expect(
        find.text('Sapaan basa Jawa krama nalika wayah sore yaiku...'),
        findsOneWidget,
      );
    });

    test('Phase 3.2: Flagged evaluation questions rewritten with distinct competency focus', () {
      final all = CurriculumQuizBank.allQuestions;

      // Unit 4: u4_n40_q06 must test conversational case study between Budi and teacher
      final u4Q06 = all.firstWhere((q) => q.id == 'u4_n40_q06');
      expect(u4Q06.prompt.contains('Budi'), isTrue);
      expect(u4Q06.prompt.contains('Pak Guru'), isTrue);
      expect(u4Q06.prompt.contains('turu'), isFalse);
      expect(u4Q06.options[u4Q06.correctIndex].contains('dhawuh'), isTrue);

      // Unit 3: u3_n30_q04 must test sandhangan swara in sentence context (Siti tuku buku)
      final u3Q04 = all.firstWhere((q) => q.id == 'u3_n30_q04');
      expect(u3Q04.prompt.contains('Siti tuku buku'), isTrue);
      expect(u3Q04.prompt.contains('kacang'), isFalse);
      expect(u3Q04.prompt.contains('gajah'), isFalse);

      // Unit 3: u3_n30_q05 must test pasangan in sentence context (Bapak tindak pasar)
      final u3Q05 = all.firstWhere((q) => q.id == 'u3_n30_q05');
      expect(u3Q05.prompt.contains('Bapak tindak pasar'), isTrue);
      expect(u3Q05.prompt.contains('kacang'), isFalse);
      expect(u3Q05.prompt.contains('gajah'), isFalse);
    });

    test('Phase 3.2: Flagged distractors have no giveaway parentheses and balanced lengths', () {
      final all = CurriculumQuizBank.allQuestions;
      final flaggedIds = [
        // Unit 4
        'u4_n32_q03', 'u4_n32_q04', 'u4_n34_q03', 'u4_n35_q04',
        'u4_n36_q06', 'u4_n38_q05', 'u4_n39_q02', 'u4_n39_q03',
        // Unit 3
        'u3_n22_q06', 'u3_n28_q01',
        // Unit 5
        'u5_n42_q04', 'u5_n44_q02', 'u5_n47_q06', 'u5_n48_q01', 'u5_n48_q02',
      ];

      for (final id in flaggedIds) {
        final q = all.firstWhere((item) => item.id == id);
        for (final opt in q.options) {
          expect(opt.isNotEmpty, isTrue, reason: '$id has empty option');
          // Must not have giveaway parentheses
          expect(opt.contains('(benar)'), isFalse, reason: '$id has (benar)');
          expect(opt.contains('(paling sopan)'), isFalse, reason: '$id has (paling sopan)');
          expect(opt.contains('(paling bener)'), isFalse, reason: '$id has (paling bener)');
        }

        // Check reasonable length balance: max option is not > 3.5x shortest non-empty option
        final lens = q.options.map((o) => o.length).toList();
        final minLen = lens.reduce((a, b) => a < b ? a : b);
        final maxLen = lens.reduce((a, b) => a > b ? a : b);
        expect(
          maxLen <= minLen * 3.5,
          isTrue,
          reason: '$id has extreme length imbalance: min=$minLen, max=$maxLen (options: ${q.options})',
        );
      }
    });

    test('Phase 3.2: All 50 nodes match question bank topicKey with zero fallback to defaultQuestions', () {
      for (final node in QuizPathData.allNodes) {
        final questions = CurriculumQuizBank.getQuestionsForNode(node);
        expect(
          questions.isNotEmpty,
          isTrue,
          reason: 'Node ${node.nodeNumber} (${node.id}) returned empty question list',
        );
        for (final q in questions) {
          expect(
            q.topicKey,
            node.topicKey,
            reason: 'Question ${q.id} topicKey (${q.topicKey}) does not match node topicKey (${node.topicKey})',
          );
        }
      }
    });
  });
}
