/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-11-25

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static void showToast(
    dynamic showContent,
  ) {
    SVProgressHUD.dismiss();

    AppException error;

    if (showContent is AppException) {
      error = showContent;
    } else if (showContent is DioError && showContent.error is AppException) {
      error = showContent.error;
    } else {
      showFluttertoast(S.current.error_tip_noDataError);
      return;
    }

    String errorStr = error.message ?? (error.code ?? '');
    //(error.code ?? '') + (error.message ?? '');
    if (error.code == 'SYS90018' ||
        error.code == 'SYS90017' ||
        error is NeedLogin) {
    } else {
      showFluttertoast(errorStr);
    }
  }

  static void showToastTip(
    String tipStr,
  ) {
    SVProgressHUD.dismiss();
    showFluttertoast(tipStr);
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

  // static void showInfo({String status}) {
  //   SVProgressHUD.showInfo(status: status);
  // }

  // static void showSuccess({String status}) {
  //   // SVProgressHUD.showSuccess(status: status);
  //   SVProgressHUD.dismiss();
  //   Fluttertoast.showToast(
  //     msg: status,
  //     // toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER, // 消息框弹出的位置
  //     // timeInSecForIosWeb: 1, // 消息框持续的时间（目前的版本只有ios有效）
  //     // backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
  //     // textColor: Colors.white,
  //     // fontSize: 16.0,
  //   );
  // }

  // static void showError({String status}) {
  //   // SVProgressHUD.showError(status: status);
  //   SVProgressHUD.dismiss();
  //   Fluttertoast.showToast(
  //     msg: status,
  //     // toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER, // 消息框弹出的位置
  //     // timeInSecForIosWeb: 1, // 消息框持续的时间（目前的版本只有ios有效）
  //     // backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
  //     // textColor: Colors.white,
  //     // fontSize: 16.0,
  //   );
  // }

  static void showImage({String status}) {
    SVProgressHUD.showImage(status: status);
  }

  static void showFluttertoast(String content) {
    Fluttertoast.showToast(
      msg: content,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
    );
  }
}
