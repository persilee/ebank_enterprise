/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 三步验证
/// Author: zhangqirong
/// Date: 2021-03-19

import 'package:json_annotation/json_annotation.dart';
part 'real_name_auth_by_three_factor.g.dart';

@JsonSerializable()
class RealNameAuthByThreeFactorReq extends Object {
  ///证件号
  @JsonKey(name: 'certNo')
  String certNo;

  ///证件类型
  @JsonKey(name: 'certType')
  String certType;

  ///用户手机号
  @JsonKey(name: 'phoneNo')
  String phoneNo;

  ///真实名称
  @JsonKey(name: 'realName')
  String realName;

  ///用户ID
  @JsonKey(name: "userId")
  String userId;

  ///1:个人   2：企业
  @JsonKey(name: 'userType')
  String userType;

  RealNameAuthByThreeFactorReq(
    this.certNo,
    this.certType,
    this.phoneNo,
    this.realName,
    this.userId, [
    this.userType = '2',
  ]);

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
