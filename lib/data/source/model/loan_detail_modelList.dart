import 'package:json_annotation/json_annotation.dart';

part 'loan_detail_modelList.g.dart';

@JsonSerializable()
class LoanDetailMastModelReq extends Object {
//贷款账户
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'contactNo')
  String contactNo;

  @JsonKey(name: 'productCode')
  String productCode;

  LoanDetailMastModelReq(
    this.acNo,
    this.ciNo,
    this.contactNo,
    this.productCode,
  );
  factory LoanDetailMastModelReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanDetailMastModelReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanDetailMastModelReqToJson(this);
}

@JsonSerializable()
class LoanDetailMastModelResp extends Object {
  @JsonKey(name: 'lnAcMastAppDOList')
  List<LnAcMastAppDOList> lnAcMastAppDOList;

  LoanDetailMastModelResp(this.lnAcMastAppDOList);

  factory LoanDetailMastModelResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanDetailMastModelRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanDetailMastModelRespToJson(this);
}

@JsonSerializable()
class LnAcMastAppDOList extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'acType')
  String acType;

  @JsonKey(name: 'availableCredit')
  int availableCredit;

  @JsonKey(name: 'br')
  int br;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciName')
  String ciName;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'cityCd')
  String cityCd;

  @JsonKey(name: 'contactNo')
  String contactNo;

  @JsonKey(name: 'disbDate')
  String disbDate;

  @JsonKey(name: 'grade')
  String grade;

  @JsonKey(name: 'insTyp')
  String insTyp;

  @JsonKey(name: 'intRate')
  int intRate;

  @JsonKey(name: 'isMaturity')
  String isMaturity;

  @JsonKey(name: 'lmtNo')
  String lmtNo;

  @JsonKey(name: 'loanAmt')
  int loanAmt;

  @JsonKey(name: 'loanTyp')
  String loanTyp;

  @JsonKey(name: 'maturityDate')
  String maturityDate;

  @JsonKey(name: 'month')
  int month;

  @JsonKey(name: 'osAmt')
  int osAmt;

  @JsonKey(name: 'payAcNo')
  String payAcNo;

  @JsonKey(name: 'penInt')
  int penInt;

  @JsonKey(name: 'prodTyp')
  String prodTyp;

  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;

  @JsonKey(name: 'repaymentDay')
  int repaymentDay;

  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  @JsonKey(name: 'restPeriods')
  int restPeriods;

  @JsonKey(name: 'revolvin')
  String revolvin;

  @JsonKey(name: 'setPerd')
  int setPerd;

  @JsonKey(name: 'setUnit')
  String setUnit;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'termValue')
  int termValue;

  @JsonKey(name: 'unpaidPrincipal')
  int unpaidPrincipal;

  LnAcMastAppDOList(
    this.acNo,
    this.acType,
    this.availableCredit,
    this.br,
    this.ccy,
    this.ciName,
    this.ciNo,
    this.cityCd,
    this.contactNo,
    this.disbDate,
    this.grade,
    this.insTyp,
    this.intRate,
    this.isMaturity,
    this.lmtNo,
    this.loanAmt,
    this.loanTyp,
    this.maturityDate,
    this.month,
    this.osAmt,
    this.payAcNo,
    this.penInt,
    this.prodTyp,
    this.repaymentAcNo,
    this.repaymentDay,
    this.repaymentMethod,
    this.restPeriods,
    this.revolvin,
    this.setPerd,
    this.setUnit,
    this.status,
    this.termValue,
    this.unpaidPrincipal,
  );

  factory LnAcMastAppDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LnAcMastAppDOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LnAcMastAppDOListToJson(this);
}
