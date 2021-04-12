import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/error_interceptor.dart';
import 'package:ebank_mobile/http/retrofit/request_interceptor.dart';
import 'package:ebank_mobile/http/retrofit/response_interceptor.dart';
import 'package:ebank_mobile/util/log_util.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'header_interceptor.dart';

class BaseDio {
  BaseDio._();

  static BaseDio _instance;

  static BaseDio getInstance() {
    _instance ??= BaseDio._();

    return _instance;
  }

  Dio getDio() {
    final Dio dio = Dio();
    dio.options = BaseOptions(
        receiveTimeout: 30000, connectTimeout: 30000); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); // 添加拦截器，如 token之类，需要全局使用的参数
    dio.interceptors.add(ErrorInterceptor()); // 添加error拦截器
    dio.interceptors.add(ResponseInterceptor());
    dio.interceptors.add(RequestInterceptor());
    dio.interceptors.add(PrettyDioLogger(
      // 添加日志格式化工具类
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

    return dio;
  }
}
