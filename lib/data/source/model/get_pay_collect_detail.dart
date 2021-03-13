/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-10

import 'package:json_annotation/json_annotation.dart';

part 'get_pay_collect_detail.g.dart';

@JsonSerializable()
class GetRevenueByCardsReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'localDateStart')
  String localDateStart;

  GetRevenueByCardsReq(
    this.page,
    this.pageSize,
    this.ciNo,
    this.localDateStart,
  );

  factory GetRevenueByCardsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetRevenueByCardsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetRevenueByCardsReqToJson(this);
}

@JsonSerializable()
class GetRevenueByCardsResp extends Object {
  @JsonKey(name: 'revenueHistoryDTOList')
  List<RevenueHistoryDTOList> revenueHistoryDTOList;

  GetRevenueByCardsResp(
    this.revenueHistoryDTOList,
  );

  factory GetRevenueByCardsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetRevenueByCardsRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetRevenueByCardsRespToJson(this);
}

@JsonSerializable()
class RevenueHistoryDTOList extends Object {
  @JsonKey(name: 'transDate')
  String transDate;

  @JsonKey(name: 'ddFinHistDOList')
  List<DdFinHistDOList> ddFinHistDOList;

  RevenueHistoryDTOList(
    this.transDate,
    this.ddFinHistDOList,
  );

  factory RevenueHistoryDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$RevenueHistoryDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$RevenueHistoryDTOListToJson(this);
}

@JsonSerializable()
class DdFinHistDOList extends Object {
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

  @JsonKey(name: 'txDateTime')
  String txDateTime;

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

  DdFinHistDOList(
    this.acDate,
    this.msgId,
    this.seq,
    this.reqId,
    this.refNo,
    this.uri,
    this.txDateTime,
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
  );

  factory DdFinHistDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$DdFinHistDOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DdFinHistDOListToJson(this);
}
