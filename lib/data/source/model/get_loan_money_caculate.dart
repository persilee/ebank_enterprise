/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-22
import 'package:json_annotation/json_annotation.dart'; 
  
part 'get_loan_money_caculate.g.dart';

@JsonSerializable()
  class GetLoanCaculateReq extends Object {

  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'instalNo')
  String instalNo;

  @JsonKey(name: 'isInterestCharge')
  String isInterestCharge;

  @JsonKey(name: 'principalAmount')
  String principalAmount;

  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  @JsonKey(name: 'rescheduleType')
  String rescheduleType;

  GetLoanCaculateReq(this.acNo,this.instalNo,this.isInterestCharge,this.principalAmount,this.repaymentMethod,this.rescheduleType,);

  factory GetLoanCaculateReq.fromJson(Map<String, dynamic> srcJson) => _$GetLoanCaculateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanCaculateReqToJson(this);

}

@JsonSerializable()
  class GetLoanCaculateResp extends Object {

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

  @JsonKey(name: 'repaymentDate')
  String repaymentDate;

  GetLoanCaculateResp(this.feeAmount,this.interestAmount,this.penaltyInterestAmount,this.principalAmount,this.repaymentAmount,this.repaymentDate,);

  factory GetLoanCaculateResp.fromJson(Map<String, dynamic> srcJson) => _$GetLoanCaculateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanCaculateRespToJson(this);

}
