/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 验证交易密码
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:json_annotation/json_annotation.dart';

part 'verify_trade_password.g.dart';

@JsonSerializable()
class VerifyTransPwdNoSmsReq {
  @JsonKey(name: 'payPassword')
  String payPassword;

  VerifyTransPwdNoSmsReq(
    this.payPassword,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory VerifyTransPwdNoSmsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$VerifyTransPwdNoSmsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VerifyTransPwdNoSmsReqToJson(this);
}

@JsonSerializable()
class VerifyTransPwdNoSmsResp {
  VerifyTransPwdNoSmsResp();

  factory VerifyTransPwdNoSmsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$VerifyTransPwdNoSmsRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VerifyTransPwdNoSmsRespToJson(this);
}
