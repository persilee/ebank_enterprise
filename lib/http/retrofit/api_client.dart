

import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:retrofit/http.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '192.168.201.184:5041')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// 登录
  @POST('/security/cutlogin')
  Future<LoginResp> login(@Body() LoginReq loginReq);
}
