/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: fangluyao
/// Date: 2020-12-22

import 'package:json_annotation/json_annotation.dart';

part 'loan_application.g.dart';

@JsonSerializable()
class LoanApplicationReq extends Object {
  //币种
  @JsonKey(name: 'ccy')
  String ccy;
  //客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
  //联系人
  @JsonKey(name: 'contact')
  String contact;
  //申请金额
  @JsonKey(name: 'intentAmt')
  double intentAmt;
  //贷款目的
  @JsonKey(name: 'loanPurpose')
  String loanPurpose;
  //联系人手机号
  @JsonKey(name: 'phone')
  String phone;
  //贷款产品码
  @JsonKey(name: 'prdtCode')
  String prdtCode;
  //备注
  @JsonKey(name: 'remark')
  String remark;
  //还款方式
  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;
  //期限单位
  @JsonKey(name: 'termUnit')
  String termUnit;
  //贷款期限
  @JsonKey(name: 'termValue')
  int termValue;
  //帐号名称
  @JsonKey(name: 'userAccount')
  String userAccount;
  //用户id
  @JsonKey(name: 'userId')
  String userId;
  //用户类型
  @JsonKey(name: 'userType')
  String userType;
  //还款帐号
  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;
  //收款帐号
  @JsonKey(name: 'payAcNo')
  String payAcNo;
  //利率
  @JsonKey(name: 'loanRate')
  String loanRate;

  LoanApplicationReq(
    this.ccy,
    this.ciNo,
    this.contact,
    this.intentAmt,
    this.loanPurpose,
    this.phone,
    this.prdtCode,
    this.remark,
    this.repaymentMethod,
    this.termUnit,
    this.termValue,
    this.userAccount,
    this.userId,
    this.userType,
    this.repaymentAcNo,
    this.payAcNo,
    this.loanRate,
  );

  factory LoanApplicationReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanApplicationReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanApplicationReqToJson(this);
}

@JsonSerializable()
class LoanApplicationResp extends Object {
  //可用金额
  @JsonKey(name: 'availableAmount')
  int availableAmount;
  //总金额
  @JsonKey(name: 'maxAmount')
  int maxAmount;
  //产品代码
  @JsonKey(name: 'prodCode')
  String prodCode;
  //产品英文名
  @JsonKey(name: 'prodEname')
  String prodEname;
  //产品本地名
  @JsonKey(name: 'prodName')
  String prodName;
  //利率
  @JsonKey(name: 'realTimeRate')
  int realTimeRate;
  //使用金额
  @JsonKey(name: 'usedAmount')
  int usedAmount;
  //手机号码
  @JsonKey(name: 'userPhone')
  String userPhone;

  LoanApplicationResp(
    this.availableAmount,
    this.maxAmount,
    this.prodCode,
    this.prodEname,
    this.prodName,
    this.realTimeRate,
    this.usedAmount,
    this.userPhone,
  );

  factory LoanApplicationResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanApplicationRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanApplicationRespToJson(this);
}
