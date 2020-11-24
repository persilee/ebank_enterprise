import 'package:json_annotation/json_annotation.dart';

part 'get_single_card_bal.g.dart';

@JsonSerializable()
class GetSingleCardBalReq {
  @JsonKey(name: 'cardNo')
  String cardNo;

  GetSingleCardBalReq(
    this.cardNo,
  );

  factory GetSingleCardBalReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetSingleCardBalReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetSingleCardBalReqToJson(this);
}

@JsonSerializable()
class GetSingleCardBalResp extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'totalAmt')
  String totalAmt;

  @JsonKey(name: 'defaultCcy')
  String defaultCcy;

  @JsonKey(name: 'cardListBal')
  List<CardBalBean> cardListBal;

  GetSingleCardBalResp(
    this.cardNo,
    this.totalAmt,
    this.defaultCcy,
    this.cardListBal,
  );

  factory GetSingleCardBalResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetSingleCardBalRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetSingleCardBalRespToJson(this);
}

@JsonSerializable()
class CardBalBean extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'currBal')
  String currBal;

  @JsonKey(name: 'equAmt')
  String equAmt;

  CardBalBean(
    this.cardNo,
    this.ccy,
    this.currBal,
    this.equAmt,
  );

  factory CardBalBean.fromJson(Map<String, dynamic> srcJson) =>
      _$CardBalBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CardBalBeanToJson(this);
}
