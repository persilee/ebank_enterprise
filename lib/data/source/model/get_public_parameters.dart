import 'package:json_annotation/json_annotation.dart';

part 'get_public_parameters.g.dart';

@JsonSerializable()
class GetPublicParametersReq extends Object {
  @JsonKey(name: 'type')
  String type;

  GetPublicParametersReq({
    this.type = 'CERT_TYPE',
  });

  factory GetPublicParametersReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetPublicParametersReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPublicParametersReqToJson(this);
}

@JsonSerializable()
class GetPublicParametersResp extends Object {
  @JsonKey(name: 'publicCodeGetRedisRspDtoList')
  List<PublicParameters> publicCodeGetRedisRspDtoList;

  GetPublicParametersResp(
    this.publicCodeGetRedisRspDtoList,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetPublicParametersResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetPublicParametersRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetPublicParametersRespToJson(this);
}

@JsonSerializable()
class PublicParameters extends Object {
  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'localName')
  String localName;
  @JsonKey(name: 'engName')
  String engName;
  @JsonKey(name: 'type')
  String type;

  PublicParameters(
    this.code,
    this.localName,
    this.engName,
    this.type,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory PublicParameters.fromJson(Map<String, dynamic> srcJson) =>
      _$PublicParametersFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PublicParametersToJson(this);
}
