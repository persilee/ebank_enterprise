import 'package:json_annotation/json_annotation.dart';

part 'account_find_info.g.dart';

@JsonSerializable()
class CheckFindAccountReq extends Object {
  @JsonKey(name: 'areaCode')
  String areaCode;

  @JsonKey(name: 'phoneNo')
  String phoneNo;

  @JsonKey(name: 'smsCode')
  String smsCode;

  @JsonKey(name: 'userType')
  String userType;

  CheckFindAccountReq(
    this.areaCode,
    this.phoneNo,
    this.smsCode, {
    this.userType = '2',
  });

  factory CheckFindAccountReq.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckFindAccountReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckFindAccountReqToJson(this);
}

@JsonSerializable()
class CheckFindAccountResp extends Object {
  List<UserAccountList> userAccountList;

  CheckFindAccountResp(this.userAccountList);

  factory CheckFindAccountResp.fromJson(Map<String, dynamic> srcJson) =>
      _$CheckFindAccountRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CheckFindAccountRespToJson(this);
}

@JsonSerializable()
class UserAccountList extends Object {
  @JsonKey(name: 'userAccount')
  String userAccount;

  @JsonKey(name: 'custName')
  String custName;

  UserAccountList(this.userAccount, this.custName);

  factory UserAccountList.fromJson(Map<String, dynamic> srcJson) =>
      _$UserAccountListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserAccountListToJson(this);
}
