/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:json_annotation/json_annotation.dart';

part 'get_transfer_partner_list.g.dart';

@JsonSerializable()
class GetTransferPartnerListReq {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  GetTransferPartnerListReq(
    this.page,
    this.pageSize,
  );

  factory GetTransferPartnerListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTransferPartnerListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTransferPartnerListReqToJson(this);
}

@JsonSerializable()
class TransferPartnerListResp extends Object {
  ///页码
  @JsonKey(name: 'page')
  int page;

  ///一页条数
  @JsonKey(name: 'pageSize')
  int pageSize;

  ///总条数
  @JsonKey(name: 'count')
  int count;

  ///总页数
  @JsonKey(name: 'totalPage')
  int totalPage;

  ///转账模板数组
  @JsonKey(name: 'rows')
  List<Rows> rows;

  TransferPartnerListResp(
    this.page,
    this.pageSize,
    this.count,
    this.totalPage,
    this.rows,
  );

  factory TransferPartnerListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$TransferPartnerListRespFromJson(srcJson);
}

@JsonSerializable()
class Rows extends Object {
  ///卡号
  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  ///客户号
  @JsonKey(name: 'custId')
  String custId;

  ///持卡人姓名
  @JsonKey(name: 'payeeName')
  String payeeName;

  ///手机号
  @JsonKey(name: 'phoneNo')
  String phoneNo;

  ///银行编码
  @JsonKey(name: 'bankCode')
  String bankCode;

  ///银行名称（本地）
  @JsonKey(name: 'payeeBankLocalName')
  String payeeBankLocalName;

  ///银行名称（英文）
  @JsonKey(name: 'payeeBankEngName')
  String payeeBankEngName;

  ///银行图标
  @JsonKey(name: 'payeeBankImageUrl')
  String payeeBankImageUrl;

  ///卡来源（0-本行，1-他行，2-国际）
  @JsonKey(name: 'transferType')
  String transferType;

  ///收款人地址
  @JsonKey(name: 'payeeAddress')
  String payeeAddress;

  ///国家/地区
  @JsonKey(name: 'district')
  String district;

  ///银行SWIFT
  @JsonKey(name: 'bankSwift')
  String bankSwift;

  ///中间行SWIFT
  @JsonKey(name: 'midBankSwift')
  String midBankSwift;

  ///交易日期
  @JsonKey(name: 'transactionDate')
  String transactionDate;

  ///备注
  @JsonKey(name: 'remark')
  String remark;

  ///付款人卡号
  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  ///付款人户名
  @JsonKey(name: 'payerName')
  String payerName;

  ///付款人银行
  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  ///城市
  @JsonKey(name: 'city')
  String city;

  ///创建时间
  @JsonKey(name: 'createTime')
  String createTime;

  ///最后修改时间
  @JsonKey(name: 'modifyTime')
  String modifyTime;

  Rows(
    this.payeeCardNo,
    this.custId,
    this.payeeName,
    this.phoneNo,
    this.bankCode,
    this.payeeBankLocalName,
    this.payeeBankEngName,
    this.payeeBankImageUrl,
    this.transferType,
    this.payeeAddress,
    this.district,
    this.bankSwift,
    this.midBankSwift,
    this.transactionDate,
    this.remark,
    this.payerCardNo,
    this.payerName,
    this.payerBankCode,
    this.city,
    this.createTime,
    this.modifyTime,
  );

  factory Rows.fromJson(Map<String, dynamic> srcJson) =>
      _$RowsFromJson(srcJson);
}
