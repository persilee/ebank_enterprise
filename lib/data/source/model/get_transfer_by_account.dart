import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_by_account.g.dart';

@JsonSerializable()
class GetTransferByAccount extends Object {
  @JsonKey(name: 'amount')
  double amount;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

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

  GetTransferByAccount(
    this.amount,
    this.creditCurrency,
    this.debitCurrency,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.remark,
  );

  factory GetTransferByAccount.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferByAccountFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetTransferByAccountToJson(this);
}

@JsonSerializable()
class TransferByAccountResp extends Object {
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

  TransferByAccountResp(
    this.payerBankCode,
    this.payerCardNo,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.amount,
    this.remark,
    this.debitCurrency,
    this.creditCurrency,
  );

  factory TransferByAccountResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferByAccountRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferByAccountRespToJson(this);
}
