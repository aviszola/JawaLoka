import 'models/quiz_question.dart';

/// Klasifikasi tingkat kemahiran kuis adaptif JawaLoka.
enum QuizTier {
  /// Tingkat Pemula: Pengenalan aksara dasar Hanacaraka (Level 1–3).
  pemula,

  /// Tingkat Menengah: Kombinasi aksara, sandangan swara & panyigeg, dan kosakata (Level 4–6).
  menengah,

  /// Tingkat Mahir: Unggah-ungguh basa, perbedaan ngoko & krama, serta konteks tata krama (Level 7+).
  mahir,
}

/// Bank soal kuis adaptif berbasis level kemahiran pengguna JawaLoka.
///
/// Seluruh materi diambil secara autentik dari kurikulum dan materi yang sudah ada di aplikasi
/// (modul aksara dasar, sandangan di [AksaraDetailScreen], kosakata di [VocabWord],
/// unggah-ungguh di [LearnHubScreen], dan sapaan di [TranslatorScreen]).
class AdaptiveQuizBank {
  AdaptiveQuizBank._();

  /// Menentukan [QuizTier] berdasarkan level pengguna:
  /// - Level 1–3: [QuizTier.pemula]
  /// - Level 4–6: [QuizTier.menengah]
  /// - Level 7+: [QuizTier.mahir]
  static QuizTier getTierForLevel(int level) {
    if (level <= 3) {
      return QuizTier.pemula;
    } else if (level <= 6) {
      return QuizTier.menengah;
    } else {
      return QuizTier.mahir;
    }
  }

  /// Mengambil daftar 10 soal adaptif berdasarkan level pengguna.
  static List<QuizQuestion> getQuestionsForLevel(int level) {
    return getQuestionsForTier(getTierForLevel(level));
  }

  /// Mengambil daftar 10 soal adaptif berdasarkan [QuizTier].
  static List<QuizQuestion> getQuestionsForTier(QuizTier tier) {
    switch (tier) {
      case QuizTier.pemula:
        return pemulaQuestions;
      case QuizTier.menengah:
        return menengahQuestions;
      case QuizTier.mahir:
        return mahirQuestions;
    }
  }

  // ===========================================================================
  // TIER 1: PEMULA (Level 1–3) — Aksara Dasar Hanacaraka
  // ===========================================================================
  static const List<QuizQuestion> pemulaQuestions = [
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

  // ===========================================================================
  // TIER 2: MENENGAH (Level 4–6) — Sandangan & Kosakata Beraksara
  // ===========================================================================
  static const List<QuizQuestion> menengahQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan wulu iki diwaca apa?',
      glyph: 'ꦲꦶ',
      options: ['Hi', 'Hu', 'He', 'Ho'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan suku iki diwaca apa?',
      glyph: 'ꦲꦸ',
      options: ['Ha', 'Hu', 'Hi', 'Hah'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan taling iki diwaca apa?',
      glyph: 'ꦲꦺ',
      options: ['Ho', 'Hi', 'He', 'Hah'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan taling-tarung iki diwaca apa?',
      glyph: 'ꦲꦺꦴ',
      options: ['He', 'Hu', 'Ha', 'Ho'],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan pepet iki diwaca apa?',
      glyph: 'ꦲꦼ',
      options: ['Hǝ', 'Hi', 'Hu', 'Ho'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Aksara Ha kanthi sandhangan wignyan iki diwaca apa?',
      glyph: 'ꦲꦃ',
      options: ['Han', 'Har', 'Hah', 'Hang'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Kosakata punapa ingkang kaserat ing aksara punika?',
      glyph: 'ꦲꦺꦴꦩꦃ',
      options: ['Omah', 'Banyu', 'Lemah', 'Segara'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Kosakata punapa ingkang kaserat ing aksara punika?',
      glyph: 'ꦧꦤꦾꦸ',
      options: ['Langit', 'Banyu', 'Segara', 'Omah'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Kosakata punapa ingkang kaserat ing aksara punika?',
      glyph: 'ꦱꦼꦒꦫ',
      options: ['Lemah', 'Langit', 'Segara', 'Hara'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: 'Kosakata punapa ingkang kaserat ing aksara punika?',
      glyph: 'ꦭꦼꦩꦃ',
      options: ['Banyu', 'Omah', 'Hawu', 'Lemah'],
      correctIndex: 3,
    ),
  ];

  // ===========================================================================
  // TIER 3: MAHIR (Level 7+) — Unggah-Ungguh & Konteks Wicara Santun
  // ===========================================================================
  static const List<QuizQuestion> mahirQuestions = [
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Ukara 'Kowe arep mangan apa?' kalebu ragam basa apa?",
      glyph: '',
      options: ['Ngoko Lugu', 'Ngoko Alus', 'Krama Lugu', 'Krama Inggil'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Ukara 'Panjenengan apa wis dhahar?' kalebu ragam basa apa?",
      glyph: '',
      options: ['Ngoko Lugu', 'Ngoko Alus', 'Krama Lugu', 'Krama Inggil'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Ukara 'Kula nedha sekul goreng.' kalebu ragam basa apa?",
      glyph: '',
      options: ['Ngoko Lugu', 'Ngoko Alus', 'Krama Lugu', 'Krama Inggil'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt:
          "Ukara 'Bapak saweg tindak dhateng kantor.' kalebu ragam basa apa?",
      glyph: '',
      options: ['Ngoko Lugu', 'Ngoko Alus', 'Krama Lugu', 'Krama Inggil'],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Tembung krama inggil kang trep kanggo tembung 'mangan' yaiku...",
      glyph: '',
      options: ['Dhahar', 'Nedha', 'Ngunjuk', 'Tindak'],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Tembung 'omah' iku ngoko. Tembung krama kang trep yaiku...",
      glyph: '',
      options: ['Sare', 'Griya', 'Sekul', 'Santen'],
      correctIndex: 1,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt:
          "Salam pakurmatan ing wanci enjang miturut materi translator yaiku...",
      glyph: '',
      options: ['Sugeng sonten', 'Sugeng dalu', 'Sugeng enjing', 'Matur nuwun'],
      correctIndex: 2,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Ungkapan matur rasa panuwun kanthi basa Jawa yaiku...",
      glyph: '',
      options: [
        'Nyuwun pangapunten',
        'Sugeng rawuh',
        'Pripun kabare',
        'Matur nuwun',
      ],
      correctIndex: 3,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt: "Ukara pitakon bab kabar kanthi krama alus yaiku...",
      glyph: '',
      options: [
        'Pripun kabaripun?',
        'Piye kabarmu?',
        'Kowe nang ngendi?',
        'Sapa jenengmu?',
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      type: QuestionType.glyphIdentify,
      prompt:
          "Paribasan 'Ajining dhiri ana ing lathi' ngandhut piwulang bab...",
      glyph: '',
      options: [
        'Kasugihan bandha',
        'Pakurmatan saka wicara',
        'Sandhangan sing apik',
        'Kekuwatan raga',
      ],
      correctIndex: 1,
    ),
  ];
}
