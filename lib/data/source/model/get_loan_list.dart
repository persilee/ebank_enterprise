/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-07

import 'package:json_annotation/json_annotation.dart';

part 'get_loan_list.g.dart';

@JsonSerializable()
class GetLoanListReq extends Object {
  //贷款账号
  @JsonKey(name: 'acNo')
  String acNo;

  //客户号
  @JsonKey(name: 'ciNo')
  String ciNo;

  //合约编号
  @JsonKey(name: 'contactNo')
  String contactNo;

  //产品号
  @JsonKey(name: 'productCode')
  String productCode;

  GetLoanListReq(
    this.acNo,
    this.ciNo,
    this.contactNo,
    this.productCode,
  );

  factory GetLoanListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanListReqToJson(this);
}

@JsonSerializable()
class GetLoanListResp extends Object {
  @JsonKey(name: 'lnAcMastAppDOList')
  List<Loan> loanList;

  GetLoanListResp(
    this.loanList,
  );

  factory GetLoanListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanListRespToJson(this);
}

@JsonSerializable()
class Loan extends Object {
  //贷款账号
  @JsonKey(name: 'acNo')
  String acNo;

  //机构代码
  @JsonKey(name: 'br')
  String br;

  //客户号
  @JsonKey(name: 'ciNo')
  String ciNo;

  //合约编号-合约账号
  @JsonKey(name: 'contactNo')
  String contactNo;

  //首次放款日期-开始时间
  @JsonKey(name: 'disbDate')
  String disbDate;

  //年利率-贷款利率
  @JsonKey(name: 'intRate')
  String intRate;

  //是否到期
  @JsonKey(name: 'isMaturity')
  String isMaturity;

  //货款金额-贷款本金
  @JsonKey(name: 'loanAmt')
  String loanAmt;

  //到期日期-结束时间
  @JsonKey(name: 'maturityDate')
  //LocalDate
  String maturityDate;

  //收款账号
  @JsonKey(name: 'payAcNo')
  String payAcNo;

  //还款账号
  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;

  //还款日
  @JsonKey(name: 'repaymentDay')
  int repaymentDay;

  //还款方法
  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  //剩余期数
  @JsonKey(name: 'restPeriods')
  int restPeriods;

  //期限
  @JsonKey(name: 'termValue')
  int termValue;

  //未还本金金额-贷款余额
  @JsonKey(name: 'unpaidPrincipal')
  String unpaidPrincipal;

  Loan(
    this.acNo,
    this.br,
    this.ciNo,
    this.contactNo,
    this.disbDate,
    this.intRate,
    this.isMaturity,
    this.loanAmt,
    this.maturityDate,
    this.payAcNo,
    this.repaymentAcNo,
    this.repaymentDay,
    this.repaymentMethod,
    this.restPeriods,
    this.termValue,
    this.unpaidPrincipal,
  );

  factory Loan.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
