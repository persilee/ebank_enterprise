import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/http/retrofit/base_response.dart';
import 'package:flutter/foundation.dart';

class ResponseInterceptor extends Interceptor {

  @override
  Future onResponse(Response response) {
    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    if (baseResponse.msgCd == '0000') {
      response.data = baseResponse.body;
    } else {
      return Future.error(BadResponseException(baseResponse?.msgCd ?? '-1',
          baseResponse?.msgInfo ?? 'response error'));
    }
    return super.onResponse(response);
  }
}
