/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-10

import 'package:json_annotation/json_annotation.dart';

part 'get_pay_collect_detail.g.dart';

@JsonSerializable()
class GetRevenueByCardsReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'localDateEnd')
  String localDateEnd;

  @JsonKey(name: 'localDateStart')
  String localDateStart;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  GetRevenueByCardsReq(
    this.ccy,
    this.localDateEnd,
    this.localDateStart,
    this.page,
    this.pageSize,
    this.acNo,
    this.ciNo,
  );

  factory GetRevenueByCardsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetRevenueByCardsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetRevenueByCardsReqToJson(this);
}

@JsonSerializable()
class GetRevenueByCardsResp extends Object {
  @JsonKey(name: 'ddFinHisDTOList')
  List<DdFinHisDTOList> ddFinHisDTOList;

  GetRevenueByCardsResp(
    this.ddFinHisDTOList,
  );
  Map<String, dynamic> toJson() => _$GetRevenueByCardsRespToJson(this);

  factory GetRevenueByCardsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetRevenueByCardsRespFromJson(srcJson);
}

@JsonSerializable()
class DdFinHisDTOList extends Object {
  @JsonKey(name: 'acDate')
  String acDate;

  @JsonKey(name: 'msgId')
  String msgId;

  @JsonKey(name: 'seq')
  int seq;

  @JsonKey(name: 'reqId')
  String reqId;

  @JsonKey(name: 'refNo')
  String refNo;

  @JsonKey(name: 'uri')
  String uri;

  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'txCcy')
  String txCcy;

  @JsonKey(name: 'txAmt')
  String txAmt;

  @JsonKey(name: 'drCrFlg')
  String drCrFlg;

  @JsonKey(name: 'txSts')
  String txSts;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'trBank')
  String trBank;

  @JsonKey(name: 'othBank')
  String othBank;

  @JsonKey(name: 'othBankAc')
  String othBankAc;

  @JsonKey(name: 'othBankAcName')
  String othBankAcName;

  @JsonKey(name: 'txMmo')
  String txMmo;

  @JsonKey(name: 'narrative')
  String narrative;

  //交易时间
  @JsonKey(name: 'txDateTime')
  String txDateTime;

  DdFinHisDTOList(
      this.acDate,
      this.msgId,
      this.seq,
      this.reqId,
      this.refNo,
      this.uri,
      this.acNo,
      this.txCcy,
      this.txAmt,
      this.drCrFlg,
      this.txSts,
      this.ciNo,
      this.trBank,
      this.othBank,
      this.othBankAc,
      this.othBankAcName,
      this.txMmo,
      this.narrative,
      this.txDateTime);
  Map<String, dynamic> toJson() => _$DdFinHisDTOListToJson(this);

  factory DdFinHisDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$DdFinHisDTOListFromJson(srcJson);
}
