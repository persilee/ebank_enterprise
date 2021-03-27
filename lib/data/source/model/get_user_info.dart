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
  /// 用户编号
  @JsonKey(name: 'userId')
  String userId;

  /// 客户号
  @JsonKey(name: 'custId')
  String custId;

  /// 用户账号
  @JsonKey(name: 'userAccount')
  String userAccount;

  /// 用户名称(本地)
  @JsonKey(name: 'localUserName')
  String localUserName;

  /// 用户名称(英文)
  @JsonKey(name: 'englishUserName')
  String englishUserName;

  /// 客户名称(本地)
  @JsonKey(name: 'custLocalName')
  String custLocalName;

  /// 客户名称(英文)
  @JsonKey(name: 'custEngName')
  String custEngName;

  /// 邮箱地址
  @JsonKey(name: 'userEmail')
  String userEmail;

  /// 手机号码
  @JsonKey(name: 'userPhone')
  String userPhone;

  /// 头像
  @JsonKey(name: 'headPortrait')
  String headPortrait;

  /// 交易密码标识
  @JsonKey(name: 'passwordEnabled')
  bool passwordEnabled;

  /// 绑卡标记
  @JsonKey(name: 'tiedCardMark')
  bool tiedCardMark;

  /// 实名认证标识
  @JsonKey(name: 'certification')
  bool certification;

  /// 证件类型(0:身份证 1:护照 9:其他)
  @JsonKey(name: 'certificateType')
  String certificateType;

  /// 证件号码
  @JsonKey(name: 'certificateNo')
  String certificateNo;

  /// 证件姓名
  @JsonKey(name: 'actualName')
  String actualName;

  /// 用户状态
  @JsonKey(name: 'userStatus')
  String userStatus;

  /// 密码错误次数
  @JsonKey(name: 'passwordErrors')
  int passwordErrors;

  /// 用户被锁
  @JsonKey(name: 'lockEnabled')
  bool lockEnabled;

  /// 用户类型(1：个人用户 2：企业用户 3：金融机构)
  @JsonKey(name: 'userType')
  String userType;

  /// 平台类型(1-手机，2-网银)
  @JsonKey(name: 'platType')
  String platType;

  /// 最后一次登录时间
  @JsonKey(name: 'lastLoginTime')
  String lastLoginTime;

  /// 创建人
  @JsonKey(name: 'createBy')
  String createBy;

  /// 修改人
  @JsonKey(name: 'modifyBy')
  String modifyBy;

  /// 创建时间
  @JsonKey(name: 'createTime')
  String createTime;

  /// 修时间
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  /// 是否第一次登陆
  @JsonKey(name: 'firstLanding')
  bool firstLanding;

  /// 角色本地名称
  @JsonKey(name: 'roleLocalName')
  String roleLocalName;

  /// 角色英文名称
  @JsonKey(name: 'roleEngName')
  String roleEngName;

  /// 角色代码
  @JsonKey(name: 'roleCode')
  String roleCode;

  /// 工作流流程ID
  @JsonKey(name: 'processId')
  String processId;

  /// 用户开户状态(
  /// 0 - 已发送快速开户邀请
  /// 1 - 资料提交企服商Maker审核
  /// 2 - 企服商Maker通过审核
  /// 3 - 企服商Maker拒绝
  /// 4 - 企服商Checker通过审核
  /// 5 - 企服商Checker拒绝
  /// 6 - 客户经理Maker通过审核
  /// 7 - 客户经理Maker拒绝
  /// 8 - 客户经理Checker通过审核
  /// 9 - 客户经理Checker拒绝
  /// 10 - 核心开客户失败
  /// 11 - 核心开账户失败
  /// 12 - 正常
  @JsonKey(name: 'belongCustStatus')
  String belongCustStatus;

  /// 区号
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
