/// Quiz question type enum.
enum QuestionType {
  /// Question that asks the user to identify or match a Javanese glyph.
  glyphIdentify,

  /// Question that asks the user to convert or transliterate text to Aksara.
  textToAksara,
}

/// Tingkat kesulitan soal kuis kurikuler JawaLoka.
enum QuizDifficulty {
  mudah,
  mahir,
  sangatMahir;

  String get label {
    switch (this) {
      case QuizDifficulty.mudah:
        return 'Mudah';
      case QuizDifficulty.mahir:
        return 'Mahir';
      case QuizDifficulty.sangatMahir:
        return 'Sangat Mahir';
    }
  }
}

/// Model domain murni untuk butir soal kuis kurikuler JawaLoka.
///
/// Independen dari Flutter framework, [BuildContext], dan presentation layer.
class QuizQuestion {
  final String id;
  final String topicKey;
  final QuizDifficulty difficulty;
  final QuestionType type;
  final String prompt; // Fallback or explicit prompt text
  final String? promptKey; // Key for localization
  final String glyph; // Javanese character / text displayed
  final List<String> options; // MCQ options
  final int correctIndex;
  final String explanation;
  final String sourceReference;

  const QuizQuestion({
    this.id = '',
    this.topicKey = '',
    this.difficulty = QuizDifficulty.mudah,
    required this.type,
    this.prompt = '',
    this.promptKey,
    required this.glyph,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
    this.sourceReference = '',
  });

  /// Resolusi teks prompt secara headless (tanpa dependensi Flutter UI context).
  String get fallbackPrompt => prompt.isNotEmpty ? prompt : (promptKey ?? '');

  /// Kumpulan soal bawaan/fallback untuk sesi pengenalan aksara legena dasar.
  static const List<QuizQuestion> defaultQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'what_glyph',
      glyph: 'ꦲ',
      options: ['Ha', 'Na', 'Ca', 'Ra'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'pronunciation',
      glyph: 'ꦤ',
      options: ['Ka', 'Da', 'Na', 'Ta'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'how_to_read',
      glyph: 'ꦕ',
      options: ['Sa', 'Wa', 'La', 'Ca'],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'which_pronunciation',
      glyph: 'ꦫ',
      options: ['Ra', 'Pa', 'Dha', 'Ja'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'what_glyph',
      glyph: 'ꦏ',
      options: ['Nya', 'Ka', 'Ma', 'Ga'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'pronunciation',
      glyph: 'ꦢ',
      options: ['Ta', 'Sa', 'Da', 'Ba'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'how_to_read',
      glyph: 'ꦠ',
      options: ['Ta', 'Tha', 'Nga', 'La'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'which_pronunciation',
      glyph: 'ꦱ',
      options: ['Wa', 'Sa', 'Ha', 'Ya'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'what_glyph',
      glyph: 'ꦮ',
      options: ['La', 'Pa', 'Ja', 'Wa'],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      promptKey: 'pronunciation',
      glyph: 'ꦭ',
      options: ['La', 'Ma', 'Ga', 'Ba'],
      correctIndex: 0,
    ),
  ];
}
