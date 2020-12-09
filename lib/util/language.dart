import 'package:flutter/material.dart';

class Language {
  static const String EN = 'en';
  static const String ZH_CN = 'zh_cn';
  static const Locale EN_LOCALE = Locale.fromSubtags(languageCode: 'en');
  static const Locale ZH_CN_LOCALE =
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN');

  final Map<String, Locale> languageMap = Map<String, Locale>();

  static final _instance = Language._internal();
  factory Language() => _instance;

  Language._internal() {
    languageMap[EN] = EN_LOCALE;
    languageMap[ZH_CN] = ZH_CN_LOCALE;
  }

  Locale getLocaleByLanguage(String lang) {
    if (languageMap.containsKey(lang)) {
      return languageMap[lang];
    } else {
      return Locale.fromSubtags(languageCode: 'en');
    }
  }
}
