/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2021-03-16

import 'package:json_annotation/json_annotation.dart';

part 'auth_identity_bean.g.dart';

@JsonSerializable()
class AuthIdentityReq {
  // 企业id
  @JsonKey(name: 'tenantId')
  String tenantId;

  // 业务id
  @JsonKey(name: 'businessId')
  String businessId;

  // 语言  zh 中文，en 英文
  @JsonKey(name: 'language')
  String language;

  // 国家/地区 CN 中国大陆，TW,台湾繁体
  @JsonKey(name: 'country')
  String country;

  // 字符串 1  大陆证件识别，2 澳台证件识别，3 护照识别
  @JsonKey(name: 'type')
  String type;

  // 话术id
  @JsonKey(name: 'tokId')
  String tokId;

  AuthIdentityReq(
    this.tenantId,
    this.businessId,
    this.language,
    this.country,
    this.type, {
    this.tokId = "ocr001",
  });

  factory AuthIdentityReq.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthIdentityReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthIdentityReqToJson(this);
}

@JsonSerializable()
class AuthIdentityResp {
  @JsonKey(name: 'certificateType')
  String certificateType;

  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'speechFlowData')
  List<SpeechFlowData> speechFlowData;

  @JsonKey(name: 'infoStr')
  dynamic infoStr;

  @JsonKey(name: 'headerImg')
  String headerImg;

  @JsonKey(name: 'positiveImage')
  String positiveImage;

  @JsonKey(name: 'videoUrl')
  String videoUrl;

  @JsonKey(name: 'compareImageData')
  List<CompareImageData> compareImageData;

  @JsonKey(name: 'backImage')
  String backImage;

  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  AuthIdentityResp(
    this.certificateType,
    this.fileName,
    this.speechFlowData,
    this.infoStr,
    this.headerImg,
    this.positiveImage,
    this.videoUrl,
    this.compareImageData,
    this.backImage,
    this.isSuccess,
  );

  factory AuthIdentityResp.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthIdentityRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthIdentityRespToJson(this);
}

@JsonSerializable()
class SpeechFlowData {
  @JsonKey(name: 'problem')
  String problem;

  @JsonKey(name: 'timer')
  String timer;

  @JsonKey(name: 'answerArr')
  List<String> answerArr;

  SpeechFlowData(
    this.problem,
    this.timer,
    this.answerArr,
  );

  factory SpeechFlowData.fromJson(Map<String, dynamic> srcJson) =>
      _$SpeechFlowDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SpeechFlowDataToJson(this);
}

@JsonSerializable()
class InfoStr {
  @JsonKey(name: 'Nation')
  String nation;

  @JsonKey(name: 'IdNum')
  String idNum;

  @JsonKey(name: 'Sex')
  String sex;

  @JsonKey(name: 'Authority')
  String authority;

  @JsonKey(name: 'Address')
  String address;

  @JsonKey(name: 'Birth')
  String birth;

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'ValidDate')
  String validDate;

  @JsonKey(name: 'Symbol')
  String symbol;

  @JsonKey(name: 'Birthday')
  String birthday;

  @JsonKey(name: 'EnName')
  String enName;

  @JsonKey(name: 'TelexCode')
  String telexCode;

  @JsonKey(name: 'CnName')
  String cnName;

  @JsonKey(name: 'CurrentIssueDate')
  String currentIssueDate;

  @JsonKey(name: 'FirstIssueDate')
  String firstIssueDate;

  @JsonKey(name: 'Permanent')
  String permanent;

  @JsonKey(name: 'DateOfExpiration')
  String dateOfExpiration;

  @JsonKey(name: 'DateOfBirth')
  String dateOfBirth;

  @JsonKey(name: 'Nationality')
  String nationality;

  @JsonKey(name: 'ID')
  String iD;

  @JsonKey(name: 'IssuingCountry')
  String issuingCountry;

  InfoStr(
    this.nation,
    this.idNum,
    this.sex,
    this.authority,
    this.address,
    this.birth,
    this.name,
    this.validDate,
    this.symbol,
    this.birthday,
    this.enName,
    this.telexCode,
    this.cnName,
    this.currentIssueDate,
    this.firstIssueDate,
    this.permanent,
    this.dateOfExpiration,
    this.dateOfBirth,
    this.nationality,
    this.iD,
    this.issuingCountry,
  );
  factory InfoStr.fromJson(Map<String, dynamic> srcJson) =>
      _$InfoStrFromJson(srcJson);
  Map<String, dynamic> toJson() => _$InfoStrToJson(this);
}

@JsonSerializable()
class CompareImageData {
  @JsonKey(name: 'xx')
  String xx;

  CompareImageData(
    this.xx,
  );

  factory CompareImageData.fromJson(Map<String, dynamic> srcJson) =>
      _$CompareImageDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompareImageDataToJson(this);
}
