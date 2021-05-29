import 'package:json_annotation/json_annotation.dart';

part 'loan_trail_commit.g.dart';

@JsonSerializable()
class LoanTrailCommitReq extends Object {
  //贷款账户
  @JsonKey(name: 'lnac')
  String lnac;
  //贷款货币
  @JsonKey(name: 'ccy')
  String ccy;
  //贷款本金 ,
  @JsonKey(name: 'amt')
  double amt;
  //利率代码 ,
  @JsonKey(name: 'iratCd')
  String iratCd;
  //贷款期限 利率档期
  @JsonKey(name: 'iratTm')
  String iratTm;
  //参考利率
  @JsonKey(name: 'intRat')
  double intRat;
  //浮动方式
  @JsonKey(name: 'fltNmth')
  String fltNmth;
  //点差
  @JsonKey(name: 'onRate')
  double onRate;
  //百分比差
  @JsonKey(name: 'intNper')
  int intNper;
  //合约利率
  @JsonKey(name: 'inRate')
  double inRate;
  //放款活期账户
  @JsonKey(name: 'ddAc')
  String ddAc;
  //还款方式
  @JsonKey(name: 'repType')
  String repType;
  //本利和公式
  @JsonKey(name: 'insType')
  String insType;
  //结息周期
  @JsonKey(name: 'setPerd')
  String setPerd;
  //结息周期单位
  @JsonKey(name: 'setUnit')
  String setUnit;
  //首次还息日期
  @JsonKey(name: 'fPaydt')
  String fPaydt;
  //还款指定日
  @JsonKey(name: 'repDay')
  int repDay;
  //贷款到期日
  @JsonKey(name: 'matuDt')
  String matuDt;
  //可借款额度
  @JsonKey(name: 'loanAmount')
  String loanAmount;
  //总利息
  // @JsonKey(name: 'totalInt')
  // String totalInt;
  //贷款用途
  @JsonKey(name: 'loanPurpose')
  String loanPurpose;

  //额度接口的还款方式
  @JsonKey(name: 'lnInsType')
  String lnInsType;

  LoanTrailCommitReq(
      this.lnac,
      this.ccy,
      this.amt,
      this.iratCd,
      this.iratTm,
      this.intRat,
      this.fltNmth,
      this.onRate,
      this.intNper,
      this.inRate,
      this.ddAc,
      this.repType,
      this.insType,
      this.setPerd,
      this.setUnit,
      this.fPaydt,
      this.repDay,
      this.matuDt,
      this.loanAmount,
      // this.totalInt,
      this.loanPurpose,
      this.lnInsType);

  factory LoanTrailCommitReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanTrailCommitReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanTrailCommitReqToJson(this);
}

@JsonSerializable()
class LoanTrailCommitResp extends Object {
  @JsonKey(name: 'amt')
  String amt;

  @JsonKey(name: 'apexRt')
  String apexRt;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ctaNo')
  String ctaNo;

  @JsonKey(name: 'ddAc')
  String ddAc;

  @JsonKey(name: 'ddAc2')
  String ddAc2;

  @JsonKey(name: 'drEqAmt')
  String drEqAmt;

  @JsonKey(name: 'inRate')
  String inRate;

  @JsonKey(name: 'jrnNo')
  int jrnNo;

  @JsonKey(name: 'lnac')
  String lnac;

  @JsonKey(name: 'matuDt')
  String matuDt;

  @JsonKey(name: 'nostrAc')
  String nostrAc;

  @JsonKey(name: 'payCcy')
  String payCcy;

  @JsonKey(name: 'penIrat')
  String penIrat;

  @JsonKey(name: 'recCcy')
  String recCcy;

  @JsonKey(name: 'rollFlg')
  String rollFlg;

  @JsonKey(name: 'setMeh')
  String setMeh;

  @JsonKey(name: 'setMeh2')
  String setMeh2;

  @JsonKey(name: 'startDt')
  String startDt;

  @JsonKey(name: 'suspeAc')
  String suspeAc;

  @JsonKey(name: 'tradeDt')
  String tradeDt;

  LoanTrailCommitResp(
    this.amt,
    this.apexRt,
    this.ccy,
    this.ctaNo,
    this.ddAc,
    this.ddAc2,
    this.drEqAmt,
    this.inRate,
    this.jrnNo,
    this.lnac,
    this.matuDt,
    this.nostrAc,
    this.payCcy,
    this.penIrat,
    this.recCcy,
    this.rollFlg,
    this.setMeh,
    this.setMeh2,
    this.startDt,
    this.suspeAc,
    this.tradeDt,
  );

  factory LoanTrailCommitResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanTrailCommitRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanTrailCommitRespToJson(this);
}
