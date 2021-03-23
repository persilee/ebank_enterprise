/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///跨行（国际）转账数据
/// Author: fangluyao
/// Date: 2021-03-18

class TransferInternationalData {
  String transferOutAccount;
  String transferOutAmount;
  String transferOutCcy;
  String transferOutAdress;
  String transferIntoName;
  String transferIntoAccount;
  String transferIntoAmount;
  String transferIntoCcy;
  String transferIntoAdress;
  String nation;
  String bank;
  String bankSWIFT;
  String centerSWIFI;
  String transferFee;
  String purpose;
  String transferRemark;
  String payeeBankCode;
  String payeeName;
  String payerBankCode;
  String payerName;
  TransferInternationalData(
    this.transferOutAccount,
    this.transferOutAmount,
    this.transferOutCcy,
    this.transferOutAdress,
    this.transferIntoName,
    this.transferIntoAccount,
    this.transferIntoAmount,
    this.transferIntoCcy,
    this.transferIntoAdress,
    this.nation,
    this.bank,
    this.bankSWIFT,
    this.centerSWIFI,
    this.transferFee,
    this.purpose,
    this.transferRemark,
    this.payeeBankCode,
    this.payeeName,
    this.payerBankCode,
    this.payerName,
  );
}
