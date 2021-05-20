/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///获取定期产品列表
/// Author: wangluyao
/// Date: 2020-12-09

import 'package:json_annotation/json_annotation.dart';

part 'time_deposit_product.g.dart';

@JsonSerializable()
class TimeDepositProductReq extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'minAmt')
  double minAmt;

  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'sort')
  String sort;

  TimeDepositProductReq(
    this.accuPeriod,
    this.auctCale,
    this.ccy,
    this.minAmt,
    this.page,
    this.pageSize,
    this.sort,
  );

  factory TimeDepositProductReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositProductReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositProductReqToJson(this);
}

// List<TimeDepositProductResp> getTimeDepositProductRespList(List<dynamic> list) {
//   List<TimeDepositProductResp> result = [];
//   list.forEach((item) {
//     result.add(TimeDepositProductResp.fromJson(item));
//   });
//   return result;
// }

// @JsonSerializable()
// class TimeDepositProductResp extends Object {
//   @JsonKey(name: 'depositType')
//   String depositType;

//   @JsonKey(name: 'bppdCode')
//   String bppdCode;

//   @JsonKey(name: 'tdepProducHeadDTO')
//   TdepProducHeadDTO tdepProducHeadDTO;

//   @JsonKey(name: 'tdepProductDTOList')
//   List<TdepProductDTOList> tdepProductDTOList;

//   TimeDepositProductResp(
//     this.depositType,
//     this.bppdCode,
//     this.tdepProducHeadDTO,
//     this.tdepProductDTOList,
//   );

//   factory TimeDepositProductResp.fromJson(Map<String, dynamic> srcJson) =>
//       _$TimeDepositProductRespFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$TimeDepositProductRespToJson(this);
// }

// @JsonSerializable()
// class TdepProducHeadDTO extends Object {
//   @JsonKey(name: 'prodType')
//   String prodType;

//   @JsonKey(name: 'bppdCode')
//   String bppdCode;

//   @JsonKey(name: 'engName')
//   String engName;

//   @JsonKey(name: 'lclName')
//   String lclName;

//   @JsonKey(name: 'minRate')
//   String minRate;

//   @JsonKey(name: 'maxRate')
//   String maxRate;

//   @JsonKey(name: 'remark')
//   String remark;

//   @JsonKey(name: 'minAmt')
//   String minAmt;

//   @JsonKey(name: 'statusNo')
//   String statusNo;

//   @JsonKey(name: 'ccy')
//   String ccy;

//   @JsonKey(name: 'insCode')
//   String insCode;

//   @JsonKey(name: 'minAuctCale')
//   String minAuctCale;

//   @JsonKey(name: 'minAccuPeriod')
//   String minAccuPeriod;

//   @JsonKey(name: 'maxAuctCale')
//   String maxAuctCale;

//   @JsonKey(name: 'maxAccuPeriod')
//   String maxAccuPeriod;

//   TdepProducHeadDTO(
//     this.prodType,
//     this.bppdCode,
//     this.engName,
//     this.lclName,
//     this.minRate,
//     this.maxRate,
//     this.remark,
//     this.minAmt,
//     this.statusNo,
//     this.ccy,
//     this.insCode,
//     this.minAuctCale,
//     this.minAccuPeriod,
//     this.maxAuctCale,
//     this.maxAccuPeriod,
//   );

//   factory TdepProducHeadDTO.fromJson(Map<String, dynamic> srcJson) =>
//       _$TdepProducHeadDTOFromJson(srcJson);

//   Map<String, dynamic> toJson() => _$TdepProducHeadDTOToJson(this);
// }

//--------------------------定期开立新接口返回的数据
@JsonSerializable()
class TimeDepositProductResp extends Object {
  @JsonKey(name: 'rows')
  List<TdepProductDTOList> tdepProductDTOList;

  TimeDepositProductResp(
    this.tdepProductDTOList,
  );

  factory TimeDepositProductResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositProductRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositProductRespToJson(this);
}

@JsonSerializable()
class TdepProductDTOList extends Object {
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
  //起存金额
  @JsonKey(name: 'minAmt')
  String minAmt;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'minAuctCale')
  String minAuctCale;

  @JsonKey(name: 'minAccuPeriod')
  String minAccuPeriod;

  @JsonKey(name: 'maxAuctCale')
  String maxAuctCale;

  @JsonKey(name: 'maxAccuPeriod')
  String maxAccuPeriod;

  @JsonKey(name: 'minRate')
  String minRate;

  @JsonKey(name: 'maxRate')
  String maxRate;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'erstFlg')
  String erstFlg;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'delFlg')
  String delFlg;

  @JsonKey(name: 'statusNo')
  String statusNo;

  @JsonKey(name: 'insTr')
  String insTr;

  TdepProductDTOList(
    this.prodType,
    this.bppdCode,
    this.engName,
    this.lclName,
    this.remark,
    this.minAmt,
    this.ccy,
    this.minAuctCale,
    this.minAccuPeriod,
    this.maxAuctCale,
    this.maxAccuPeriod,
    this.minRate,
    this.maxRate,
    this.depositType,
    this.erstFlg,
    this.id,
    this.delFlg,
    this.statusNo,
    this.insTr,
  );

  factory TdepProductDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$TdepProductDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TdepProductDTOListToJson(this);
}
