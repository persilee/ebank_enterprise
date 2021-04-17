import 'package:json_annotation/json_annotation.dart';

part 'country_region_new_model.g.dart';

@JsonSerializable()
class CountryRegionNewListReq extends Object {
  CountryRegionNewListReq();

  factory CountryRegionNewListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CountryRegionNewListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CountryRegionNewListReqToJson(this);
}

@JsonSerializable()
class CountryRegionNewListResp extends Object {
  @JsonKey(name: 'body')
  List<CountryRegionNewModel> body;

  CountryRegionNewListResp(
    this.body,
  );

  factory CountryRegionNewListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CountryRegionNewListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CountryRegionNewListRespToJson(this);
}

@JsonSerializable()
class CountryRegionNewModel extends Object {
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'cntyCd')
  String cntyCd;

  @JsonKey(name: 'cntyNm')
  String cntyNm;

  @JsonKey(name: 'cntyCnm')
  String cntyCnm;

  @JsonKey(name: 'cntyTcnm')
  String cntyTcnm;

  @JsonKey(name: 'areaCode')
  String areaCode;

  CountryRegionNewModel(
    this.modifyTime,
    this.createTime,
    this.cntyCd,
    this.cntyNm,
    this.cntyCnm,
    this.cntyTcnm,
    this.areaCode,
  );

  factory CountryRegionNewModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CountryRegionNewModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CountryRegionNewModelToJson(this);
}
