import 'package:json_annotation/json_annotation.dart';

part 'loan_prepayment_model.g.dart';

@JsonSerializable()
class LoanPrepaymentModelReq extends Object {
  //贷款合约
  @JsonKey(name: 'acNo')
  String acNo;
//贷款货币
  @JsonKey(name: 'ccy')
  String ccy;
//折算后的金额
  @JsonKey(name: 'eqAmt')
  double eqAmt;

//还利息金额
  @JsonKey(name: 'interestAmount')
  double interestAmount;
//贷款余额
  @JsonKey(name: 'outBal')
  double outBal;
//贷款本金
  @JsonKey(name: 'prin')
  double prin;
//还本金金额
  @JsonKey(name: 'principalAmount')
  double principalAmount;
// //还息方式
  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;
//结算方式
  // @JsonKey(name: 'setMethod')
  // String setMethod;
//结算货币
  @JsonKey(name: 'setlCcy')
  String setlCcy;
//实际还款金额
  @JsonKey(name: 'totalAmount')
  double totalAmount;
//还款帐号
  @JsonKey(name: 'ddAc')
  String ddAc;

  LoanPrepaymentModelReq(
    this.acNo,
    this.ccy,
    this.eqAmt,
    this.interestAmount,
    this.outBal,
    this.prin,
    this.principalAmount,
    this.repaymentMethod,
    // this.setMethod,
    this.setlCcy,
    this.totalAmount,
    this.ddAc,
  );

  factory LoanPrepaymentModelReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanPrepaymentModelReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanPrepaymentModelReqToJson(this);
}

@JsonSerializable()
class LoanPrepaymentModelResp extends Object {
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

  @JsonKey(name: 'eqAmt')
  String eqAmt;

  @JsonKey(name: 'exRate')
  String exRate;

  // @JsonKey(name: 'feeAmount')
  // int feeAmount;

  @JsonKey(name: 'intMode')
  String intMode;

  @JsonKey(name: 'interestAmount')
  String interestAmount;

  // @JsonKey(name: 'jrnNo')
  // int jrnNo;

  @JsonKey(name: 'msgType')
  String msgType;

  @JsonKey(name: 'nostrac')
  String nostrac;

  @JsonKey(name: 'outBal')
  String outBal;

  // @JsonKey(name: 'penaltyInterestAmount')
  // int penaltyInterestAmount;

  @JsonKey(name: 'prin')
  String prin;

  @JsonKey(name: 'principalAmount')
  String principalAmount;

  @JsonKey(name: 'repaymentAmount')
  String repaymentAmount;

  @JsonKey(name: 'setMethod')
  String setMethod;

  @JsonKey(name: 'setlCcy')
  String setlCcy;

  @JsonKey(name: 'suspeac')
  String suspeac;

  @JsonKey(name: 'trDate')
  String trDate;

  @JsonKey(name: 'trValDate')
  String trValDate;

  LoanPrepaymentModelResp(
    this.acNo,
    this.acState,
    this.ccy,
    this.ctaNo,
    this.ddAc,
    this.eqAmt,
    this.exRate,
    // this.feeAmount,
    this.intMode,
    this.interestAmount,
    // this.jrnNo,
    this.msgType,
    this.nostrac,
    this.outBal,
    // this.penaltyInterestAmount,
    this.prin,
    this.principalAmount,
    this.repaymentAmount,
    this.setMethod,
    this.setlCcy,
    this.suspeac,
    this.trDate,
    this.trValDate,
  );

  factory LoanPrepaymentModelResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanPrepaymentModelRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanPrepaymentModelRespToJson(this);
}
