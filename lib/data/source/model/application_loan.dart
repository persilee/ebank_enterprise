import 'package:json_annotation/json_annotation.dart';

part 'application_loan.g.dart';

@JsonSerializable()
class LoanIntereRateReq extends Object {
  @JsonKey(name: 'branch')
  int branchID;

  @JsonKey(name: 'currency')
  String currency;

  @JsonKey(name: 'rateType')
  String rateType;

  @JsonKey(name: 'tenor')
  String tenor;

  LoanIntereRateReq(
    this.branchID,
    this.currency,
    this.rateType,
    this.tenor,
  );

  factory LoanIntereRateReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanIntereRateReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanIntereRateReqToJson(this);
}

@JsonSerializable()
class LoantIntereRateResp extends Object {
  @JsonKey(name: 'branch')
  int branchID;

  @JsonKey(name: 'currency')
  String currency;

  @JsonKey(name: 'interestRate')
  int interestRate;

  @JsonKey(name: 'rateType')
  String rateType;

  @JsonKey(name: 'tenor')
  String tenor;

  LoantIntereRateResp(
    this.branchID,
    this.currency,
    this.interestRate,
    this.rateType,
    this.tenor,
  );

  factory LoantIntereRateResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoantIntereRateRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$LoantIntereRateRespToJson(this);
}
