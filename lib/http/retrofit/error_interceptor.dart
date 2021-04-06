import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    var e = err.error;
    AppException appException = AppException.create(err);
    e = appException;
    return super.onError(err);
  }
}