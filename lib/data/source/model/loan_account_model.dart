import 'package:json_annotation/json_annotation.dart';

part 'loan_account_model.g.dart';

@JsonSerializable()
class LoanAccountMastModelReq extends Object {
  //机构号
  @JsonKey(name: 'branch')
  int branch;
//客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
//贷款帐号
  @JsonKey(name: 'lnac')
  String lnac;

  LoanAccountMastModelReq(
    this.branch,
    this.ciNo,
    this.lnac,
  );

  factory LoanAccountMastModelReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanAccountMastModelReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanAccountMastModelReqToJson(this);
}

@JsonSerializable()
class LoanAccountMastModelResp extends Object {
  @JsonKey(name: 'loanAccountDOList')
  List<LoanAccountDOList> loanAccountDOList;

  LoanAccountMastModelResp(this.loanAccountDOList);

  factory LoanAccountMastModelResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanAccountMastModelRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanAccountMastModelRespToJson(this);
}

@JsonSerializable()
class LoanAccountDOList extends Object {
  @JsonKey(name: 'amt')
  String amt;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'bookBr')
  int bookBr;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciName')
  String ciName;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'clsDt')
  String clsDt;

  @JsonKey(name: 'endDt')
  String endDt;

  @JsonKey(name: 'lmtCcy')
  String lmtCcy;

  @JsonKey(name: 'lmtMamt')
  int lmtMamt;

  @JsonKey(name: 'lmtNo')
  String lmtNo;

  @JsonKey(name: 'lnSource')
  String lnSource;

  @JsonKey(name: 'lnUsaCd')
  String lnUsaCd;

  @JsonKey(name: 'lnac')
  String lnac;

  @JsonKey(name: 'prodTyp')
  String prodTyp;

  @JsonKey(name: 'revolving')
  String revolving;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'valDt')
  String valDt;

  LoanAccountDOList(
    this.amt,
    this.bal,
    this.bookBr,
    this.ccy,
    this.ciName,
    this.ciNo,
    this.clsDt,
    this.endDt,
    this.lmtCcy,
    this.lmtMamt,
    this.lmtNo,
    this.lnSource,
    this.lnUsaCd,
    this.lnac,
    this.prodTyp,
    this.revolving,
    this.status,
    this.valDt,
  );

  factory LoanAccountDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanAccountDOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanAccountDOListToJson(this);
}
