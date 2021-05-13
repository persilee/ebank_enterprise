/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置交易密码--身份证验证
/// Author: hlx
/// Date: 2021-01-06

import 'package:json_annotation/json_annotation.dart';
part 'checkout_informant.g.dart';

//提交身份验证信息
@JsonSerializable()
class CheckoutInformantReq {
  @JsonKey(name: 'certNo') //证件号
  String certNo;
  @JsonKey(name: 'cardNo') //卡号
  String cardNo;
  @JsonKey(name: 'certType') //证件类型
  String certType;
  @JsonKey(name: 'phoneNo')
  String phoneNo;
  @JsonKey(name: 'realName')
  String realName;
  @JsonKey(name: 'smsCode')
  String smsCode;
  @JsonKey(name: 'payPassword')
  String payPassword;

  CheckoutInformantReq(this.certNo, this.cardNo, this.certType, this.phoneNo,
      this.realName, this.smsCode, this.payPassword);

  @override
  String toString() {
    return toJson().toString();
  }

  factory CheckoutInformantReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckoutInformantReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckoutInformantReqToJson(this);
}

@JsonSerializable()
class CheckoutInformantResp {
  @JsonKey(name: 'enabled')
  bool enabled;

  CheckoutInformantResp(this.enabled);

  factory CheckoutInformantResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckoutInformantRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckoutInformantRespToJson(this);
}
