/*
 * Filename: d:\work\flutter\ebank_mobile_enterprise\lib\data\source\model\time_deposit_product.dart
 * Path: d:\work\flutter\ebank_mobile_enterprise\lib\data\source\model
 * Created Date: Wednesday, December 9th 2020, 10:19:07 am
 * Author: wangluyao
 * 
 * Copyright (c) 2020 Your Company
 */

import 'package:json_annotation/json_annotation.dart';

part 'time_deposit_product.g.dart';

class TimeDepositProductReq {}

@JsonSerializable()
class TimeDepositProductResp extends Object {
  @JsonKey(name: 'requestId')
  String requestId;

  @JsonKey(name: 'msgId')
  String msgId;

  @JsonKey(name: 'traceId')
  String traceId;

  @JsonKey(name: 'spanId')
  String spanId;

  @JsonKey(name: 'accDate')
  String accDate;

  @JsonKey(name: 'startDateTime')
  String startDateTime;

  @JsonKey(name: 'endDateTime')
  String endDateTime;

  @JsonKey(name: 'locale')
  String locale;

  @JsonKey(name: 'routeInfo')
  String routeInfo;

  @JsonKey(name: 'clientIp')
  String clientIp;

  @JsonKey(name: 'seq')
  int seq;

  @JsonKey(name: 'body')
  List<Body> body;

  @JsonKey(name: 'msgCd')
  String msgCd;

  @JsonKey(name: 'msgInfo')
  String msgInfo;

  @JsonKey(name: 'msgType')
  String msgType;

  TimeDepositProductResp(
    this.requestId,
    this.msgId,
    this.traceId,
    this.spanId,
    this.accDate,
    this.startDateTime,
    this.endDateTime,
    this.locale,
    this.routeInfo,
    this.clientIp,
    this.seq,
    this.body,
    this.msgCd,
    this.msgInfo,
    this.msgType,
  );

  factory TimeDepositProductResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositProductRespFromJson(srcJson);
}

@JsonSerializable()
class Body extends Object {
  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'tdepProducHeadDTO')
  TdepProducHeadDTO tdepProducHeadDTO;

  @JsonKey(name: 'tdepProducDTOList')
  List<TdepProducDTOList> tdepProducDTOList;

  Body(
    this.depositType,
    this.bppdCode,
    this.tdepProducHeadDTO,
    this.tdepProducDTOList,
  );

  factory Body.fromJson(Map<String, dynamic> srcJson) =>
      _$BodyFromJson(srcJson);
}

@JsonSerializable()
class TdepProducHeadDTO extends Object {
  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'minRate')
  String minRate;

  @JsonKey(name: 'maxRate')
  String maxRate;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'minAmt')
  String minAmt;

  TdepProducHeadDTO(
    this.prodType,
    this.bppdCode,
    this.engName,
    this.lclName,
    this.minRate,
    this.maxRate,
    this.remark,
    this.minAmt,
  );

  factory TdepProducHeadDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProducHeadDTOFromJson(srcJson);
}

@JsonSerializable()
class TdepProducDTOList extends Object {
  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'minAmt')
  String minAmt;

  @JsonKey(name: 'maxAmt')
  String maxAmt;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'annualInterestRate')
  String annualInterestRate;

  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'erstFlg')
  String erstFlg;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'delFlg')
  String delFlg;

  TdepProducDTOList(
    this.prodType,
    this.bppdCode,
    this.engName,
    this.lclName,
    this.remark,
    this.minAmt,
    this.maxAmt,
    this.ccy,
    this.auctCale,
    this.annualInterestRate,
    this.accuPeriod,
    this.depositType,
    this.erstFlg,
    this.id,
    this.delFlg,
  );

  factory TdepProducDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProducDTOListFromJson(srcJson);
}
