import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_all_finished_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

//@RestApi(baseUrl: 'http://161.189.48.75:5040') //dev
@RestApi(baseUrl: 'http://47.57.236.20:5040') //sit
//@RestApi(baseUrl: 'http://47.242.2.219:5040') //UAT
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// 查询属于我的待办任务
  @POST('/wkfl/processTask/findUserTodoTask')
  Future<FindUserTodoTaskModel> findUserTodoTask(
      @Body() FindTaskBody findTaskBody);

  /// 查询所有历史任务列表
  @POST('/wkfl/processTask/findAllFinishedTask')
  Future<FindAllFinishedTaskModel> findAllFinishedTask(
      @Body() FindTaskBody findTaskBody);

  /// 根据流程id查询待办任务详细信息
  @POST('/wkfl/processTask/findToDoTaskDetail')
  Future<dynamic> findToDoTaskDetail(
      @Body() FindTodoTaskDetailBody findTodoTaskDetailBody);

  @POST('/wkfl/processTask/findHistoryTaskDetail')
  Future<dynamic> findHistoryTaskDetail(
      @Body() FindTodoTaskDetailBody findTodoTaskDetailBody);

  /// 认领任务
  @POST('/wkfl/processTask/doClaimTask')
  Future<void> doClaimTask(@Body() FindTaskBody findTaskBody);

  /// 取消认领任务
  @POST('/wkfl/processTask/doUnclaimTask')
  Future<void> doUnclaimTask(@Body() FindTaskBody findTaskBody);

  /// 回退到发起人
  @POST('/wkfl/processTask/withdrawToStartTask')
  Future<void> withdrawToStartTask(@Body() FindTaskBody findTaskBody);

  /// 完成任务
  @POST('/wkfl/processTask/completeTask')
  Future<CompleteTaskModel> completeTask(
      @Body() CompleteTaskBody completeTaskBody);

  /// 查询我的处理记录待办任务
  @POST('/wkfl/processTask/findUserFinishedTask')
  Future<FindUserTodoTaskModel> findUserFinishedTask(
      @Body() FindTaskBody findTaskBody);

  /// 查询我的申请的流程列表
  @POST('/wkfl/processTask/findUserStartTask')
  Future<FindUserTodoTaskModel> findUserStartTask(
      @Body() FindTaskBody findTaskBody);

  /// 上传头像（开户图片上传暂时共用）
  @POST('/cust/user/uploadAvatar')
  Future<dynamic> uploadAvatar(
    @Queries() BaseBody baseBody,
    @Part(fileName: 'avatar.jpg') File file,
  );

  /// 银行信息管理-上传银行图标（开户图片上传暂时共用）
  @POST('/platform/bankInfo/uploadBankIcon')
  Future<dynamic> uploadBankIcon(
    @Queries() BaseBody baseBody,
    @Part(fileName: "certificate.jpg") List<int> file,
  );
}
