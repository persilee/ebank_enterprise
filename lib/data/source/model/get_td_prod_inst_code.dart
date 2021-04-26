import 'package:json_annotation/json_annotation.dart';

part 'get_td_prod_inst_code.g.dart';

@JsonSerializable()
class GetTdProductInstCodeReq extends Object {
  @JsonKey(name: 'prodCode')
  String prodCode;

  GetTdProductInstCodeReq(
    this.prodCode,
  );

  factory GetTdProductInstCodeReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdProductInstCodeReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdProductInstCodeReqToJson(this);
}

@JsonSerializable()
class GetTdProductInstCodeResp extends Object {
  @JsonKey(name: 'insCodes')
  List<String> insCodes;

  @JsonKey(name: 'prdAcCd')
  String prdAcCd;

  GetTdProductInstCodeResp(
    this.insCodes,
    this.prdAcCd,
  );

  factory GetTdProductInstCodeResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdProductInstCodeRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdProductInstCodeRespToJson(this);
}
