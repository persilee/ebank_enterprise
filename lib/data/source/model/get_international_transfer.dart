import 'package:json_annotation/json_annotation.dart';

part 'get_international_transfer.g.dart';

@JsonSerializable()
class GetInternationalTransferReq extends Object {
  @JsonKey(name: 'amount')
  double amount;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payerAddress')
  String payerAddress;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  // @JsonKey(name: 'phone')
  // String phone;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  GetInternationalTransferReq(
    this.amount,
    this.bankSwift,
    this.costOptions,
    this.creditCurrency,
    this.debitCurrency,
    this.district,
    this.intermediateBankSwift,
    this.payeeAddress,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerAddress,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    // this.phone,
    this.remark,
    this.remittancePurposes,
  );

  factory GetInternationalTransferReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInternationalTransferReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInternationalTransferReqToJson(this);
}

@JsonSerializable()
class InternationalTransferResp extends Object {
  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'payerAddress')
  String payerAddress;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'district')
  String district;

  InternationalTransferResp(
    this.payerBankCode,
    this.payerCardNo,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.amount,
    this.remark,
    this.debitCurrency,
    this.creditCurrency,
    this.payerAddress,
    this.payeeAddress,
    this.bankSwift,
    this.intermediateBankSwift,
    this.remittancePurposes,
    this.costOptions,
    this.district,
  );

  factory InternationalTransferResp.fromJson(Map<String, dynamic> srcJson) =>
      _$InternationalTransferRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternationalTransferRespToJson(this);
}
