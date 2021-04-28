import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/http/retrofit/base_response.dart';
import 'package:flutter/foundation.dart';

class ResponseInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    if (response.data is Map && response.request.path != '/security/cutlogin') {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      print(baseResponse.toJson());
      if (baseResponse.msgCd == '0000') {
        response.data = baseResponse.body;
      } else {
        if (baseResponse?.msgCd == 'SYS90018' ||
            baseResponse?.msgCd == 'SYS90017') {
          return Future.error(NeedLogin());
        }
        return Future.error(
            AppException(baseResponse?.msgCd, baseResponse?.msgInfo));
      }
    }
    return super.onResponse(response);
  }
}
