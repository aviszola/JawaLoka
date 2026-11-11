import '../models/quiz_question.dart';
import '../quiz_path_models.dart';
import 'unit1_questions.dart';
import 'unit2_questions.dart';
import 'unit3_questions.dart';
import 'unit4_questions.dart';
import 'unit5_questions.dart';

/// Master curriculum-based question bank for JawaLoka.
///
/// Menyediakan akses ke bank soal terstruktur untuk 50 node pembelajaran
/// lintas 5 unit dengan 3 tingkat kesulitan ([QuizDifficulty.mudah],
/// [QuizDifficulty.mahir], [QuizDifficulty.sangatMahir]).
class CurriculumQuizBank {
  CurriculumQuizBank._();

  /// Seluruh soal kurikuler dalam aplikasi (320 soal terverifikasi).
  static List<QuizQuestion> get allQuestions => [
    ...Unit1Questions.allQuestions,
    ...Unit2Questions.allQuestions,
    ...Unit3Questions.allQuestions,
    ...Unit4Questions.allQuestions,
    ...Unit5Questions.allQuestions,
  ];

  /// Mengambil daftar soal kuis kurikuler untuk sebuah [QuizPathNode].
  ///
  /// - Untuk node evaluasi/milestone/finalExam: mengembalikan 10 soal evaluasi komprehensif unit.
  /// - Untuk node reguler: mengembalikan soal sesuai [node.topicKey], diprioritaskan
  ///   berdasarkan [difficulty] yang aktif.
  static List<QuizQuestion> getQuestionsForNode(
    QuizPathNode node, {
    QuizDifficulty? difficulty,
    bool strictDifficulty = false,
  }) {
    // 1. Check if node is an evaluation milestone or final exam
    final isEvaluationNode =
        node.type == QuizNodeType.milestone ||
        node.type == QuizNodeType.finalExam ||
        node.topicKey.startsWith('evaluasi_');

    if (isEvaluationNode) {
      return getEvaluationQuestions(node.unitId);
    }

    // 2. Fetch questions for regular node topic
    return getQuestionsForTopic(
      node.topicKey,
      difficulty: difficulty,
      strictDifficulty: strictDifficulty,
    );
  }

  /// Mengambil soal berdasarkan [topicKey] spesifik.
  static List<QuizQuestion> getQuestionsForTopic(
    String topicKey, {
    QuizDifficulty? difficulty,
    bool strictDifficulty = false,
  }) {
    final matching = allQuestions.where((q) => q.topicKey == topicKey).toList();

    if (matching.isEmpty) {
      // Fallback: return default questions to prevent crash
      return QuizQuestion.defaultQuestions;
    }

    if (difficulty == null) {
      return matching;
    }

    if (strictDifficulty) {
      final strict = matching.where((q) => q.difficulty == difficulty).toList();
      return strict.isNotEmpty ? strict : matching;
    }

    // Prioritized by difficulty: matching first, then adjacent difficulties
    final prioritized = List<QuizQuestion>.from(matching);
    prioritized.sort((a, b) {
      if (a.difficulty == difficulty && b.difficulty != difficulty) return -1;
      if (b.difficulty == difficulty && a.difficulty != difficulty) return 1;
      return 0;
    });

    return prioritized;
  }

  /// Mengambil 10 soal evaluasi komprehensif untuk sebuah unit (1–5).
  static List<QuizQuestion> getEvaluationQuestions(int unitId) {
    final evalTopicKey = unitId == 5
        ? 'evaluasi_akhir'
        : 'evaluasi_unit$unitId';
    final evalQuestions = allQuestions
        .where((q) => q.topicKey == evalTopicKey)
        .toList();

    if (evalQuestions.isNotEmpty) {
      return evalQuestions;
    }

    // Fallback: collect representative questions from that unit
    return allQuestions
        .where((q) => q.id.startsWith('u${unitId}_'))
        .take(10)
        .toList();
  }

  /// Memvalidasi integritas bank soal:
  /// - Memastikan tidak ada duplikasi ID soal
  /// - Memastikan setiap soal memiliki 4 opsi dan correctIndex valid
  /// - Memastikan penjelasan dan referensi sumber tidak kosong
  /// - Memastikan seluruh 50 topik memiliki soal
  static Map<String, dynamic> validateBank({List<String>? expectedTopicKeys}) {
    final Set<String> seenIds = {};
    final List<String> duplicateIds = [];
    final List<String> invalidOptionCounts = [];
    final List<String> invalidIndices = [];
    final List<String> missingExplanations = [];
    final List<String> missingSources = [];
    final Map<String, int> topicCounts = {};

    for (final q in allQuestions) {
      // Check ID uniqueness
      if (seenIds.contains(q.id)) {
        duplicateIds.add(q.id);
      } else {
        seenIds.add(q.id);
      }

      // Check options count
      if (q.options.length != 4) {
        invalidOptionCounts.add(q.id);
      }

      // Check correctIndex bounds
      if (q.correctIndex < 0 || q.correctIndex >= q.options.length) {
        invalidIndices.add(q.id);
      }

      // Check explanation
      if (q.explanation.trim().isEmpty) {
        missingExplanations.add(q.id);
      }

      // Check source reference
      if (q.sourceReference.trim().isEmpty) {
        missingSources.add(q.id);
      }

      // Count by topic
      topicCounts[q.topicKey] = (topicCounts[q.topicKey] ?? 0) + 1;
    }

    final List<String> missingTopics = [];
    if (expectedTopicKeys != null) {
      for (final topic in expectedTopicKeys) {
        if (!topicCounts.containsKey(topic) || (topicCounts[topic] ?? 0) == 0) {
          missingTopics.add(topic);
        }
      }
    }

    final isValid =
        duplicateIds.isEmpty &&
        invalidOptionCounts.isEmpty &&
        invalidIndices.isEmpty &&
        missingExplanations.isEmpty &&
        missingSources.isEmpty &&
        missingTopics.isEmpty;

    return {
      'isValid': isValid,
      'totalQuestions': allQuestions.length,
      'uniqueIds': seenIds.length,
      'topicCounts': topicCounts,
      'duplicateIds': duplicateIds,
      'invalidOptionCounts': invalidOptionCounts,
      'invalidIndices': invalidIndices,
      'missingExplanations': missingExplanations,
      'missingSources': missingSources,
      'missingTopics': missingTopics,
    };
  }
}
