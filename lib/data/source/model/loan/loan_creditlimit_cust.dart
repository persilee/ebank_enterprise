import 'package:json_annotation/json_annotation.dart';

part 'loan_creditlimit_cust.g.dart';

@JsonSerializable()
class LoanGetCreditlimitReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'lmtNo')
  String lmtNo;

  @JsonKey(name: 'qLmtCtl')
  String qLmtCtl;

  LoanGetCreditlimitReq(
    this.acNo,
    this.ciNo,
    this.lmtNo,
    this.qLmtCtl,
  );

  factory LoanGetCreditlimitReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanGetCreditlimitReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanGetCreditlimitReqToJson(this);
}

@JsonSerializable()
class LoanGetCreditlimitResp extends Object {
  @JsonKey(name: 'getCreditlimitByCusteDTOList')
  List<GetCreditlimitByCusteDTOList> getCreditlimitByCusteDTOList;

  LoanGetCreditlimitResp(
    this.getCreditlimitByCusteDTOList,
  );

  factory LoanGetCreditlimitResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanGetCreditlimitRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanGetCreditlimitRespToJson(this);
}

@JsonSerializable()
class GetCreditlimitByCusteDTOList extends Object {
  @JsonKey(name: 'avaBal')
  String avaBal;

  @JsonKey(name: 'cexCAmt')
  String cexCAmt;

  @JsonKey(name: 'commtFlg')
  String commtFlg;

  @JsonKey(name: 'cumBal')
  String cumBal;

  @JsonKey(name: 'effDt')
  String effDt;

  @JsonKey(name: 'expDt')
  String expDt;

  @JsonKey(name: 'fLmt')
  String fLmt;

  @JsonKey(name: 'floatNMth')
  String floatNMth;

  @JsonKey(name: 'highRat')
  String highRat;

  @JsonKey(name: 'iratCd1')
  String iratCd1;

  @JsonKey(name: 'iratNPer')
  String iratNPer;

  @JsonKey(name: 'lmtAct')
  String lmtAct;

  @JsonKey(name: 'lmtCcy')
  String lmtCcy;

  @JsonKey(name: 'lmtCd')
  String lmtCd;

  @JsonKey(name: 'lmtEmk')
  String lmtEmk;

  @JsonKey(name: 'lmtLel')
  String lmtLel;

  @JsonKey(name: 'lmtMax')
  String lmtMax;

  @JsonKey(name: 'lmtNo')
  String lmtNo;

  @JsonKey(name: 'lmtNrvwDat')
  String lmtNrvwDat;

  @JsonKey(name: 'lmtUse')
  String lmtUse;

  @JsonKey(name: 'loanFee')
  String loanFee;

  @JsonKey(name: 'onRate')
  String onRate;

  @JsonKey(name: 'tLmt')
  String tLmt;

  @JsonKey(name: 'useBal')
  String useBal;

  GetCreditlimitByCusteDTOList(
    this.avaBal,
    this.cexCAmt,
    this.commtFlg,
    this.cumBal,
    this.effDt,
    this.expDt,
    this.fLmt,
    this.floatNMth,
    this.highRat,
    this.iratCd1,
    this.iratNPer,
    this.lmtAct,
    this.lmtCcy,
    this.lmtCd,
    this.lmtEmk,
    this.lmtLel,
    this.lmtMax,
    this.lmtNo,
    this.lmtNrvwDat,
    this.lmtUse,
    this.loanFee,
    this.onRate,
    this.tLmt,
    this.useBal,
  );

  factory GetCreditlimitByCusteDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCreditlimitByCusteDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetCreditlimitByCusteDTOListToJson(this);
}
