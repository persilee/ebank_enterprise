import 'package:json_annotation/json_annotation.dart';

part 'query_fee.g.dart';

@JsonSerializable()
class QueryFeeReq extends Object {
  @JsonKey(name: 'ac')
  String ac;

  @JsonKey(name: 'amt')
  String amt;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciNo')
  String ciNo;

  QueryFeeReq(
    this.ac,
    this.amt,
    this.ccy,
    this.ciNo,
  );

  factory QueryFeeReq.fromJson(Map<String, dynamic> srcJson) =>
      _$QueryFeeReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QueryFeeReqToJson(this);
}

@JsonSerializable()
class QueryFeeResp extends Object {
  @JsonKey(name: 'recordLists')
  List<RecordLists> recordLists;

  @JsonKey(name: 'totalRows')
  String totalRows;

  QueryFeeResp(
    this.recordLists,
    this.totalRows,
  );

  factory QueryFeeResp.fromJson(Map<String, dynamic> srcJson) =>
      _$QueryFeeRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QueryFeeRespToJson(this);
}

@JsonSerializable()
class RecordLists extends Object {
  @JsonKey(name: 'feeC')
  String feeC;

  @JsonKey(name: 'pFee')
  String pFee;

  RecordLists(
    this.feeC,
    this.pFee,
  );

  factory RecordLists.fromJson(Map<String, dynamic> srcJson) =>
      _$RecordListsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecordListsToJson(this);
}
