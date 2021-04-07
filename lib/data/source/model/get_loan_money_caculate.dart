/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-22
import 'package:json_annotation/json_annotation.dart';

part 'get_loan_money_caculate.g.dart';

@JsonSerializable()
class GetLoanCaculateResp extends Object {
  @JsonKey(name: 'postAdvanceRepaymentDTOList')
  List<PostAdvanceRepaymentDTOList> postAdvanceRepaymentDTOList;

  GetLoanCaculateResp(
    this.postAdvanceRepaymentDTOList,
  );

  factory GetLoanCaculateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanCaculateRespFromJson(srcJson);
}

@JsonSerializable()
class PostAdvanceRepaymentDTOList extends Object {
  @JsonKey(name: 'acNo')
  String acNo;

  @JsonKey(name: 'bfcFat')
  String bfcFat;

  @JsonKey(name: 'bfcFee')
  String bfcFee;

  @JsonKey(name: 'br')
  int br;

  @JsonKey(name: 'calrStd')
  String calrStd;

  @JsonKey(name: 'ccy')
  String ccy;

  @JsonKey(name: 'chgFee')
  String chgFee;

  @JsonKey(name: 'chgRat')
  String chgRat;

  @JsonKey(name: 'ciCnm')
  String ciCnm;

  @JsonKey(name: 'ciEnm')
  String ciEnm;

  @JsonKey(name: 'ciNo')
  String ciNo;

  @JsonKey(name: 'cityCd')
  String cityCd;

  @JsonKey(name: 'intMod')
  String intMod;

  @JsonKey(name: 'lonBal')
  String lonBal;

  @JsonKey(name: 'lonPrin')
  String lonPrin;

  @JsonKey(name: 'payInt')
  String payInt;

  @JsonKey(name: 'payPrin')
  String payPrin;

  @JsonKey(name: 'prodCd')
  String prodCd;

  @JsonKey(name: 'rcvCom')
  String rcvCom;

  @JsonKey(name: 'rcvInt')
  String rcvInt;

  @JsonKey(name: 'rcvPen')
  String rcvPen;

  @JsonKey(name: 'rcvPri')
  String rcvPri;

  @JsonKey(name: 'rcvTot')
  String rcvTot;

  @JsonKey(name: 'refNo')
  String refNo;

  @JsonKey(name: 'synFlg')
  String synFlg;

  @JsonKey(name: 'totAmt')
  String totAmt;

  @JsonKey(name: 'valDt')
  String valDt;

  PostAdvanceRepaymentDTOList(
    this.acNo,
    this.bfcFat,
    this.bfcFee,
    this.br,
    this.calrStd,
    this.ccy,
    this.chgFee,
    this.chgRat,
    this.ciCnm,
    this.ciEnm,
    this.ciNo,
    this.cityCd,
    this.intMod,
    this.lonBal,
    this.lonPrin,
    this.payInt,
    this.payPrin,
    this.prodCd,
    this.rcvCom,
    this.rcvInt,
    this.rcvPen,
    this.rcvPri,
    this.rcvTot,
    this.refNo,
    this.synFlg,
    this.totAmt,
    this.valDt,
  );

  factory PostAdvanceRepaymentDTOList.fromJson(Map<String, dynamic> srcJson) =>
      _$PostAdvanceRepaymentDTOListFromJson(srcJson);
}

@JsonSerializable()
class GetLoanCaculateReq extends Object {
  @JsonKey(name: 'acNo')
  String acNo;
  //机构号
  @JsonKey(name: 'br')
  String br;
//币种
  @JsonKey(name: 'ccy')
  String ccy;

//客户号
  @JsonKey(name: 'ciNo')
  String ciNo;
//贷款余额
  @JsonKey(name: 'lonBal')
  String lonBal;
//贷款本金
  @JsonKey(name: 'lonPrin')
  String lonPrin;
//还本金额
  @JsonKey(name: 'principalAmount')
  String principalAmount;

//产品类型
  @JsonKey(name: 'prodCd')
  String prodCd;
  //生效日期
  @JsonKey(name: 'valDt')
  String valDt;
  //还息方式
  @JsonKey(name: 'repaymentMethod')
  String repaymentMethod;

  GetLoanCaculateReq(
    this.acNo,
    this.br,
    this.ccy,
    this.ciNo,
    this.lonBal,
    this.lonPrin,
    this.principalAmount,
    this.prodCd,
    this.repaymentMethod,
    this.valDt,
  );
  factory GetLoanCaculateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanCaculateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanCaculateReqToJson(this);
}
