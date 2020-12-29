/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_early_contract.g.dart';

@JsonSerializable()
class GetDepositEarlyContractReq extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'eryInt')
  double eryInt;

  @JsonKey(name: 'eryRate')
  double eryRate;

  @JsonKey(name: 'hdlFee')
  double hdlFee;

  @JsonKey(name: 'matAmt')
  double matAmt;

  @JsonKey(name: 'pnltFee')
  double pnltFee;

  @JsonKey(name: 'settBal')
  double settBal;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  GetDepositEarlyContractReq(
    this.conNo,
    this.eryInt,
    this.eryRate,
    this.hdlFee,
    this.matAmt,
    this.pnltFee,
    this.settBal,
    this.settDdAc,
  );

  factory GetDepositEarlyContractReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositEarlyContractReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetDepositEarlyContractReqToJson(this);
}

@JsonSerializable()
class DepositEarlyContractResp extends Object {
  DepositEarlyContractResp();

  factory DepositEarlyContractResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositEarlyContractRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepositEarlyContractRespToJson(this);
}
