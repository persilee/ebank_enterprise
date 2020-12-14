import 'package:json_annotation/json_annotation.dart';

part 'get_schedule_detail_list.g.dart';

@JsonSerializable()
class GetScheduleDetailListReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'repaymentStatus')
  String repaymentStatus;

  GetScheduleDetailListReq(
    this.acNo,
    this.repaymentStatus,
  );

  factory GetScheduleDetailListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetScheduleDetailListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetScheduleDetailListReqToJson(this);
}

@JsonSerializable()
class GetScheduleDetailListResp extends Object {
  @JsonKey(name: 'getLnAcScheduleRspDetlsDTOList')
  List<GetLnAcScheduleRspDetlsDTOList> getLnAcScheduleRspDetlsDTOList;

  GetScheduleDetailListResp(
    this.getLnAcScheduleRspDetlsDTOList,
  );

  factory GetScheduleDetailListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetScheduleDetailListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetScheduleDetailListRespToJson(this);
}

@JsonSerializable()
class GetLnAcScheduleRspDetlsDTOList extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'amorIntAmt')
  int amorIntAmt;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'ctrDays')
  int ctrDays;

  @JsonKey(name: 'ctrInstal')
  int ctrInstal;

  @JsonKey(name: 'ctrStageNo')
  int ctrStageNo;

  @JsonKey(name: 'instalDate')
  String instalDate;

  @JsonKey(name: 'instalOutstAmt')
  int instalOutstAmt;

  @JsonKey(name: 'instalStatus')
  String instalStatus;

  @JsonKey(name: 'instalType')
  String instalType;

  @JsonKey(name: 'interestAmt')
  int interestAmt;

  @JsonKey(name: 'lastPaymentDate')
  String lastPaymentDate;

  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'princBalAmt')
  int princBalAmt;

  @JsonKey(name: 'principalAmt')
  int principalAmt;

  @JsonKey(name: 'stageStartDate')
  String stageStartDate;

  @JsonKey(name: 'startDate')
  String startDate;

  @JsonKey(name: 'subsidyAmt')
  int subsidyAmt;

  GetLnAcScheduleRspDetlsDTOList(
    this.acNo,
    this.amorIntAmt,
    this.createTime,
    this.ctrDays,
    this.ctrInstal,
    this.ctrStageNo,
    this.instalDate,
    this.instalOutstAmt,
    this.instalStatus,
    this.instalType,
    this.interestAmt,
    this.lastPaymentDate,
    this.modifyTime,
    this.princBalAmt,
    this.principalAmt,
    this.stageStartDate,
    this.startDate,
    this.subsidyAmt,
  );

  factory GetLnAcScheduleRspDetlsDTOList.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetLnAcScheduleRspDetlsDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLnAcScheduleRspDetlsDTOListToJson(this);
}
