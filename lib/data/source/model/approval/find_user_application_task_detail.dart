/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: fangluyao
/// Date: 2020-12-31

import 'package:json_annotation/json_annotation.dart';

part 'find_user_application_task_detail.g.dart';

@JsonSerializable()
class FindUserApplicationDetailReq extends Object {
  @JsonKey(name: 'processId')
  String processId;

  FindUserApplicationDetailReq(
    this.processId,
  );

  factory FindUserApplicationDetailReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserApplicationDetailReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FindUserApplicationDetailReqToJson(this);
}

@JsonSerializable()
class FindUserApplicationDetailResp extends Object {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'processTitle')
  String processTitle;

  @JsonKey(name: 'processKey')
  String processKey;

  @JsonKey(name: 'operateEndValue')
  OperateEndValue operateEndValue;

  @JsonKey(name: 'servCtr')
  String servCtr;

  @JsonKey(name: 'commentList')
  List<CommentList> commentList;

  @JsonKey(name: 'result')
  bool result;

  FindUserApplicationDetailResp(
    this.userId,
    this.processTitle,
    this.processKey,
    this.operateEndValue,
    this.servCtr,
    this.commentList,
    this.result,
  );

  factory FindUserApplicationDetailResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$FindUserApplicationDetailRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserApplicationDetailRespToJson(this);
}

@JsonSerializable()
class OperateEndValue extends Object {
  @JsonKey(name: 'prdtCode')
  String prdtCode;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'payAcNo')
  String payAcNo;

  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'intentAmt')
  String intentAmt;

  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  @JsonKey(name: 'termValue')
  int termValue;

  @JsonKey(name: 'termUnit')
  String termUnit;

  @JsonKey(name: 'loanPurpose')
  String loanPurpose;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'prodMast')
  ProdMast prodMast;

  @JsonKey(name: 'prodCcy')
  ProdCcy prodCcy;

  OperateEndValue(
    this.prdtCode,
    this.ccy,
    this.payAcNo,
    this.repaymentAcNo,
    this.ciNo,
    this.intentAmt,
    this.repaymentMethod,
    this.termValue,
    this.termUnit,
    this.loanPurpose,
    this.remark,
    this.prodMast,
    this.prodCcy,
  );

  factory OperateEndValue.fromJson(Map<String, dynamic> srcJson) =>
      _$OperateEndValueFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OperateEndValueToJson(this);
}

@JsonSerializable()
class ProdMast extends Object {
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'prdtCode')
  String prdtCode;

  @JsonKey(name: 'contType')
  String contType;

  @JsonKey(name: 'curType')
  String curType;

  @JsonKey(name: 'chnName')
  String chnName;

  @JsonKey(name: 'engName')
  String engName;

  @JsonKey(name: 'effDate')
  String effDate;

  @JsonKey(name: 'expDate')
  String expDate;

  @JsonKey(name: 'prdtSts')
  String prdtSts;

  @JsonKey(name: 'prdtCiType')
  String prdtCiType;

  @JsonKey(name: 'apprSeq')
  String apprSeq;

  @JsonKey(name: 'efsPymtAllowedFlg')
  String efsPymtAllowedFlg;

  @JsonKey(name: 'ppfPymtAllowedFlg')
  String ppfPymtAllowedFlg;

  @JsonKey(name: 'disbModeAllow')
  String disbModeAllow;

  @JsonKey(name: 'repaymentModeAllow')
  String repaymentModeAllow;

  @JsonKey(name: 'repaymentMethodAllow')
  String repaymentMethodAllow;

  @JsonKey(name: 'gracePeriodMethod')
  String gracePeriodMethod;

  @JsonKey(name: 'maxGraceDays')
  int maxGraceDays;

  @JsonKey(name: 'holidayMethod')
  String holidayMethod;

  @JsonKey(name: 'maxLoanTerm')
  int maxLoanTerm;

  @JsonKey(name: 'minLoanTerm')
  int minLoanTerm;

  @JsonKey(name: 'repricingPeriod')
  int repricingPeriod;

  @JsonKey(name: 'repricingPeriodUnit')
  String repricingPeriodUnit;

  @JsonKey(name: 'interestRateFloatDay')
  String interestRateFloatDay;

  @JsonKey(name: 'rateFloatType')
  String rateFloatType;

  @JsonKey(name: 'noticeDays')
  int noticeDays;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'trBr')
  String trBr;

  @JsonKey(name: 'createUser')
  String createUser;

  @JsonKey(name: 'modifyUser')
  String modifyUser;

  ProdMast(
    this.modifyTime,
    this.createTime,
    this.prdtCode,
    this.contType,
    this.curType,
    this.chnName,
    this.engName,
    this.effDate,
    this.expDate,
    this.prdtSts,
    this.prdtCiType,
    this.apprSeq,
    this.efsPymtAllowedFlg,
    this.ppfPymtAllowedFlg,
    this.disbModeAllow,
    this.repaymentModeAllow,
    this.repaymentMethodAllow,
    this.gracePeriodMethod,
    this.maxGraceDays,
    this.holidayMethod,
    this.maxLoanTerm,
    this.minLoanTerm,
    this.repricingPeriod,
    this.repricingPeriodUnit,
    this.interestRateFloatDay,
    this.rateFloatType,
    this.noticeDays,
    this.remark,
    this.trBr,
    this.createUser,
    this.modifyUser,
  );

  factory ProdMast.fromJson(Map<String, dynamic> srcJson) =>
      _$ProdMastFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProdMastToJson(this);
}

