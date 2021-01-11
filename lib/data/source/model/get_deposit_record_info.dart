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
  @JsonKey(name: 'excludeClosed')
  bool excludeClosed;

  @JsonKey(name: 'page')
  String page;

  @JsonKey(name: 'pageSize')
  String pageSize;

  DepositRecordReq(
    this.excludeClosed,
    this.page,
    this.pageSize,
  );

  factory DepositRecordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositRecordReqToJson(this);
}

@JsonSerializable()
class DepositRecordResp extends Object {
  @JsonKey(name: 'sort')
  String sort;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<DepositRecord> rows;

  DepositRecordResp(
    this.sort,
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory DepositRecordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositRecordRespToJson(this);
}

@JsonSerializable()
class DepositRecord extends Object {
  //档期
  @JsonKey(name: 'auctCale')
  String auctCale;
  //合约号
  @JsonKey(name: 'conNo')
  String conNo;
  //利率
  @JsonKey(name: 'conRate')
  String conRate;
  //银行卡号
  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'serNo')
  int serNo;
  //整存整取
  @JsonKey(name: 'lclName')
  String lclName;
  //客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
  //定期产品编号
  @JsonKey(name: 'prdCode')
  String prdCode;
  //存单金额
  @JsonKey(name: 'bal')
  String bal;
  //产品英文名
  @JsonKey(name: 'engName')
  String engName;
  //最后修改时间
  @JsonKey(name: 'modifyTime')
  String modifyTime;
  //到期时间
  @JsonKey(name: 'mtDate')
  String mtDate;
  //币种
  @JsonKey(name: 'ccy')
  String ccy;
  //起息时间
  @JsonKey(name: 'valDate')
  String valDate;
  //是否提前结清
  @JsonKey(name: 'erstFlg')
  String erstFlg;

  DepositRecord(
    this.auctCale,
    this.conNo,
    this.conRate,
    this.settDdAc,
    this.serNo,
    this.lclName,
    this.ciNo,
    this.prdCode,
    this.bal,
    this.engName,
    this.modifyTime,
    this.mtDate,
    this.ccy,
    this.valDate,
    this.erstFlg,
  );

  factory DepositRecord.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRecordFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositRecordToJson(this);
}
