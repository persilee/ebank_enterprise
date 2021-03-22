/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 三步验证
/// Author: zhangqirong
/// Date: 2021-03-19

import 'package:json_annotation/json_annotation.dart';
part 'real_name_auth_by_three_factor.g.dart';

@JsonSerializable()
class RealNameAuthByThreeFactorReq extends Object {
  @JsonKey(name: 'certNo')
  String certNo;

  @JsonKey(name: 'certType')
  String certType;

  @JsonKey(name: 'userPhoneNo')
  String userPhoneNo;

  @JsonKey(name: 'realName')
  String realName;

  RealNameAuthByThreeFactorReq(
    this.certNo,
    this.certType,
    this.userPhoneNo,
    this.realName,
  );

  factory RealNameAuthByThreeFactorReq.fromJson(Map<String, dynamic> srcJson) =>
      _$RealNameAuthByThreeFactorReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RealNameAuthByThreeFactorReqToJson(this);
}

@JsonSerializable()
class RealNameAuthByThreeFactorResp extends Object {
  @JsonKey(name: 'enabled')
  bool enabled;

  RealNameAuthByThreeFactorResp(
    this.enabled,
  );

  factory RealNameAuthByThreeFactorResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$RealNameAuthByThreeFactorRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RealNameAuthByThreeFactorRespToJson(this);
}
