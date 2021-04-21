import 'package:json_annotation/json_annotation.dart';

part 'foreign_ccy.g.dart';

@JsonSerializable()
class ForeignCcyReq extends Object {
  @JsonKey(name: 'buyAmt')
  String buyAmt;

  @JsonKey(name: 'buyCcy')
  String buyCcy;

  @JsonKey(name: 'buyDac')
  String buyDac;

  @JsonKey(name: 'exRate')
  String exRate;

  @JsonKey(name: 'exTime')
  String exTime;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'prodCd')
  String prodCd;

  @JsonKey(name: 'sellAmt')
  String sellAmt;

  @JsonKey(name: 'sellCcy')
  String sellCcy;

  @JsonKey(name: 'sellDac')
  String sellDac;

  @JsonKey(name: 'smsCode')
  String smsCode;

  ForeignCcyReq(
    this.buyAmt,
    this.buyCcy,
    this.buyDac,
    this.exRate,
    this.exTime,
    this.payPassword,
    this.prodCd,
    this.sellAmt,
    this.sellCcy,
    this.sellDac,
    this.smsCode,
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
