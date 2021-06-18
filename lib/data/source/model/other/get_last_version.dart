/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///获取最新版本信息
/// Author: wangluyao
/// Date: 2021-03-03

import 'package:json_annotation/json_annotation.dart';

part 'get_last_version.g.dart';

@JsonSerializable()
class GetLastVersionReq extends Object {
  /// 平台用户类型 1 个人， 2 企业
  ///
  /// P - 个人；
  /// C - 企业；
  /// F - 金融机构；
  @JsonKey(name: 'platUserType')
  String platUserType;

  /// 系统类型 1:Android 0：IOS
  @JsonKey(name: 'systemType')
  String systemType;

  /// 版本号
  @JsonKey(name: 'versionId')
  String versionId;

  GetLastVersionReq({
    this.platUserType,
    this.systemType,
    this.versionId,
  });

  factory GetLastVersionReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLastVersionReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLastVersionReqToJson(this);
}

@JsonSerializable()
class GetLastVersionResp extends Object {
  @JsonKey(name: 'bundleId')
  String bundleId;

  @JsonKey(name: 'channel')
  String channel;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'downloadLink')
  String downloadLink;

  @JsonKey(name: 'forceUpdate')
  String forceUpdate;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'packageName')
  String packageName;

  @JsonKey(name: 'systemType')
  String systemType;

  @JsonKey(name: 'updateText')
  String updateText;

  @JsonKey(name: 'versionId')
  String versionId;

  @JsonKey(name: 'versionName')
  String versionName;

  GetLastVersionResp(
    this.bundleId,
    this.channel,
    this.createBy,
    this.downloadLink,
    this.forceUpdate,
    this.modifyBy,
    this.packageName,
    this.systemType,
    this.updateText,
    this.versionId,
    this.versionName,
  );

  factory GetLastVersionResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLastVersionRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLastVersionRespToJson(this);
}
