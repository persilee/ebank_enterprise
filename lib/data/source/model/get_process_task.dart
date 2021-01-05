/*
 * 
 * Created Date: Tuesday, January 5th 2021, 5:16:46 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2021 Your Company
 */

import 'package:json_annotation/json_annotation.dart';

part 'get_process_task.g.dart';

@JsonSerializable()
class GetProcessTaskReq extends Object {
  @JsonKey(name: 'approveResult')
  bool approveResult;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: 'rejectToStart')
  bool rejectToStart;

  @JsonKey(name: 'taskId')
  String taskId;

  GetProcessTaskReq(
    this.approveResult,
    this.comment,
    this.rejectToStart,
    this.taskId,
  );

  factory GetProcessTaskReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetProcessTaskReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetProcessTaskReqToJson(this);
}

@JsonSerializable()
class ProcessTaskResp extends Object {
  ProcessTaskResp();

  factory ProcessTaskResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ProcessTaskRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$ProcessTaskRespToJson(this);
}
