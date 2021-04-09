import 'package:json_annotation/json_annotation.dart';

part 'loan_applyfor_list.g.dart';

@JsonSerializable()
class LoanApplyFoyListReq extends Object {
  @JsonKey(name: 'userId')
  String userId;

  LoanApplyFoyListReq(
    this.userId,
  );

  factory LoanApplyFoyListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanApplyFoyListReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanApplyFoyListReqToJson(this);
}

@JsonSerializable()
class LoanApplyFoyListResp extends Object {
  @JsonKey(name: 'loanRecordDOList')
  List<LoanRecordDOList> loanRecordDOList;

  LoanApplyFoyListResp(
    this.loanRecordDOList,
  );

  factory LoanApplyFoyListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanApplyFoyListRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanApplyFoyListRespToJson(this);
}

@JsonSerializable()
class LoanRecordDOList extends Object {
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'custid')
  String custid;

  @JsonKey(name: 'prdtCode')
  String prdtCode;

  @JsonKey(name: 'intentAmt')
  String intentAmt;

  @JsonKey(name: 'termValue')
  int termValue;

  @JsonKey(name: 'termUnit')
  String termUnit;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'loanPurpse')
  String loanPurpse;

  @JsonKey(name: 'payAcno')
  String payAcno;

  @JsonKey(name: 'repaymentAcno')
  String repaymentAcno;

  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  @JsonKey(name: 'loanRate')
  String loanRate;

  @JsonKey(name: 'contact')
  String contact;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'userType')
  String userType;

  @JsonKey(name: 'remark')
  String remark;

  LoanRecordDOList(
    this.modifyTime,
    this.createTime,
    this.id,
    this.custid,
    this.prdtCode,
    this.intentAmt,
    this.termValue,
    this.termUnit,
    this.ccy,
    this.loanPurpse,
    this.payAcno,
    this.repaymentAcno,
    this.repaymentMethod,
    this.loanRate,
    this.contact,
    this.phone,
    this.userType,
    this.remark,
  );

  factory LoanRecordDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRecordDOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanRecordDOListToJson(this);
}
