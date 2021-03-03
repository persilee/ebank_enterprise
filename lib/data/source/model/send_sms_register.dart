/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///注册发送短信验证码
/// Author: wangluyao
/// Date: 2021-03-03

import 'package:json_annotation/json_annotation.dart';

part 'send_sms_register.g.dart';

@JsonSerializable()
class SendSmsRegisterReq extends Object {
  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'smsType')
  String smsType;

  SendSmsRegisterReq(
    this.areaCode,
    this.phoneNumber,
    this.smsType,
  );

  factory SendSmsRegisterReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsRegisterReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsRegisterReqToJson(this);
}

@JsonSerializable()
class SendSmsRegisterResp extends Object {
  SendSmsRegisterResp();

  factory SendSmsRegisterResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsRegisterRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsRegisterRespToJson(this);
}
