/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-02

import 'package:json_annotation/json_annotation.dart';

part 'get_user_info.g.dart';

@JsonSerializable()
class GetUserInfoReq extends Object {
  @JsonKey(name: 'userId')
  String userId;

  GetUserInfoReq(
    this.userId,
  );

  factory GetUserInfoReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetUserInfoReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetUserInfoReqToJson(this);
}

@JsonSerializable()
class UserInfoResp extends Object {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'localUserName')
  String localUserName;

  @JsonKey(name: 'englishUserName')
  String englishUserName;

  @JsonKey(name: 'custLocalName')
  String custLocalName;

  @JsonKey(name: 'custEngName')
  String custEngName;

  @JsonKey(name: 'userEmail')
  String userEmail;

  @JsonKey(name: 'userPhone')
  String userPhone;

  @JsonKey(name: 'headPortrait')
  String headPortrait;

  @JsonKey(name: 'passwordEnabled')
  bool passwordEnabled;

  @JsonKey(name: 'tiedCardMark')
  bool tiedCardMark;

  @JsonKey(name: 'certification')
  bool certification;

  @JsonKey(name: 'certificateType')
  String certificateType;

  @JsonKey(name: 'certificateNo')
  String certificateNo;

  @JsonKey(name: 'actualName')
  String actualName;

  @JsonKey(name: 'userStatus')
  String userStatus;

  @JsonKey(name: 'passwordErrors')
  int passwordErrors;

  @JsonKey(name: 'lockEnabled')
  bool lockEnabled;

  @JsonKey(name: 'userType')
  String userType;

  @JsonKey(name: 'platType')
  String platType;

  @JsonKey(name: 'lastLoginTime')
  String lastLoginTime;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'firstLanding')
  bool firstLanding;

  @JsonKey(name: 'roleLocalName')
  String roleLocalName;

  @JsonKey(name: 'roleEngName')
  String roleEngName;

  @JsonKey(name: 'roleCode')
  String roleCode;

  @JsonKey(name: 'processId')
  String processId;

  @JsonKey(name: 'belongCustStatus')
  String belongCustStatus;

  @JsonKey(name: 'areaCode')
  String areaCode;

  UserInfoResp(
    this.userId,
    this.custId,
    this.userAccount,
    this.localUserName,
    this.englishUserName,
    this.custLocalName,
    this.custEngName,
    this.userEmail,
    this.userPhone,
    this.headPortrait,
    this.passwordEnabled,
    this.tiedCardMark,
    this.certification,
    this.certificateType,
    this.certificateNo,
    this.actualName,
    this.userStatus,
    this.passwordErrors,
    this.lockEnabled,
    this.userType,
    this.platType,
    this.lastLoginTime,
    this.createBy,
    this.modifyBy,
    this.createTime,
    this.modifyTime,
    this.firstLanding,
    this.roleLocalName,
    this.roleEngName,
    this.roleCode,
    this.processId,
    this.belongCustStatus,
    this.areaCode,
  );

  factory UserInfoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$UserInfoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoRespToJson(this);
}
