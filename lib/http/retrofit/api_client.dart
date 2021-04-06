import 'dart:io';

import 'package:ebank_mobile/data/source/model/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_body.dart';
import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'http://161.189.48.75:5040') //dev
// @RestApi(baseUrl: 'http://47.57.236.20:5040') //sit
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
  Future<FindUserTodoTaskModel> findUserTodoTask(
      @Body() FindUserTodoTaskBody findUserTodoTaskBody);

  /// 根据流程id查询待办任务详细信息
  @POST('/wkfl/processTask/findToDoTaskDetail')
  Future<dynamic> findToDoTaskDetail(
      @Body() FindTodoTaskDetailBody findTodoTaskDetailBody);

  /// 上传头像
  @POST('/cust/user/uploadAvatar')
  Future<dynamic> uploadAvatar(
    @Queries() BaseBody baseBody,
    @Part(fileName: 'avatar.jpg') File file,
  );

  /// 银行信息管理-上传银行图标（开户图片上传暂时共用）
  @POST('/platform/bankInfo/uploadBankIcon')
  Future<dynamic> uploadBankIcon(
    @Queries() BaseBody baseBody,
    // @Body() ResponseBody bytesBody,
    // @Part(fileName: "certificate.jpg") List<int> file
    @Part(fileName: 'certificate.jpg') File file,
  );
}
