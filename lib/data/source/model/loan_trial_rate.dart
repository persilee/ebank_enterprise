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
  @JsonKey(name: 'calrStd')
  String calrStd;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'instAmt')
  int instAmt;

  @JsonKey(name: 'nextPay')
  String nextPay;

  @JsonKey(name: 'outBal')
  int outBal;

  @JsonKey(name: 'payAmt')
  int payAmt;

  @JsonKey(name: 'payDt')
  String payDt;

  @JsonKey(name: 'payFre')
  int payFre;

  @JsonKey(name: 'payInt')
  int payInt;

  @JsonKey(name: 'payPrin')
  int payPrin;

  @JsonKey(name: 'payUnit')
  String payUnit;

  @JsonKey(name: 'paytyp')
  String paytyp;

  @JsonKey(name: 'prin')
  int prin;

  @JsonKey(name: 'rate')
  int rate;

  @JsonKey(name: 'repDay')
  int repDay;

  @JsonKey(name: 'term')
  String term;

  @JsonKey(name: 'totAmt')
  int totAmt;

  @JsonKey(name: 'totInt')
  int totInt;

  @JsonKey(name: 'totPri')
  int totPri;

  @JsonKey(name: 'totTerm')
  int totTerm;

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
