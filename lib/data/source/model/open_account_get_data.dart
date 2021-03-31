import 'package:json_annotation/json_annotation.dart';

part 'open_account_get_data.g.dart';

@JsonSerializable()
class OpenAccountGetDataReq extends Object {
  ///类型、或者页面，自定义的key
  @JsonKey(name: 'step')
  String step;

  OpenAccountGetDataReq({
    this.step = 'QuickOpen',
  });

  factory OpenAccountGetDataReq.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountGetDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountGetDataReqToJson(this);
}

@JsonSerializable()
class OpenAccountGetDataResp extends Object {
  ///类型、或者页面，自定义的key
  @JsonKey(name: 'step')
  String step;

  ///内容json需要转为sting
  @JsonKey(name: 'content')
  String content;

  OpenAccountGetDataResp(
    this.content,
    this.step,
  );

  factory OpenAccountGetDataResp.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountGetDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountGetDataRespToJson(this);
}
