import 'package:json_annotation/json_annotation.dart';

part 'get_card_by_card_no.g.dart';

@JsonSerializable()
class GetCardByCardNoReq extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'acEnm')
  String acEnm;

  GetCardByCardNoReq(this.cardNo, this.acEnm);

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

  @JsonKey(name: 'rtnFlg')
  String rtnFlg; //Y 成功 N 不成功

  GetCardByCardNoResp(
    this.bankCode,
    this.cardNo,
    this.cardType,
    this.ciName,
    this.custId,
    this.own,
    this.phoneNumber,
    this.status,
    this.rtnFlg,
  );

  factory GetCardByCardNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardByCardNoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardByCardNoRespToJson(this);
}
