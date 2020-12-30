/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'get_my_application.g.dart';

@JsonSerializable()
class GetMyApplicationReq extends Object {
  @JsonKey(name: 'finish')
  bool finish;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'processId')
  String processId;

  @JsonKey(name: 'processKey')
  String processKey;

  @JsonKey(name: 'processStatus')
  bool processStatus;

  @JsonKey(name: 'processTitle')
  String processTitle;

  @JsonKey(name: 'sort')
  String sort;

  @JsonKey(name: 'taskName')
  String taskName;
  GetMyApplicationReq(
    this.finish,
    this.page,
    this.pageSize,
    this.processId,
    this.processKey,
    this.processStatus,
    this.processTitle,
    this.sort,
    this.taskName,
  );

  factory GetMyApplicationReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetMyApplicationReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetMyApplicationReqToJson(this);
}

@JsonSerializable()
class MyApplicationResp extends Object {
  @JsonKey(name: 'sort')
  String sort;

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

  MyApplicationResp(
    this.sort,
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory MyApplicationResp.fromJson(Map<String, dynamic> srcJson) =>
      _$MyApplicationRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MyApplicationRespToJson(this);
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

  @JsonKey(name: 'createTime')
  String createTime;

  Rows(
    this.processId,
    this.processKey,
    this.processTitle,
    this.taskId,
    this.taskName,
    this.createTime,
  );
  factory Rows.fromJson(Map<String, dynamic> srcJson) =>
      _$RowsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$RowsToJson(this);
}
