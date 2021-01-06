import 'package:json_annotation/json_annotation.dart';

part 'get_public_parameters.g.dart';

//获取证件类型
@JsonSerializable()
class GetIdTypeReq extends Object {
  @JsonKey(name: 'type')
  String type;

  GetIdTypeReq({
    this.type = 'CERT_TYPE',
  });

  factory GetIdTypeReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetIdTypeReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetIdTypeReqToJson(this);
}

@JsonSerializable()
class GetIdTypeResp extends Object {
  @JsonKey(name: 'publicCodeGetRedisRspDtoList')
  List<IdType> publicCodeGetRedisRspDtoList;

  GetIdTypeResp(
    this.publicCodeGetRedisRspDtoList,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetIdTypeResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetIdTypeRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetIdTypeRespToJson(this);
}

@JsonSerializable()
class IdType extends Object {
  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'localName')
  String localName;
  @JsonKey(name: 'engName')
  String engName;
  @JsonKey(name: 'type')
  String type;

  IdType(
    this.code,
    this.localName,
    this.engName,
    this.type,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory IdType.fromJson(Map<String, dynamic> srcJson) =>
      _$IdTypeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$IdTypeToJson(this);
}

//获取本币
@JsonSerializable()
class GetLocalCurrencyReq extends Object {
  @JsonKey(name: 'type')
  String type;

  GetLocalCurrencyReq({
    this.type = 'LOCAL_CCY',
  });

  factory GetLocalCurrencyReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLocalCurrencyReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLocalCurrencyReqToJson(this);
}

@JsonSerializable()
class GetLocalCurrencyResp extends Object {
  @JsonKey(name: 'publicCodeGetRedisRspDtoList')
  List<LocalCurrency> publicCodeGetRedisRspDtoList;

  GetLocalCurrencyResp(
    this.publicCodeGetRedisRspDtoList,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetLocalCurrencyResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLocalCurrencyRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLocalCurrencyRespToJson(this);
}

@JsonSerializable()
class LocalCurrency extends Object {
  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'cName')
  String cName;
  @JsonKey(name: 'type')
  String type;

  LocalCurrency(
    this.code,
    this.name,
    this.cName,
    this.type,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory LocalCurrency.fromJson(Map<String, dynamic> srcJson) =>
      _$LocalCurrencyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LocalCurrencyToJson(this);
}
