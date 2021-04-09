import 'package:json_annotation/json_annotation.dart';

part 'loan_record_list_model.g.dart';

@JsonSerializable()
class LoanRecordListReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ddAc')
  String ddAc;

  @JsonKey(name: 'eqAmt')
  int eqAmt;

  @JsonKey(name: 'exRate')
  int exRate;

  @JsonKey(name: 'intMode')
  String intMode;

  @JsonKey(name: 'nostrac')
  String nostrac;

  @JsonKey(name: 'outBal')
  int outBal;

  @JsonKey(name: 'prin')
  int prin;

  @JsonKey(name: 'repyInt')
  int repyInt;

  @JsonKey(name: 'repyPrin')
  int repyPrin;

  @JsonKey(name: 'repyTot')
  int repyTot;

  @JsonKey(name: 'setMethod')
  String setMethod;

  @JsonKey(name: 'setlCcy')
  String setlCcy;

  @JsonKey(name: 'suspeac')
  String suspeac;

  @JsonKey(name: 'trValDate')
  String trValDate;

  LoanRecordListReq(
    this.acNo,
    this.ccy,
    this.ddAc,
    this.eqAmt,
    this.exRate,
    this.intMode,
    this.nostrac,
    this.outBal,
    this.prin,
    this.repyInt,
    this.repyPrin,
    this.repyTot,
    this.setMethod,
    this.setlCcy,
    this.suspeac,
    this.trValDate,
  );

  factory LoanRecordListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRecordListReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRecordListReqToJson(this);
}

@JsonSerializable()
class LoanRecordListResp extends Object {
  @JsonKey(name: 'loanPrepaymentHistoryDTOList')
  List<LoanPrepaymentHistoryDTOList> loanPrepaymentHistoryDTOList;

  LoanRecordListResp(
    this.loanPrepaymentHistoryDTOList,
  );

  factory LoanRecordListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRecordListRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRecordListRespToJson(this);
}

@JsonSerializable()
class LoanPrepaymentHistoryDTOList extends Object {
  @JsonKey(name: 'delFlg')
  String delFlg;

  @JsonKey(name: 'dueDt')
  String dueDt;

  @JsonKey(name: 'fee')
  int fee;

  @JsonKey(name: 'iWaive')
  int iWaive;

  @JsonKey(name: 'ilaChg')
  int ilaChg;

  @JsonKey(name: 'intRat')
  int intRat;

  @JsonKey(name: 'jrnNo')
  int jrnNo;

  @JsonKey(name: 'osAmt')
  int osAmt;

  @JsonKey(name: 'pWaive')
  int pWaive;

  @JsonKey(name: 'payFlg')
  String payFlg;

  @JsonKey(name: 'payInt')
  int payInt;

  @JsonKey(name: 'payPrin')
  int payPrin;

  @JsonKey(name: 'payTerm')
  int payTerm;

  @JsonKey(name: 'plaChg')
  int plaChg;

  @JsonKey(name: 'prepayChg')
  int prepayChg;

  @JsonKey(name: 'structLength2')
  String structLength2;

  @JsonKey(name: 'trDt')
  String trDt;

  @JsonKey(name: 'trValDt')
  String trValDt;

  LoanPrepaymentHistoryDTOList(
    this.delFlg,
    this.dueDt,
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
