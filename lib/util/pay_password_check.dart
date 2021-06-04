import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/hsg_text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

// ignore: non_constant_identifier_names
Future<String> CheckPayPassword(
    BuildContext context, Function(Map resultsData) callback) {
  return _openBottomSheet(context, callback);
}

//点击提校验交易密码
Future<String> _openBottomSheet(
    BuildContext context, Function(Map resultsData) callback) async {
  bool passwordEnabled = SpUtil.getBool(ConfigKey.USER_PASSWORDENABLED);
  // 判断是否设置交易密码，如果没有设置，跳转到设置密码页面，
  if (!passwordEnabled) {
    HsgShowTip.shouldSetTranPasswordTip(
      context: context,
      click: (value) {
        if (value == true) {
          //前往设置交易密码
          Navigator.pushNamed(context, pageResetPayPwdOtp);
        }
      },
    );
    return '';
  } else {
    // 输入交易密码
    String password = await _didBottomSheet(context, callback);
    // // 如果交易密码正确，处理审批逻辑
    // if (password.length > 0) {
    //   callback({
    //     'password': password ?? '',
    //   });
    // }
    return password;
  }
}

//交易密码窗口
Future<String> _didBottomSheet(
    BuildContext context, Function(Map resultsData) callback) async {
  String passwordStr = '';
  final isPassword = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
          returnPasswordFunc: (password) {
            print('>>>>>>>>>>>>>>>>>>>>>> $password');
            passwordStr = password ?? '';
            callback({
              'password': password ?? '',
            });
          },
        );
      });
  if (isPassword != null && isPassword == true) {
    return passwordStr;
  }
  FocusManager.instance.primaryFocus?.unfocus();
  return '';
}

// ignore: non_constant_identifier_names
Future<String> CheckOTP(
    BuildContext context, Function(Map resultsData) callback) {
  return _openShowDialogForOTP(context, callback);
}

//点击提校验短信验证码
Future<String> _openShowDialogForOTP(
    BuildContext context, Function(Map resultsData) callback) async {
  // 输入短信验证码
  String otpStr = await _didShowDialogForOTP(context, callback);
  return otpStr;
}

//短信验证码窗口
Future<String> _didShowDialogForOTP(
    BuildContext context, Function(Map resultsData) callback) async {
  TextEditingController _editingController = TextEditingController();

  String inputStr = '';
  final prefs = await SharedPreferences.getInstance();
  String phoneNum = prefs.getString(ConfigKey.USER_PHONE);
  String areaCodeNum = prefs.getString(ConfigKey.USER_AREACODE);
  final isCheck = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return HsgTextFieldDialog(
          areaCode: areaCodeNum != null ? areaCodeNum : '',
          phoneNum: phoneNum != null ? phoneNum : '',
          editingController: _editingController,
          returnOtpStrFunc: (value) {
            inputStr = value;
            callback({
              'otpStr': inputStr ?? '',
            });
          },
        );
      });
  print(isCheck);
  FocusManager.instance.primaryFocus?.unfocus();
  return inputStr ?? '';
}

// ignore: non_constant_identifier_names
Future<Map> CheckPasswordAndOTP(
    BuildContext context, Function(Map resultsData) callback) async {
  String passwordStr =
      await CheckPayPassword(context, (resultsData) => () async {});
  String otpStr = '';
  if (passwordStr == null || passwordStr == '') {
    callback({
      'password': '',
      'otpStr': '',
      'check': false,
    });
  } else {
    otpStr = await CheckOTP(context, (resultsDataOTP) => () {});
    if (otpStr == null || otpStr == '') {
      callback({
        'password': '',
        'otpStr': '',
        'check': false,
      });
    } else {
      callback({
        'password': passwordStr ?? '',
        'otpStr': otpStr ?? '',
        'check': true,
      });
    }
  }
  Map returnData = {
    'password': passwordStr ?? '',
    'otpStr': otpStr ?? '',
  };
  return returnData;
}
