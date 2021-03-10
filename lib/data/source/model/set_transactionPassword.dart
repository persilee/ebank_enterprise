/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置交易密码--身份证验证
/// Author: hlx
/// Date: 2021-01-06

import 'package:json_annotation/json_annotation.dart';
part 'set_transactionPassword.g.dart';

//提交身份验证信息
@JsonSerializable()
class SetTransactionPasswordReq {
  @JsonKey(name: 'actualName')
  String actualName;
  @JsonKey(name: 'cardNo') //卡号
  String cardNo;
  @JsonKey(name: 'certificateNo') //证件号
  String certificateNo;
  @JsonKey(name: 'certificateType') //证件类型
  String certificateType;
  @JsonKey(name: 'payPassword')
  String payPassword;
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;
  @JsonKey(name: 'userId')
  String userId;
  @JsonKey(name: 'verify')
  bool verify;
  @JsonKey(name: 'smsCode')
  String smsCode;

  SetTransactionPasswordReq(
      this.actualName,
      this.cardNo,
      this.certificateNo,
      this.certificateType,
      this.payPassword,
      this.phoneNumber,
      this.userId,
      this.verify,
      this.smsCode);

  @override
  String toString() {
    return toJson().toString();
  }

  factory SetTransactionPasswordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SetTransactionPasswordReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetTransactionPasswordReqToJson(this);
}

@JsonSerializable()
class SetTransactionPasswordResp {
  @JsonKey(name: 'enabled')
  bool enabled;

  SetTransactionPasswordResp(this.enabled);

  factory SetTransactionPasswordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SetTransactionPasswordRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetTransactionPasswordRespToJson(this);
}
