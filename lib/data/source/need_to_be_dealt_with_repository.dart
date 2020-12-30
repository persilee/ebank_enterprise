import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task_detail.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model/get_my_application.dart';

class NeedToBeDealtWithRepository {
  //授权记录
  Future<FindUserFinishedTaskResp> findUserFinishedTask(
      GetFindUserFinishedTaskReq req, String tag) {
    return request('/firmWkfl/processTask/findUserFinishedTask', req, tag,
        (data) => FindUserFinishedTaskResp.fromJson(data));
  }

  //授权记录详情
  Future<FindUserFinishedDetailResp> findUserFinishedDetail(
      GetFindUserFinishedDetailReq req, String tag) {
    return request('/firmWkfl/processTask/findHistoryTaskDetail', req, tag,
        (data) => FindUserFinishedDetailResp.fromJson(data));
  }

  //我的申请
  Future<MyApplicationResp> getMyApplication(
      GetMyApplicationReq req, String tag) {
    return request('/firmWkfl/processTask/findUserStartTask', req, tag,
        (data) => MyApplicationResp.fromJson(data));
  }

  static final _instance = NeedToBeDealtWithRepository._internal();
  factory NeedToBeDealtWithRepository() => _instance;

  NeedToBeDealtWithRepository._internal();
}
