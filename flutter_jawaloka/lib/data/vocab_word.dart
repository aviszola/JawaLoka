import 'package:flutter/widgets.dart';
import '../core/l10n/l10n_extension.dart';

/// Model publik kosakata untuk modul pembelajaran dan kata harian JawaLoka.
class VocabWord {
  final String id;
  final String javanese;
  final String aksara;
  final String indonesian;
  final String english;
  final String level;

  const VocabWord({
    required this.id,
    required this.javanese,
    required this.aksara,
    required this.indonesian,
    required this.english,
    required this.level,
  });

  /// Mengembalikan terjemahan makna kata sesuai dengan Locale aktif.
  String meaning(BuildContext context) {
    final l10n = context.l10n;
    switch (id) {
      case 'omah':
        return l10n.learnDailyWordOmah;
      case 'banyu':
        return l10n.learnDailyWordBanyu;
      case 'segara':
        return l10n.learnDailyWordSegara;
      case 'lemah':
        return l10n.learnDailyWordLemah;
      case 'langit':
        return l10n.learnDailyWordLangit;
      default:
        return indonesian;
    }
  }

  // DATA CONTOH, PERLU VALIDASI
  static const List<VocabWord> sampleWords = [
    VocabWord(
      id: 'omah',
      javanese: 'Omah',
      aksara: 'ꦲꦺꦴꦩꦃ',
      indonesian: 'Rumah',
      english: 'House',
      level: 'Ngoko',
    ),
    VocabWord(
      id: 'banyu',
      javanese: 'Banyu',
      aksara: 'ꦧꦤꦾꦸ',
      indonesian: 'Air',
      english: 'Water',
      level: 'Ngoko',
    ),
    VocabWord(
      id: 'segara',
      javanese: 'Segara',
      aksara: 'ꦱꦼꦒꦫ',
      indonesian: 'Laut',
      english: 'Sea',
      level: 'Krama',
    ),
    VocabWord(
      id: 'lemah',
      javanese: 'Lemah',
      aksara: 'ꦭꦼꦩꦃ',
      indonesian: 'Tanah',
      english: 'Ground',
      level: 'Ngoko',
    ),
    VocabWord(
      id: 'langit',
      javanese: 'Langit',
      aksara: 'ꦭꦁꦒꦶꦠ꧀',
      indonesian: 'Langit',
      english: 'Sky',
      level: 'Ngoko',
    ),
  ];
}
