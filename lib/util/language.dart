/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-12-04

import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.LANGUAGE, language);
  }

  static Future<String> getSaveLangage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ConfigKey.LANGUAGE) ?? EN;
  }
}
