import 'package:json_annotation/json_annotation.dart';

part 'loan_repayment_confim.g.dart';

@JsonSerializable()
class LoanRepaymentConfimReq extends Object {
  //合约号
  @JsonKey(name: 'acNo')
  String acNo;

  //币种
  @JsonKey(name: 'ccy')
  String ccy;

  //还复利金额 利息罚息
  @JsonKey(name: 'compoundAmount')
  String compoundAmount;

  //活期账户
  @JsonKey(name: 'ddAc')
  String ddAc;

  //还利息金额
  @JsonKey(name: 'interestAmount')
  String interestAmount;

  //贷款余额
  @JsonKey(name: 'outBal')
  String outBal;

  // // 罚息金额
  @JsonKey(name: 'penaltyAmount')
  String penaltyAmount;

  //贷款本金
  @JsonKey(name: 'prin')
  String prin;

  //还本金金额
  @JsonKey(name: 'principalAmount')
  String principalAmount;

  //产品代码
  @JsonKey(name: 'prodCode')
  String prodCode;

  //实际还款金额
  @JsonKey(name: 'totalAmount')
  String totalAmount;

  //密码
  @JsonKey(name: 'payPassword')
  String payPassword;

  //还款日期
  @JsonKey(name: 'repaymentDay')
  String repaymentDay;

  LoanRepaymentConfimReq(
    this.acNo,
    this.ccy,
    this.compoundAmount,
    this.ddAc,
    this.interestAmount,
    this.outBal,
    this.penaltyAmount,
    this.prin,
    this.principalAmount,
    this.prodCode,
    this.totalAmount,
    this.payPassword,
    this.repaymentDay,
  );

  factory LoanRepaymentConfimReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRepaymentConfimReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRepaymentConfimReqToJson(this);
}

@JsonSerializable()
class LoanRepaymentConfimResp extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'acState')
  String acState;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ctaNo')
  String ctaNo;

  @JsonKey(name: 'ddAc')
  String ddAc;

  LoanRepaymentConfimResp(
      this.acNo, this.acState, this.ccy, this.ctaNo, this.ddAc);

  factory LoanRepaymentConfimResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRepaymentConfimRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRepaymentConfimRespToJson(this);
}
