import 'package:flutter/widgets.dart';
import 'locale_controller.dart';

/// An [InheritedNotifier] providing [LocaleController] throughout the widget tree.
///
/// Descendants can listen to locale updates via [LocaleScope.of(context)] or [LocaleScope.maybeOf(context)].
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Returns the nearest [LocaleController] in the widget hierarchy.
  ///
  /// Throws an assertion error in debug mode if [LocaleScope] is not found.
  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(
      scope != null,
      'No LocaleScope found in BuildContext. Ensure MaterialApp is wrapped with LocaleScope.',
    );
    return scope!.notifier!;
  }

  /// Returns the nearest [LocaleController] in the widget hierarchy, or null if not present.
  static LocaleController? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    return scope?.notifier;
  }
}
