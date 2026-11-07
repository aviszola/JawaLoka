import 'package:flutter/widgets.dart';
import 'profile_controller.dart';

/// An [InheritedNotifier] providing [ProfileController] throughout the widget tree.
///
/// Descendants can listen to profile updates via [ProfileScope.of(context)] or [ProfileScope.maybeOf(context)].
class ProfileScope extends InheritedNotifier<ProfileController> {
  const ProfileScope({
    super.key,
    required ProfileController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Returns the nearest [ProfileController] in the widget hierarchy.
  ///
  /// Throws an assertion error in debug mode if [ProfileScope] is not found.
  static ProfileController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProfileScope>();
    assert(
      scope != null,
      'No ProfileScope found in BuildContext. Ensure MaterialApp is wrapped with ProfileScope.',
    );
    return scope!.notifier!;
  }

  /// Returns the nearest [ProfileController] in the widget hierarchy, or null if not present.
  static ProfileController? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProfileScope>();
    return scope?.notifier;
  }
}

