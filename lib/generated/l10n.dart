// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get simplifiedChinese {
    return Intl.message(
      'Chinese',
      name: 'simplifiedChinese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Email/Mobile Phone No./User ID`
  String get login_account_placeholder {
    return Intl.message(
      'Email/Mobile Phone No./User ID',
      name: 'login_account_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get fotget_password_q {
    return Intl.message(
      'Forget Password?',
      name: 'fotget_password_q',
      desc: '',
      args: [],
    );
  }

  /// `Operation Successfully`
  String get operation_successful {
    return Intl.message(
      'Operation Successfully',
      name: 'operation_successful',
      desc: '',
      args: [],
    );
  }

  /// `Please input account`
  String get please_input_account {
    return Intl.message(
      'Please input account',
      name: 'please_input_account',
      desc: '',
      args: [],
    );
  }

  /// `Please input password`
  String get please_input_password {
    return Intl.message(
      'Please input password',
      name: 'please_input_password',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Approval`
  String get approval {
    return Intl.message(
      'Approval',
      name: 'approval',
      desc: '',
      args: [],
    );
  }

  /// `Chang Login Password`
  String get setChangLoginPasd {
    return Intl.message(
      'Chang Login Password',
      name: 'setChangLoginPasd',
      desc: '',
      args: [],
    );
  }

  /// `Please Set the Login Password`
  String get plaseSetPsd {
    return Intl.message(
      'Please Set the Login Password',
      name: 'plaseSetPsd',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}