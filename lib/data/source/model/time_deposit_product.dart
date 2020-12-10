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
  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'tdepProducDTOList')
  List<TdepProducDTOList> tdepProducDTOList;

  @JsonKey(name: 'tdepProducHeadDTO')
  TdepProducHeadDTO tdepProducHeadDTO;

  TimeDepositProductResp(
    this.bppdCode,
    this.depositType,
    this.tdepProducDTOList,
    this.tdepProducHeadDTO,
  );

  factory TimeDepositProductResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositProductRespFromJson(srcJson);

  get length => null;
}

@JsonSerializable()
class TdepProducDTOList extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'annualInterestRate')
  int annualInterestRate;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'delFlg')
  String delFlg;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'erstFlg')
  String erstFlg;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'maxAmt')
  int maxAmt;

  @JsonKey(name: 'minAmt')
  int minAmt;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'remark')
  String remark;

  TdepProducDTOList(
    this.accuPeriod,
    this.annualInterestRate,
    this.auctCale,
    this.bppdCode,
    this.ccy,
    this.delFlg,
    this.depositType,
    this.engName,
    this.erstFlg,
    this.id,
    this.lclName,
    this.maxAmt,
    this.minAmt,
    this.prodType,
    this.remark,
  );

  factory TdepProducDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProducDTOListFromJson(srcJson);
}

@JsonSerializable()
class TdepProducHeadDTO extends Object {
  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'maxRate')
  int maxRate;

  @JsonKey(name: 'minAmt')
  int minAmt;

  @JsonKey(name: 'minRate')
  int minRate;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'remark')
  String remark;

  TdepProducHeadDTO(
    this.bppdCode,
    this.engName,
    this.lclName,
    this.maxRate,
    this.minAmt,
    this.minRate,
    this.prodType,
    this.remark,
  );

  factory TdepProducHeadDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProducHeadDTOFromJson(srcJson);
}
