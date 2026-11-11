import '../../l10n/app_localizations.dart';
import 'validation_result.dart';

/// Maps domain validation error enums to localized user-facing strings.
/// Guarantees no hardcoded user strings are used in UI presentation.
class ValidationMessages {
  ValidationMessages._();

  /// Returns localized message for a [NameError].
  static String nameError(AppLocalizations l10n, NameError error) {
    return switch (error) {
      NameError.empty => l10n.validationNameRequired,
      NameError.tooShort => l10n.validationNameTooShort,
      NameError.tooLong => l10n.validationNameTooLong,
      NameError.invalidChars => l10n.validationNameInvalidChars,
    };
  }

  /// Returns localized message for an [EmailError].
  static String emailError(AppLocalizations l10n, EmailError error) {
    return switch (error) {
      EmailError.empty => l10n.validationEmailInvalid,
      EmailError.invalidFormat => l10n.validationEmailInvalid,
      EmailError.tooLong => l10n.validationEmailTooLong,
    };
  }

  /// Returns localized message for a [PasswordError].
  static String passwordError(AppLocalizations l10n, PasswordError error) {
    return switch (error) {
      PasswordError.empty => l10n.validationPasswordEmpty,
      PasswordError.tooShort => l10n.validationPasswordMinLength,
      PasswordError.tooLong => l10n.validationPasswordTooLong,
      PasswordError.whitespaceOnly => l10n.validationPasswordWhitespaceOnly,
    };
  }

  /// Returns localized message for a [TranslationInputError].
  static String translationError(
    AppLocalizations l10n,
    TranslationInputError error,
  ) {
    return switch (error) {
      TranslationInputError.empty => l10n.validationTranslationEmpty,
      TranslationInputError.tooLong => l10n.validationTranslationTooLong,
    };
  }

  /// Returns localized message for a [QuestDrawingError].
  static String questDrawingError(
    AppLocalizations l10n,
    QuestDrawingError error,
  ) {
    return switch (error) {
      QuestDrawingError.empty => l10n.validationDrawingEmpty,
      QuestDrawingError.tooShort => l10n.validationDrawingTooShort,
      QuestDrawingError.invalidCoordinates => l10n.validationDrawingEmpty,
    };
  }
}
