// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_single_card_bal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSingleCardBalReq _$GetSingleCardBalReqFromJson(Map<String, dynamic> json) {
  return GetSingleCardBalReq(
    json['cardNo'] as String,
  );
}

Map<String, dynamic> _$GetSingleCardBalReqToJson(
        GetSingleCardBalReq instance) =>
    <String, dynamic>{
      'cardNo': instance.cardNo,
    };

GetSingleCardBalResp _$GetSingleCardBalRespFromJson(Map<String, dynamic> json) {
  return GetSingleCardBalResp(
    json['cardNo'] as String,
    json['totalAmt'] as String,
    json['defaultCcy'] as String,
    (json['cardListBal'] as List)
        ?.map((e) =>
            e == null ? null : CardBalBean.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetSingleCardBalRespToJson(
        GetSingleCardBalResp instance) =>
    <String, dynamic>{
      'cardNo': instance.cardNo,
      'totalAmt': instance.totalAmt,
      'defaultCcy': instance.defaultCcy,
      'cardListBal': instance.cardListBal,
    };

CardBalBean _$CardBalBeanFromJson(Map<String, dynamic> json) {
  return CardBalBean(
    json['cardNo'] as String,
    json['ccy'] as String,
    json['currBal'] as String,
    json['equAmt'] as String,
  );
}

Map<String, dynamic> _$CardBalBeanToJson(CardBalBean instance) =>
    <String, dynamic>{
      'cardNo': instance.cardNo,
      'ccy': instance.ccy,
      'currBal': instance.currBal,
      'equAmt': instance.equAmt,
    };
