import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    AppException appException = AppException.create(err);
    debugPrint('DioError===: ${appException.toString()}');
    err.error = appException;
    return super.onError(err);
  }
}