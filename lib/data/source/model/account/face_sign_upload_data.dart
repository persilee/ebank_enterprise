import 'package:json_annotation/json_annotation.dart';

part 'face_sign_upload_data.g.dart';

@JsonSerializable()
class FaceSignUploadDataReq {
  /// 业务id
  @JsonKey(name: 'businessId')
  String businessId;

  ///ai录制后视频名称
  @JsonKey(name: 'fileName')
  String fileName;

  /// 证件号
  @JsonKey(name: 'idNo')
  String idNo;

  /// 证件类型
  @JsonKey(name: 'idType')
  String idType;

  /// 手机号
  @JsonKey(name: 'phone')
  String phone;

  ///ai会话中对话数据
  @JsonKey(name: 'SpeechFlowDataHS')
  List<SpeechFlowDataHS> speechFlowDataHS;

  FaceSignUploadDataReq(
    this.businessId,
    this.fileName,
    this.idNo,
    this.idType,
    this.phone,
    this.speechFlowDataHS,
  );

  factory FaceSignUploadDataReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceSignUploadDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FaceSignUploadDataReqToJson(this);
}

///话术数据
@JsonSerializable()
class SpeechFlowDataHS {
  @JsonKey(name: 'problem')
  String problem;

  @JsonKey(name: 'timer')
  String timer;

  @JsonKey(name: 'answer')
  String answer;

  SpeechFlowDataHS(
    this.problem,
    this.timer,
    this.answer,
  );

  factory SpeechFlowDataHS.fromJson(Map<String, dynamic> srcJson) =>
      _$SpeechFlowDataHSFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SpeechFlowDataHSToJson(this);
}

@JsonSerializable()
class FaceSignUploadDataResp {
  ///状态
  @JsonKey(name: 'state')
  String state;

  FaceSignUploadDataResp(
    this.state,
  );

  factory FaceSignUploadDataResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceSignUploadDataRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FaceSignUploadDataRespToJson(this);
}
