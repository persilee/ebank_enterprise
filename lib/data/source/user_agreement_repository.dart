/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取用户协议
/// Author: CaiTM
/// Date: 2020-12-25
import 'package:ebank_mobile/data/source/model/get_user_agreement.dart';

import 'package:ebank_mobile/http/hsg_http.dart';

class UserAgreementRepository {
  //用户协议列表
  Future<FindPactListResp> findUserPactList(FindPactListReq req, String tag) {
    return request('/platform/pact/findPactList', req, tag,
        (data) => FindPactListResp.fromJson(data));
  }

  //用户协议详情
  Future<GetUserAgreementResp> getUserPact(
      GetUserAgreementReq req, String tag) {
    return request('/platform/pact/getPact', req, tag,
        (data) => GetUserAgreementResp.fromJson(data));
  }

  static final _instance = UserAgreementRepository._internal();
  factory UserAgreementRepository() => _instance;

  UserAgreementRepository._internal();
}
