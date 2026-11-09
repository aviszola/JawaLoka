import '../../../data/translation_entries.dart';
import '../domain/translation_models.dart';

/// Implementasi luring berbasis kamus terstruktur untuk TranslationService.
class OfflineDictionaryService implements TranslationService {
  final List<TranslationEntry> entries;

  const OfflineDictionaryService({this.entries = kTranslationEntries});

  /// Normalisasi masukan teks:
  /// - trim spasi awal/akhir
  /// - huruf kecil (case-insensitive matching)
  /// - rapatkan spasi ganda menjadi spasi tunggal
  /// - buang tanda baca di ujung (. , ! ? ;)
  static String normalize(String input) {
    var s = input.trim().toLowerCase();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    s = s.replaceAll(RegExp(r'[\.,!\?;]+$'), '').trim();
    return s;
  }

  @override
  Future<TranslationResult> translate({
    required String text,
    required TranslationVariant from,
    required TranslationVariant to,
  }) async {
    final normalizedInput = normalize(text);
    if (normalizedInput.isEmpty) {
      return const NotFound();
    }

    // Jika varian bahasa asal dan tujuan sama persis, kembalikan apa adanya
    if (from == to) {
      return Found(text);
    }

    // Cari entri kamus yang cocok secara eksak pada varian bahasa asal
    for (final entry in entries) {
      final entryFromText = normalize(entry.getVariant(from));
      if (entryFromText == normalizedInput) {
        return Found(entry.getVariant(to));
      }
    }

    // Tidak ada kecocokan: tidak menebak kata-per-kata
    return const NotFound();
  }

  @override
  List<String> examples(TranslationVariant from, {int max = 4}) {
    if (max <= 0) return const [];
    return entries.take(max).map((e) => e.getVariant(from)).toList();
  }
}

