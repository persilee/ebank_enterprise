/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款利率
/// Author: fangluyao
/// Date: 2020-12-08
import 'package:json_annotation/json_annotation.dart';

part 'get_loan_rate.g.dart';

@JsonSerializable()
class GetLoanRateReq extends Object {
  //产品代码列表
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
  //汇率列表
  @JsonKey(name: 'ccyList')
  List<String> ccyList;
  //产品目录
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
  //贷款名称（英文）
  @JsonKey(name: 'engName')
  String engName;
  //贷款名称（中文）
  @JsonKey(name: 'chnName')
  String chnName;

  //币种列表
  @JsonKey(name: 'prodCcyList')
  List<ProdCcyList> prodCcyList;

  ProdMastList(
    this.engName,
    this.chnName,
    this.prodCcyList,
  );

  factory ProdMastList.fromJson(Map<String, dynamic> srcJson) =>
      _$ProdMastListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProdMastListToJson(this);
}

@JsonSerializable()
class ProdCcyList extends Object {
  //币种
  @JsonKey(name: 'ccy')
  String ccy;

  //固定汇率
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
