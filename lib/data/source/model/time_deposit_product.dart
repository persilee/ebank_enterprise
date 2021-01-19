/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///获取定期产品列表
/// Author: wangluyao
/// Date: 2020-12-09

import 'package:json_annotation/json_annotation.dart';

part 'time_deposit_product.g.dart';

class TimeDepositProductReq {}

@JsonSerializable()
class TimeDepositProductResp extends Object {
  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'tdepProductDTOList')
  List<TdepProducDTOList> tdepProductDTOList;

  @JsonKey(name: 'tdepProducHeadDTO')
  TdepProducHeadDTO tdepProducHeadDTO;

  TimeDepositProductResp(
    this.bppdCode,
    this.depositType,
    this.tdepProductDTOList,
    this.tdepProducHeadDTO,
  );

  factory TimeDepositProductResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositProductRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositProductRespToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class TdepProducDTOList extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'annualInterestRate')
  String annualInterestRate;

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

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'maxAmt')
  String maxAmt;

  @JsonKey(name: 'minAmt')
  String minAmt;

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
    this.lclName,
    this.maxAmt,
    this.minAmt,
    this.prodType,
    this.remark,
  );

  factory TdepProducDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProducDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TdepProducDTOListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class TdepProducHeadDTO extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'lclName')
  String lclName;

  @JsonKey(name: 'maxRate')
  String maxRate;

  @JsonKey(name: 'minAmt')
  String minAmt;

  @JsonKey(name: 'minRate')
  String minRate;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'remark')
  String remark;

  TdepProducHeadDTO(
    this.ccy,
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

  Map<String, dynamic> toJson() => _$TdepProducHeadDTOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
