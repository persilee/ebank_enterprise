/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///取消转账计划
/// Author: wangluyao
/// Date: 2021-01-14

import 'package:json_annotation/json_annotation.dart';

part 'cancel_transfer_plan.g.dart';

@JsonSerializable()
class CancelTransferPlanReq extends Object {
  @JsonKey(name: 'planId')
  String planId;

  CancelTransferPlanReq(
    this.planId,
  );

  factory CancelTransferPlanReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CancelTransferPlanReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CancelTransferPlanReqToJson(this);
}

@JsonSerializable()
class CancelTransferPlanResp extends Object {
  @JsonKey(name: 'count')
  int count;

  CancelTransferPlanResp(
    this.count,
  );

  factory CancelTransferPlanResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CancelTransferPlanRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CancelTransferPlanRespToJson(this);
}
