import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginReq {
  String password = 'OkDOYrdBTBcq36OKApyAlA==';
  String signType = 'P';
  String userPhone = '18033410021';
  String userType = '1';
  String captcha = '123456';

  LoginReq({
    this.password = 'OkDOYrdBTBcq36OKApyAlA==',
    this.signType = 'P',
    this.userPhone = '18033410021',
    this.userType = '1',
    this.captcha = '123456',
  });

  factory LoginReq.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginReqToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class LoginResp {
  String userId;
  String custId;
  String userAccount;
  String headPortrait;
  String actualName;
  String userPhone;

  LoginResp(this.userId, this.custId, this.userAccount, this.headPortrait,
      this.actualName, this.userPhone);

  factory LoginResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginRespToJson(this);
}
