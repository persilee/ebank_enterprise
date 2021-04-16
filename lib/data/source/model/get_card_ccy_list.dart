import 'package:json_annotation/json_annotation.dart';

part 'get_card_ccy_list.g.dart';

@JsonSerializable()
class GetCardCcyListReq extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetCardCcyListReq(
    this.cardNo,
  );

  factory GetCardCcyListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardCcyListReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetCardCcyListReqToJson(this);
}

@JsonSerializable()
class GetCardCcyListResp extends Object {
  @JsonKey(name: 'curType')
  String curType;

  @JsonKey(name: 'outputCount')
  String outputCount;

  @JsonKey(name: 'recordLists')
  List<RecordLists> recordLists;

  GetCardCcyListResp(
    this.curType,
    this.outputCount,
    this.recordLists,
  );

  factory GetCardCcyListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardCcyListRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetCardCcyListRespToJson(this);
}

@JsonSerializable()
class RecordLists extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  RecordLists(
    this.ccy,
  );

  factory RecordLists.fromJson(Map<String, dynamic> srcJson) =>
      _$RecordListsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$RecordListsToJson(this);
}
