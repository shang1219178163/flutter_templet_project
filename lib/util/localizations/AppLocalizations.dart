// lib/l10n/app_localizations.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

class _AppLocalizationsResoure {
  static final _AppLocalizationsResoure _instance = _AppLocalizationsResoure._();
  _AppLocalizationsResoure._();
  factory _AppLocalizationsResoure() => _instance;
  static _AppLocalizationsResoure get instance => _instance;

  Map<String, String> map = {};

  late final locale = supportedLocales.first;

  final supportedLocales = const [
    Locale('zh'),
    Locale('en'),
  ];
}

/// 国际化
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    try {
      var jsonString = await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      var _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      _AppLocalizationsResoure().map = _localizedStrings;
      return true;
    } catch (e) {
      debugPrint("$this $e");
    }
    return false;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return _AppLocalizationsResoure().supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension StringLocalizations on String {
  /// 获取本地化之后的值
  String get tr => _AppLocalizationsResoure().map[this] ?? this;
}
