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
