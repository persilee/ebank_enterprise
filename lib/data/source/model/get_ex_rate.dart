import 'package:json_annotation/json_annotation.dart';

part 'get_ex_rate.g.dart';

@JsonSerializable()
class GetExRateReq extends Object {
  GetExRateReq();

  factory GetExRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetExRateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetExRateReqToJson(this);
}

@JsonSerializable()
class GetExRateResp extends Object {
  @JsonKey(name: 'recordLists')
  List<RecordLists> recordLists;

  GetExRateResp(
    this.recordLists,
  );

  factory GetExRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetExRateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetExRateRespToJson(this);
}

@JsonSerializable()
class RecordLists extends Object {
  @JsonKey(name: 'ccsBuy')
  String ccsBuy;

  @JsonKey(name: 'ccsSell')
  String ccsSell;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ccy2')
  String ccy2;

  @JsonKey(name: 'cfxBuy')
  String cfxBuy;

  @JsonKey(name: 'csBuy')
  String csBuy;

  @JsonKey(name: 'csSell')
  String csSell;

  @JsonKey(name: 'fxBuy')
  String fxBuy;

  @JsonKey(name: 'fxSell')
  String fxSell;

  @JsonKey(name: 'hcsBuy')
  String hcsBuy;

  @JsonKey(name: 'hcsSell')
  String hcsSell;

  @JsonKey(name: 'hfxBuy')
  String hfxBuy;

  @JsonKey(name: 'hfxSell')
  String hfxSell;

  @JsonKey(name: 'mid')
  String mid;

  RecordLists(
    this.ccsBuy,
    this.ccsSell,
    this.ccy,
    this.ccy2,
    this.cfxBuy,
    this.csBuy,
    this.csSell,
    this.fxBuy,
    this.fxSell,
    this.hcsBuy,
    this.hcsSell,
    this.hfxBuy,
    this.hfxSell,
    this.mid,
  );

  factory RecordLists.fromJson(Map<String, dynamic> srcJson) =>
      _$RecordListsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RecordListsToJson(this);
}
