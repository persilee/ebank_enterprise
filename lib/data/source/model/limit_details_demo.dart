import 'package:json_annotation/json_annotation.dart'; 
  
part 'limit_details_demo.g.dart';


@JsonSerializable()
  class LimitDetailsDemo extends Object {

  @JsonKey(name: 'contractAccount')
  String contractAccount;

  @JsonKey(name: 'loanPrincipal')
  String loanPrincipal;

  @JsonKey(name: 'loanBalance')
  String loanBalance;

  @JsonKey(name: 'startTime')
  String startTime;

  @JsonKey(name: 'endTime')
  String endTime;

  @JsonKey(name: 'loanRate')
  String loanRate;

  LimitDetailsDemo(this.contractAccount,this.loanPrincipal,this.loanBalance,this.startTime,this.endTime,this.loanRate,);

  factory LimitDetailsDemo.fromJson(Map<String, dynamic> srcJson) => _$LimitDetailsDemoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LimitDetailsDemoToJson(this);

}

  
