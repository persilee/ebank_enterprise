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

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Record`
  String get transfer_record {
    return Intl.message(
      'Transfer Record',
      name: 'transfer_record',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Template`
  String get transfer_model {
    return Intl.message(
      'Transfer Template',
      name: 'transfer_model',
      desc: '',
      args: [],
    );
  }

  /// `Time Deposit Opening`
  String get deposit_open {
    return Intl.message(
      'Time Deposit Opening',
      name: 'deposit_open',
      desc: '',
      args: [],
    );
  }

  /// `My Time Deposits`
  String get deposit_record {
    return Intl.message(
      'My Time Deposits',
      name: 'deposit_record',
      desc: '',
      args: [],
    );
  }

  /// `View Interest Rate`
  String get deposit_rate {
    return Intl.message(
      'View Interest Rate',
      name: 'deposit_rate',
      desc: '',
      args: [],
    );
  }

  /// `Loan`
  String get loan_apply {
    return Intl.message(
      'Loan',
      name: 'loan_apply',
      desc: '',
      args: [],
    );
  }

  /// `Loan Record`
  String get loan_record {
    return Intl.message(
      'Loan Record',
      name: 'loan_record',
      desc: '',
      args: [],
    );
  }

  /// `Loan Interest Rate`
  String get loan_rate {
    return Intl.message(
      'Loan Interest Rate',
      name: 'loan_rate',
      desc: '',
      args: [],
    );
  }

  /// `Foreign Exchange`
  String get foreign_exchange {
    return Intl.message(
      'Foreign Exchange',
      name: 'foreign_exchange',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Rate`
  String get exchange_rate {
    return Intl.message(
      'Exchange Rate',
      name: 'exchange_rate',
      desc: '',
      args: [],
    );
  }

  /// `Electronic Statement`
  String get electronic_statement {
    return Intl.message(
      'Electronic Statement',
      name: 'electronic_statement',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer_collection {
    return Intl.message(
      'Transfer',
      name: 'transfer_collection',
      desc: '',
      args: [],
    );
  }

  /// `Time Deposit`
  String get deposit_service {
    return Intl.message(
      'Time Deposit',
      name: 'deposit_service',
      desc: '',
      args: [],
    );
  }

  /// `Loan`
  String get loan_service {
    return Intl.message(
      'Loan',
      name: 'loan_service',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get other_service {
    return Intl.message(
      'Others',
      name: 'other_service',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Details`
  String get transaction_details {
    return Intl.message(
      'Transaction Details',
      name: 'transaction_details',
      desc: '',
      args: [],
    );
  }

  /// `Account Summary`
  String get account_summary {
    return Intl.message(
      'Account Summary',
      name: 'account_summary',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `All Functions`
  String get all_features {
    return Intl.message(
      'All Functions',
      name: 'all_features',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get my_account {
    return Intl.message(
      'My Account',
      name: 'my_account',
      desc: '',
      args: [],
    );
  }

  /// `Pre-arranged Transfer`
  String get transfer_appointment {
    return Intl.message(
      'Pre-arranged Transfer',
      name: 'transfer_appointment',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Plan`
  String get transfer_plan {
    return Intl.message(
      'Transfer Plan',
      name: 'transfer_plan',
      desc: '',
      args: [],
    );
  }

  /// `Time Deposit`
  String get time_deposit {
    return Intl.message(
      'Time Deposit',
      name: 'time_deposit',
      desc: '',
      args: [],
    );
  }

  /// `Loan`
  String get loan {
    return Intl.message(
      'Loan',
      name: 'loan',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
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