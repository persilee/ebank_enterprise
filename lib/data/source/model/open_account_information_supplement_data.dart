import 'package:json_annotation/json_annotation.dart';

part 'open_account_information_supplement_data.g.dart';

@JsonSerializable()
class OpenAccountInformationSupplementDataReq {
  ///业务编号
  @JsonKey(name: 'businessId')
  String businessId;

  ///面签类型（1-大陆证件，2-港澳台证件，3-护照）
  @JsonKey(name: 'certificateType')
  String certificateType;

  ///AI对比图片数据
  @JsonKey(name: 'compareImageData')
  String compareImageData;

  ///大头照
  @JsonKey(name: 'headerPic')
  String headerPic;

  ///证件正面图片
  @JsonKey(name: 'idPic')
  String idPic;

  ///证件背面图片
  @JsonKey(name: 'idPicBack')
  String idPicBack;

  ///识别结果（1-识别成功，0-识别失败）
  @JsonKey(name: 'isSuccess')
  String isSuccess;

  ///手机号码
  @JsonKey(name: 'phone')
  String phone;

  ///租户编号
  @JsonKey(name: 'tenantId')
  String tenantId;

  ///港澳台识别录制视频
  @JsonKey(name: 'videoUrl')
  String videoUrl;

  ///文件名称
  @JsonKey(name: 'fileName')
  String fileName;

  ///大陆证件信息
  @JsonKey(name: 'mainlandCertificateInfo')
  ChinaMainlandCertificateInfoDTO mainlandCertificateInfo;

  ///港澳台证件信息
  @JsonKey(name: 'hkCertificateInfo')
  HKCertificateInfoDTO hkCertificateInfo;

  ///护照信息
  @JsonKey(name: 'passportInfo')
  PassportInfoDTO passportInfo;

  ///话术内容
  @JsonKey(name: 'speakings')
  List<SignSpeakDTO> speakings;

  OpenAccountInformationSupplementDataReq({
    this.businessId,
    this.certificateType,
    this.compareImageData,
    this.headerPic,
    this.idPic,
    this.idPicBack,
    this.isSuccess,
    this.phone,
    this.tenantId,
    this.videoUrl,
    this.fileName,
    this.mainlandCertificateInfo,
    this.hkCertificateInfo,
    this.passportInfo,
    this.speakings,
  });

  @override
  String toString() {
    return toJson().toString();
  }

  factory OpenAccountInformationSupplementDataReq.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountInformationSupplementDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$OpenAccountInformationSupplementDataReqToJson(this);
}

///中国大陆身份证
@JsonSerializable()
class ChinaMainlandCertificateInfoDTO {
  ///名称(本地)
  @JsonKey(name: 'fullNameLoc')
  String fullNameLoc;

  ///证件号
  @JsonKey(name: 'idNo')
  String idNo;

  ///性别
  @JsonKey(name: 'gender')
  String gender;

  ///民族
  @JsonKey(name: 'nation')
  String nation;

  ///出生日期
  @JsonKey(name: 'birthdate')
  String birthdate;

  ///地址
  @JsonKey(name: 'address')
  String address;

  ///签发机关
  @JsonKey(name: 'issuingAuthority')
  String issuingAuthority;

  ///证件生效日期
  @JsonKey(name: 'idIssueDate')
  String idIssueDate;

  ///证件失效日期
  @JsonKey(name: 'idDueDate')
  String idDueDate;

  ChinaMainlandCertificateInfoDTO({
    this.fullNameLoc,
    this.idNo,
    this.gender,
    this.nation,
    this.birthdate,
    this.address,
    this.issuingAuthority,
    this.idIssueDate,
    this.idDueDate,
  });
  factory ChinaMainlandCertificateInfoDTO.fromJson(
          Map<String, dynamic> srcJson) =>
      _$ChinaMainlandCertificateInfoDTOFromJson(srcJson);
  Map<String, dynamic> toJson() =>
      _$ChinaMainlandCertificateInfoDTOToJson(this);
}

///中国港澳台身份证
@JsonSerializable()
class HKCertificateInfoDTO {
  ///名称(本地)
  @JsonKey(name: 'fullNameLoc')
  String fullNameLoc;

  ///证件号
  @JsonKey(name: 'idNo')
  String idNo;

  ///英文名称
  @JsonKey(name: 'fullNameEng')
  String fullNameEng;

  ///姓名电码
  @JsonKey(name: 'telexCode')
  String telexCode;

  ///性别
  @JsonKey(name: 'gender')
  String gender;

  ///证件符号
  @JsonKey(name: 'symbol')
  String symbol;

  ///出生日期
  @JsonKey(name: 'birthdate')
  String birthdate;

  ///首次签发日期
  @JsonKey(name: 'firthIssueDate')
  String firthIssueDate;

  ///最近领取日期
  @JsonKey(name: 'currentIssueDate')
  String currentIssueDate;

  HKCertificateInfoDTO({
    this.fullNameLoc,
    this.idNo,
    this.fullNameEng,
    this.telexCode,
    this.gender,
    this.symbol,
    this.birthdate,
    this.firthIssueDate,
    this.currentIssueDate,
  });
  factory HKCertificateInfoDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$HKCertificateInfoDTOFromJson(srcJson);
  Map<String, dynamic> toJson() => _$HKCertificateInfoDTOToJson(this);
}

///护照
@JsonSerializable()
class PassportInfoDTO {
  /// 名称(本地)
  @JsonKey(name: 'fullNameLoc')
  String fullNameLoc;

  ///护照id
  @JsonKey(name: 'idNo')
  String idNo;

  ///性别
  @JsonKey(name: 'gender')
  String gender;

  ///国籍
  @JsonKey(name: 'nationality')
  String nationality;

  ///出生日期
  @JsonKey(name: 'birthdate')
  String birthdate;

  ///发行国
  @JsonKey(name: 'issuingCountry')
  String issuingCountry;

  ///证件生效日期
  @JsonKey(name: 'idIssueDate')
  String idIssueDate;

  ///证件失效日期
  @JsonKey(name: 'idDueDate')
  String idDueDate;

  PassportInfoDTO({
    this.fullNameLoc,
    this.idNo,
    this.gender,
    this.nationality,
    this.birthdate,
    this.issuingCountry,
    // this.idIssueDate,
    this.idDueDate,
  });
  factory PassportInfoDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$PassportInfoDTOFromJson(srcJson);
  Map<String, dynamic> toJson() => _$PassportInfoDTOToJson(this);
}

///话术数据
@JsonSerializable()
class SignSpeakDTO {
  @JsonKey(name: 'problem')
  String problem;

  @JsonKey(name: 'timer')
  String timer;

  @JsonKey(name: 'answer')
  String answer;

  SignSpeakDTO(
    this.problem,
    this.timer,
    this.answer,
  );

  factory SignSpeakDTO.fromJson(Map<String, dynamic> srcJson) =>
      _$SignSpeakDTOFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SignSpeakDTOToJson(this);
}

@JsonSerializable()
class OpenAccountInformationSupplementDataResp {
  ///状态
  @JsonKey(name: 'state')
  int state;

  OpenAccountInformationSupplementDataResp(
    this.state,
  );

  factory OpenAccountInformationSupplementDataResp.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OpenAccountInformationSupplementDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$OpenAccountInformationSupplementDataRespToJson(this);
}
