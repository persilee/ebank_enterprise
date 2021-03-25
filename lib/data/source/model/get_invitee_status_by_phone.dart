/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 获取通过手机号用户的邀请状态数据模型
/// Author: 李家伟
/// Date: 2021-03-25

import 'package:json_annotation/json_annotation.dart';

part 'get_invitee_status_by_phone.g.dart';

@JsonSerializable()
class GetInviteeStatusByPhoneReq extends Object {
  ///区号
  @JsonKey(name: 'areaCode')
  String areaCode;

  ///手机号
  @JsonKey(name: 'phone')
  String phone;

  GetInviteeStatusByPhoneReq(
    this.areaCode,
    this.phone,
  );

  factory GetInviteeStatusByPhoneReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInviteeStatusByPhoneReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInviteeStatusByPhoneReqToJson(this);
}

@JsonSerializable()
class GetInviteeStatusByPhoneResp extends Object {
  ///被邀请人状态 1是被邀请 0非邀请
  @JsonKey(name: 'inviteeStatus')
  String inviteeStatus;

  GetInviteeStatusByPhoneResp(
    this.inviteeStatus,
  );

  factory GetInviteeStatusByPhoneResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInviteeStatusByPhoneRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInviteeStatusByPhoneRespToJson(this);
}
