// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_card_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCardListResp _$GetCardListRespFromJson(Map<String, dynamic> json) {
  return GetCardListResp(
    (json['cardList'] as List)
        ?.map((e) => e == null
            ? null
            : RemoteBankCard.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetCardListRespToJson(GetCardListResp instance) =>
    <String, dynamic>{
      'cardList': instance.cardList,
    };

RemoteBankCard _$RemoteBankCardFromJson(Map<String, dynamic> json) {
  return RemoteBankCard(
    json['bankCode'] as String,
    json['bankEngName'] as String,
    json['bankLocalName'] as String,
    json['cardNo'] as String,
    json['cardType'] as String,
    json['ciName'] as String,
    json['custId'] as String,
    json['imageUrl'] as String,
    json['own'] as bool,
    json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$RemoteBankCardToJson(RemoteBankCard instance) =>
    <String, dynamic>{
      'bankCode': instance.bankCode,
      'bankEngName': instance.bankEngName,
      'bankLocalName': instance.bankLocalName,
      'cardNo': instance.cardNo,
      'cardType': instance.cardType,
      'ciName': instance.ciName,
      'custId': instance.custId,
      'imageUrl': instance.imageUrl,
      'own': instance.own,
      'phoneNumber': instance.phoneNumber,
    };
