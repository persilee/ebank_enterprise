/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'find_user_to_do_task.g.dart';

@JsonSerializable()
class FindUserToDoTaskReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  FindUserToDoTaskReq(
    this.page,
    this.pageSize,
  );

  factory FindUserToDoTaskReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserToDoTaskReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserToDoTaskReqToJson(this);
}

@JsonSerializable()
class FindUserToDoTaskResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<FindUserTaskDetail> rows;

  FindUserToDoTaskResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory FindUserToDoTaskResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserToDoTaskRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserToDoTaskRespToJson(this);
}

@JsonSerializable()
class FindUserTaskDetail extends Object {
  @JsonKey(name: 'processId')
  String processId;

  @JsonKey(name: 'processKey')
  String processKey;

  @JsonKey(name: 'processTitle')
  String processTitle;

  @JsonKey(name: 'taskId')
  String taskId;

  @JsonKey(name: 'taskName')
  String taskName;

  @JsonKey(name: 'startUser')
  String startUser;

  @JsonKey(name: 'createTime')
  String createTime;

  FindUserTaskDetail(
    this.processId,
    this.processKey,
    this.processTitle,
    this.taskId,
    this.taskName,
    this.startUser,
    this.createTime,
  );

  factory FindUserTaskDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserTaskDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserTaskDetailToJson(this);
}
