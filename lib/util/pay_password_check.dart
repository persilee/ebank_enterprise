import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

// ignore: non_constant_identifier_names
Future<bool> CheckPayPassword(BuildContext context, VoidCallback callback) {
  return _openBottomSheet(context, callback);
}

//点击提校验交易密码
Future<bool> _openBottomSheet(
    BuildContext context, VoidCallback callback) async {
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
    return false;
  } else {
    // 输入交易密码
    bool isPassword = await _didBottomSheet(context);
    // 如果交易密码正确，处理审批逻辑
    if (isPassword) {
      callback();
    }
    return isPassword;
  }
}

//交易密码窗口
Future<bool> _didBottomSheet(BuildContext context) async {
  final isPassword = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
          isDialog: false,
        );
      });
  if (isPassword != null && isPassword == true) {
    return true;
  }
  FocusManager.instance.primaryFocus?.unfocus();
  return false;
}
