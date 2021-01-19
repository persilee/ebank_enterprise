/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期开立试算
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
  double bal;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'depositType')
  String depositType;

  @JsonKey(name: 'tenor')
  String tenor;

  TimeDepositContractTrialReq(
    this.accuPeriod,
    this.auctCale,
    this.bal,
    this.bppdCode,
    this.ccy,
    this.ciNo,
    this.depositType,
    this.tenor,
  );

  factory TimeDepositContractTrialReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractTrialReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractTrialReqToJson(this);
}

@JsonSerializable()
class TimeDepositContractTrialResp extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'auctCale')
  String auctCale;

  @JsonKey(name: 'valDate')
  String valDate;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'matAmt')
  String matAmt;

  @JsonKey(name: 'matInt')
  String matInt;

  @JsonKey(name: 'conRate')
  String conRate;

  TimeDepositContractTrialResp(
    this.ccy,
    this.bal,
    this.auctCale,
    this.valDate,
    this.mtDate,
    this.matAmt,
    this.matInt,
    this.conRate,
  );

  factory TimeDepositContractTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositContractTrialRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeDepositContractTrialRespToJson(this);
}
