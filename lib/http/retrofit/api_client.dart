import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:ebank_mobile/http/retrofit/base_response.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:ebank_mobile/data/source/model/find_to_do_task_detail_contract_model.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'http://161.189.48.75:5040')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// 登录
  @POST('/security/cutlogin')
  Future<LoginResp> login(@Body() BaseBody baseBody);

  /// 查询属于我的待办任务
  @POST('/wkfl/processTask/findUserTodoTask')
  Future<FindUserTodoTaskModel> findUserTodoTask(@Body() BaseBody baseBody);

  /// 根据流程id查询待办任务详细信息
  @POST('/wkfl/processTask/findToDoTaskDetail')
  Future<FindToDoTaskDetailContractModel> findToDoTaskDetail(
      @Body() BaseBody baseBody);

  /// 上传头像（开户图片上传暂时共用）
  @POST('/cust/user/uploadAvatar')
  Future<dynamic> uploadAvatar(
    @Part(fileName: 'avatar.jpg') File file,
  );
}
