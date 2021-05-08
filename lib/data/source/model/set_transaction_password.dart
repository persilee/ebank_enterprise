/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置交易密码--身份证验证
/// Author: hlx
/// Date: 2021-01-06

import 'package:json_annotation/json_annotation.dart';
part 'set_transaction_password.g.dart';

//提交身份验证信息
@JsonSerializable()
class SetTransactionPasswordReq {
  @JsonKey(name: 'actualName')
  String actualName;
  @JsonKey(name: 'cardNo')
  String cardNo;
  @JsonKey(name: 'certificateNo') //证件号
  String certificateNo;
  @JsonKey(name: 'certificateType') //证件类型
  String certificateType;
  @JsonKey(name: 'payPassword') //交易密码
  String payPassword;
  @JsonKey(name: 'phoneNumber') //手机号
  String phoneNumber;
  @JsonKey(name: 'userId') //用户Id
  String userId;
  @JsonKey(name: 'verify') //false
  bool verify;
  @JsonKey(name: 'smsCode')
  String smsCode;
  @JsonKey(name: 'userAccount')
  String userAccount;

  SetTransactionPasswordReq({
    this.certificateNo,
    this.certificateType,
    this.payPassword,
    this.phoneNumber,
    this.userId,
    this.userAccount,
    this.verify,
    this.smsCode,
    this.actualName,
    this.cardNo,
  });

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
