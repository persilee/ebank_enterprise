import 'package:json_annotation/json_annotation.dart';

part 'get_card_list_bal_by_user.g.dart';

@JsonSerializable()
class GetCardListBalByUserReq extends Object {
  @JsonKey(name: 'accountType')
  String accountType;

  @JsonKey(name: 'cardNoList')
  List<dynamic> cardNoList;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciNo')
  String ciNo;

  GetCardListBalByUserReq(
    this.accountType,
    this.cardNoList,
    this.ccy,
    this.ciNo,
  );

  factory GetCardListBalByUserReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListBalByUserReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardListBalByUserReqToJson(this);
}

@JsonSerializable()
class GetCardListBalByUserResp extends Object {
  @JsonKey(name: 'totalAmt')
  String totalAmt;

  @JsonKey(name: 'ddTotalAmt')
  String ddTotalAmt;

  @JsonKey(name: 'tdTotalAmt')
  String tdTotalAmt;

  @JsonKey(name: 'cardListBal')
  List<CardListBal> cardListBal;

  @JsonKey(name: 'tedpListBal')
  List<TedpListBal> tedpListBal;

  GetCardListBalByUserResp(
    this.totalAmt,
    this.ddTotalAmt,
    this.tdTotalAmt,
    this.cardListBal,
    this.tedpListBal,
  );

  factory GetCardListBalByUserResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListBalByUserRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardListBalByUserRespToJson(this);
}

@JsonSerializable()
class CardListBal extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'currBal')
  String currBal;

  @JsonKey(name: 'avaBal')
  String avaBal;

  @JsonKey(name: 'equAmt')
  String equAmt;

  CardListBal(
    this.cardNo,
    this.ccy,
    this.currBal,
    this.avaBal,
    this.equAmt,
  );

  factory CardListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$CardListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CardListBalToJson(this);
}

@JsonSerializable()
class TedpListBal extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'currBal')
  String currBal;

  @JsonKey(name: 'avaBal')
  String avaBal;

  @JsonKey(name: 'equAmt')
  String equAmt;

  TedpListBal(
    this.cardNo,
    this.ccy,
    this.currBal,
    this.avaBal,
    this.equAmt,
  );

  factory TedpListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$TedpListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TedpListBalToJson(this);
}
