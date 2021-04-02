import 'package:json_annotation/json_annotation.dart';

part 'get_info_by_swift_code.g.dart';

@JsonSerializable()
class GetInfoBySwiftCodeReq extends Object {
  @JsonKey(name: 'swiftCode')
  String swiftCode;

  GetInfoBySwiftCodeReq(
    this.swiftCode,
  );

  factory GetInfoBySwiftCodeReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInfoBySwiftCodeReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInfoBySwiftCodeReqToJson(this);
}

@JsonSerializable()
class GetInfoBySwiftCodeResp extends Object {
  @JsonKey(name: 'swiftBke')
  String swiftBke;

  @JsonKey(name: 'swiftCode')
  String swiftCode;

  @JsonKey(name: 'swiftName1')
  String swiftName1;

  @JsonKey(name: 'swiftName2')
  String swiftName2;

  @JsonKey(name: 'swiftName3')
  String swiftName3;

  @JsonKey(name: 'swiftStatus')
  String swiftStatus;

  GetInfoBySwiftCodeResp(
    this.swiftBke,
    this.swiftCode,
    this.swiftName1,
    this.swiftName2,
    this.swiftName3,
    this.swiftStatus,
  );

  factory GetInfoBySwiftCodeResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInfoBySwiftCodeRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInfoBySwiftCodeRespToJson(this);
}
