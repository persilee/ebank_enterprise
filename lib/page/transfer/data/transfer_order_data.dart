/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///预约转账数据
/// Author: fangluyao
/// Date: 2021-04-01

class TransferOrderData {
  String amount;

  String availableBalance;

  String bankSwift;

  String city;

  String costOptions;

  String creditCurrency;

  String day;

  String debitCurrency;

  String district;

  bool enabled;

  String endDate;

  int feeAmount;

  Map frequency;

  String midBankSwift;

  String month;

  String payPassword;

  String payeeAddress;

  String payeeBankCode;

  String payeeCardNo;

  String payeeName;

  String payerBankCode;

  String payerCardNo;

  String payerName;

  String planName;

  String remark;

  String remittancePurposes;

  String remitterAddress;

  String smsCode;

  String startDate;

  String transferType;

  String transferIntoAmount;

  String xRate;

  TransferOrderData(
    this.amount,
    this.availableBalance,
    this.bankSwift,
    this.city,
    this.costOptions,
    this.creditCurrency,
    this.day,
    this.debitCurrency,
    this.district,
    this.enabled,
    this.endDate,
    this.feeAmount,
    this.frequency,
    this.midBankSwift,
    this.month,
    this.payPassword,
    this.payeeAddress,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.payerBankCode,
    this.payerCardNo,
    this.payerName,
    this.planName,
    this.remark,
    this.remittancePurposes,
    this.remitterAddress,
    this.smsCode,
    this.startDate,
    this.transferType,
    this.transferIntoAmount,
    this.xRate,
  );
}
