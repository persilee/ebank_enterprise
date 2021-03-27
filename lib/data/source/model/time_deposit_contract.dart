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
  String annualInterestRate;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'bal')
  double bal;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'instCode')
  String instCode;

  @JsonKey(name: 'oppAc')
  String oppAc;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'prodName')
  String prodName;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'tenor')
  String tenor;

  TimeDepositContractReq(
    this.accuPeriod,
    this.annualInterestRate,
    this.auctCale,
    this.bal,
    this.bppdCode,
    this.ccy,
    this.ciNo,
    this.depositType,
    this.instCode,
    this.oppAc,
    this.payPassword,
    this.prodName,
    this.settDdAc,
    this.smsCode,
    this.tenor,
  );

  factory TimeDepositContractReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractReqToJson(this);
}

@JsonSerializable()
class TimeDepositContractResp extends Object {
  TimeDepositContractResp();

  factory TimeDepositContractResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractRespToJson(this);
}
