/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 修改登录密码
/// Author: CaiTM
/// Date: 2020-12-30

import 'package:json_annotation/json_annotation.dart';

part 'update_login_password.g.dart';

@JsonSerializable()
class ModifyPasswordReq {
  @JsonKey(name: 'newPassword')
  String newPassword;
  @JsonKey(name: 'password')
  String password;
  @JsonKey(name: 'smsCode')
  String smsCode;
  @JsonKey(name: 'userId')
  String userId;

  ModifyPasswordReq(
    this.newPassword,
    this.password,
    this.smsCode,
    this.userId,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory ModifyPasswordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$ModifyPasswordReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModifyPasswordReqToJson(this);
}

@JsonSerializable()
class ModifyPasswordResp {
  ModifyPasswordResp();

  factory ModifyPasswordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ModifyPasswordRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModifyPasswordRespToJson(this);
}
