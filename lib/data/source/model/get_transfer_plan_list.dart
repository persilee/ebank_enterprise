/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///获取预约转账列表
/// Author: wangluyao
/// Date: 2021-01-14

import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_plan_list.g.dart';

@JsonSerializable()
class GetTransferPlanListReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'sort')
  String sort;

  @JsonKey(name: 'statusList')
  List<String> statusList;

  @JsonKey(name: 'transferType')
  String transferType;

  GetTransferPlanListReq(
    this.page,
    this.pageSize,
    this.sort,
    this.statusList,
    this.transferType,
  );

  factory GetTransferPlanListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferPlanListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferPlanListReqToJson(this);
}

@JsonSerializable()
class GetTransferPlanListResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<TransferPlan> rows;

  GetTransferPlanListResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory GetTransferPlanListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferPlanListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferPlanListRespToJson(this);
}

@JsonSerializable()
class TransferPlan extends Object {
  @JsonKey(name: 'planId')
  String planId;

  @JsonKey(name: 'planName')
  String planName;

  @JsonKey(name: 'frequency')
  String frequency;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'startDate')
  String startDate;

  @JsonKey(name: 'nextDate')
  String nextDate;

  @JsonKey(name: 'endDate')
  String endDate;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'feeAmount')
  String feeAmount;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'transferType')
  String transferType;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'midBankSwift')
  String midBankSwift;

  @JsonKey(name: 'remitterAddress')
  String remitterAddress;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'createBy')
  String createBy;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'modifyBy')
  String modifyBy;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  TransferPlan(
    this.planId,
    this.planName,
    this.frequency,
    this.status,
    this.startDate,
    this.nextDate,
    this.endDate,
    this.payeeName,
    this.payeeCardNo,
    this.payeeBankCode,
    this.amount,
    this.debitCurrency,
    this.creditCurrency,
    this.feeAmount,
    this.payerCardNo,
    this.payerName,
    this.payerBankCode,
    this.transferType,
    this.district,
    this.city,
    this.bankSwift,
    this.midBankSwift,
    this.remitterAddress,
    this.payeeAddress,
    this.remittancePurposes,
    this.costOptions,
    this.remark,
    this.createBy,
    this.createTime,
    this.modifyBy,
    this.modifyTime,
  );

  factory TransferPlan.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferPlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferPlanToJson(this);
}
