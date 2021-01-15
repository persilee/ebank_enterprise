/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///任务审批签收
/// Author: wangluyao
/// Date: 2021-01-11

import 'package:json_annotation/json_annotation.dart';

part 'do_claim_task.g.dart';

@JsonSerializable()
class DoClaimTaskReq extends Object {
  @JsonKey(name: 'taskId')
  String taskId;

  DoClaimTaskReq(
    this.taskId,
  );

  factory DoClaimTaskReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DoClaimTaskReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DoClaimTaskReqToJson(this);
}

@JsonSerializable()
class DoClaimTaskResp extends Object {
  DoClaimTaskResp();

  factory DoClaimTaskResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DoClaimTaskRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DoClaimTaskRespToJson(this);
}
