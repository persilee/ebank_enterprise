/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账记录
/// Author: fangluyao
/// Date: 2020-12-25

import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_record.g.dart';

@JsonSerializable()
class GetTransferRecordReq extends Object {
//币种
  @JsonKey(name: 'ccy')
  String ccy;
//结束日期
  @JsonKey(name: 'endDate')
  String endDate;
//页
  @JsonKey(name: 'page')
  int page;
//页面大小
  @JsonKey(name: 'pageSize')
  int pageSize;
//交易银行卡号收款
  @JsonKey(name: 'paymentCardNos')
  List<String> paymentCardNos;
//排序
  @JsonKey(name: 'sort')
  String sort;
//开始日期
  @JsonKey(name: 'startDate')
  String startDate;
  //登录名
  @JsonKey(name: 'loginName')
  String loginName;
//用户ID
  @JsonKey(name: 'userId')
  String userId;

  GetTransferRecordReq(
    this.ccy,
    this.endDate,
    this.page,
    this.pageSize,
    this.paymentCardNos,
    this.sort,
    this.startDate,
    this.loginName,
    this.userId,
  );

  factory GetTransferRecordReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferRecordReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferRecordReqToJson(this);
}

@JsonSerializable()
class GetTransferRecordResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'rows')
  List<TransferRecord> transferRecord;

  GetTransferRecordResp(
    this.page,
    this.count,
    this.totalPage,
    this.transferRecord,
  );

  factory GetTransferRecordResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferRecordRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferRecordRespToJson(this);
}

@JsonSerializable()
class TransferRecord extends Object {
  //id
  @JsonKey(name: 'id')
  String id;
//交易流水号
  @JsonKey(name: 'msgId')
  String msgId;
//交易时间
  @JsonKey(name: 'transactionTime')
  String transactionTime;
//收款卡号
  @JsonKey(name: 'receiveCardNo')
  String receiveCardNo;
//收款人姓名
  @JsonKey(name: 'receiveName')
  String receiveName;
//收款银行代码
  @JsonKey(name: 'receiveBankCode')
  String receiveBankCode;
//数量
  @JsonKey(name: 'debitAmount')
  String debitAmount;
//付款货币
  @JsonKey(name: 'debitCurrency')
  String debitCurrency;
//信用货币
  @JsonKey(name: 'creditCurrency')
  String creditCurrency;
//借贷方向
  @JsonKey(name: 'drCrFlg')
  String drCrFlg;
//状态
  @JsonKey(name: 'status')
  String status;
//费用金额
  @JsonKey(name: 'feeAmount')
  String feeAmount;
//付款卡号
  @JsonKey(name: 'paymentCardNo')
  String paymentCardNo;
//付款银行代码
  @JsonKey(name: 'paymentBankCode')
  String paymentBankCode;
//转账类型
  @JsonKey(name: 'transferType')
  String transferType;
//国家/地区
  @JsonKey(name: 'countryOrRegion')
  String countryOrRegion;
//银行SWIFT
  @JsonKey(name: 'bankSwift')
  String bankSwift;
//中间行SWIFT
  @JsonKey(name: 'intermediateBankSwift')
  String intermediateBankSwift;
//汇款人地址
  @JsonKey(name: 'remitterAddress')
  String remitterAddress;
  //收款人地址
  @JsonKey(name: 'payeeAddress')
  String payeeAddress;
  //付款目的
  @JsonKey(name: 'remittancePurposes')
  String remittancePurposes;
//其他费用
  @JsonKey(name: 'costOptions')
  String costOptions;
//备注
  @JsonKey(name: 'remark')
  String remark;
//修改时间
  @JsonKey(name: 'modifyTime')
  String modifyTime;
//创建时间
  @JsonKey(name: 'createTime')
  String createTime;

  TransferRecord(
    this.id,
    this.msgId,
    this.transactionTime,
    this.receiveCardNo,
    this.receiveName,
    this.receiveBankCode,
    this.debitAmount,
    this.debitCurrency,
    this.creditCurrency,
    this.drCrFlg,
    this.status,
    this.feeAmount,
    this.paymentCardNo,
    this.paymentBankCode,
    this.transferType,
    this.countryOrRegion,
    this.bankSwift,
    this.intermediateBankSwift,
    this.remitterAddress,
    this.payeeAddress,
    this.remittancePurposes,
    this.costOptions,
    this.remark,
    this.modifyTime,
    this.createTime,
  );

  factory TransferRecord.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferRecordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransferRecordToJson(this);
}
