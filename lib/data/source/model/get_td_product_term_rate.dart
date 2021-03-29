import 'package:json_annotation/json_annotation.dart';

part 'get_td_product_term_rate.g.dart';

@JsonSerializable()
class GetTdProductTermRateReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'prodCode')
  String prodCode;

  GetTdProductTermRateReq(
    this.ccy,
    this.prodCode,
  );

  factory GetTdProductTermRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdProductTermRateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdProductTermRateReqToJson(this);
}

@JsonSerializable()
class GetTdProductTermRateResp extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'minAmt')
  String minAmt;

  @JsonKey(name: 'maxAmt')
  String maxAmt;

  @JsonKey(name: 'recordLists')
  List<RecordLists> recordLists;

  GetTdProductTermRateResp(
    this.ccy,
    this.minAmt,
    this.maxAmt,
    this.recordLists,
  );

  factory GetTdProductTermRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdProductTermRateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdProductTermRateRespToJson(this);
}

@JsonSerializable()
class RecordLists extends Object {
  @JsonKey(name: 'term')
  String term;

  @JsonKey(name: 'intRat')
  String intRat;

  RecordLists(
    this.term,
    this.intRat,
  );

  factory RecordLists.fromJson(Map<String, dynamic> srcJson) =>
      _$RecordListsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecordListsToJson(this);
}
