/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///手机号注册
/// Author: wangluyao
/// Date: 2021-03-03

import 'package:json_annotation/json_annotation.dart';

part 'check_phone.g.dart';

@JsonSerializable()
class CheckPhoneReq extends Object {
  @JsonKey(name: 'userPhone')
  String userPhone;

  @JsonKey(name: 'userType')
  String userType;

  CheckPhoneReq(
    this.userPhone,
    this.userType,
  );

  factory CheckPhoneReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckPhoneReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckPhoneReqToJson(this);
}

@JsonSerializable()
class CheckPhoneResp extends Object {
  @JsonKey(name: 'register')
  bool register;

  @JsonKey(name: 'userAccount')
  String userAccount;

  CheckPhoneResp(
    this.register,
    this.userAccount,
  );

  factory CheckPhoneResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckPhoneRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckPhoneRespToJson(this);
}
