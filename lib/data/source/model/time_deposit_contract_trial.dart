/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: wangluyao
/// Date: 2020-12-14

import 'package:json_annotation/json_annotation.dart';

part 'time_deposit_contract_trial.g.dart';

@JsonSerializable()
class TimeDepositContractTrialReq extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'prodType')
  String prodType;

  TimeDepositContractTrialReq(
    this.accuPeriod,
    this.auctCale,
    this.bal,
    this.bppdCode,
    this.ccy,
    this.depositType,
    this.prodType,
  );

  factory TimeDepositContractTrialReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractTrialReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractTrialReqToJson(this);

  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class TimeDepositContractTrialResp extends Object {
  @JsonKey(name: 'accuPeriod')
  String accuPeriod;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'bal')
  int bal;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'matAmt')
  int matAmt;

  @JsonKey(name: 'matInt')
  int matInt;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'valDate')
  String valDate;

  TimeDepositContractTrialResp(
    this.accuPeriod,
    this.auctCale,
    this.bal,
    this.ccy,
    this.matAmt,
    this.matInt,
    this.mtDate,
    this.valDate,
  );

  factory TimeDepositContractTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractTrialRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractTrialRespToJson(this);

  String toString() {
    return toJson().toString();
  }
}
