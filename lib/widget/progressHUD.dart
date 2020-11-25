import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

class HSProgressHUD {
  static void progressHudConfig() {
    SVProgressHUD.setBackgroundColor(Color.fromRGBO(0, 0, 0, 0.8));
    SVProgressHUD.setForegroundColor(Colors.white);
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear);
    SVProgressHUD.setMinimumDismissTimeInterval(1.0);
  }

  static void show({
    String status,
  }) {
    SVProgressHUD.show(status: status);
  }

  static void showProgress(
    num progress, {
    String status,
  }) {
    SVProgressHUD.showProgress(progress, status: status);
  }

  static void dismiss({Duration delay, VoidCallback completion}) {
    SVProgressHUD.dismiss(delay: delay, completion: completion);
  }

  static void showInfo({String status}) {
    SVProgressHUD.showInfo(status: status);
  }

  static void showSuccess({String status}) {
    SVProgressHUD.showSuccess(status: status);
  }

  static void showError({String status}) {
    SVProgressHUD.showError(status: status);
  }

  static void showImage({String status}) {
    SVProgressHUD.showImage(status: status);
  }
}
