import 'package:json_annotation/json_annotation.dart';

part 'open_account_save_data.g.dart';

@JsonSerializable()
class OpenAccountSaveDataReq extends Object {
  ///类型、或者页面，自定义的key
  @JsonKey(name: 'step')
  String step;

  ///内容json需要转为sting
  @JsonKey(name: 'content')
  String content;

  OpenAccountSaveDataReq(
    this.content, {
    this.step = 'QuickOpen',
  });

  factory OpenAccountSaveDataReq.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountSaveDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountSaveDataReqToJson(this);
}

@JsonSerializable()
class OpenAccountSaveDataResp extends Object {
  OpenAccountSaveDataResp();

  factory OpenAccountSaveDataResp.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountSaveDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountSaveDataRespToJson(this);
}
