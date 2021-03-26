import 'package:json_annotation/json_annotation.dart';

part 'get_card_list_bal_by_user.g.dart';

@JsonSerializable()
class GetCardListBalByUserReq extends Object {
  @JsonKey(name: 'accountType')
  String accountType;

  @JsonKey(name: 'cardNoList')
  List<String> cardNoList;

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
  @JsonKey(name: 'cardListBal')
  List<CardListBal> cardListBal;

  @JsonKey(name: 'ddTotalAmt')
  String ddTotalAmt;

  @JsonKey(name: 'defaultCcy')
  String defaultCcy;

  @JsonKey(name: 'tdTotalAmt')
  String tdTotalAmt;

  @JsonKey(name: 'tedpListBal')
  List<TedpListBal> tedpListBal;

  @JsonKey(name: 'totalAmt')
  String totalAmt;

  @JsonKey(name: 'lnTotalAmt')
  String lnTotalAmt;

  @JsonKey(name: 'lnListBal')
  List<LnListBal> lnListBal;

  GetCardListBalByUserResp(
      this.cardListBal,
      this.ddTotalAmt,
      this.defaultCcy,
      this.tdTotalAmt,
      this.tedpListBal,
      this.totalAmt,
      this.lnTotalAmt,
      this.lnListBal);

  factory GetCardListBalByUserResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListBalByUserRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardListBalByUserRespToJson(this);
}

@JsonSerializable()
class CardListBal extends Object {
  @JsonKey(name: 'accountType')
  String accountType;

  @JsonKey(name: 'avaBal')
  String avaBal;

  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'currBal')
  String currBal;

  @JsonKey(name: 'equAmt')
  String equAmt;

  @JsonKey(name: 'freezeBal')
  String freezeBal;

  @JsonKey(name: 'intBal')
  String intBal;

  CardListBal(
    this.accountType,
    this.avaBal,
    this.cardNo,
    this.ccy,
    this.currBal,
    this.equAmt,
    this.freezeBal,
    this.intBal,
  );

  factory CardListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$CardListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CardListBalToJson(this);
}

@JsonSerializable()
class TedpListBal extends Object {
  @JsonKey(name: 'accountType')
  String accountType;

  @JsonKey(name: 'avaBal')
  String avaBal;

  @JsonKey(name: 'cardNo')
  String cardNo;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'currBal')
  String currBal;

  @JsonKey(name: 'equAmt')
  String equAmt;

  @JsonKey(name: 'freezeBal')
  String freezeBal;

  @JsonKey(name: 'intBal')
  String intBal;

  TedpListBal(
    this.accountType,
    this.avaBal,
    this.cardNo,
    this.ccy,
    this.currBal,
    this.equAmt,
    this.freezeBal,
    this.intBal,
  );

  factory TedpListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$TedpListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TedpListBalToJson(this);
}

@JsonSerializable()
class LnListBal extends Object {
  @JsonKey(name: 'accountType')
  String accountType;

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

  LnListBal(
    this.accountType,
    this.cardNo,
    this.ccy,
    this.currBal,
    this.avaBal,
    this.equAmt,
  );

  factory LnListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$LnListBalFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LnListBalToJson(this);
}
