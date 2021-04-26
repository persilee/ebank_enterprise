import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

class HsgShowTip {
  ///没有开户提示(快速)
  static void notOpenAccountTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).openAccount_notOpen_content,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      click(value);
    });
  }

  ///没有开户提示（非快速）
  static void notOpenAccountGotoEbankTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).open_account_goto_ebank_tip,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }

  /// 受限客户
  static void limitedCustomerTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).limited_customer_tip,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }

  ///没有设置交易密码提示
  static void shouldSetTranPasswordTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).not_set_tranPassword_content,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      click(value);
    });
  }

  ///开户成功提示
  static void openAccountSuccessfulTip(
    BuildContext context,
    Function(dynamic value) click,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).openAccout_application_results_title,
            message: S.of(context).openAccout_application_results_content,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }

  ///完整开户面签成功提示
  static void faceSignSuccessfulTip(
    BuildContext context,
    Function(dynamic value) click,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).openAccount_faceSign_results_content,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }

  ///面签码返回错误的提示
  static void notFaceSignBusinessTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).face_sign_NotBusiness_content,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      click(value);
    });
  }

  /// 登录密码错误次数提示
  static void loginPasswordErrorTip(
    BuildContext context,
    int errorNum,
    int totalNum,
    Function(dynamic value) click,
  ) {
    totalNum = totalNum == null || totalNum == 0 ? 5 : totalNum;
    String tipTitle = S.of(context).login_password_error_tip;
    tipTitle = tipTitle.replaceAll('errNum', errorNum.toString());
    tipTitle =
        tipTitle.replaceAll('remainNum', (totalNum - errorNum).toString());
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: tipTitle,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }

  /// 登录密码错误次数太多，被锁定提示
  static void loginPasswordErrorToMuchTip(
    BuildContext context,
    Function(dynamic value) click,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).warm_prompt,
            message: S.of(context).login_password_error_toMuch_tip,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      click(value);
    });
  }
}
