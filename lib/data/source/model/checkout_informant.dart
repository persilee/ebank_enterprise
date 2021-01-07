/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置支付密码--身份证验证
/// Author: hlx
/// Date: 2021-01-06

import 'package:json_annotation/json_annotation.dart';
part 'checkout_informant.g.dart';

//提交身份验证信息
@JsonSerializable()
class CheckoutInformantReq {
  @JsonKey(name: 'certNo')
  String certNo;
  @JsonKey(name: 'cardNo')
  String cardNo;
  @JsonKey(name: 'certType')
  String certType;
   @JsonKey(name: 'phoneNo')
  String phoneNo;
  @JsonKey(name: 'realName')
  String realName;
  @JsonKey(name: 'smsCode')
  String smsCode;

  CheckoutInformantReq(
    this.certNo,
    this.cardNo,
    this.certType,
    this.phoneNo,
    this.realName,
    this.smsCode
  );

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
  String phoneNo;

  CheckoutInformantResp(this.phoneNo);

  factory CheckoutInformantResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckoutInformantRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckoutInformantRespToJson(this);
}
