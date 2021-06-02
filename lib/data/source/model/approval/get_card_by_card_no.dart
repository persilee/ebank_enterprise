import 'package:json_annotation/json_annotation.dart';

part 'get_card_by_card_no.g.dart';

@JsonSerializable()
class GetCardByCardNoReq extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetCardByCardNoReq(
    this.cardNo,
  );

  factory GetCardByCardNoReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardByCardNoReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardByCardNoReqToJson(this);
}

@JsonSerializable()
class GetCardByCardNoResp extends Object {
  @JsonKey(name: 'bankCode')
  String bankCode;

  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'cardType')
  String cardType;

  @JsonKey(name: 'ciName')
  String ciName;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'own')
  bool own;

  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'status')
  String status;

  GetCardByCardNoResp(
    this.bankCode,
    this.cardNo,
    this.cardType,
    this.ciName,
    this.custId,
    this.own,
    this.phoneNumber,
    this.status,
  );

  factory GetCardByCardNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardByCardNoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardByCardNoRespToJson(this);
}
