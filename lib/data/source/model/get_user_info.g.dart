// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserInfoReq _$GetUserInfoReqFromJson(Map<String, dynamic> json) {
  return GetUserInfoReq(
    json['userId'] as String,
  );
}

Map<String, dynamic> _$GetUserInfoReqToJson(GetUserInfoReq instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

UserInfoResp _$UserInfoRespFromJson(Map<String, dynamic> json) {
  return UserInfoResp(
    json['certification'] as bool,
    json['headPortrait'] as String,
    json['certificateNo'] as String,
    json['actualName'] as String,
    json['passwordEnabled'] as bool,
    json['userName'] as String,
    json['createBy'] as String,
    json['custId'] as String,
    json['englishUserName'] as String,
    json['localUserName'] as String,
    json['lockEnabled'] as bool,
    json['modifyBy'] as String,
    json['passwordErrors'] as int,
    json['userAccount'] as String,
    json['userEmail'] as String,
    json['userId'] as String,
    json['userPhone'] as String,
    json['userRole'] as String,
    json['userStatus'] as String,
    json['userType'] as String,
  );
}

Map<String, dynamic> _$UserInfoRespToJson(UserInfoResp instance) =>
    <String, dynamic>{
      'certification': instance.certification,
      'headPortrait': instance.headPortrait,
      'certificateNo': instance.certificateNo,
      'actualName': instance.actualName,
      'passwordEnabled': instance.passwordEnabled,
      'userName': instance.userName,
      'createBy': instance.createBy,
      'custId': instance.custId,
      'englishUserName': instance.englishUserName,
      'localUserName': instance.localUserName,
      'lockEnabled': instance.lockEnabled,
      'modifyBy': instance.modifyBy,
      'passwordErrors': instance.passwordErrors,
      'userAccount': instance.userAccount,
      'userEmail': instance.userEmail,
      'userId': instance.userId,
      'userPhone': instance.userPhone,
      'userRole': instance.userRole,
      'userStatus': instance.userStatus,
      'userType': instance.userType,
    };
