/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取验证码--通过手机号
/// Author: hlx
/// Date: 2021-01-13

import 'package:json_annotation/json_annotation.dart';
part 'get_verificationByPhone_code.g.dart';


//根据账户获取验证码
@JsonSerializable()
class SendSmsByPhoneNumberReq {
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'smsType')
  String smsType;

  

  SendSmsByPhoneNumberReq(
    this.phoneNumber,
    this.smsType
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory SendSmsByPhoneNumberReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsByPhoneNumberReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsByPhoneNumberReqToJson(this);
}

@JsonSerializable()
class SendSmsByPhoneNumberResp {
  @JsonKey(name: 'phoneNo')
  @JsonKey(name: 'smsType')
  String phoneNo;
  String smsType;

  SendSmsByPhoneNumberResp(this.phoneNo);

  factory SendSmsByPhoneNumberResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsByPhoneNumberRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsByPhoneNumberRespToJson(this);
}
