/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:json_annotation/json_annotation.dart';
part 'get_account_overview_info.g.dart';

// 总资产
@JsonSerializable()
class GetTotalAssetsReq {
  @JsonKey(name: 'userId')
  String userId;

  GetTotalAssetsReq(
    this.userId,
  );

  factory GetTotalAssetsReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTotalAssetsReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTotalAssetsReqToJson(this);
}

@JsonSerializable()
class GetTotalAssetsResp extends Object {
  @JsonKey(name: 'ccy')
  String ccy;
  @JsonKey(name: 'totalAssets')
  String totalAssets;
  @JsonKey(name: 'totalLiability')
  String totalLiability;
  @JsonKey(name: 'netAssets')
  String netAssets;

  GetTotalAssetsResp(
    this.ccy,
    this.totalAssets,
    this.totalLiability,
    this.netAssets,
  );

  factory GetTotalAssetsResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTotalAssetsRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTotalAssetsRespToJson(this);
}

// 活期
@JsonSerializable()
class GetCardListBalByUserReq {}

@JsonSerializable()
class GetCardListBalByUserResp extends Object {
  @JsonKey(name: 'cardListBal')
  List<CardListBal> cardListBal;
  @JsonKey(name: 'totalAmt')
  String totalAmt;
  @JsonKey(name: 'defaultCcy')
  String defaultCcy;

  GetCardListBalByUserResp(
    this.cardListBal,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetCardListBalByUserResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetCardListBalByUserRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetCardListBalByUserRespToJson(this);
}

@JsonSerializable()
class CardListBal extends Object {
  @JsonKey(name: 'cardNo')
  String cardNo;
  @JsonKey(name: 'ccy')
  String ccy;
  @JsonKey(name: 'currBal')
  String currBal;
  @JsonKey(name: 'avaBal')
  String avaBal;
  @JsonKey(name: 'equAmt')
  String equAmt;

  CardListBal(
    this.cardNo,
    this.ccy,
    this.currBal,
    this.avaBal,
    this.equAmt,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory CardListBal.fromJson(Map<String, dynamic> srcJson) =>
      _$CardListBalFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CardListBalToJson(this);
}

// 定期
@JsonSerializable()
class GetTdConInfoListReq {
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'page')
  String page;
  @JsonKey(name: 'pageSize')
  String pageSize;

  GetTdConInfoListReq({this.ciNo, this.page = '1', this.pageSize = '200'});

  factory GetTdConInfoListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdConInfoListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdConInfoListReqToJson(this);
}

@JsonSerializable()
class GetTdConInfoListResp extends Object {
  @JsonKey(name: 'rows')
  List<TdConInfoList> rows;

  GetTdConInfoListResp(
    this.rows,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetTdConInfoListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTdConInfoListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTdConInfoListRespToJson(this);
}

@JsonSerializable()
class TdConInfoList extends Object {
  @JsonKey(name: 'settDdAc')
  String settDdAc;
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'conNo')
  String conNo;
  @JsonKey(name: 'bal')
  String bal;
  @JsonKey(name: 'ccy')
  String ccy;

  TdConInfoList(
    this.settDdAc,
    this.ciNo,
    this.conNo,
    this.bal,
    this.ccy,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory TdConInfoList.fromJson(Map<String, dynamic> srcJson) =>
      _$TdConInfoListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TdConInfoListToJson(this);
}

@JsonSerializable()
class GetActiveContractByCiNoReq {
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'userId')
  String userId;

  GetActiveContractByCiNoReq(this.ciNo, this.userId);

  factory GetActiveContractByCiNoReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetActiveContractByCiNoReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetActiveContractByCiNoReqToJson(this);
}

@JsonSerializable()
class GetActiveContractByCiNoResp extends Object {
  @JsonKey(name: 'totalAmt')
  String totalAmt;

  GetActiveContractByCiNoResp(
    this.totalAmt,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetActiveContractByCiNoResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetActiveContractByCiNoRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetActiveContractByCiNoRespToJson(this);
}

// 贷款
@JsonSerializable()
class GetLoanMastListReq {
  @JsonKey(name: 'ciNo')
  String ciNo;

  GetLoanMastListReq(this.ciNo);

  factory GetLoanMastListReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanMastListReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanMastListReqToJson(this);
}

@JsonSerializable()
class GetLoanMastListResp extends Object {
  @JsonKey(name: 'totalLiability')
  String totalLiability;
  @JsonKey(name: 'lnAcMastAppDOList')
  List<LoanMastList> lnAcMastAppDOList;

  GetLoanMastListResp(
    this.totalLiability,
    this.lnAcMastAppDOList,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory GetLoanMastListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLoanMastListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLoanMastListRespToJson(this);
}

@JsonSerializable()
class LoanMastList extends Object {
  @JsonKey(name: 'acNo')
  String acNo;
  @JsonKey(name: 'contactNo')
  String contactNo;
  @JsonKey(name: 'ciNo')
  String ciNo;
  @JsonKey(name: 'loanAmt')
  String loanAmt;
  @JsonKey(name: 'unpaidPrincipal')
  String unpaidPrincipal;

  LoanMastList(
    this.acNo,
    this.contactNo,
    this.ciNo,
    this.loanAmt,
    this.unpaidPrincipal,
  );

  @override
  String toString() {
    return toJson().toString();
  }

  factory LoanMastList.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanMastListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanMastListToJson(this);
}
