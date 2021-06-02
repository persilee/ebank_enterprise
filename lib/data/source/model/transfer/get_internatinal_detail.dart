import 'package:json_annotation/json_annotation.dart';

part 'get_internatinal_detail.g.dart';

@JsonSerializable()
class TransferInterModelReq extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'transferType')
  String transferType;

  TransferInterModelReq(
    this.id,
    this.status,
    this.transferType,
  );

  factory TransferInterModelReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferInterModelReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TransferInterModelReqToJson(this);
}

@JsonSerializable()
class TransferInterModelResp extends Object {
  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'bankSwift')
  String bankSwift;

  @JsonKey(name: 'costOptions')
  String costOptions;

  @JsonKey(name: 'countryOrRegion')
  String countryOrRegion;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'creditAmount')
  String creditAmount;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  @JsonKey(name: 'debitAmount')
  String debitAmount;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'drCrFlg')
  String drCrFlg;

  @JsonKey(name: 'exchangeRate')
  String exchangeRate;

  @JsonKey(name: 'feeAccount')
  String feeAccount;

  @JsonKey(name: 'feeAmount')
  String feeAmount;

  @JsonKey(name: 'feeCcy')
  String feeCcy;

  @JsonKey(name: 'feeCode')
  String feeCode;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'msgId')
  String msgId;

  @JsonKey(name: 'ormstRef')
  String ormstRef;

  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'paymentBankCode')
  String paymentBankCode;

  @JsonKey(name: 'paymentCardNo')
  String paymentCardNo;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'receiveAddress')
  String receiveAddress;

  @JsonKey(name: 'receiveBankCode')
  String receiveBankCode;

  @JsonKey(name: 'receiveCardNo')
  String receiveCardNo;

  @JsonKey(name: 'receiveName')
  String receiveName;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;

  @JsonKey(name: 'remitterAddress')
  String remitterAddress;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'transactionTime')
  String transactionTime;

  @JsonKey(name: 'transferType')
  String transferType;

  TransferInterModelResp(
    this.amount,
    this.bankSwift,
    this.costOptions,
    this.countryOrRegion,
    this.createTime,
    this.creditAmount,
    this.creditCurrency,
    this.debitAmount,
    this.debitCurrency,
    this.drCrFlg,
    this.exchangeRate,
    this.feeAccount,
    this.feeAmount,
    this.feeCcy,
    this.feeCode,
    this.id,
    this.intermediateBankSwift,
    this.modifyTime,
    this.msgId,
    this.ormstRef,
    this.payeeAddress,
    this.payerName,
    this.paymentBankCode,
    this.paymentCardNo,
    this.phone,
    this.receiveAddress,
    this.receiveBankCode,
    this.receiveCardNo,
    this.receiveName,
    this.remark,
    this.remittancePurposes,
    this.remitterAddress,
    this.status,
    this.transactionTime,
    this.transferType,
  );

  factory TransferInterModelResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferInterModelRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TransferInterModelRespToJson(this);
}
