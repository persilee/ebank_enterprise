/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2021-03-16

import 'package:json_annotation/json_annotation.dart';

part 'auth_identity_bean.g.dart';

@JsonSerializable()
class AuthIdentityReq extends Object {
  // 企业id
  @JsonKey(name: 'tenantId')
  String tenantId;

  // 业务id
  @JsonKey(name: 'businessId')
  String businessId;

  // 语言  zh 中文，en 英文
  @JsonKey(name: 'language')
  String language;

  // 字符串 1  大陆证件识别，2 澳台证件识别，3 护照识别
  @JsonKey(name: 'type')
  String type;

  AuthIdentityReq(
    this.tenantId,
    this.businessId,
    this.language,
    this.type,
  );

  factory AuthIdentityReq.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthIdentityReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthIdentityReqToJson(this);
}

@JsonSerializable()
class AuthIdentityResp extends Object {
  @JsonKey(name: 'result')
  String result;

  AuthIdentityResp(
    this.result,
  );

  factory AuthIdentityResp.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthIdentityRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthIdentityRespToJson(this);
}
