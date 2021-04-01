import 'package:dio/dio.dart';

/// 自定义异常
class AppException implements Exception {
  final String _message;
  final String _code;

  AppException([
    this._code,
    this._message,
  ]);

  String toString() {
    return "_code:$_code message:$_message";
  }

  factory AppException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return BadRequestException("-1", "请求已被取消，请重新请求");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return BadRequestException("-1", "网络连接超时，请检查网络设置");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return BadRequestException("-1", "网络请求超时，请稍后重试！");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return BadRequestException("-1", "响应超时，请稍后重试！");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return BadRequestException("400", "请求语法错误");
                }
                break;
              case 401:
                {
                  return UnauthorisedException("401", "没有权限");
                }
                break;
              case 403:
                {
                  return UnauthorisedException("403", "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return UnauthorisedException("404", "无法连接服务器");
                }
                break;
              case 405:
                {
                  return UnauthorisedException("405", "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return UnauthorisedException("500", "服务器内部错误");
                }
                break;
              case 502:
                {
                  return UnauthorisedException("502", "无效的请求");
                }
                break;
              case 503:
                {
                  return UnauthorisedException("503", "服务器挂了");
                }
                break;
              case 505:
                {
                  return UnauthorisedException("505", "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return AppException(errCode.toString(), error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return AppException("-1", "未知错误");
          }
        }
        break;
      default:
        {
          return AppException("-1", error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException([String code, String message]) : super(code, message);
}

/// 响应错误
class BadResponseException extends AppException {
  BadResponseException([String code, String message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException([String code, String message]) : super(code, message);
}
