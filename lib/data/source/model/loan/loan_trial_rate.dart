import 'package:json_annotation/json_annotation.dart';

part 'loan_trial_rate.g.dart';

@JsonSerializable()
class LoanTrailReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'payFre')
  String payFre;

  @JsonKey(name: 'payUnit')
  String payUnit;

  @JsonKey(name: 'paytyp')
  String paytyp;

  @JsonKey(name: 'prin')
  double prin;

  @JsonKey(name: 'rate')
  double rate;

  // @JsonKey(name: 'repDay')
  // int repDay;

  @JsonKey(name: 'totTerm')
  String totTerm;

  // @JsonKey(name: 'valDt')
  // String valDt;

  LoanTrailReq(
    this.ccy,
    this.payFre,
    this.payUnit,
    this.paytyp,
    this.prin,
    this.rate,
    // this.repDay,
    this.totTerm,
    // this.valDt,
  );

  factory LoanTrailReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanTrailReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanTrailReqToJson(this);
}

@JsonSerializable()
class LoanTrailResp extends Object {
  @JsonKey(name: 'loanTrialDTOList')
  List<LoanTrialDTOList> loanTrialDTOList;

  LoanTrailResp(
    this.loanTrialDTOList,
  );

  factory LoanTrailResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanTrailRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanTrailRespToJson(this);
}

@JsonSerializable()
class LoanTrialDTOList extends Object {
  //利息计算基数
  @JsonKey(name: 'calrStd')
  String calrStd;
//货币
  @JsonKey(name: 'ccy')
  String ccy;
//本利和金额
  @JsonKey(name: 'instAmt')
  String instAmt;
//下一还款日
  @JsonKey(name: 'nextPay')
  String nextPay;
//剩余本金
  @JsonKey(name: 'outBal')
  String outBal;
//还款金额
  @JsonKey(name: 'payAmt')
  String payAmt;
//还款日期
  @JsonKey(name: 'payDt')
  String payDt;
//还款频率
  @JsonKey(name: 'payFre')
  int payFre;
//利息
  @JsonKey(name: 'payInt')
  String payInt;
//本金
  @JsonKey(name: 'payPrin')
  String payPrin;
//还款频率单位
  @JsonKey(name: 'payUnit')
  String payUnit;
//还款方式
  @JsonKey(name: 'paytyp')
  String paytyp;
//贷款本金
  @JsonKey(name: 'prin')
  String prin;
//贷款利率
  @JsonKey(name: 'rate')
  String rate;
//指定还款日
  @JsonKey(name: 'repDay')
  int repDay;
//期数号
  @JsonKey(name: 'term')
  String term;
//总还款金额
  @JsonKey(name: 'totAmt')
  String totAmt;
//总利息
  @JsonKey(name: 'totInt')
  String totInt;
//总本金
  @JsonKey(name: 'totPri')
  String totPri;
//总期数
  @JsonKey(name: 'totTerm')
  int totTerm;
//起息日
  @JsonKey(name: 'valDt')
  String valDt;

  LoanTrialDTOList(
    this.calrStd,
    this.ccy,
    this.instAmt,
    this.nextPay,
    this.outBal,
    this.payAmt,
    this.payDt,
    this.payFre,
    this.payInt,
    this.payPrin,
    this.payUnit,
    this.paytyp,
    this.prin,
    this.rate,
    this.repDay,
    this.term,
    this.totAmt,
    this.totInt,
    this.totPri,
    this.totTerm,
    this.valDt,
  );

  factory LoanTrialDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanTrialDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanTrialDTOListToJson(this);
}
