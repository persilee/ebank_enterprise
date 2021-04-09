import 'package:json_annotation/json_annotation.dart';

part 'get_schedule_detail_list.g.dart';

@JsonSerializable()
class GetScheduleDetailListReq extends Object {
  //贷款账号
  @JsonKey(name: 'acNo')
  String acNo;
  //页码
  // @JsonKey(name: 'page')
  // String page;
  // //一页数据条数
  // @JsonKey(name: 'pageSize')
  // String pageSize;
  //还款状态
  @JsonKey(name: 'trnFunc')
  String trnFunc;

  GetScheduleDetailListReq(
    this.acNo,
    // this.page,
    // this.pageSize,
    this.trnFunc,
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
  // //贷款账号
  // @JsonKey(name: 'acNo')
  // String acNo;
  // //利息摊销金额
  // @JsonKey(name: 'amorIntAmt')
  // String amorIntAmt;
  // //分期天数
  // @JsonKey(name: 'ctrDays')
  // String ctrDays;
  // //阶段分期
  // @JsonKey(name: 'ctrInstal')
  // int ctrInstal;
  // //阶段序号
  // @JsonKey(name: 'ctrStageNo')
  // int ctrStageNo;
  // //分期日期
  // @JsonKey(name: 'instalDate')
  // String instalDate;
  // //归还金额合计
  // @JsonKey(name: 'instalOutstAmt')
  // String instalOutstAmt;
  // //分期状态
  // //正常NORMAL 到期EXPIRE 逾期OVERDUE 代偿COMPENSATE
  // @JsonKey(name: 'instalStatus')
  // String instalStatus;
  // //还款状态 未还NONE、部分还款PART、全额还款ALL
  // @JsonKey(name: 'instalType')
  // String instalType;
  // //分期金额
  // @JsonKey(name: 'interestAmt')
  // String interestAmt;
  // //最后还款日期
  // @JsonKey(name: 'lastPaymentDate')
  // String lastPaymentDate;
  // //期后本金金额
  // @JsonKey(name: 'princBalAmt')
  // String princBalAmt;
  // //本金金额
  // @JsonKey(name: 'principalAmt')
  // String principalAmt;
  // //阶段开始日期
  // @JsonKey(name: 'stageStartDate')
  // String stageStartDate;
  // //开始日期
  // @JsonKey(name: 'startDate')
  // String startDate;
  // //补贴金额
  // @JsonKey(name: 'subsidyAmt')
  // String subsidyAmt;
  @JsonKey(name: 'payType')
  String payType;

  @JsonKey(name: 'paySts')
  String paySts;

  @JsonKey(name: 'term')
  int term;

  @JsonKey(name: 'valDt')
  String valDt;

  @JsonKey(name: 'payDt')
  String payDt;

  @JsonKey(name: 'curRate')
  String curRate;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'payAmt')
  String payAmt;

  @JsonKey(name: 'payPrin')
  String payPrin;

  @JsonKey(name: 'payInt')
  String payInt;

  @JsonKey(name: 'payPen')
  String payPen;

  @JsonKey(name: 'payCom')
  String payCom;

  @JsonKey(name: 'recAmt')
  String recAmt;

  @JsonKey(name: 'recPrin')
  String recPrin;

  @JsonKey(name: 'recInt')
  String recInt;

  @JsonKey(name: 'recPen')
  String recPen;

  @JsonKey(name: 'recCom')
  String recCom;

  @JsonKey(name: 'remark')
  String remark;

  GetLnAcScheduleRspDetlsDTOList(
    this.payType,
    this.paySts,
    this.term,
    this.valDt,
    this.payDt,
    this.curRate,
    this.ccy,
    this.payAmt,
    this.payPrin,
    this.payInt,
    this.payPen,
    this.payCom,
    this.recAmt,
    this.recPrin,
    this.recInt,
    this.recPen,
    this.recCom,
    this.remark,
  );
  // GetLnAcScheduleRspDetlsDTOList(
  //   this.acNo,
  //   this.amorIntAmt,
  //   this.ctrDays,
  //   this.ctrInstal,
  //   this.ctrStageNo,
  //   this.instalDate,
  //   this.instalOutstAmt,
  //   this.instalStatus,
  //   this.instalType,
  //   this.interestAmt,
  //   this.lastPaymentDate,
  //   this.princBalAmt,
  //   this.principalAmt,
  //   this.stageStartDate,
  //   this.startDate,
  //   this.subsidyAmt,
  // );

  factory GetLnAcScheduleRspDetlsDTOList.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetLnAcScheduleRspDetlsDTOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLnAcScheduleRspDetlsDTOListToJson(this);
}
