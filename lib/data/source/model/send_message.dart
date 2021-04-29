/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///手机号注册
/// Author: yanjiasong
/// Date: 2021-04/26

import 'package:json_annotation/json_annotation.dart';

part 'send_message.g.dart';

@JsonSerializable()
class SendMessageReq extends Object {
  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'smsType')
  String smsType;

  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'smsTemplateId')
  String smsTemplateId;

  @JsonKey(name: 'msgChnnl')
  String msgChnnl;

  @JsonKey(name: 'msgBankId')
  String msgBankId;

  SendMessageReq(this.areaCode, this.phoneNumber, this.smsType,
      this.userAccount, this.smsTemplateId, this.msgChnnl,
      {this.msgBankId});

  factory SendMessageReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SendMessageReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendMessageReqToJson(this);
}

@JsonSerializable()
class SendMessageResp extends Object {
  @JsonKey(name: 'smsCode')
  String smsCode;

  SendMessageResp(
    this.smsCode,
  );

  factory SendMessageResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SendMessageRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendMessageRespToJson(this);
}
