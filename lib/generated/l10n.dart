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

  /// `loan details`
  String get loanDetails {
    return Intl.message(
      'loan details',
      name: 'loanDetails',
      desc: '',
      args: [],
    );
  }

  /// `Business Varieties`
  String get businessVarieties {
    return Intl.message(
      'Business Varieties',
      name: 'businessVarieties',
      desc: '',
      args: [],
    );
  }

  /// `Loan Id`
  String get loanId {
    return Intl.message(
      'Loan Id',
      name: 'loanId',
      desc: '',
      args: [],
    );
  }

  /// `normal`
  String get normal {
    return Intl.message(
      'normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Loan Amount`
  String get loanAmount {
    return Intl.message(
      'Loan Amount',
      name: 'loanAmount',
      desc: '',
      args: [],
    );
  }

  /// `Loan Balance`
  String get loanBalance {
    return Intl.message(
      'Loan Balance',
      name: 'loanBalance',
      desc: '',
      args: [],
    );
  }

  /// `Payment History`
  String get paymentHistory {
    return Intl.message(
      'Payment History',
      name: 'paymentHistory',
      desc: '',
      args: [],
    );
  }

  /// `Repayment Schedule`
  String get repaymentSchedule {
    return Intl.message(
      'Repayment Schedule',
      name: 'repaymentSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Loan Interest Rates`
  String get loanInterestRates {
    return Intl.message(
      'Loan Interest Rates',
      name: 'loanInterestRates',
      desc: '',
      args: [],
    );
  }

  /// `Total Periods`
  String get totalPeriods {
    return Intl.message(
      'Total Periods',
      name: 'totalPeriods',
      desc: '',
      args: [],
    );
  }

  /// `Rest Periods`
  String get restPeriods {
    return Intl.message(
      'Rest Periods',
      name: 'restPeriods',
      desc: '',
      args: [],
    );
  }

  /// `Starting Date`
  String get startingDate {
    return Intl.message(
      'Starting Date',
      name: 'startingDate',
      desc: '',
      args: [],
    );
  }

  /// `Expiring Date`
  String get expiringDate {
    return Intl.message(
      'Expiring Date',
      name: 'expiringDate',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Agreement`
  String get agreement {
    return Intl.message(
      'Agreement',
      name: 'agreement',
      desc: '',
      args: [],
    );
  }

  /// `debitCard`
  String get debitCard {
    return Intl.message(
      'debitCard',
      name: 'debitCard',
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