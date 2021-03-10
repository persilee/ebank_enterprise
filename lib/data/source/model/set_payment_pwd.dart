/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 设置交易密码
/// Author: hlx
/// Date: 2020-12-02
///

import 'package:json_annotation/json_annotation.dart';

part 'set_payment_pwd.g.dart';

@JsonSerializable()
class SetPaymentPwdReq {
  @JsonKey(name: 'oldPayPassword')
  String oldPayPassword;

  @JsonKey(name: 'newPayPassword')
  String newPayPassword;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'verificationCode')
  String verificationCode;

  SetPaymentPwdReq(this.oldPayPassword, this.newPayPassword, this.userId,
      this.verificationCode);
  @override
  String toString() {
    return toJson().toString();
  }

  factory SetPaymentPwdReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SetPaymentPwdReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetPaymentPwdReqToJson(this);
}

@JsonSerializable()
class SetPaymentPwdResp extends Object {
  SetPaymentPwdResp();
  @override
  String toString() {
    return toJson().toString();
  }

  factory SetPaymentPwdResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SetPaymentPwdRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetPaymentPwdRespToJson(this);
}
