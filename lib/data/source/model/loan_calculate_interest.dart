import 'package:json_annotation/json_annotation.dart';

part 'loan_calculate_interest.g.dart';

@JsonSerializable()
class LoanCalculateInterestReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'payFre')
  int payFre;

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

  @JsonKey(name: 'totTerm')
  int totTerm;

  @JsonKey(name: 'valDt')
  String valDt;

  LoanCalculateInterestReq(
    this.ccy,
    this.payFre,
    this.payUnit,
    this.paytyp,
    this.prin,
    this.rate,
    this.repDay,
    this.totTerm,
    this.valDt,
  );
  factory LoanCalculateInterestReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanCalculateInterestReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanCalculateInterestReqToJson(this);
}

@JsonSerializable()
class LoanCalculateInterestResp extends Object {
  @JsonKey(name: 'loanTrialDTOList')
  List<LoanTrialDTOList> loanTrialDTOList;

  LoanCalculateInterestResp(
    this.loanTrialDTOList,
  );

  factory LoanCalculateInterestResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanCalculateInterestRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanCalculateInterestRespToJson(this);
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
