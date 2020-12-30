import 'package:json_annotation/json_annotation.dart';

part 'find_user_finished_task_detail.g.dart';

@JsonSerializable()
class GetFindUserFinishedDetailReq extends Object {
  @JsonKey(name: 'processId')
  String processId;

  GetFindUserFinishedDetailReq(
    this.processId,
  );

  factory GetFindUserFinishedDetailReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFindUserFinishedDetailReqFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GetFindUserFinishedDetailReqToJson(this);
}

@JsonSerializable()
class FindUserFinishedDetailResp extends Object {
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'processTitle')
  String processTitle;

  @JsonKey(name: 'processKey')
  String processKey;

  @JsonKey(name: 'operateEndValue')
  OperateEndValue operateEndValue;

  @JsonKey(name: 'servCtr')
  String servCtr;

  @JsonKey(name: 'commentList')
  List<dynamic> commentList;

  @JsonKey(name: 'result')
  bool result;

  FindUserFinishedDetailResp(
    this.userId,
    this.processTitle,
    this.processKey,
    this.operateEndValue,
    this.servCtr,
    this.commentList,
    this.result,
  );

  factory FindUserFinishedDetailResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserFinishedDetailRespFromJson(srcJson);
  Map<String, dynamic> toJson() => _$FindUserFinishedDetailRespToJson(this);
}

@JsonSerializable()
class OperateEndValue extends Object {
  @JsonKey(name: 'payerName')
  String payerName;

  @JsonKey(name: 'payerBankCode')
  String payerBankCode;

  @JsonKey(name: 'payerCardNo')
  String payerCardNo;

  @JsonKey(name: 'payeeBankCode')
  String payeeBankCode;

  @JsonKey(name: 'payeeCardNo')
  String payeeCardNo;

  @JsonKey(name: 'payeeName')
  String payeeName;

  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'debitCurrency')
  String debitCurrency;

  @JsonKey(name: 'creditCurrency')
  String creditCurrency;

  OperateEndValue(
    this.payerName,
    this.payerBankCode,
    this.payerCardNo,
    this.payeeBankCode,
    this.payeeCardNo,
    this.payeeName,
    this.amount,
    this.remark,
    this.debitCurrency,
    this.creditCurrency,
  );

  factory OperateEndValue.fromJson(Map<String, dynamic> srcJson) =>
      _$OperateEndValueFromJson(srcJson);
  Map<String, dynamic> toJson() => _$OperateEndValueToJson(this);
}
