/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 根据UserID获取用户多张卡余额（欧亚修改的账户总览接口）数据模型
/// Author: 李家伟
/// Date: 2021-03-09

import 'package:json_annotation/json_annotation.dart';

part 'account_overview_all_data.g.dart';

@JsonSerializable()
class AccOverviewDataReq extends Object {
  @JsonKey(name: 'userId') //用户ID
  String userId;

  @JsonKey(name: 'ccy') //币种
  String ccy;

  @JsonKey(name: 'ciNo') //客户号custID
  String ciNo;

  @JsonKey(name: 'accountType') //SA：储蓄账户，CA往来账户，TD定期账户，LN贷款账户，不传查所有
  String accountType;

  AccOverviewDataReq(
    this.userId,
    this.ccy,
    this.ciNo,
    this.accountType,
  );

  factory AccOverviewDataReq.fromJson(Map<String, dynamic> srcJson) =>
      _$AccOverviewDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccOverviewDataReqToJson(this);
}

@JsonSerializable()
class AccOverviewDataResp extends Object {
  ///总金额
  @JsonKey(name: 'totalAmt')
  String totalAmt;

  ///活期总额
  @JsonKey(name: 'ddTotalAmt')
  String ddTotalAmt;

  ///定期总额
  @JsonKey(name: 'tdTotalAmt')
  String tdTotalAmt;

  ///
  @JsonKey(name: 'accDate')
  String accDate;

  ///默认币种
  @JsonKey(name: 'defaultCcy')
  String defaultCcy;

  ///定期列表
  @JsonKey(name: 'tedpListBal')
  List<AccountOverviewList> tedpListBal;

  ///活期列表
  @JsonKey(name: 'cardListBal')
  List<AccountOverviewList> cardListBal;

  AccOverviewDataResp(
    this.totalAmt,
    this.ddTotalAmt,
    this.tdTotalAmt,
    this.accDate,
    this.defaultCcy,
    this.tedpListBal,
    this.cardListBal,
  );

  factory AccOverviewDataResp.fromJson(Map<String, dynamic> srcJson) =>
      _$AccOverviewDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccOverviewDataRespToJson(this);
}

@JsonSerializable()
class AccountOverviewList extends Object {
  ///账户类型
  @JsonKey(name: 'accountType')
  String accountType;

  ///活期账户号
  @JsonKey(name: 'cardNo')
  String cardNo;

  ///币种
  @JsonKey(name: 'ccy')
  String ccy;

  ///余额
  @JsonKey(name: 'currBal')
  String currBal;

  ///可用余额
  @JsonKey(name: 'avaBal')
  String avaBal;

  ///等值本币
  @JsonKey(name: 'equAmt')
  String equAmt;

  AccountOverviewList(
    this.accountType,
    this.cardNo,
    this.ccy,
    this.currBal,
    this.avaBal,
    this.equAmt,
  );

  factory AccountOverviewList.fromJson(Map<String, dynamic> srcJson) =>
      _$AccountOverviewListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$AccountOverviewListToJson(this);
}
