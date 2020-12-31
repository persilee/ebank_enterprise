/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'find_user_finished_task.g.dart';

@JsonSerializable()
class GetFindUserFinishedTaskReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  GetFindUserFinishedTaskReq(
    this.page,
    this.pageSize,
  );

  factory GetFindUserFinishedTaskReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFindUserFinishedTaskReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetFindUserFinishedTaskReqToJson(this);
}

@JsonSerializable()
class FindUserFinishedTaskResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<Rows> rows;

  FindUserFinishedTaskResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory FindUserFinishedTaskResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserFinishedTaskRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FindUserFinishedTaskRespToJson(this);
}

@JsonSerializable()
class Rows extends Object {
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

  @JsonKey(name: 'assign')
  String assign;

  @JsonKey(name: 'startUser')
  String startUser;

  @JsonKey(name: 'createTime')
  String createTime;

  Rows(
    this.processId,
    this.processKey,
    this.processTitle,
    this.taskId,
    this.taskName,
    this.assign,
    this.startUser,
    this.createTime,
  );

  factory Rows.fromJson(Map<String, dynamic> srcJson) =>
      _$RowsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$RowsToJson(this);
}
