/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期开立
/// Author: wangluyao
/// Date: 2020-12-14

import 'package:json_annotation/json_annotation.dart';

part 'time_deposit_contract.g.dart';

@JsonSerializable()
class TimeDepositContractReq extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'annualInterestRate')
  double annualInterestRate;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'bal')
  double bal;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'custName')
  String custName;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'instCode')
  String instCode;

  @JsonKey(name: 'mergeTerm')
  String mergeTerm;

  @JsonKey(name: 'payDdAc')
  String payDdAc;

  @JsonKey(name: 'payDdAmt')
  double payDdAmt;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'remarks')
  String remarks;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  TimeDepositContractReq(
    this.accuPeriod,
    this.annualInterestRate,
    this.auctCale,
    this.bal,
    this.bppdCode,
    this.ccy,
    this.custName,
    this.depositType,
    this.instCode,
    this.mergeTerm,
    this.payDdAc,
    this.payDdAmt,
    this.prodType,
    this.remarks,
    this.settDdAc,
  );

  factory TimeDepositContractReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractReqToJson(this);

  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class TimeDepositContractResp extends Object {
  @JsonKey(name: 'ciName')
  String ciName;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'prodCode')
  String prodCode;

  TimeDepositContractResp(
    this.ciName,
    this.ciNo,
    this.conNo,
    this.prodCode,
  );

  factory TimeDepositContractResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractRespToJson(this);

  String toString() {
    return toJson().toString();
  }
}
