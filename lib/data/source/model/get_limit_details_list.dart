/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-03

import 'package:json_annotation/json_annotation.dart';

part 'get_limit_details_list.g.dart';

@JsonSerializable()
class GetLimitDetailsListResp extends Object {
  @JsonKey(name: 'limitDetailsList')
  List<LimitDetails> limitDetailsList;

  GetLimitDetailsListResp(
    this.limitDetailsList,
  );

  factory GetLimitDetailsListResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetLimitDetailsListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetLimitDetailsListRespToJson(this);
}


@JsonSerializable()
class LimitDetails extends Object {
  @JsonKey(name: 'contract_account')
  String contractAccount;

  @JsonKey(name: 'loan_principal')
  String loanPrincipal;

  @JsonKey(name: 'loan_balance2')
  String loanBalance2;

  @JsonKey(name: 'begin_time')
  String beginTime;

  @JsonKey(name: 'end_time')
  String endTime;

  @JsonKey(name: 'loan_interest_rate')
  String loanInterestRate;

  LimitDetails(
    this.contractAccount,
    this.loanPrincipal,
    this.loanBalance2,
    this.beginTime,
    this.endTime,
    this.loanInterestRate,
  );

  factory LimitDetails.fromJson(Map<String, dynamic> srcJson) =>
      _$LimitDetailsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LimitDetailsToJson(this);
}
