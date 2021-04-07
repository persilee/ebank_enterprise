import 'package:json_annotation/json_annotation.dart';

part 'loan_prepayment_model.g.dart';

@JsonSerializable()
class LoanPrepaymentModelReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'compoundAmount')
  int compoundAmount;

  @JsonKey(name: 'ddAc')
  String ddAc;

  @JsonKey(name: 'dueAmount')
  int dueAmount;

  @JsonKey(name: 'eqAmt')
  int eqAmt;

  @JsonKey(name: 'exRate')
  int exRate;

  @JsonKey(name: 'instalNo')
  int instalNo;

  @JsonKey(name: 'interestAmount')
  int interestAmount;

  @JsonKey(name: 'nostrac')
  String nostrac;

  @JsonKey(name: 'outBal')
  int outBal;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'penaltyAmount')
  int penaltyAmount;

  @JsonKey(name: 'prin')
  int prin;

  @JsonKey(name: 'principalAmount')
  int principalAmount;

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

  @JsonKey(name: 'setMethod')
  String setMethod;

  @JsonKey(name: 'setlCcy')
  String setlCcy;

  @JsonKey(name: 'suspeac')
  String suspeac;

  @JsonKey(name: 'totalAmount')
  int totalAmount;

  @JsonKey(name: 'trValDate')
  String trValDate;

  LoanPrepaymentModelReq(
    this.acNo,
    this.ccy,
    this.compoundAmount,
    this.ddAc,
    this.dueAmount,
    this.eqAmt,
    this.exRate,
    this.instalNo,
    this.interestAmount,
    this.nostrac,
    this.outBal,
    this.payPassword,
    this.penaltyAmount,
    this.prin,
    this.principalAmount,
    this.prodCode,
    this.refNo,
    this.repaymentAcNo,
    this.repaymentAcType,
    this.repaymentCiName,
    this.repaymentMethod,
    this.rescheduleType,
    this.setMethod,
    this.setlCcy,
    this.suspeac,
    this.totalAmount,
    this.trValDate,
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
  int eqAmt;

  @JsonKey(name: 'exRate')
  int exRate;

  @JsonKey(name: 'feeAmount')
  int feeAmount;

  @JsonKey(name: 'intMode')
  String intMode;

  @JsonKey(name: 'interestAmount')
  int interestAmount;

  @JsonKey(name: 'jrnNo')
  int jrnNo;

  @JsonKey(name: 'msgType')
  String msgType;

  @JsonKey(name: 'nostrac')
  String nostrac;

  @JsonKey(name: 'outBal')
  int outBal;

  @JsonKey(name: 'penaltyInterestAmount')
  int penaltyInterestAmount;

  @JsonKey(name: 'prin')
  int prin;

  @JsonKey(name: 'principalAmount')
  int principalAmount;

  @JsonKey(name: 'repaymentAmount')
  int repaymentAmount;

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
    this.feeAmount,
    this.intMode,
    this.interestAmount,
    this.jrnNo,
    this.msgType,
    this.nostrac,
    this.outBal,
    this.penaltyInterestAmount,
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