@JsonSerializable()
class ProdCcy extends Object {
  @JsonKey(name: 'prdtCode')
  String prdtCode;

  @JsonKey(name: 'contType')
  String contType;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'maxInstalAmt')
  String maxInstalAmt;

  @JsonKey(name: 'maxLoanAmt')
  String maxLoanAmt;

  @JsonKey(name: 'minInstalAmt')
  String minInstalAmt;

  @JsonKey(name: 'minLoanAmt')
  String minLoanAmt;

  @JsonKey(name: 'rateType')
  String rateType;

  @JsonKey(name: 'normalRateCode')
  String normalRateCode;

  @JsonKey(name: 'floatRate')
  String floatRate;

  @JsonKey(name: 'maxIntRate')
  String maxIntRate;

  @JsonKey(name: 'minIntRate')
  String minIntRate;

  @JsonKey(name: 'penaltyChargeFlg')
  String penaltyChargeFlg;

  @JsonKey(name: 'compIntFlg')
  String compIntFlg;

  @JsonKey(name: 'penaltyRateBasis')
  String penaltyRateBasis;

  @JsonKey(name: 'penaltyRateCode')
  String penaltyRateCode;

  @JsonKey(name: 'penaltyFloatMethod')
  String penaltyFloatMethod;

  @JsonKey(name: 'penaltyFloatRate')
  String penaltyFloatRate;

  @JsonKey(name: 'trBr')
  String trBr;

  @JsonKey(name: 'intVarType')
  String intVarType;

  @JsonKey(name: 'payCiNo')
  String payCiNo;

  @JsonKey(name: 'receiveCiNo')
  String receiveCiNo;

  @JsonKey(name: 'payAcNo')
  String payAcNo;

  @JsonKey(name: 'payCiName')
  String payCiName;

  @JsonKey(name: 'receiveAcNo')
  String receiveAcNo;

  @JsonKey(name: 'receiveCiName')
  String receiveCiName;

  @JsonKey(name: 'createUser')
  String createUser;

  @JsonKey(name: 'modifyUser')
  String modifyUser;

  ProdCcy(
    this.prdtCode,
    this.contType,
    this.ccy,
    this.maxInstalAmt,
    this.maxLoanAmt,
    this.minInstalAmt,
    this.minLoanAmt,
    this.rateType,
    this.normalRateCode,
    this.floatRate,
    this.maxIntRate,
    this.minIntRate,
    this.penaltyChargeFlg,
    this.compIntFlg,
    this.penaltyRateBasis,
    this.penaltyRateCode,
    this.penaltyFloatMethod,
    this.penaltyFloatRate,
    this.trBr,
    this.intVarType,
    this.payCiNo,
    this.receiveCiNo,
    this.payAcNo,
    this.payCiName,
    this.receiveAcNo,
    this.receiveCiName,
    this.createUser,
    this.modifyUser,
  );

  factory ProdCcy.fromJson(Map<String, dynamic> srcJson) =>
      _$ProdCcyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProdCcyToJson(this);
}

@JsonSerializable()
class CommentList extends Object {
  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'result')
  bool result;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: 'time')
  String time;

  CommentList(
    this.userName,
    this.result,
    this.comment,
    this.time,
  );

  factory CommentList.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentListToJson(this);
}
