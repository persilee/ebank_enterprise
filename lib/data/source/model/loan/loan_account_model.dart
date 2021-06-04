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
  //贷款金额
  @JsonKey(name: 'amt')
  String amt;
//贷款余额
  @JsonKey(name: 'bal')
  String bal;
//机构号
  @JsonKey(name: 'bookBr')
  int bookBr;
//币种
  @JsonKey(name: 'ccy')
  String ccy;
//客户名称
  @JsonKey(name: 'ciName')
  String ciName;
//客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
//销户日期
  @JsonKey(name: 'clsDt')
  String clsDt;
//结束日期
  @JsonKey(name: 'endDt')
  String endDt;
//最低提款币种
  @JsonKey(name: 'lmtCcy')
  String lmtCcy;
//最低提款金额
  @JsonKey(name: 'lmtMamt')
  int lmtMamt;
//额度号
  @JsonKey(name: 'lmtNo')
  String lmtNo;
//资金来源
  @JsonKey(name: 'lnSource')
  String lnSource;
//贷款用途
  @JsonKey(name: 'lnUsaCd')
  String lnUsaCd;
//贷款账户
  @JsonKey(name: 'lnac')
  String lnac;
//贷款产品
  @JsonKey(name: 'prodTyp')
  String prodTyp;
//额度循环类型
  @JsonKey(name: 'revolving')
  String revolving;
//状态
  @JsonKey(name: 'status')
  String status;
//开始日期
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
