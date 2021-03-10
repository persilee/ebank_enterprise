import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_trial.g.dart';

@JsonSerializable()
class GetDepositTrialReq extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  GetDepositTrialReq(
    this.conNo,
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

  @JsonKey(name: 'matAmt')
  String matAmt;

  @JsonKey(name: 'settDdAc')
  String settDdAc;

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
    this.conMatAmt,
    this.conRate,
    this.conInt,
    this.eryRate,
    this.eryInt,
    this.matAmt,
    this.settDdAc,
    this.terms,
  );

  factory GetDepositTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositTrialRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetDepositTrialRespToJson(this);
}
