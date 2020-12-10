/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-03

import 'package:json_annotation/json_annotation.dart';

part 'loan.g.dart';

@JsonSerializable()
class Loans extends Object {
  @JsonKey(name: 'loan_product_name_with_value')
  String loanProductNameWithValue;

  @JsonKey(name: 'loanId')
  String loanId;

  @JsonKey(name: 'loan_amount')
  String loanAmount;

  @JsonKey(name: 'loan_balance2')
  String loanBalance2;

  @JsonKey(name: 'loan_interest_rate_with_symbol')
  String loanInterestRateWithSymbol;

  @JsonKey(name: 'total_periods')
  String totalPeriods;

  @JsonKey(name: 'remaining_periods')
  String remainingPeriods;

  @JsonKey(name: 'begin_date')
  String beginDate;

  @JsonKey(name: 'end_date')
  String endDate;

  @JsonKey(name: 'repayment_ways')
  String repaymentWays;

  @JsonKey(name: 'deduct_money_date')
  String deductMoneyDate;

  @JsonKey(name: 'deduct_money_account')
  String deductMoneyAccount;

  Loans(
    this.loanProductNameWithValue,
    this.loanId,
    this.loanAmount,
    this.loanBalance2,
    this.loanInterestRateWithSymbol,
    this.totalPeriods,
    this.remainingPeriods,
    this.beginDate,
    this.endDate,
    this.repaymentWays,
    this.deductMoneyDate,
    this.deductMoneyAccount,
  );

  factory Loans.fromJson(Map<String, dynamic> srcJson) =>
      _$LoansFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoansToJson(this);
}
