import 'package:json_annotation/json_annotation.dart';

part 'add_transfer_plan.g.dart';

@JsonSerializable()
class AddTransferPlanReq extends Object {
  @JsonKey(name: 'amount')
  double amount;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'enabled')
  bool enabled;

  @JsonKey(name: 'endDate')
  String endDate;

  @JsonKey(name: 'feeAmount')
  double feeAmount;

  @JsonKey(name: 'frequency')
  String frequency;

  @JsonKey(name: 'midBankSwift')
  String midBankSwift;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'planId')
  String planId;

  @JsonKey(name: 'planName')
  String planName;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'remitterAddress')
  String remitterAddress;

  @JsonKey(name: 'startDate')
  String startDate;

  @JsonKey(name: 'transferType')
  String transferType;

  AddTransferPlanReq(
    this.amount,
    this.bankSwift,
    this.city,
    this.costOptions,
    this.creditCurrency,
    this.debitCurrency,
    this.district,
    this.enabled,
    this.endDate,
    this.feeAmount,
    this.frequency,
    this.midBankSwift,
    this.payeeAddress,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.planId,
    this.planName,
    this.remark,
    this.remittancePurposes,
    this.remitterAddress,
    this.startDate,
    this.transferType,
  );

  factory AddTransferPlanReq.fromJson(Map<String, dynamic> srcJson) =>
      _$AddTransferPlanReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddTransferPlanReqToJson(this);
}

@JsonSerializable()
class AddTransferPlanResp extends Object {
  @JsonKey(name: 'count')
  int count;

  AddTransferPlanResp(
    this.count,
  );

  factory AddTransferPlanResp.fromJson(Map<String, dynamic> srcJson) =>
      _$AddTransferPlanRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddTransferPlanRespToJson(this);
}
