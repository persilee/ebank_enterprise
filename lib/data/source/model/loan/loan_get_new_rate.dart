import 'package:json_annotation/json_annotation.dart';

part 'loan_get_new_rate.g.dart';

@JsonSerializable()
class LoanGetNewRateReq extends Object {
  @JsonKey(name: 'amt')
  double amt; //贷款本金

  @JsonKey(name: 'ccy')
  String ccy; //贷款货币

  @JsonKey(name: 'lnAc')
  String lnAc; //贷款账户

  @JsonKey(name: 'term')
  String term; //贷款期限(月)

  LoanGetNewRateReq(
    this.amt,
    this.ccy,
    this.lnAc,
    this.term,
  );

  factory LoanGetNewRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanGetNewRateReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanGetNewRateReqToJson(this);
}

@JsonSerializable()
class LoanGetNewRateResp extends Object {
  @JsonKey(name: 'acTvDt')
  String acTvDt; //罚息利率生效日期

  @JsonKey(name: 'amt')
  String amt; //贷款本金

  @JsonKey(name: 'ccy')
  String ccy; //贷款货币

  @JsonKey(name: 'endDt')
  String endDt; //贷款到期日

  @JsonKey(name: 'fPayDt')
  String fPayDt; //首次还息日期

  @JsonKey(name: 'floatUt')
  String floatUt; //利率浮动周期单位

  @JsonKey(name: 'fltNmTh')
  String fltNmTh; //浮动方式

  @JsonKey(name: 'fltOmTh')
  String fltOmTh; //罚息浮动方式

  @JsonKey(name: 'fltPed')
  String fltPed; //利率浮动周期

  @JsonKey(name: 'fstFld')
  String fstFld; //利率首次/下次浮动日期

  @JsonKey(name: 'graType')
  String graType; //宽限期处理方式

  @JsonKey(name: 'graceDt')
  String graceDt; //宽限期天数

  @JsonKey(name: 'iRatCd')
  String iRatCd; //参考利率类型

  @JsonKey(name: 'iRatTm')
  String iRatTm; //参考利率档期

  @JsonKey(name: 'inRate')
  String inRate; //合约利率

  @JsonKey(name: 'insType')
  String insType; //本利和公式

  @JsonKey(name: 'intOpEr')
  String intOpEr; //罚息百分比差

  @JsonKey(name: 'intPer')
  String intPer; //百分比差

  @JsonKey(name: 'intRat')
  String intRat; //参考利率

  @JsonKey(name: 'intSrt')
  String intSrt; //利率生效日期

  @JsonKey(name: 'intTyp')
  String intTyp; //利率浮动类型

  @JsonKey(name: 'lnAc')
  String lnAc; //贷款账户

  @JsonKey(name: 'onRate')
  String onRate; //点差

  @JsonKey(name: 'penIRat')
  String penIRat; //罚息利率

  @JsonKey(name: 'penRRat')
  String penRRat; //罚息参考利率类型

  @JsonKey(name: 'penSpr')
  String penSpr; //罚息点差

  @JsonKey(name: 'rePrcDt')
  String rePrcDt; //利率浮动指定日

  @JsonKey(name: 'repDay')
  String repDay; //还款指定日

  @JsonKey(name: 'repType')
  String repType; //还款方式

  @JsonKey(name: 'setPeRd')
  String setPeRd; //结息周期

  @JsonKey(name: 'setUnit')
  String setUnit; //结息周期单位

  @JsonKey(name: 'startDt')
  String startDt; //贷款生效日

  @JsonKey(name: 'term')
  String term; //贷款期限（月）

  LoanGetNewRateResp(
    this.acTvDt,
    this.amt,
    this.ccy,
    this.endDt,
    this.fPayDt,
    this.floatUt,
    this.fltNmTh,
    this.fltOmTh,
    this.fltPed,
    this.fstFld,
    this.graType,
    this.graceDt,
    this.iRatCd,
    this.iRatTm,
    this.inRate,
    this.insType,
    this.intOpEr,
    this.intPer,
    this.intRat,
    this.intSrt,
    this.intTyp,
    this.lnAc,
    this.onRate,
    this.penIRat,
    this.penRRat,
    this.penSpr,
    this.rePrcDt,
    this.repDay,
    this.repType,
    this.setPeRd,
    this.setUnit,
    this.startDt,
    this.term,
  );

  factory LoanGetNewRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanGetNewRateRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanGetNewRateRespToJson(this);
}
