/*
 * Created Date: Monday, December 7th 2020, 5:32:52 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';
part 'get_deposit_record_info.g.dart';

@JsonSerializable()
class DepositRecordReq {
  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'excludeClosed')
  bool excludeClosed;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'stsNo')
  String stsNo;

  @JsonKey(name: 'nextKey')
  String nextKey;

  DepositRecordReq(
    this.ciNo,
    this.conNo,
    this.excludeClosed,
    this.page,
    this.pageSize,
    this.stsNo,
    this.nextKey,
  );

  factory DepositRecordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositRecordReqToJson(this);
}

@JsonSerializable()
class DepositRecordResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'toatalPage')
  int toatalPage;

  @JsonKey(name: 'rows')
  List<DepositRecord> rows;

  @JsonKey(name: 'totalAmt')
  String totalAmt;

  @JsonKey(name: 'defaultCcy')
  String defaultCcy;

  DepositRecordResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.toatalPage,
    this.rows,
    this.totalAmt,
    this.defaultCcy,
  );

  factory DepositRecordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositRecordRespToJson(this);
}

@JsonSerializable()
class DepositRecord extends Object {
  @JsonKey(name: 'engName')
  String engName;
  //中文名
  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'conRate')
  String conRate;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'openDrAc')
  String openDrAc;

  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'prdCode')
  String prdCode;

  @JsonKey(name: 'tenor')
  String tenor;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'valDate')
  String valDate;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'instCode')
  String instCode;

  @JsonKey(name: 'conSts')
  String conSts;

  DepositRecord(
    this.engName,
    this.lclName,
    this.conRate,
    this.settDdAc,
    this.openDrAc,
    this.conNo,
    this.prdCode,
    this.tenor,
    this.auctCale,
    this.accuPeriod,
    this.ccy,
    this.bal,
    this.valDate,
    this.mtDate,
    this.instCode,
    this.conSts,
  );

  factory DepositRecord.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositRecordToJson(this);
}
