import 'package:json_annotation/json_annotation.dart';

part 'city_for_country.g.dart';

@JsonSerializable()
class CityForCountryListReq extends Object {
  ///国家代码
  @JsonKey(name: 'cntyCode')
  String cntyCode;

  CityForCountryListReq(
    this.cntyCode,
  );

  factory CityForCountryListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CityForCountryListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CityForCountryListReqToJson(this);
}

@JsonSerializable()
class CityForCountryListResp extends Object {
  @JsonKey(name: 'body')
  List<CityForCountryModel> body;

  CityForCountryListResp(
    this.body,
  );

  factory CityForCountryListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CityForCountryListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CityForCountryListRespToJson(this);
}

@JsonSerializable()
class CityForCountryModel extends Object {
  ///城市代码
  @JsonKey(name: 'cityCd')
  String cityCd;

  ///城市名称(中文)
  @JsonKey(name: 'cityCnm')
  String cityCnm;

  ///城市名称(英文)
  @JsonKey(name: 'cityNm')
  String cityNm;

  ///国家代码
  @JsonKey(name: 'cntyCd')
  String cntyCd;

  ///生效日期
  @JsonKey(name: 'effDate')
  String effDate;

  ///失效日期
  @JsonKey(name: 'expDate')
  String expDate;

  CityForCountryModel(
    this.cityCd,
    this.cityCnm,
    this.cityNm,
    this.cntyCd,
    this.effDate,
    this.expDate,
  );

  factory CityForCountryModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CityForCountryModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CityForCountryModelToJson(this);
}
