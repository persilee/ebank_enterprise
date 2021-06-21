import 'package:json_annotation/json_annotation.dart';

part 'get_card_list.g.dart';

@JsonSerializable()
class GetCardListReq extends Object {
  @JsonKey(name: 'custId')
  String custId;

  GetCardListReq(this.custId);

  factory GetCardListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetCardListReqToJson(this);
}

@JsonSerializable()
class GetCardListResp extends Object {
  @JsonKey(name: 'cardList')
  List<RemoteBankCard> cardList;

  GetCardListResp(
    this.cardList,
  );
  @override
  String toString() {
    return toJson().toString();
  }

  factory GetCardListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardListRespToJson(this);
}

@JsonSerializable()
class RemoteBankCard extends Object {
  @JsonKey(name: 'bankCode')
  String bankCode;

  @JsonKey(name: 'bankEngName')
  String bankEngName;

  @JsonKey(name: 'bankLocalName')
  String bankLocalName;

  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'cardType')
  String cardType;

  @JsonKey(name: 'ciName')
  String ciName;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'imageUrl')
  String imageUrl;

  @JsonKey(name: 'own')
  bool own;

  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  @JsonKey(name: 'acSts')
  String acSts;

  RemoteBankCard(
    this.bankCode,
    this.bankEngName,
    this.bankLocalName,
    this.cardNo,
    this.cardType,
    this.ciName,
    this.custId,
    this.imageUrl,
    this.own,
    this.phoneNumber,
    this.acSts,
  );
  @override
  String toString() {
    return toJson().toString();
  }

  factory RemoteBankCard.fromJson(Map<String, dynamic> srcJson) =>
      _$RemoteBankCardFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RemoteBankCardToJson(this);
}
