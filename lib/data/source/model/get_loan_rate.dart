/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-08
import 'package:json_annotation/json_annotation.dart';

part 'get_loan_rate.g.dart';

@JsonSerializable()
class GetLoanRateReq extends Object {
  @JsonKey(name: 'productCodeList')
  List<String> productCodeList;

  GetLoanRateReq(
    this.productCodeList,
  );

  factory GetLoanRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanRateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanRateReqToJson(this);
}

@JsonSerializable()
class GetLoanRateResp extends Object {
  @JsonKey(name: 'ccyList')
  List<String> ccyList;

  @JsonKey(name: 'prodMastList')
  List<ProdMastList> prodMastList;

  GetLoanRateResp(
    this.ccyList,
    this.prodMastList,
  );

  factory GetLoanRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanRateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanRateRespToJson(this);
}

@JsonSerializable()
class ProdMastList extends Object {
  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'prodCcyList')
  List<ProdCcyList> prodCcyList;

  ProdMastList(
    this.engName,
    this.prodCcyList,
  );

  factory ProdMastList.fromJson(Map<String, dynamic> srcJson) =>
      _$ProdMastListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProdMastListToJson(this);
}

@JsonSerializable()
class ProdCcyList extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'fixedRate')
  String fixedRate;

  ProdCcyList(
    this.ccy,
    this.fixedRate,
  );

  factory ProdCcyList.fromJson(Map<String, dynamic> srcJson) =>
      _$ProdCcyListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProdCcyListToJson(this);
}
