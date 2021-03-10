/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-10

import 'package:json_annotation/json_annotation.dart';

part 'get_pay_collect_detail.g.dart';

@JsonSerializable()
class GetRevenueByCardsReq {
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'localDateStart')
  String localDateStart;
  @JsonKey(name: 'page')
  String page;
  @JsonKey(name: 'pageSize')
  String pageSize;
  @JsonKey(name: 'cards')
  List<String> cards;

  GetRevenueByCardsReq({
    this.localDateStart,
    this.ciNo,
    this.page = '0',
    this.pageSize = '10',
    this.cards,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetRevenueByCardsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetRevenueByCardsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetRevenueByCardsReqToJson(this);
}

@JsonSerializable()
class GetRevenueByCardsResp extends Object {
  @JsonKey(name: 'revenueHistoryDTOList')
  List<RevenueHistoryDTOList> revenueHistoryDTOList;

  GetRevenueByCardsResp(this.revenueHistoryDTOList);

  @override
  String toString() {
    return toJson().toString();
  }

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

  @override
  String toString() {
    return toJson().toString();
  }

  factory RevenueHistoryDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$RevenueHistoryDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RevenueHistoryDTOListToJson(this);
}

@JsonSerializable()
class DdFinHistDOList extends Object {
  @JsonKey(name: 'msgId')
  String msgId;
  @JsonKey(name: 'txDateTime')
  String txDateTime;
  @JsonKey(name: 'acNo')
  String acNo;
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'txCcy')
  String txCcy;
  @JsonKey(name: 'txAmt')
  String txAmt;
  @JsonKey(name: 'drCrFlg')
  String drCrFlg;
  @JsonKey(name: 'remark')
  String remark;
  @JsonKey(name: 'narrative')
  String narrative;

  DdFinHistDOList(
    this.msgId,
    this.txDateTime,
    this.acNo,
    this.ciNo,
    this.txCcy,
    this.txAmt,
    this.drCrFlg,
    this.remark,
    this.narrative,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory DdFinHistDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$DdFinHistDOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DdFinHistDOListToJson(this);
}
