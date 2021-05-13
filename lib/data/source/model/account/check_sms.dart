/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///手机号注册
/// Author: yanjiasong
/// Date: 2021-04/26

import 'package:json_annotation/json_annotation.dart';

part 'check_sms.g.dart';

@JsonSerializable()
class CheckSmsReq extends Object {
  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'smsType')
  String smsType;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'msgChnnl')
  String msgChnnl;

  CheckSmsReq(this.phone, this.smsType, this.smsCode, this.msgChnnl);

  factory CheckSmsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckSmsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckSmsReqToJson(this);
}

@JsonSerializable()
class CheckSmsResp extends Object {
  @JsonKey(name: 'checkResult')
  bool checkResult;

  CheckSmsResp(
    this.checkResult,
  );

  factory CheckSmsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckSmsRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckSmsRespToJson(this);
}
