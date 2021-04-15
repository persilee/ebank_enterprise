import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_by_account.g.dart';

@JsonSerializable()
class GetTransferByAccount extends Object {
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

  GetTransferByAccount(
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
  );

  factory GetTransferByAccount.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferByAccountFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetTransferByAccountToJson(this);
}

@JsonSerializable()
class TransferByAccountResp extends Object {
  // @JsonKey(name: 'payerBankCode')
  // String payerBankCode;

  // @JsonKey(name: 'payerCardNo')
  // String payerCardNo;

  // @JsonKey(name: 'payeeBankCode')
  // String payeeBankCode;

  // @JsonKey(name: 'payeeCardNo')
  // String payeeCardNo;

  // @JsonKey(name: 'payeeName')
  // String payeeName;

  // @JsonKey(name: 'amount')
  // String amount;

  // @JsonKey(name: 'remark')
  // String remark;

  // @JsonKey(name: 'debitCurrency')
  // String debitCurrency;

  // @JsonKey(name: 'creditCurrency')
  // String creditCurrency;

  // @JsonKey(name: 'xRate')
  // String xRate;

  TransferByAccountResp(
      // this.payerBankCode,
      // this.payerCardNo,
      // this.payeeBankCode,
      // this.payeeCardNo,
      // this.payeeName,
      // this.amount,
      // this.remark,
      // this.debitCurrency,
      // this.creditCurrency,
      // this.xRate,
      );

  factory TransferByAccountResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferByAccountRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferByAccountRespToJson(this);
}
