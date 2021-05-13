import 'package:json_annotation/json_annotation.dart';

part 'loan_detail_modelList.g.dart';

@JsonSerializable()
class LoanDetailMastModelReq extends Object {
//贷款账户
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'contactNo')
  String contactNo;

  @JsonKey(name: 'productCode')
  String productCode;

  LoanDetailMastModelReq(
    this.acNo,
    this.ciNo,
    this.contactNo,
    this.productCode,
  );
  factory LoanDetailMastModelReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanDetailMastModelReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanDetailMastModelReqToJson(this);
}

@JsonSerializable()
class LoanDetailMastModelResp extends Object {
  @JsonKey(name: 'lnAcMastAppDOList')
  List<LnAcMastAppDOList> lnAcMastAppDOList;

  LoanDetailMastModelResp(this.lnAcMastAppDOList);

  factory LoanDetailMastModelResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanDetailMastModelRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanDetailMastModelRespToJson(this);
}

@JsonSerializable()
class LnAcMastAppDOList extends Object {
  //贷款帐号
  @JsonKey(name: 'acNo')
  String acNo;
//
  @JsonKey(name: 'acType')
  String acType;
// 可用额度
  @JsonKey(name: 'availableCredit')
  String availableCredit;
//机构代码
  @JsonKey(name: 'br')
  String br;
//币种
  @JsonKey(name: 'ccy')
  String ccy;
//客户名称
  @JsonKey(name: 'ciName')
  String ciName;
//客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
//城市编码
  @JsonKey(name: 'cityCd')
  String cityCd;
//合约编号
  @JsonKey(name: 'contactNo')
  String contactNo;
//首次放款日期
  @JsonKey(name: 'disbDate')
  String disbDate;
// 贷款等级
  @JsonKey(name: 'grade')
  String grade;
//  * 本利和公式
//  * 1：等额本息公式
//  * 2：等额本金公式
//  * 3：RULE78
  @JsonKey(name: 'insTyp')
  String insTyp;
//年利率
  @JsonKey(name: 'intRate')
  String intRate;
//是否到期 0-未到期 1-已到期 2-已逾期
  @JsonKey(name: 'isMaturity')
  String isMaturity;
//额度编号
  @JsonKey(name: 'lmtNo')
  String lmtNo;
//贷款金额
  @JsonKey(name: 'loanAmt')
  String loanAmt;
//  * 贷款类型
//  * CLDD应计贷款
//  * CLDL贴现贷款
  @JsonKey(name: 'loanTyp')
  String loanTyp;
//到期日期
  @JsonKey(name: 'maturityDate')
  String maturityDate;
// 期限（结束日期 - 开始日期）——月份
  @JsonKey(name: 'month')
  String month;
//贷款余额
  @JsonKey(name: 'osAmt')
  String osAmt;
//收款账号
  @JsonKey(name: 'payAcNo')
  String payAcNo;
// 罚息利率
  @JsonKey(name: 'penInt')
  String penInt;
//产品类型
  @JsonKey(name: 'prodTyp')
  String prodTyp;
//repaymentAcNo
  @JsonKey(name: 'repaymentAcNo')
  String repaymentAcNo;
//还款日
  @JsonKey(name: 'repaymentDay')
  int repaymentDay;
//repaymentMethod
  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;
//剩余期数
  @JsonKey(name: 'restPeriods')
  int restPeriods;
// 额度循环类型
//  * R-循环，N-非循换
  @JsonKey(name: 'revolvin')
  String revolvin;
//结息周期
  @JsonKey(name: 'setPerd')
  int setPerd;
// 结息周期单位
//  * D：日
//  * M：月
  @JsonKey(name: 'setUnit')
  String setUnit;
// 状态
//  * A正常状态
//  * C呆账状态
//  * D冲正状态
//  * L逾期18个月
//  * M结清状态
//  * N逾期3个月
//  * O逾期状态
//  * Q逾期12个月
//  * U未生效
//  * X全额核销
//  * Y核销预设
  @JsonKey(name: 'status')
  String status;
// 期限
  @JsonKey(name: 'termValue')
  int termValue;
//未还本金金额
  @JsonKey(name: 'unpaidPrincipal')
  int unpaidPrincipal;

  LnAcMastAppDOList(
    this.acNo,
    this.acType,
    this.availableCredit,
    this.br,
    this.ccy,
    this.ciName,
    this.ciNo,
    this.cityCd,
    this.contactNo,
    this.disbDate,
    this.grade,
    this.insTyp,
    this.intRate,
    this.isMaturity,
    this.lmtNo,
    this.loanAmt,
    this.loanTyp,
    this.maturityDate,
    this.month,
    this.osAmt,
    this.payAcNo,
    this.penInt,
    this.prodTyp,
    this.repaymentAcNo,
    this.repaymentDay,
    this.repaymentMethod,
    this.restPeriods,
    this.revolvin,
    this.setPerd,
    this.setUnit,
    this.status,
    this.termValue,
    this.unpaidPrincipal,
  );

  factory LnAcMastAppDOList.fromJson(Map<String, dynamic> srcJson) =>
      _$LnAcMastAppDOListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LnAcMastAppDOListToJson(this);
}
