/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_rate.g.dart';

@JsonSerializable()
class GetDepositRate extends Object {
  GetDepositRate();

  factory GetDepositRate.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositRateFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetDepositRateToJson(this);
}

@JsonSerializable()
class DepositRateResp extends Object {
  @JsonKey(name: 'ccyList')
  List<String> ccyList;

  @JsonKey(name: 'ebankInterestRateRspDTOList')
  List<EbankInterestRateRspDTOList> ebankInterestRateRspDTOList;

  DepositRateResp(
    this.ccyList,
    this.ebankInterestRateRspDTOList,
  );

  factory DepositRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositRateRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositRateRespToJson(this);
}

@JsonSerializable()
class EbankInterestRateRspDTOList extends Object {
  @JsonKey(name: 'ebankInterestRateHead')
  EbankInterestRateHead ebankInterestRateHead;

  @JsonKey(name: 'ebankInterestRateDOList')
  List<EbankInterestRateDOList> ebankInterestRateDOList;

  EbankInterestRateRspDTOList(
    this.ebankInterestRateHead,
    this.ebankInterestRateDOList,
  );

  factory EbankInterestRateRspDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$EbankInterestRateRspDTOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$EbankInterestRateRspDTOListToJson(this);
}

@JsonSerializable()
class EbankInterestRateHead extends Object {
  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'depositEname')
  String depositEname;

  EbankInterestRateHead(
    this.auctCale,
    this.accuPeriod,
    this.depositEname,
  );

  factory EbankInterestRateHead.fromJson(Map<String, dynamic> srcJson) =>
      _$EbankInterestRateHeadFromJson(srcJson);
  Map<String, dynamic> toJson() => _$EbankInterestRateHeadToJson(this);
}

@JsonSerializable()
class EbankInterestRateDOList extends Object {
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'intRate')
  String intRate;

  @JsonKey(name: 'ts')
  String ts;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'depositEname')
  String depositEname;

  @JsonKey(name: 'depositLname')
  String depositLname;

  EbankInterestRateDOList(
    this.modifyTime,
    this.createTime,
    this.id,
    this.ccy,
    this.auctCale,
    this.accuPeriod,
    this.intRate,
    this.ts,
    this.depositType,
    this.depositEname,
    this.depositLname,
  );

  factory EbankInterestRateDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$EbankInterestRateDOListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$EbankInterestRateDOListToJson(this);
}
