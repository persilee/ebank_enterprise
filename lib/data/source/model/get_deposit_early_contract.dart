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

  @JsonKey(name: 'mainAc')
  String mainAc;

  @JsonKey(name: 'matAmt')
  double matAmt;

  @JsonKey(name: 'pnltFee')
  double pnltFee;

  @JsonKey(name: 'settBal')
  double settBal;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  @JsonKey(name: 'transferAc')
  String transferAc;

  GetDepositEarlyContractReq(
    this.conNo,
    this.eryInt,
    this.eryRate,
    this.hdlFee,
    this.mainAc,
    this.matAmt,
    this.pnltFee,
    this.settBal,
    this.settDdAc,
    this.transferAc,
  );

  factory GetDepositEarlyContractReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositEarlyContractReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDepositEarlyContractReqToJson(this);
}

@JsonSerializable()
class GetDepositEarlyContractResp extends Object {
  GetDepositEarlyContractResp();

  factory GetDepositEarlyContractResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositEarlyContractRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDepositEarlyContractRespToJson(this);
}
