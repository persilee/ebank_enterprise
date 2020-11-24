// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_card_limit_by_card_no.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCardLimitByCardNoReq _$GetCardLimitByCardNoReqFromJson(
    Map<String, dynamic> json) {
  return GetCardLimitByCardNoReq(
    json['cardNo'] as String,
  );
}

Map<String, dynamic> _$GetCardLimitByCardNoReqToJson(
        GetCardLimitByCardNoReq instance) =>
    <String, dynamic>{
      'cardNo': instance.cardNo,
    };

GetCardLimitByCardNoResp _$GetCardLimitByCardNoRespFromJson(
    Map<String, dynamic> json) {
  return GetCardLimitByCardNoResp(
    json['id'] as String,
    json['limitType'] as String,
    json['channel'] as String,
    json['custId'] as String,
    json['userId'] as String,
    json['cardNo'] as String,
    json['singleDayCountLimit'] as int,
    json['singleLimit'] as String,
    json['singleDayLimit'] as String,
    json['enabled'] as bool,
  );
}

Map<String, dynamic> _$GetCardLimitByCardNoRespToJson(
        GetCardLimitByCardNoResp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'limitType': instance.limitType,
      'channel': instance.channel,
      'custId': instance.custId,
      'userId': instance.userId,
      'cardNo': instance.cardNo,
      'singleDayCountLimit': instance.singleDayCountLimit,
      'singleLimit': instance.singleLimit,
      'singleDayLimit': instance.singleDayLimit,
      'enabled': instance.enabled,
    };
