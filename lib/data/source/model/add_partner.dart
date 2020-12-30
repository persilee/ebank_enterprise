/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-28

import 'package:json_annotation/json_annotation.dart'; 
  
part 'add_partner.g.dart';

@JsonSerializable()
  class AddPartnerReq extends Object {

  @JsonKey(name: 'bankCode')
  String bankCode;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'midBankSwift')
  String midBankSwift;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'phoneNo')
  String phoneNo;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'transferType')
  String transferType;

  AddPartnerReq(this.bankCode,this.bankSwift,this.city,this.district,this.midBankSwift,this.payeeAddress,this.payeeCardNo,this.payeeName,this.payerBankCode,this.payerCardNo,this.payerName,this.phoneNo,this.remark,this.transferType,);

  factory AddPartnerReq.fromJson(Map<String, dynamic> srcJson) => _$AddPartnerReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddPartnerReqToJson(this);

}

@JsonSerializable()
  class AddPartnerResp extends Object {

  AddPartnerResp();

  factory AddPartnerResp.fromJson(Map<String, dynamic> srcJson) => _$AddPartnerRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddPartnerRespToJson(this);

}