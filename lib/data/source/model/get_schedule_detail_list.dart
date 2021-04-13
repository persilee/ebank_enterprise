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
  //还款状态 未还NONE、部分还款PART、全额还款ALL
  @JsonKey(name: 'instalType')
  String instalType;
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
  //
  // 还款类型
  @JsonKey(name: 'payType')
  String payType;
//还款状态
  @JsonKey(name: 'paySts')
  String paySts;
//期数号
  @JsonKey(name: 'term')
  int term;
//起息日
  @JsonKey(name: 'valDt')
  String valDt;
//还款日期
  @JsonKey(name: 'payDt')
  String payDt;
//当前期利率
  @JsonKey(name: 'curRate')
  String curRate;
//币种
  @JsonKey(name: 'ccy')
  String ccy;
//还款总金额
  @JsonKey(name: 'payAmt')
  String payAmt;
//还款本金
  @JsonKey(name: 'payPrin')
  String payPrin;
//还款利息
  @JsonKey(name: 'payInt')
  String payInt;
//本金罚息
  @JsonKey(name: 'payPen')
  String payPen;
//利息罚息
  @JsonKey(name: 'payCom')
  String payCom;
//已还总金额
  @JsonKey(name: 'recAmt')
  String recAmt;
//已还本金
  @JsonKey(name: 'recPrin')
  String recPrin;
//已还利息
  @JsonKey(name: 'recInt')
  String recInt;
//已还本金罚息
  @JsonKey(name: 'recPen')
  String recPen;
//已还利息罚息
  @JsonKey(name: 'recCom')
  String recCom;
//备注
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
