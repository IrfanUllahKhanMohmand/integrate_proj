import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', locale.languageCode);
    // prefs.setString('countryCode', locale.countryCode ?? 'US');
    notifyListeners();
  }
}
