/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-23

import 'package:json_annotation/json_annotation.dart'; 
  
part 'post_repayment.g.dart';


@JsonSerializable()
  class PostRepaymentReq extends Object {

  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'dueAmount')
  String dueAmount;

  @JsonKey(name: 'instalNo')
  String instalNo;

  @JsonKey(name: 'interestAmount')
  String interestAmount;

  @JsonKey(name: 'penaltyAmount')
  String penaltyAmount;

  @JsonKey(name: 'principalAmount')
  String principalAmount;

  @JsonKey(name: 'prodCode')
  String prodCode;

  @JsonKey(name: 'refNo')
  String refNo;

  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;

  @JsonKey(name: 'repaymentAcType')
  String repaymentAcType;

  @JsonKey(name: 'repaymentCiName')
  String repaymentCiName;

  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  @JsonKey(name: 'rescheduleType')
  String rescheduleType;

  @JsonKey(name: 'totalAmount')
  String totalAmount;

  PostRepaymentReq(this.acNo,this.dueAmount,this.instalNo,this.interestAmount,this.penaltyAmount,this.principalAmount,this.prodCode,this.refNo,this.repaymentAcNo,this.repaymentAcType,this.repaymentCiName,this.repaymentMethod,this.rescheduleType,this.totalAmount,);

  factory PostRepaymentReq.fromJson(Map<String, dynamic> srcJson) => _$PostRepaymentReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PostRepaymentReqToJson(this);

}

@JsonSerializable()
  class PostRepaymentResp extends Object {

  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'acState')
  String acState;

  @JsonKey(name: 'feeAmount')
  String feeAmount;

  @JsonKey(name: 'interestAmount')
  String interestAmount;

  @JsonKey(name: 'penaltyInterestAmount')
  String penaltyInterestAmount;

  @JsonKey(name: 'principalAmount')
  String principalAmount;

  @JsonKey(name: 'repaymentAmount')
  String repaymentAmount;

  PostRepaymentResp(this.acNo,this.acState,this.feeAmount,this.interestAmount,this.penaltyInterestAmount,this.principalAmount,this.repaymentAmount,);

  factory PostRepaymentResp.fromJson(Map<String, dynamic> srcJson) => _$PostRepaymentRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PostRepaymentRespToJson(this);

}  
