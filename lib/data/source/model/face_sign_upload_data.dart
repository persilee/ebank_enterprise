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

  /// 手机号
  @JsonKey(name: 'phone')
  String phone;

  ///ai会话中对话数据
  @JsonKey(name: 'speechFlowData')
  List<SpeechFlowData> speechFlowData;

  FaceSignUploadDataReq(
    this.businessId,
    this.fileName,
    this.phone,
    this.speechFlowData,
  );

  factory FaceSignUploadDataReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceSignUploadDataReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FaceSignUploadDataReqToJson(this);
}

///话术数据
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
