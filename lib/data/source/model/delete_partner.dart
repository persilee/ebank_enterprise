/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-30

import 'package:json_annotation/json_annotation.dart';

part 'delete_partner.g.dart';

@JsonSerializable()
class DeletePartnerReq extends Object {
  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  DeletePartnerReq(
    this.custId,
    this.payeeCardNo,
  );

  factory DeletePartnerReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DeletePartnerReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeletePartnerReqToJson(this);
}

@JsonSerializable()
class DeletePartnerResp extends Object {
  @JsonKey(name: 'count')
  int count;

  DeletePartnerResp(
    this.count,
  );

  factory DeletePartnerResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DeletePartnerRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeletePartnerRespToJson(this);
}
