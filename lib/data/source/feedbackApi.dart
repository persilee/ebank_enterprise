import 'package:ebank_mobile/data/source/model/getFeedback.dart';
/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 意见反馈接口
/// Author: hlx
/// Date: 2020-12-28
import 'package:ebank_mobile/http/hsg_http.dart';
class FeedbackRepository {
  //提交意见
  Future<GetFeedbackResp> feedBack(GetFeedBackReq req, String tag) {
    return request(
        'platform/opinion/feedbackProblem', req, tag, (data) => GetFeedbackResp.fromJson(data));
  }
  
  static final _instance = FeedbackRepository._internal();
  factory FeedbackRepository() => _instance;

  FeedbackRepository._internal();
}
