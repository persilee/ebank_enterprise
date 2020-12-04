import 'package:json_annotation/json_annotation.dart';

part 'loan.g.dart';

@JsonSerializable()
class Loan extends Object {
  @JsonKey(name: 'businessVarieties')
  String businessVarieties;

  @JsonKey(name: 'loanId')
  String loanId;

  @JsonKey(name: 'loanAmount')
  String loanAmount;

  @JsonKey(name: 'loanBalance')
  String loanBalance;

  @JsonKey(name: 'paymentHistory')
  String paymentHistory;

  @JsonKey(name: 'repaymentSchedule')
  String repaymentSchedule;

  @JsonKey(name: 'loanInterestRates')
  String loanInterestRates;

  @JsonKey(name: 'totalPeriods')
  String totalPeriods;

  @JsonKey(name: 'restPeriods')
  String restPeriods;

  @JsonKey(name: 'startingDate')
  String startingDate;

  @JsonKey(name: 'expiringDate')
  String expiringDate;

  @JsonKey(name: 'paymentMethod')
  String paymentMethod;

  @JsonKey(name: 'agreement')
  String agreement;

  @JsonKey(name: 'debitCard')
  String debitCard;

  Loan(
    this.businessVarieties,
    this.loanId,
    this.loanAmount,
    this.loanBalance,
    this.paymentHistory,
    this.repaymentSchedule,
    this.loanInterestRates,
    this.totalPeriods,
    this.restPeriods,
    this.startingDate,
    this.expiringDate,
    this.paymentMethod,
    this.agreement,
    this.debitCard,
  );

  factory Loan.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
