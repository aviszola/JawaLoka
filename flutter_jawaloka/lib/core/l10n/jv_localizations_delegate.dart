import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Fallback MaterialLocalizations delegate for Javanese (`jv`).
///
/// Since Flutter SDK does not have built-in Material strings for Javanese,
/// this delegate provides Indonesian (`id`) fallback for Material widgets
/// while custom application strings are provided by `AppLocalizations`.
class JvMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const JvMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'jv';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(const Locale('id'));
  }

  @override
  bool shouldReload(JvMaterialLocalizationsDelegate old) => false;
}

/// Fallback CupertinoLocalizations delegate for Javanese (`jv`).
///
/// Provides Indonesian (`id`) fallback for Cupertino widgets.
class JvCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const JvCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'jv';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(const Locale('id'));
  }

  @override
  bool shouldReload(JvCupertinoLocalizationsDelegate old) => false;
}

/// Composite helper providing all localizations delegates required by JawaLoka,
/// including the Javanese Material and Cupertino fallbacks.
class AppLocalizationDelegates {
  AppLocalizationDelegates._();

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    JvMaterialLocalizationsDelegate(),
    JvCupertinoLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

