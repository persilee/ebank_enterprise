import 'package:json_annotation/json_annotation.dart';

part 'open_account_quick_data.g.dart';

@JsonSerializable()
class OpenAccountQuickReq {
  ///业务编号
  @JsonKey(name: 'businessId')
  String businessId;

  OpenAccountQuickReq({
    this.businessId,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory OpenAccountQuickReq.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountQuickReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountQuickReqToJson(this);
}

@JsonSerializable()
class OpenAccountQuickResp {
  OpenAccountQuickResp();

  factory OpenAccountQuickResp.fromJson(Map<String, dynamic> srcJson) =>
      _$OpenAccountQuickRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OpenAccountQuickRespToJson(this);
}
