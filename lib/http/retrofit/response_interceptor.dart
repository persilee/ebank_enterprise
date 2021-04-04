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
      if(baseResponse?.msgCd == 'SYS90018') {
        return Future.error(NeedLogin());
      }
      return Future.error(
          AppException(baseResponse?.msgCd, baseResponse?.msgInfo));
    }
    return super.onResponse(response);
  }
}
