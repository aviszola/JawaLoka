/// Domain models and service contracts for the JawaLoka translation feature.
library;

/// Supported translation variants across Javanese, Indonesian, and English.
enum TranslationVariant {
  jvNgoko,
  jvKrama,
  id,
  en,
}

/// Sealed result hierarchy for translation outcomes.
sealed class TranslationResult {
  const TranslationResult();
}

/// Returned when an exact dictionary translation is discovered.
final class Found extends TranslationResult {
  final String text;
  const Found(this.text);
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

