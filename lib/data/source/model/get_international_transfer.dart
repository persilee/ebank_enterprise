import 'package:json_annotation/json_annotation.dart';

part 'get_international_transfer.g.dart';

@JsonSerializable()
class GetInternationalTransferReq extends Object {
  @JsonKey(name: 'opt')
  String opt;

  @JsonKey(name: 'debitAmount')
  //付款金额
  String debitAmount;

  @JsonKey(name: 'creditAmount')
  //收款金额
  String creditAmount;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'payPassword')
  String payPassword;

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

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'exchangeRate')
  String exchangeRate;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'costOptions')
  String costOptions;

  GetInternationalTransferReq(
    this.opt,
    this.debitAmount,
    this.creditAmount,
    this.creditCurrency,
    this.debitCurrency,
    this.payPassword,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.remark,
    this.smsCode,
    this.exchangeRate,
    this.payeeAddress,
    this.bankSwift,
    this.district,
    this.custId,
    this.costOptions,
  );

  factory GetInternationalTransferReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetInternationalTransferReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInternationalTransferReqToJson(this);
}

@JsonSerializable()
class InternationalTransferResp extends Object {
  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'payPassword')
  String payPassword;

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

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'exchangeRate')
  String exchangeRate;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'costOptions')
  String costOptions;

  InternationalTransferResp(
    this.amount,
    this.creditCurrency,
    this.debitCurrency,
    this.payPassword,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.remark,
    this.smsCode,
    this.exchangeRate,
    this.payeeAddress,
    this.bankSwift,
    this.district,
    this.custId,
    this.costOptions,
  );

  factory InternationalTransferResp.fromJson(Map<String, dynamic> srcJson) =>
      _$InternationalTransferRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternationalTransferRespToJson(this);
}
