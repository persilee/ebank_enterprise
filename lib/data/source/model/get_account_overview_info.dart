import 'package:json_annotation/json_annotation.dart';

part 'get_account_overview_info.g.dart';

@JsonSerializable()
class GetTotalAssetsReq {
  @JsonKey(name: 'userId')
  String userId;

  GetTotalAssetsReq(
    this.userId,
  );

  factory GetTotalAssetsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTotalAssetsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTotalAssetsReqToJson(this);
}

@JsonSerializable()
class GetTotalAssetsResp {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'totalAssets')
  String totalAssets;

  @JsonKey(name: 'totalLiability')
  String totalLiability;

  @JsonKey(name: 'netAssets')
  String netAssets;

  GetTotalAssetsResp(
    this.ccy,
    this.totalAssets,
    this.totalLiability,
    this.netAssets,
  );

  factory GetTotalAssetsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTotalAssetsRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTotalAssetsRespToJson(this);
}
