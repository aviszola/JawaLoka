/// Represents a handwriting challenge target for the Daily Quest.
///
/// Restricted strictly to authentic curved letters in [JavaneseCalligraphyPainter]
/// (Ha, Na, Ca, Ra, Ka, Ja) to guarantee accurate vector alignment and evaluation.
class QuestTarget {
  final String aksaraChar;
  final String aksaraName;
  final String description;

  /// Ambang batas kelulusan tantangan menulis aksara (Daily Quest).
  // PERLU KEPUTUSAN: PRD menulis 85%
  static const double questPassThreshold = 0.70;

  const QuestTarget({
    required this.aksaraChar,
    required this.aksaraName,
    required this.description,
  });

  /// Canonical set of authentic curved characters with dedicated vector paths.
  static const Set<String> authenticCurvedChars = {
    'ꦲ', // Ha
    'ꦤ', // Na
    'ꦕ', // Ca
    'ꦫ', // Ra
    'ꦏ', // Ka
    'ꦗ', // Ja
  };

  // DATA CONTOH, terbatas pada huruf berkurva
  static const List<QuestTarget> dailyTargets = [
    QuestTarget(
      aksaraChar: 'ꦲ',
      aksaraName: 'Ha',
      description: 'Aksara Ha',
    ),
    QuestTarget(
      aksaraChar: 'ꦤ',
      aksaraName: 'Na',
      description: 'Aksara Na',
    ),
    QuestTarget(
      aksaraChar: 'ꦕ',
      aksaraName: 'Ca',
      description: 'Aksara Ca',
    ),
    QuestTarget(
      aksaraChar: 'ꦫ',
      aksaraName: 'Ra',
      description: 'Aksara Ra',
    ),
    QuestTarget(
      aksaraChar: 'ꦏ',
      aksaraName: 'Ka',
      description: 'Aksara Ka',
    ),
    QuestTarget(
      aksaraChar: 'ꦗ',
      aksaraName: 'Ja',
      description: 'Aksara Ja',
    ),
    QuestTarget(
      aksaraChar: 'ꦲꦤ',
      aksaraName: 'Hana',
      description: 'Tembung Hana',
    ),
    QuestTarget(
      aksaraChar: 'ꦫꦗ',
      aksaraName: 'Raja',
      description: 'Tembung Raja',
    ),
    QuestTarget(
      aksaraChar: 'ꦏꦕ',
      aksaraName: 'Kaca',
      description: 'Tembung Kaca',
    ),
    QuestTarget(
      aksaraChar: 'ꦕꦫ',
      aksaraName: 'Cara',
      description: 'Tembung Cara',
    ),
    QuestTarget(
      aksaraChar: 'ꦗꦤ',
      aksaraName: 'Jana',
      description: 'Tembung Jana',
    ),
    QuestTarget(
      aksaraChar: 'ꦏꦫ',
      aksaraName: 'Kara',
      description: 'Tembung Kara',
    ),
  ];

  /// Returns true if [char] is composed solely of letters with authentic curves.
  static bool hasOnlyAuthenticCurves(String char) {
    if (char.isEmpty) return false;
    for (final rune in char.runes) {
      final letter = String.fromCharCode(rune);
      if (!authenticCurvedChars.contains(letter)) {
        return false;
      }
    }
    return true;
  }
}

