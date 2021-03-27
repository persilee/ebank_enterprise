import 'package:json_annotation/json_annotation.dart';

part 'get_international_transfer_new.g.dart';

@JsonSerializable()
class GetInternationalTransferNewReq extends Object {
  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'availableBalance')
  String availableBalance;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'exRate')
  String exRate;

  @JsonKey(name: 'exchangeRate')
  String exchangeRate;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'localCurrency')
  String localCurrency;

  @JsonKey(name: 'otherFees')
  String otherFees;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeBankName1')
  String payeeBankName1;

  @JsonKey(name: 'payeeBankName2')
  String payeeBankName2;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payeeName2')
  String payeeName2;

  @JsonKey(name: 'payeeName3')
  String payeeName3;

  @JsonKey(name: 'payeeName4')
  String payeeName4;

  @JsonKey(name: 'payerAddress')
  String payerAddress;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'paymentMethod')
  String paymentMethod;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'toCreditAmount')
  String toCreditAmount;

  @JsonKey(name: 'xRate')
  String xRate;

  GetInternationalTransferNewReq(
    this.amount,
    this.areaCode,
    this.availableBalance,
    this.bankSwift,
    this.city,
    this.costOptions,
    this.creditCurrency,
    this.custId,
    this.debitCurrency,
    this.district,
    this.exRate,
    this.exchangeRate,
    this.intermediateBankSwift,
    this.localCurrency,
    this.otherFees,
    this.payPassword,
    this.payeeAddress,
    this.payeeBankCode,
    this.payeeBankName1,
    this.payeeBankName2,
    this.payeeCardNo,
    this.payeeName,
    this.payeeName2,
    this.payeeName3,
    this.payeeName4,
    this.payerAddress,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.paymentMethod,
    this.phone,
    this.remark,
    this.remittancePurposes,
    this.smsCode,
    this.toCreditAmount,
    this.xRate,
  );

  factory GetInternationalTransferNewReq.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetInternationalTransferNewReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetInternationalTransferNewReqToJson(this);
}

@JsonSerializable()
class GetInternationalTransferNewResp extends Object {
  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'availableBalance')
  String availableBalance;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'custId')
  String custId;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'exRate')
  String exRate;

  @JsonKey(name: 'exchangeRate')
  String exchangeRate;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'localCurrency')
  String localCurrency;

  @JsonKey(name: 'otherFees')
  String otherFees;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeBankName1')
  String payeeBankName1;

  @JsonKey(name: 'payeeBankName2')
  String payeeBankName2;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'payeeName2')
  String payeeName2;

  @JsonKey(name: 'payeeName3')
  String payeeName3;

  @JsonKey(name: 'payeeName4')
  String payeeName4;

  @JsonKey(name: 'payerAddress')
  String payerAddress;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'paymentMethod')
  String paymentMethod;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'toCreditAmount')
  String toCreditAmount;

  @JsonKey(name: 'xRate')
  String xRate;

  GetInternationalTransferNewResp(
    this.amount,
    this.areaCode,
    this.availableBalance,
    this.bankSwift,
    this.city,
    this.costOptions,
    this.creditCurrency,
    this.custId,
    this.debitCurrency,
    this.district,
    this.exRate,
    this.exchangeRate,
    this.intermediateBankSwift,
    this.localCurrency,
    this.otherFees,
    this.payPassword,
    this.payeeAddress,
    this.payeeBankCode,
    this.payeeBankName1,
    this.payeeBankName2,
    this.payeeCardNo,
    this.payeeName,
    this.payeeName2,
    this.payeeName3,
    this.payeeName4,
    this.payerAddress,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.paymentMethod,
    this.phone,
    this.remark,
    this.remittancePurposes,
    this.smsCode,
    this.toCreditAmount,
    this.xRate,
  );

  factory GetInternationalTransferNewResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetInternationalTransferNewRespFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetInternationalTransferNewRespToJson(this);
}
