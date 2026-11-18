/// Domain models and service contracts for the JawaLoka translation feature.
library;

/// Supported translation variants across Javanese, Indonesian, and English.
enum TranslationVariant { jvNgoko, jvKrama, id, en }

/// Tingkatan tutur (undha-usuk) Bahasa Jawa untuk pemilihan bentuk leksikal kontekstual:
/// - [ngoko]: ragam akrab / setara / kepada yang lebih muda.
/// - [kramaLugu]: ragam halus netral / untuk diri sendiri.
/// - [kramaInggil]: ragam penghormatan untuk tindakan/milik orang yang dihormati.
/// - [kramaAndhap]: ragam perendahan diri saat diri sendiri melakukan tindakan kepada orang yang dihormati.
enum SpeechRegister { ngoko, kramaLugu, kramaInggil, kramaAndhap }

/// Sealed result hierarchy for translation outcomes.
sealed class TranslationResult {
  const TranslationResult();
}

/// Returned when an exact or contextual dictionary translation is discovered.
final class Found extends TranslationResult {
  final String text;

  /// Catatan konteks/ambiguitas/keterbatasan (null bila tidak ada catatan khusus).
  final String? note;

  /// Tingkat tutur yang diterapkan saat menerjemahkan ke Bahasa Jawa (bila terdeteksi).
  final SpeechRegister? appliedRegister;

  const Found(
    this.text, {
    this.note,
    this.appliedRegister,
  });
}

/// Returned when no matching dictionary entry exists.
final class NotFound extends TranslationResult {
  const NotFound();
}

/// Abstract contract for offline and future online translation providers.
abstract class TranslationService {
  Future<TranslationResult> translate({
    required String text,
    required TranslationVariant from,
    required TranslationVariant to,
  });

  List<String> examples(TranslationVariant from, {int max = 4});
}
