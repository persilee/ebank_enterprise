import 'package:azlistview/azlistview.dart';
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
  @JsonKey(name: 'countryCodeinfoDTOList')
  List<CountryRegionNewModel> countryCodeinfoDTOList;

  CountryRegionNewListResp(
    this.countryCodeinfoDTOList,
  );

  factory CountryRegionNewListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CountryRegionNewListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CountryRegionNewListRespToJson(this);
}

@JsonSerializable()
class CountryRegionNewModel extends ISuspensionBean {
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

  ///辅助字段
  @JsonKey(name: 'namePinyin')
  String namePinyin;

  ///辅助字段
  @JsonKey(name: 'tagIndex')
  String tagIndex;

  CountryRegionNewModel(
    this.modifyTime,
    this.createTime,
    this.cntyCd,
    this.cntyNm,
    this.cntyCnm,
    this.cntyTcnm,
    this.areaCode,
    this.tagIndex,
  );

  factory CountryRegionNewModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CountryRegionNewModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CountryRegionNewModelToJson(this);

  @override
  String getSuspensionTag() => tagIndex;
}
