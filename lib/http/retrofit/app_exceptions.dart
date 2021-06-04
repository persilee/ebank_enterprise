import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_error_page.dart';
import 'package:flutter/material.dart';

/// 自定义异常
class AppException implements Exception {
  final String message;
  final String code;

  AppException([
    this.code,
    this.message,
  ]);

  @override
  String toString() {
    return 'AppException{message: $message, code: $code}';
  }

  factory AppException.create(DioError error) {
    print('error.type: ${error.type}');
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return error.error =
              AppException("-1", S.current.network_error_cancel);
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return error.error =
              AppException("-1", S.current.network_error_connect_timeout);
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return error.error =
              AppException("-1", S.current.network_error_send_timeout);
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return error.error =
              AppException("-1", S.current.network_error_receive_timeout);
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  return error.error =
                      AppException("400", S.current.network_error_http_400);
                }
                break;
              case 401:
                {
                  return error.error =
                      AppException("401", S.current.network_error_http_401);
                }
                break;
              case 403:
                {
                  return error.error =
                      AppException("403", S.current.network_error_http_403);
                }
                break;
              case 404:
                {
                  return error.error =
                      AppException("404", S.current.network_error_http_404);
                }
                break;
              case 405:
                {
                  return error.error =
                      AppException("405", S.current.network_error_http_405);
                }
                break;
              case 500:
                {
                  return error.error =
                      AppException("500", S.current.network_error_http_500);
                }
                break;
              case 502:
                {
                  return error.error =
                      AppException("502", S.current.network_error_http_502);
                }
                break;
              case 503:
                {
                  return error.error =
                      AppException("503", S.current.network_error_http_503);
                }
                break;
              case 505:
                {
                  return error.error =
                      AppException("505", S.current.network_error_http_505);
                }
                break;
              default:
                {
                  return error.error = AppException(
                      errCode.toString(), error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return error.error =
                AppException("-1", S.current.network_error_http_unknown);
          }
        }
        break;
      case DioErrorType.DEFAULT:
        {
          if (error.error is SocketException) {
            return error.error =
                AppException("-1", S.current.network_error_no_internet);
          } else if (error.error.code == 'SYS90018' ||
              error.error.code == 'SYS90017') {
            showDialog(
                barrierDismissible: false,
                context: navigatorKey.currentContext,
                builder: (context) {
                  return HsgAlertDialog(
                    title: S.current.warm_prompt,
                    message: error.error.code + ' ' + error.error.message,
                    positiveButton: S.current.confirm,
                  );
                }).then((value) {
              if (value == true) {
                navigatorKey.currentState.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginPage();
                  }),
                  (Route route) {
                    //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
                    if (route.settings?.name == "/") {
                      return true; //停止关闭
                    }
                    return false; //继续关闭
                  },
                );
              }
            });
            return error.error = NeedLogin();
          } else {
            return error.error;
          }
          // return error.error = AppException("-1", "网络异常，请稍后重试！");
        }
        break;
      default:
        {
          return error.error = AppException("-1", error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException([String code, String message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException([String code, String message]) : super(code, message);
}

abstract class BaseError {
  final String code;
  final String message;

  BaseError({this.code, this.message});
}

class NeedLogin extends AppException implements BaseError {
  @override
  String get code => '401';

  @override
  String get message => S.current.network_error_not_login;
}
