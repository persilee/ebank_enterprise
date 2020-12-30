/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取验证码
/// Author: CaiTM
/// Date: 2020-12-30

import 'package:json_annotation/json_annotation.dart';

part 'get_verification_code.g.dart';

//根据账户获取验证码
@JsonSerializable()
class SendSmsByAccountReq {
  @JsonKey(name: 'smsType')
  String smsType;
  @JsonKey(name: 'userAccount')
  String userAccount;

  SendSmsByAccountReq(
    this.smsType,
    this.userAccount,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory SendSmsByAccountReq.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsByAccountReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsByAccountReqToJson(this);
}

@JsonSerializable()
class SendSmsByAccountResp {
  @JsonKey(name: 'phoneNo')
  String phoneNo;

  SendSmsByAccountResp(this.phoneNo);

  factory SendSmsByAccountResp.fromJson(Map<String, dynamic> srcJson) =>
      _$SendSmsByAccountRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendSmsByAccountRespToJson(this);
}
