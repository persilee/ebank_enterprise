import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_plan_details.g.dart';

@JsonSerializable()
class GetTransferPlanDetailsReq extends Object {
  @JsonKey(name: 'planId')
  String planId;

  GetTransferPlanDetailsReq(
    this.planId,
  );

  factory GetTransferPlanDetailsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferPlanDetailsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferPlanDetailsReqToJson(this);
}

@JsonSerializable()
class GetTransferPlanDetailsResp extends Object {
  @JsonKey(name: 'planId')
  String planId;

  @JsonKey(name: 'planName')
  String planName;

  @JsonKey(name: 'frequency')
  String frequency;

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

  @JsonKey(name: 'remitterAddress')
  String remitterAddress;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'midBankSwift')
  String midBankSwift;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'remark')
  String remark;

  GetTransferPlanDetailsResp(
    this.planId,
    this.planName,
    this.frequency,
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
    this.remitterAddress,
    this.payeeAddress,
    this.bankSwift,
    this.midBankSwift,
    this.remittancePurposes,
    this.costOptions,
    this.remark,
  );

  factory GetTransferPlanDetailsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferPlanDetailsRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferPlanDetailsRespToJson(this);
}
