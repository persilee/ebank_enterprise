/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 意见反馈的对象
/// Author: hlx
/// Date: 2020-12-02
/// 
import 'package:json_annotation/json_annotation.dart';

part 'getFeedback.g.dart';

@JsonSerializable()
class GetFeedBackReq {
  @JsonKey(name: 'feedbackProblem')
  String feedbackProblem;

  @JsonKey(name: 'opinionPhone')
  String opinionPhone;

  @JsonKey(name: 'opinionTheme')
  String opinionTheme;

  @JsonKey(name: 'problemType')
  String problemType;

  GetFeedBackReq(
    this.feedbackProblem,
    this.opinionPhone,
    this.opinionTheme,
    this.problemType,
  );
  @override
  String toString() {
    return toJson().toString();
  }
  factory GetFeedBackReq.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFeedBackReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFeedBackReqToJson(this);
}

@JsonSerializable()
class GetFeedbackResp extends Object {
  GetFeedbackResp();
  @override
  String toString() {
    return toJson().toString();
  }

  factory GetFeedbackResp.fromJson(Map<String, dynamic> srcJson) =>
      _$GetFeedbackRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetFeedbackRespToJson(this);
}
