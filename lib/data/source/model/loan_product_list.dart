import 'package:json_annotation/json_annotation.dart';

part 'loan_product_list.g.dart';

@JsonSerializable()
class LoanProductListReq extends Object {
  @JsonKey(name: 'statusNo')
  String statusNo;

  LoanProductListReq(
    this.statusNo,
  );

  factory LoanProductListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanProductListReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanProductListReqToJson(this);
}

@JsonSerializable()
class LoanProductListResp extends Object {
  @JsonKey(name: 'list')
  List<LoanProductList> loanProductList;

  LoanProductListResp(
    this.loanProductList,
  );

  factory LoanProductListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanProductListRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanProductListRespToJson(this);
}

@JsonSerializable()
class LoanProductList extends Object {
  @JsonKey(name: 'partRepaymentSign')
  String partRepaymentSign;

  @JsonKey(name: 'statusNo')
  String statusNo;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'interestSetlCycle')
  String interestSetlCycle;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'prodCategories')
  String prodCategories;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'delFlg')
  String delFlg;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'interestSetlCycleUnit')
  String interestSetlCycleUnit;

  @JsonKey(name: 'remark')
  String remark;

  LoanProductList(
    this.partRepaymentSign,
    this.statusNo,
    this.engName,
    this.interestSetlCycle,
    this.prodType,
    this.prodCategories,
    this.modifyTime,
    this.bppdCode,
    this.createTime,
    this.id,
    this.delFlg,
    this.ccy,
    this.lclName,
    this.interestSetlCycleUnit,
    this.remark,
  );

  factory LoanProductList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanProductListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoanProductListToJson(this);
}
