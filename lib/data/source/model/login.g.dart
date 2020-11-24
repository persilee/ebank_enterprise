// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginReq _$LoginReqFromJson(Map<String, dynamic> json) {
  return LoginReq(
    password: json['password'] as String,
    signType: json['signType'] as String,
    userPhone: json['userPhone'] as String,
    userType: json['userType'] as String,
    captcha: json['captcha'] as String,
  );
}

Map<String, dynamic> _$LoginReqToJson(LoginReq instance) => <String, dynamic>{
      'password': instance.password,
      'signType': instance.signType,
      'userPhone': instance.userPhone,
      'userType': instance.userType,
      'captcha': instance.captcha,
    };

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) {
  return LoginResp(
    json['userId'] as String,
    json['custId'] as String,
    json['userAccount'] as String,
    json['headPortrait'] as String,
    json['actualName'] as String,
    json['userPhone'] as String,
  );
}

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
      'userId': instance.userId,
      'custId': instance.custId,
      'userAccount': instance.userAccount,
      'headPortrait': instance.headPortrait,
      'actualName': instance.actualName,
      'userPhone': instance.userPhone,
    };
