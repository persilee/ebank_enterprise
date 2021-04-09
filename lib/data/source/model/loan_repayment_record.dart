import 'package:json_annotation/json_annotation.dart';

part 'loan_repayment_record.g.dart';

@JsonSerializable()
class LoanRepaymentRecordReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  // @JsonKey(name: 'ccy')
  // String ccy;

  // @JsonKey(name: 'ddAc')
  // String ddAc;

  // @JsonKey(name: 'eqAmt')
  // int eqAmt;

  // @JsonKey(name: 'exRate')
  // int exRate;

  // @JsonKey(name: 'intMode')
  // String intMode;

  // @JsonKey(name: 'nostrac')
  // String nostrac;

  // @JsonKey(name: 'outBal')
  // int outBal;

  // @JsonKey(name: 'prin')
  // int prin;

  // @JsonKey(name: 'repyInt')
  // int repyInt;

  // @JsonKey(name: 'repyPrin')
  // int repyPrin;

  // @JsonKey(name: 'repyTot')
  // int repyTot;

  // @JsonKey(name: 'setMethod')
  // String setMethod;

  // @JsonKey(name: 'setlCcy')
  // String setlCcy;

  // @JsonKey(name: 'suspeac')
  // String suspeac;

  LoanRepaymentRecordReq(
    this.acNo,
    // this.ccy,
    // this.ddAc,
    // this.eqAmt,
    // this.exRate,
    // this.intMode,
    // this.nostrac,
    // this.outBal,
    // this.prin,
    // this.repyInt,
    // this.repyPrin,
    // this.repyTot,
    // this.setMethod,
    // this.setlCcy,
    // this.suspeac,
  );

  factory LoanRepaymentRecordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRepaymentRecordReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRepaymentRecordReqToJson(this);
}

@JsonSerializable()
class LoanRepaymentRecordResp extends Object {
  @JsonKey(name: 'loanPrepaymentHistoryDTOList')
  List<LoanPrepaymentHistoryDTOList> loanPrepaymentHistoryDTOList;

  LoanRepaymentRecordResp(
    this.loanPrepaymentHistoryDTOList,
  );

  factory LoanRepaymentRecordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRepaymentRecordRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRepaymentRecordRespToJson(this);
}

@JsonSerializable()
class LoanPrepaymentHistoryDTOList extends Object {
  @JsonKey(name: 'delFlg')
  String delFlg;

  // @JsonKey(name: 'dueDt')
  // String dueDt;

  @JsonKey(name: 'fee')
  String fee;

  @JsonKey(name: 'iWaive')
  String iWaive;

  @JsonKey(name: 'ilaChg')
  String ilaChg;

  @JsonKey(name: 'intRat')
  String intRat;

  @JsonKey(name: 'jrnNo')
  int jrnNo;

  @JsonKey(name: 'osAmt')
  String osAmt;

  @JsonKey(name: 'pWaive')
  String pWaive;

  @JsonKey(name: 'payFlg')
  String payFlg;

  @JsonKey(name: 'payInt')
  String payInt;

  @JsonKey(name: 'payPrin')
  String payPrin;

  @JsonKey(name: 'payTerm')
  int payTerm;

  @JsonKey(name: 'plaChg')
  String plaChg;

  @JsonKey(name: 'prepayChg')
  String prepayChg;

  @JsonKey(name: 'structLength2')
  String structLength2;

  @JsonKey(name: 'trDt')
  String trDt;

  @JsonKey(name: 'trValDt')
  String trValDt;

  LoanPrepaymentHistoryDTOList(
    this.delFlg,
    // this.dueDt,
    this.fee,
    this.iWaive,
    this.ilaChg,
    this.intRat,
    this.jrnNo,
    this.osAmt,
    this.pWaive,
    this.payFlg,
    this.payInt,
    this.payPrin,
    this.payTerm,
    this.plaChg,
    this.prepayChg,
    this.structLength2,
    this.trDt,
    this.trValDt,
  );

  factory LoanPrepaymentHistoryDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanPrepaymentHistoryDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanPrepaymentHistoryDTOListToJson(this);
}
