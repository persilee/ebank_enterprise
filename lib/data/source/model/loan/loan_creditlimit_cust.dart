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
  @JsonKey(name: 'allRepay')
  String allRepay; //提早全数还款罚款

  @JsonKey(name: 'avaBal')
  String avaBal; //可用余额

  @JsonKey(name: 'availDate')
  String availDate; //提款有效期

  @JsonKey(name: 'bsFeePct')
  String bsFeePct; //贸易融资手续费收取比率（%）

  @JsonKey(name: 'cexCAmt')
  String cexCAmt; //当前超额金额

  @JsonKey(name: 'commtFlg')
  String commtFlg; //承诺额度标志)

  @JsonKey(name: 'cumBal')
  String cumBal; // 累计使用结余

  @JsonKey(name: 'effDt')
  String effDt; //生效日

  @JsonKey(name: 'expDt')
  String expDt; //到期日

  @JsonKey(name: 'fLmt')
  String fLmt; //上层额度

  @JsonKey(name: 'feeAvg')
  String feeAvg; //最低月平均用款比例(%)

  @JsonKey(name: 'feeFlg')
  String feeFlg;

  @JsonKey(name: 'feePer')
  String feePer;
  
  @JsonKey(name: 'finRaPct')
  String finRaPct;//融资比例

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

  @JsonKey(name: 'lnCcy1')
  String lnCcy1;

  @JsonKey(name: 'lnCcy2')
  String lnCcy2;

  @JsonKey(name: 'lnCcy3')
  String lnCcy3;

  @JsonKey(name: 'lnCcy4')
  String lnCcy4;

  @JsonKey(name: 'lnCcy5')
  String lnCcy5;

  @JsonKey(name: 'lnExtFlg')
  String lnExtFlg;

  @JsonKey(name: 'lnFinalExpDate')
  String lnFinalExpDate;

  @JsonKey(name: 'lnInsType')
  String lnInsType; //还款方式

  @JsonKey(name: 'maxDdAmt')
  String maxDdAmt; //最高提款金额

  @JsonKey(name: 'minDdAmt')
  String minDdAmt; //最低提款金额

  @JsonKey(name: 'odAcNo')
  String odAcNo;

  @JsonKey(name: 'part_Repay')
  String partRepay;

  @JsonKey(name: 'payBnCyl')
  String payBnCyl;

  @JsonKey(name: 'payBnTp')
  String payBnTp;

  @JsonKey(name: 'payCly')
  String payCly;

  @JsonKey(name: 'payClyTp')
  String payClyTp;

  @JsonKey(name: 'penPer')
  String penPer;

  @JsonKey(name: 'rate1')
  String rate1;

  @JsonKey(name: 'rate2')
  String rate2;

  @JsonKey(name: 'rate3')
  String rate3;

  @JsonKey(name: 'rate4')
  String rate4;

  @JsonKey(name: 'rate5')
  String rate5;

  @JsonKey(name: 'rateTypBase1')
  String rateTypBase1;

  @JsonKey(name: 'rateTypBase2')
  String rateTypBase2;

  @JsonKey(name: 'rateTypBase3')
  String rateTypBase3;

  @JsonKey(name: 'rateTypBase4')
  String rateTypBase4;

  @JsonKey(name: 'rateTypBase5')
  String rateTypBase5;

  @JsonKey(name: 'rateTypHigh1')
  String rateTypHigh1;

  @JsonKey(name: 'rateTypHigh2')
  String rateTypHigh2;

  @JsonKey(name: 'rateTypHigh3')
  String rateTypHigh3;

  @JsonKey(name: 'rateTypHigh4')
  String rateTypHigh4;

  @JsonKey(name: 'rateTypHigh5')
  String rateTypHigh5;

  @JsonKey(name: 'sectionsFlg')
  String sectionsFlg;

  @JsonKey(name: 'spreadBase1')
  String spreadBase1;

  @JsonKey(name: 'spreadBase2')
  String spreadBase2;

  @JsonKey(name: 'spreadBase3')
  String spreadBase3;

  @JsonKey(name: 'spreadBase4')
  String spreadBase4;

  @JsonKey(name: 'spreadBase5')
  String spreadBase5;

  @JsonKey(name: 'spreadHigh1')
  String spreadHigh1;

  @JsonKey(name: 'spreadHigh2')
  String spreadHigh2;

  @JsonKey(name: 'spreadHigh3')
  String spreadHigh3;

  @JsonKey(name: 'spreadHigh4')
  String spreadHigh4;

  @JsonKey(name: 'spreadHigh5')
  String spreadHigh5;

  @JsonKey(name: 'tLmt')
  String tLmt;

  @JsonKey(name: 'tenorDays')
  String tenorDays; //月份 1 2 3 6 12前提是超过当前月份的期限都不显示

  @JsonKey(name: 'tenorUnit')
  String tenorUnit; //月份单位 M

  @JsonKey(name: 'useBal')
  String useBal;
  //币种列表
  @JsonKey(name: 'loanRateList')
  List<LoanRateList> loanRateList;

  GetCreditlimitByCusteDTOList(
    this.allRepay,
    this.avaBal,
    this.availDate,
    this.bsFeePct,
    this.cexCAmt,
    this.commtFlg,
    this.cumBal,
    this.effDt,
    this.expDt,
    this.fLmt,
    this.feeAvg,
    this.feeFlg,
    this.feePer,
    this.finRaPct,
    this.lmtAct,
    this.lmtCcy,
    this.lmtCd,
    this.lmtEmk,
    this.lmtLel,
    this.lmtMax,
    this.lmtNo,
    this.lmtNrvwDat,
    this.lmtUse,
    this.lnCcy1,
    this.lnCcy2,
    this.lnCcy3,
    this.lnCcy4,
    this.lnCcy5,
    this.lnExtFlg,
    this.lnFinalExpDate,
    this.lnInsType,
    this.maxDdAmt,
    this.minDdAmt,
    this.odAcNo,
    this.partRepay,
    this.payBnCyl,
    this.payBnTp,
    this.payCly,
    this.payClyTp,
    this.penPer,
    this.rate1,
    this.rate2,
    this.rate3,
    this.rate4,
    this.rate5,
    this.rateTypBase1,
    this.rateTypBase2,
    this.rateTypBase3,
    this.rateTypBase4,
    this.rateTypBase5,
    this.rateTypHigh1,
    this.rateTypHigh2,
    this.rateTypHigh3,
    this.rateTypHigh4,
    this.rateTypHigh5,
    this.sectionsFlg,
    this.spreadBase1,
    this.spreadBase2,
    this.spreadBase3,
    this.spreadBase4,
    this.spreadBase5,
    this.spreadHigh1,
    this.spreadHigh2,
    this.spreadHigh3,
    this.spreadHigh4,
    this.spreadHigh5,
    this.tLmt,
    this.tenorDays,
    this.tenorUnit,
    this.useBal,
    this.loanRateList,
  );
  factory GetCreditlimitByCusteDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCreditlimitByCusteDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetCreditlimitByCusteDTOListToJson(this);
}

@JsonSerializable()
class LoanRateList extends Object {
  @JsonKey(name: 'lnCcy')
  String lnCcy;

  @JsonKey(name: 'rate')
  String rate;

  @JsonKey(name: 'rateTypBase')
  String rateTypBase;

  @JsonKey(name: 'rateTypHigh')
  String rateTypHigh;

  @JsonKey(name: 'spreadBase')
  String spreadBase;

  @JsonKey(name: 'spreadHigh')
  String spreadHigh;

  LoanRateList(
    this.lnCcy,
    this.rate,
    this.rateTypBase,
    this.rateTypHigh,
    this.spreadBase,
    this.spreadHigh,
  );

  factory LoanRateList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRateListFromJson(srcJson);
}
