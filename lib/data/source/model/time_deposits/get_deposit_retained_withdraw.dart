import 'package:json_annotation/json_annotation.dart';

part 'get_deposit_retained_withdraw.g.dart';

//--------------此Json配置为最低存金额
@JsonSerializable()
class TimeDepositRetainedReq extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'prodCode')
  String prodCode;

  TimeDepositRetainedReq(
    this.ccy,
    this.prodCode,
  );

  factory TimeDepositRetainedReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositRetainedReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TimeDepositRetainedReqToJson(this);
}

@JsonSerializable()
class TimeDepositRetainedResp extends Object {
  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'maxAmt')
  String maxAmt;

  @JsonKey(name: 'minAmt')
  String minAmt;

  @JsonKey(name: 'minLeft')
  String minLeft;

  @JsonKey(name: 'partNum')
  String partNum;

  TimeDepositRetainedResp(
    this.ccy,
    this.maxAmt,
    this.minAmt,
    this.minLeft,
    this.partNum,
  );

  factory TimeDepositRetainedResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositRetainedRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TimeDepositRetainedRespToJson(this);
}

//----------定期获取剩余支取次数
@JsonSerializable()
class TimeDepositWithdrawReq extends Object {
  @JsonKey(name: 'conNo')
  String conNo;

  TimeDepositWithdrawReq(
    this.conNo,
  );

  factory TimeDepositWithdrawReq.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositWithdrawReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TimeDepositWithdrawReqToJson(this);
}

@JsonSerializable()
class TimeDepositWithdrawResp extends Object {
  @JsonKey(name: 'resArray')
  List<ResArray> resArray;

  TimeDepositWithdrawResp(
    this.resArray,
  );

  factory TimeDepositWithdrawResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TimeDepositWithdrawRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$TimeDepositWithdrawRespToJson(this);
}

@JsonSerializable()
class ResArray extends Object {
  @JsonKey(name: 'ciId')
  String ciId;

  @JsonKey(name: 'pacName')
  String pacName;

  @JsonKey(name: 'pacctNo')
  String pacctNo;

  @JsonKey(name: 'pavaCal')
  String pavaCal;

  @JsonKey(name: 'pccy')
  String pccy;

  @JsonKey(name: 'pcurCal')
  String pcurCal;

  @JsonKey(name: 'pdueDt')
  String pdueDt;

  @JsonKey(name: 'pinStr')
  String pinStr;

  @JsonKey(name: 'pintAc')
  String pintAc;

  @JsonKey(name: 'pminBal')
  String pminBal;

  @JsonKey(name: 'pprodCd')
  String pprodCd;

  @JsonKey(name: 'prate')
  String prate;

  @JsonKey(name: 'pteNor')
  String pteNor;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'surPartNum')
  String surPartNum;

  ResArray(
    this.ciId,
    this.pacName,
    this.pacctNo,
    this.pavaCal,
    this.pccy,
    this.pcurCal,
    this.pdueDt,
    this.pinStr,
    this.pintAc,
    this.pminBal,
    this.pprodCd,
    this.prate,
    this.pteNor,
    this.status,
    this.surPartNum,
  );

  factory ResArray.fromJson(Map<String, dynamic> srcJson) =>
      _$ResArrayFromJson(srcJson);
}
