import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_trial.g.dart';

@JsonSerializable()
class GetDepositTrialReq extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'settBal')
  int settBal;

  GetDepositTrialReq(
    this.conNo,
    this.settBal,
  );

  factory GetDepositTrialReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetDepositTrialReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetDepositTrialReqToJson(this);
}

@JsonSerializable()
class DepositTrialResp extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'custName')
  String custName;

  @JsonKey(name: 'bppdCode')
  String bppdCode;

  @JsonKey(name: 'prodType')
  String prodType;

  @JsonKey(name: 'valDate')
  String valDate;

  @JsonKey(name: 'mtDate')
  String mtDate;

  @JsonKey(name: 'fixedFloatRate')
  String fixedFloatRate;

  @JsonKey(name: 'intRate')
  String intRate;

  @JsonKey(name: 'intRateType')
  String intRateType;

  @JsonKey(name: 'floatRateType')
  String floatRateType;

  @JsonKey(name: 'floatVal')
  String floatVal;

  @JsonKey(name: 'floatCycelMode')
  String floatCycelMode;

  @JsonKey(name: 'floatCycel')
  String floatCycel;

  @JsonKey(name: 'floatDate')
  String floatDate;

  @JsonKey(name: 'intSettPerd')
  String intSettPerd;

  @JsonKey(name: 'intSettDay')
  String intSettDay;

  @JsonKey(name: 'bal')
  String bal;

  @JsonKey(name: 'conMatAmt')
  String conMatAmt;

  @JsonKey(name: 'conRate')
  String conRate;

  @JsonKey(name: 'conInt')
  String conInt;

  @JsonKey(name: 'settBal')
  String settBal;

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

  @JsonKey(name: 'settDdAc')
  String settDdAc;

  DepositTrialResp(
    this.conNo,
    this.ciNo,
    this.custName,
    this.bppdCode,
    this.prodType,
    this.valDate,
    this.mtDate,
    this.fixedFloatRate,
    this.intRate,
    this.intRateType,
    this.floatRateType,
    this.floatVal,
    this.floatCycelMode,
    this.floatCycel,
    this.floatDate,
    this.intSettPerd,
    this.intSettDay,
    this.bal,
    this.conMatAmt,
    this.conRate,
    this.conInt,
    this.settBal,
    this.eryRate,
    this.eryInt,
    this.hdlFee,
    this.pnltFee,
    this.matAmt,
    this.settDdAc,
  );

  factory DepositTrialResp.fromJson(Map<String, dynamic> srcJson) =>
      _$DepositTrialRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$DepositTrialRespToJson(this);
}
