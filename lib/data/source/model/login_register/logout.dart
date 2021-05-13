import 'package:json_annotation/json_annotation.dart';

part 'logout.g.dart';

@JsonSerializable()
class LogoutReq extends Object {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'loginname')
  String loginname;

  LogoutReq(
    this.userId,
    this.loginname,
  );

  factory LogoutReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LogoutReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogoutReqToJson(this);
}

@JsonSerializable()
class LogoutResp extends Object {
  LogoutResp();

  factory LogoutResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LogoutRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogoutRespToJson(this);
}
