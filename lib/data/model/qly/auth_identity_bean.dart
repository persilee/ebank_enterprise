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
  ///租户编号
  @JsonKey(name: 'tenant_id')
  String tenantId;

  ///业务编号
  @JsonKey(name: 'business_id')
  String businessId;

  ///选择的面签类型1大陆2港澳台3护照
  @JsonKey(name: 'certificateType')
  String certificateType;

  ///ai录制后视频名称
  @JsonKey(name: 'fileName')
  String fileName;

  ///ai会话中对话数据
  @JsonKey(name: 'speechFlowData')
  List<SpeechFlowData> speechFlowData;

  ///证件识别信息
  @JsonKey(name: 'infoStr')
  dynamic infoStr;

  ///大头照
  @JsonKey(name: 'headerImg')
  String headerImg;

  ///正面照片
  @JsonKey(name: 'positiveImage')
  String positiveImage;

  ///港澳台识别录制视频
  @JsonKey(name: 'videoUrl')
  String videoUrl;

  ///ai对比图片数据
  @JsonKey(name: 'compareImageData')
  List<CompareImageData> compareImageData;

  ///反面照片
  @JsonKey(name: 'backImage')
  String backImage;

  ///识别结果 人脸对比 isSuccess 为true识别成功，错误和识别失败为false
  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  /// 人脸识别图片
  @JsonKey(name: 'idFaceComparisonImg')
  String idFaceComparisonImg;

  /** 
   * 1  回答错误次数 过多 
   * 2 AI面签过程中 挂断退出    
   * 3 AI面签过程中回答错误的弹窗退出 
   * 4  AI面签过程中异常退出  
   * 5 人脸识别 或 录制视频 退出 
   * 6  返回退出
   * 7 异常退出
   * 8 证件不符合条件
   * 999  ai面签过完成退出 
  */
  ///错误编号
  @JsonKey(name: 'outCode')
  String outCode;

  ///反面照片
  @JsonKey(name: 'errorMessage')
  String errorMessage;

  AuthIdentityResp(
    this.tenantId,
    this.businessId,
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
    this.idFaceComparisonImg,
    this.outCode,
    this.errorMessage,
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

///中国大陆身份证
@JsonSerializable()
class InfoStrForCN {
  ///姓名
  @JsonKey(name: 'Name')
  String name;

  ///证件号
  @JsonKey(name: 'IdNum')
  String idNum;

  ///性别
  @JsonKey(name: 'Sex')
  String sex;

  ///民族
  @JsonKey(name: 'Nation')
  String nation;

  ///出生
  @JsonKey(name: 'Birth')
  String birth;

  ///地址
  @JsonKey(name: 'Address')
  String address;

  ///有效期
  @JsonKey(name: 'ValidDate')
  String validDate;

  ///签发机关
  @JsonKey(name: 'Authority')
  String authority;

  InfoStrForCN(
    this.name,
    this.idNum,
    this.sex,
    this.nation,
    this.birth,
    this.address,
    this.validDate,
    this.authority,
  );
  factory InfoStrForCN.fromJson(Map<String, dynamic> srcJson) =>
      _$InfoStrForCNFromJson(srcJson);
  Map<String, dynamic> toJson() => _$InfoStrForCNToJson(this);
}

///中国港澳台身份证
@JsonSerializable()
class InfoStrForHK {
  ///中文名称
  @JsonKey(name: 'Name')
  String name;

  ///身份证号
  @JsonKey(name: 'IdNum')
  String idNum;

  ///英文名称
  @JsonKey(name: 'EnName')
  String enName;

  ///姓名电码
  @JsonKey(name: 'TelexCode')
  String telexCode;

  ///性别
  @JsonKey(name: 'Sex')
  String sex;

  ///证件符号
  @JsonKey(name: 'Symbol')
  String symbol;

  ///出生日期
  @JsonKey(name: 'Birthday')
  String birthday;

  ///首次签发日期
  @JsonKey(name: 'FirstIssueDate')
  String firstIssueDate;

  ///最近领取日期
  @JsonKey(name: 'CurrentIssueDate')
  String currentIssueDate;

  InfoStrForHK(
    this.name,
    this.idNum,
    this.enName,
    this.telexCode,
    this.sex,
    this.symbol,
    this.birthday,
    this.firstIssueDate,
    this.currentIssueDate,
  );
  factory InfoStrForHK.fromJson(Map<String, dynamic> srcJson) =>
      _$InfoStrForHKFromJson(srcJson);
  Map<String, dynamic> toJson() => _$InfoStrForHKToJson(this);
}

///护照
@JsonSerializable()
class InfoStrForPassport {
  ///姓名
  @JsonKey(name: 'Name')
  String name;

  ///护照id
  @JsonKey(name: 'IdNum')
  String idNum;

  ///性别
  @JsonKey(name: 'Sex')
  String sex;

  ///国籍
  @JsonKey(name: 'Nationality')
  String nationality;

  ///出生日期
  @JsonKey(name: 'DateOfBirth')
  String dateOfBirth;

  ///发行国
  @JsonKey(name: 'IssuingCountry')
  String issuingCountry;

  ///有效日期
  @JsonKey(name: 'DateOfExpiration')
  String dateOfExpiration;

  InfoStrForPassport(
    this.name,
    this.idNum,
    this.sex,
    this.nationality,
    this.dateOfBirth,
    this.issuingCountry,
    this.dateOfExpiration,
  );
  factory InfoStrForPassport.fromJson(Map<String, dynamic> srcJson) =>
      _$InfoStrForPassportFromJson(srcJson);
  Map<String, dynamic> toJson() => _$InfoStrForPassportToJson(this);
}

@JsonSerializable()
class CompareImageData {
  ///base串
  @JsonKey(name: 'faceImgUrl')
  String faceImgUrl;

  ///相识度
  @JsonKey(name: 'score')
  double score;

  CompareImageData(
    this.faceImgUrl,
    this.score,
  );

  factory CompareImageData.fromJson(Map<String, dynamic> srcJson) =>
      _$CompareImageDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompareImageDataToJson(this);
}
