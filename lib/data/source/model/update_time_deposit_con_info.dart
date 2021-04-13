import 'package:json_annotation/json_annotation.dart';

part 'update_time_deposit_con_info.g.dart';

@JsonSerializable()
class UpdateTdConInfoReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'instCode')
  String instCode;

  @JsonKey(name: 'intAcCcy')
  String intAcCcy;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'settIntAc')
  String settIntAc;

  UpdateTdConInfoReq(
    this.ccy,
    this.conNo,
    this.instCode,
    this.intAcCcy,
    this.settDdAc,
    this.settIntAc,
  );

  factory UpdateTdConInfoReq.fromJson(Map<String, dynamic> srcJson) =>
      _$UpdateTdConInfoReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UpdateTdConInfoReqToJson(this);
}

@JsonSerializable()
class UpdateTdConInfoResp extends Object {
  @JsonKey(name: 'outQacNo')
  String outQacNo;

  @JsonKey(name: 'outQroLind')
  String outQroLind;

  @JsonKey(name: 'outQtinAc')
  String outQtinAc;

  @JsonKey(name: 'outQtinAcCcy')
  String outQtinAcCcy;

  @JsonKey(name: 'outQtoAc')
  String outQtoAc;

  @JsonKey(name: 'outQtoAcCcy')
  String outQtoAcCcy;

  UpdateTdConInfoResp(
    this.outQacNo,
    this.outQroLind,
    this.outQtinAc,
    this.outQtinAcCcy,
    this.outQtoAc,
    this.outQtoAcCcy,
  );

  factory UpdateTdConInfoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$UpdateTdConInfoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UpdateTdConInfoRespToJson(this);
}
