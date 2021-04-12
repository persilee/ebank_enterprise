

import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';

class RequestInterceptor extends Interceptor {

  @override
  Future onRequest(RequestOptions options) {
    print('options: ${options.data is FormData}');
    if(options.data != null && !(options.data is FormData)) {
      BaseBody baseBody = BaseBody(body: options.data);
      options.data = baseBody.toJson();
    }
    return super.onRequest(options);
  }
}