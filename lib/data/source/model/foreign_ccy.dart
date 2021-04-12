import 'package:json_annotation/json_annotation.dart';

part 'foreign_ccy.g.dart';

@JsonSerializable()
class ForeignCcyReq extends Object {
  @JsonKey(name: 'buyAmt')
  String buyAmt;

  @JsonKey(name: 'buyCcy')
  String buyCcy;

  @JsonKey(name: 'ctaNo')
  String ctaNo;

  @JsonKey(name: 'exRate')
  String exRate;

  @JsonKey(name: 'prodCd')
  String prodCd;

  @JsonKey(name: 'sellAmt')
  String sellAmt;

  @JsonKey(name: 'sellCcy')
  String sellCcy;

  ForeignCcyReq(
    this.buyAmt,
    this.buyCcy,
    this.ctaNo,
    this.exRate,
    this.prodCd,
    this.sellAmt,
    this.sellCcy,
  );

  factory ForeignCcyReq.fromJson(Map<String, dynamic> srcJson) =>
      _$ForeignCcyReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForeignCcyReqToJson(this);
}

@JsonSerializable()
class ForeignCcyResp extends Object {
  ForeignCcyResp();

  factory ForeignCcyResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ForeignCcyRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ForeignCcyRespToJson(this);
}
