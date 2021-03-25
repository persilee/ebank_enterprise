import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

class HsgShowTip {
  static void loginTip({
    BuildContext context,
    Function(dynamic value) click,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.of(context).openAccount_notOpen_tips,
            message: S.of(context).openAccount_notOpen_content,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      click(value);
    });
  }
}
