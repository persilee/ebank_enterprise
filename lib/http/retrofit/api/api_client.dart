import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/approval/card_bal_by_card_no_body.dart';
import 'package:ebank_mobile/data/source/model/approval/card_bal_by_card_no_model.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_all_finished_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_application_task_detail.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/publicCode/tdep_products_body.dart';
import 'package:ebank_mobile/data/source/model/approval/publicCode/tdep_products_model.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/statement/statement_query_list_body.dart';
import 'package:ebank_mobile/data/source/model/statement/statement_query_list_model.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// 我的申请详情
  @POST('/firmWkfl/processTask/findHistoryTaskDetail')
  Future<FindUserApplicationDetailResp> findUserApplicationDetail(
      @Body() FindUserApplicationDetailReq findTaskBody);

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
  Future<dynamic> completeTask(@Body() CompleteTaskBody completeTaskBody);

  /// 查询我的处理记录待办任务
  @POST('/wkfl/processTask/findUserFinishedTask')
  Future<FindUserTodoTaskModel> findUserFinishedTask(
      @Body() FindTaskBody findTaskBody);

  /// 查询我的申请的流程列表
  @POST('/wkfl/processTask/findUserStartTask')
  Future<FindUserTodoTaskModel> findUserStartTask(
      @Body() FindTaskBody findTaskBody);

  /// 汇率换算
  @POST('/ddep/transfer/transferTrial')
  Future<TransferTrialResp> transferTrial(
      @Body() TransferTrialReq transferTrialReq);

  /// 电子结单列表查询
  @POST('/general/statement/queryList')
  Future<StatementQueryListModel> statementQueryList(
      @Body() StatementQueryListBody statementQueryListBody);

  /// 电子结单下载
  @GET('/general/statement/downLoad')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> statementDownLoad(@Query('internalId') String internalId);

  /// 获取用户信息
  @POST('/cust/user/getUser')
  Future<UserInfoResp> getUserInfo(@Body() GetUserInfoReq getUserInfoReq);

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

  /*****************公共代码******************/
  /// 查询定期产品名称
  @POST('/tdep/timeDeposit/getTdepProductsByPage')
  Future<TdepProductsModel> getTdepProductsByPage(
      @Body() TdepProductsBody tdepProductsBody);

  /// 查询可用余额
  @POST('/cust/bankcard/getCardBalByCardNo')
  Future<CardBalByCardNoModel> getCardBalByCardNo(
      @Body() CardBalByCardNoBody cardBalByCardNoBody);
}
