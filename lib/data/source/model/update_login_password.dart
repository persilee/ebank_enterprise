/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 修改登录密码
/// Author: CaiTM
/// Date: 2020-12-30

import 'package:json_annotation/json_annotation.dart';

part 'update_login_password.g.dart';

@JsonSerializable()
class ModifyPasswordReq {
  @JsonKey(name: 'newPassword') //新密码
  String newPassword;
  @JsonKey(name: 'password') //旧密码
  String password;
  @JsonKey(name: 'smsCode') //短信码
  String smsCode;
  @JsonKey(name: 'userId') //用户ID
  String userId;
  @JsonKey(name: 'userAccount') //用户账号
  String userAccount;
  @JsonKey(name: 'userPhone') //用户手机号
  String userPhone;
  @JsonKey(
      name: 'modifyPwdType') //修改密码类型:modifyPwd-修改登录密码，transactionPwd-修改支付密码
  String modifyPwdType;

  ModifyPasswordReq(this.newPassword, this.password, this.smsCode, this.userId,
      this.userAccount, this.userPhone, this.modifyPwdType);

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
