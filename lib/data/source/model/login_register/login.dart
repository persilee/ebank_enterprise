import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginReq {
  String password; //OkDOYrdBTBcq36OKApyAlA== //Qwe123456~
  String signType; // 密码P 验证码C 账号A
  String userPhone; //'18033410021'; //Smile04 //手机号 ,
  String username; //用户账号 ,
  String platType; //用户类型 1：手机 2：网银 ,
  String userType; //用户类型 1：个人用户 2：企业用户

  LoginReq({
    this.password,
    this.signType = 'A',
    this.userPhone,
    this.username,
    this.platType = '1',
    this.userType = '2',
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
  String areaCode;
  String userType;
  bool passwordEnabled;
  int passwordErrors;
  String belongCustStatus;
  List<CustInfoList> custInfoList;

  ///错误码
  String errorCode;

  LoginResp(
    this.userId,
    this.custId,
    this.userAccount,
    this.headPortrait,
    this.actualName,
    this.userPhone,
    this.areaCode,
    this.userType,
    this.passwordEnabled,
    this.passwordErrors,
    this.belongCustStatus,
    this.errorCode,
    this.custInfoList,
  );

  factory LoginResp.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginRespToJson(this);
}

@JsonSerializable()
class CustInfoList extends Object {
  @JsonKey(name: 'businessId')
  String businessId;

  @JsonKey(name: 'custNameLoc')
  String custNameLoc;

  @JsonKey(name: 'custNameEng')
  String custNameEng;

  @JsonKey(name: 'custId')
  String custId;

 @JsonKey(name: 'userId')
  String userId;

  CustInfoList(
    this.businessId,
    this.custNameLoc,
    this.custNameEng,
    this.custId,
    this.userId
  );

  factory CustInfoList.fromJson(Map<String, dynamic> srcJson) =>
      _$CustInfoListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CustInfoListToJson(this);
}
