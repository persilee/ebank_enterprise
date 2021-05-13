/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_limit_by_con_no.g.dart';

@JsonSerializable()
class GetDepositLimitByConNo extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  GetDepositLimitByConNo(
    this.conNo,
  );

  factory GetDepositLimitByConNo.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositLimitByConNoFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetDepositLimitByConNoToJson(this);
}

@JsonSerializable()
class DepositByLimitConNoResp extends Object {
  //卡号
  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'engName')
  String engName;
  //整存整取
  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'prodType')
  String prodType;
  //合约号
  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'ccy')
  String ccy;
  //存款金额
  @JsonKey(name: 'bal')
  String bal;

  //存期(月)
  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'valDate')
  String valDate;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'erstFlg')
  String erstFlg;

  @JsonKey(name: 'instCode')
  String instCode;

  @JsonKey(name: 'intRate')
  String intRate;

  @JsonKey(name: 'stsNo')
  String stsNo;

  DepositByLimitConNoResp(
    this.ciNo,
    this.bppdCode,
    this.engName,
    this.lclName,
    this.prodType,
    this.conNo,
    this.ccy,
    this.bal,
    this.auctCale,
    this.accuPeriod,
    this.valDate,
    this.mtDate,
    this.settDdAc,
    this.erstFlg,
    this.instCode,
    this.intRate,
    this.stsNo,
  );

  factory DepositByLimitConNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositByLimitConNoRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositByLimitConNoRespToJson(this);
}
