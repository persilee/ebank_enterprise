/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-02

import 'package:json_annotation/json_annotation.dart';

part 'get_user_info.g.dart';

@JsonSerializable()
class GetUserInfoReq {
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
  @JsonKey(name: 'certification')

  ///是否实名 1实名
  bool certification;

  @JsonKey(name: 'headPortrait')

  ///头像地址
  String headPortrait;

  @JsonKey(name: 'certificateNo')

  ///证件号码
  String certificateNo;

  @JsonKey(name: 'actualName')

  ///证件姓名
  String actualName;

  @JsonKey(name: 'passwordEnabled')

  ///是否设置支付密码 1是
  bool passwordEnabled;

  @JsonKey(name: 'userName')

  ///用户姓名
  String userName;

  @JsonKey(name: 'createBy')

  ///创建人
  String createBy;

  @JsonKey(name: 'custId')

  ///客户号
  String custId;

  @JsonKey(name: 'englishUserName')

  ///用户名称(英文)
  String englishUserName;

  @JsonKey(name: 'localUserName')

  ///用户名称(本地)
  String localUserName;

  @JsonKey(name: 'lockEnabled')

  ///用户被锁
  bool lockEnabled;

  @JsonKey(name: 'modifyBy')

  ///修改人
  String modifyBy;

  @JsonKey(name: 'passwordErrors')

  ///密码错误次数
  int passwordErrors;

  @JsonKey(name: 'userAccount')

  ///用户账号*
  String userAccount;

  @JsonKey(name: 'userEmail')

  ///邮箱地址
  String userEmail;

  @JsonKey(name: 'userId')

  ///用户编号
  String userId;

  @JsonKey(name: 'userPhone')

  ///手机号码
  String userPhone;

  @JsonKey(name: 'userRole')

  ///用户角色
  String userRole;

  @JsonKey(name: 'userStatus')

  ///用户状态
  String userStatus;

  @JsonKey(name: 'userType')

  ///用户类型(0:个人网银 1：个人手机网银 2：企业网银)
  String userType;

  UserInfoResp(
    this.certification,
    this.headPortrait,
    this.certificateNo,
    this.actualName,
    this.passwordEnabled,
    this.userName,
    this.createBy,
    this.custId,
    this.englishUserName,
    this.localUserName,
    this.lockEnabled,
    this.modifyBy,
    this.passwordErrors,
    this.userAccount,
    this.userEmail,
    this.userId,
    this.userPhone,
    this.userRole,
    this.userStatus,
    this.userType,
  );

  factory UserInfoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$UserInfoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoRespToJson(this);
}
