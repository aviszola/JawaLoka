/// Sealed validation result and domain error definitions.
/// Pure Dart — completely decoupled from Flutter UI and BuildContext.
sealed class ValidationResult<T, E> {
  const ValidationResult();

  bool get isValid => this is Valid<T, E>;
  bool get isInvalid => this is Invalid<T, E>;

  T? get valueOrNull => switch (this) {
    Valid(:final value) => value,
    Invalid() => null,
  };

  E? get errorOrNull => switch (this) {
    Valid() => null,
    Invalid(:final error) => error,
  };
}

/// Represents a successful validation containing the normalized value.
class Valid<T, E> extends ValidationResult<T, E> {
  final T value;
  const Valid(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Valid<T, E> && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Valid($value)';
}

/// Represents a failed validation containing a strongly-typed domain error code.
class Invalid<T, E> extends ValidationResult<T, E> {
  final E error;
  const Invalid(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invalid<T, E> && other.error == error);

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Invalid($error)';
}

/// Domain errors for user display name input.
enum NameError { empty, tooShort, tooLong, invalidChars }

/// Domain errors for email input.
enum EmailError { empty, invalidFormat, tooLong }

/// Domain errors for password input.
enum PasswordError { empty, tooShort, tooLong, whitespaceOnly }

/// Domain errors for translator input text.
enum TranslationInputError { empty, tooLong }

/// Domain errors for quest canvas drawing strokes.
enum QuestDrawingError { empty, tooShort, invalidCoordinates }
