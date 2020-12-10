/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-08
import 'package:json_annotation/json_annotation.dart';

part 'loan_rate.g.dart';

@JsonSerializable()
class LoanRateReq extends Object {
  @JsonKey(name: 'productCodeList')
  List<String> productCodeList;

  LoanRateReq(
    this.productCodeList,
  );

  factory LoanRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanRateReqToJson(this);
}

@JsonSerializable()
class LoanRateResp extends Object {
  @JsonKey(name: 'ccyList')
  List<String> ccyList;

  @JsonKey(name: 'prodMastList')
  List<ProdMastList> prodMastList;

  LoanRateResp(
    this.ccyList,
    this.prodMastList,
  );

  factory LoanRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanRateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanRateRespToJson(this);
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
