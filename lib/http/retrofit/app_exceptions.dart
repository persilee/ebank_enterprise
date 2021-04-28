import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
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
          return error.error = AppException("-1", "请求已被取消，请重新请求");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return error.error = AppException("-1", "网络连接超时，请检查网络设置");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return error.error = AppException("-1", "网络请求超时，请稍后重试！");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return error.error = AppException("-1", "响应超时，请稍后重试！");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  return error.error = AppException("400", "请求语法错误");
                }
                break;
              case 401:
                {
                  return error.error = AppException("401", "没有权限");
                }
                break;
              case 403:
                {
                  return error.error = AppException("403", "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return error.error = AppException("404", "无法连接服务器");
                }
                break;
              case 405:
                {
                  return error.error = AppException("405", "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return error.error = AppException("500", "服务器内部错误");
                }
                break;
              case 502:
                {
                  return error.error = AppException("502", "无效的请求");
                }
                break;
              case 503:
                {
                  return error.error = AppException("503", "服务器挂了");
                }
                break;
              case 505:
                {
                  return error.error = AppException("505", "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return error.error = AppException(
                      errCode.toString(), error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return error.error = AppException("-1", "未知错误");
          }
        }
        break;
      case DioErrorType.DEFAULT:
        {
          if (error.error.code == 'SYS90018' ||
              error.error.code == 'SYS90017') {
            navigatorKey.currentState.pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage();
                }), (Route route) {
              //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
              print(route.settings?.name);
              if (route.settings?.name == "/") {
                return true; //停止关闭
              }
              return false; //继续关闭
            });
            return error.error = NeedLogin();
          }
          if (error.error is SocketException) {
            return error.error = AppException("-1", "请查看是否连接网络！");
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
  String get message => "登录状态已失效，请重新登录！";
}
