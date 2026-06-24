import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Claves de locale soportadas. Añadir nuevas entradas aquí al incorporar idiomas.
class AppLocales {
  static const spanish = Locale('es');
  static const english = Locale('en');

  static const supported = <Locale>[
    spanish,
    english,
  ];

  static const storageKey = 'app_locale';
}

class LocaleService extends ChangeNotifier {
  LocaleService({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    final code = _preferences!.getString(AppLocales.storageKey);
    if (code == null) {
      _locale = null;
    } else {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _preferences ??= await SharedPreferences.getInstance();
    _locale = locale;
    if (locale == null) {
      await _preferences!.remove(AppLocales.storageKey);
    } else {
      await _preferences!.setString(AppLocales.storageKey, locale.languageCode);
    }
    notifyListeners();
  }
}
