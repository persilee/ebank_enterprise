/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///取消转账计划
/// Author: wangluyao
/// Date: 2021-01-14

import 'package:json_annotation/json_annotation.dart';

part 'delete_transfer_plan.g.dart';

@JsonSerializable()
class DeleteTransferPlanReq extends Object {
  @JsonKey(name: 'planId')
  String planId;

  DeleteTransferPlanReq(
    this.planId,
  );

  factory DeleteTransferPlanReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteTransferPlanReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteTransferPlanReqToJson(this);
}

@JsonSerializable()
class DeleteTransferPlanResp extends Object {
  @JsonKey(name: 'count')
  int count;

  DeleteTransferPlanResp(
    this.count,
  );

  factory DeleteTransferPlanResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteTransferPlanRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteTransferPlanRespToJson(this);
}
