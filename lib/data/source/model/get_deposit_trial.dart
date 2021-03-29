import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_trial.g.dart';

@JsonSerializable()
class GetDepositTrialReq extends Object {
  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'settBal')
  String settBal;

  GetDepositTrialReq(
    this.bal,
    this.conNo,
    this.settBal,
  );

  factory GetDepositTrialReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositTrialReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDepositTrialReqToJson(this);
}

@JsonSerializable()
class GetDepositTrialResp extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'mainAc')
  String mainAc;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'valDate')
  String valDate;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'intRate')
  String intRate;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'matBal')
  String matBal;

  @JsonKey(name: 'clsRate')
  String clsRate;

  @JsonKey(name: 'clsInt')
  String clsInt;

  @JsonKey(name: 'conMatAmt')
  String conMatAmt;

  @JsonKey(name: 'conRate')
  String conRate;

  @JsonKey(name: 'conInt')
  String conInt;

  @JsonKey(name: 'eryRate')
  String eryRate;

  @JsonKey(name: 'eryInt')
  String eryInt;

  @JsonKey(name: 'hdlFee')
  String hdlFee;

  @JsonKey(name: 'pnltFee')
  String pnltFee;

  @JsonKey(name: 'matAmt')
  String matAmt;

  @JsonKey(name: 'terms')
  String terms;

  GetDepositTrialResp(
    this.conNo,
    this.mainAc,
    this.ccy,
    this.valDate,
    this.mtDate,
    this.intRate,
    this.bal,
    this.matBal,
    this.clsRate,
    this.clsInt,
    this.conMatAmt,
    this.conRate,
    this.conInt,
    this.eryRate,
    this.eryInt,
    this.hdlFee,
    this.pnltFee,
    this.matAmt,
    this.terms,
  );

  factory GetDepositTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositTrialRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDepositTrialRespToJson(this);
}
