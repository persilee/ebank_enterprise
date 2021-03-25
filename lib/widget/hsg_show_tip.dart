import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

class HsgShowTip {
  ///没有开户提示
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
}
