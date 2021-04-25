import 'package:json_annotation/json_annotation.dart';

part 'login_Verfiy_phone.g.dart';

@JsonSerializable()
class LoginVerifyPhoneReq extends Object {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'phone')
  String phone;

  LoginVerifyPhoneReq(
    this.userId,
    this.userAccount,
    this.phone,
  );

  factory LoginVerifyPhoneReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginVerifyPhoneReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoginVerifyPhoneReqToJson(this);
}

@JsonSerializable()
class LoginVerifyPhoneResp extends Object {
  @JsonKey(name: 'opened')
  bool opened;

  LoginVerifyPhoneResp(this.opened);

  factory LoginVerifyPhoneResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginVerifyPhoneRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoginVerifyPhoneRespToJson(this);
}
