/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///手机号注册
/// Author: wangluyao
/// Date: 2021-03-03

import 'package:json_annotation/json_annotation.dart';

part 'register_by_account.g.dart';

@JsonSerializable()
class RegisterByAccountReq extends Object {
  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'userPhone')
  String userPhone;

  @JsonKey(name: 'userType')
  String userType;

  @JsonKey(name: 'verifyCode')
  String verifyCode;

  RegisterByAccountReq(
    this.areaCode,
    this.password,
    this.userAccount,
    this.userPhone,
    this.userType,
    this.verifyCode,
  );

  factory RegisterByAccountReq.fromJson(Map<String, dynamic> srcJson) =>
      _$RegisterByAccountReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RegisterByAccountReqToJson(this);
}

@JsonSerializable()
class RegisterByAccountResp extends Object {
  @JsonKey(name: 'state')
  int state;

  RegisterByAccountResp(
    this.state,
  );

  factory RegisterByAccountResp.fromJson(Map<String, dynamic> srcJson) =>
      _$RegisterByAccountRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RegisterByAccountRespToJson(this);
}
