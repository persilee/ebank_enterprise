import 'package:json_annotation/json_annotation.dart';

part 'modify_pwd_by_sms.g.dart';

@JsonSerializable()
class ModifyPwdBySmsReq extends Object {
  String password;

  String smsCode;

  String userAccount;

  ModifyPwdBySmsReq(
    this.password,
    this.smsCode,
    this.userAccount,
  );

  factory ModifyPwdBySmsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$ModifyPwdBySmsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModifyPwdBySmsReqToJson(this);
}

@JsonSerializable()
class ModifyPwdBySmsResp extends Object {
  int state;

  ModifyPwdBySmsResp(
    this.state,
  );

  factory ModifyPwdBySmsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ModifyPwdBySmsRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$ModifyPwdBySmsRespToJson(this);
}
