import 'package:json_annotation/json_annotation.dart';

part 'get_card_limit_by_card_no.g.dart';

@JsonSerializable()
class GetCardLimitByCardNoReq {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetCardLimitByCardNoReq(
    this.cardNo,
  );

  factory GetCardLimitByCardNoReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardLimitByCardNoReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardLimitByCardNoReqToJson(this);
}

@JsonSerializable()
class GetCardLimitByCardNoResp {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'limitType')
  String limitType;

  @JsonKey(name: 'channel')
  String channel;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'singleDayCountLimit')
  int singleDayCountLimit;

  @JsonKey(name: 'singleLimit')
  String singleLimit;

  @JsonKey(name: 'singleDayLimit')
  String singleDayLimit;

  @JsonKey(name: 'enabled')
  bool enabled;

  GetCardLimitByCardNoResp(
    this.id,
    this.limitType,
    this.channel,
    this.custId,
    this.userId,
    this.cardNo,
    this.singleDayCountLimit,
    this.singleLimit,
    this.singleDayLimit,
    this.enabled,
  );

  factory GetCardLimitByCardNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardLimitByCardNoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardLimitByCardNoRespToJson(this);
}
