import 'package:json_annotation/json_annotation.dart';

part 'open_account_Industry_two_data.g.dart';

//获取证件类型
@JsonSerializable()
class SubPublicCodeByTypeReq extends Object {
  @JsonKey(name: 'type')
  String type = 'BIZ_IDU_SUB';

  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'userId')
  String userId;

  ///一级商业行业性质
  @JsonKey(name: 'code')
  String code;

  SubPublicCodeByTypeReq(
    this.type,
    this.userAccount,
    this.userId,
    this.code,
  );

  factory SubPublicCodeByTypeReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SubPublicCodeByTypeReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SubPublicCodeByTypeReqToJson(this);
}

@JsonSerializable()
class SubPublicCodeByTypeResp extends Object {
  @JsonKey(name: 'publicCodeGetRedisRspDtoList')
  List<RedisRspDto> publicCodeGetRedisRspDtoList;

  SubPublicCodeByTypeResp(
    this.publicCodeGetRedisRspDtoList,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory SubPublicCodeByTypeResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SubPublicCodeByTypeRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SubPublicCodeByTypeRespToJson(this);
}

@JsonSerializable()
class RedisRspDto extends Object {
  @JsonKey(name: 'code')
  String code;
  @JsonKey(name: 'cname')
  String cname;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'localName')
  String localName;
  @JsonKey(name: 'engName')
  String engName;
  @JsonKey(name: 'chName')
  String chName;

  RedisRspDto(
    this.code,
    this.cname,
    this.name,
    this.type,
    this.localName,
    this.engName,
    this.chName,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory RedisRspDto.fromJson(Map<String, dynamic> srcJson) =>
      _$RedisRspDtoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RedisRspDtoToJson(this);
}
