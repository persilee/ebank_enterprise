/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 三步验证
/// Author: zhangqirong
/// Date: 2021-03-19

import 'package:json_annotation/json_annotation.dart';
part 'real_name_auth.g.dart';

@JsonSerializable()
class RealNameAuthReq extends Object {
  @JsonKey(name: 'certNo')
  String certNo;

  @JsonKey(name: 'certType')
  String certType;

  @JsonKey(name: 'realName')
  String realName;

  RealNameAuthReq(
    this.certNo,
    this.certType,
    this.realName,
  );

  factory RealNameAuthReq.fromJson(Map<String, dynamic> srcJson) =>
      _$RealNameAuthReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RealNameAuthReqToJson(this);
}

@JsonSerializable()
class RealNameAuthResp extends Object {
  @JsonKey(name: 'enabled')
  bool enabled;

  RealNameAuthResp(
    this.enabled,
  );

  factory RealNameAuthResp.fromJson(Map<String, dynamic> srcJson) =>
      _$RealNameAuthRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RealNameAuthRespToJson(this);
}
