import 'package:ebank_mobile/data/source/model/checkout_informant.dart';
import 'package:ebank_mobile/data/source/model/real_name_auth.dart';
import 'package:ebank_mobile/data/source/model/set_transactionPassword.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置交易密码--身份证验证
/// Author: hlx
/// Date: 2020-12-30
import 'package:ebank_mobile/http/hsg_http.dart';

class ChecInformantApiRepository {
  //修改交易密码
  Future<CheckoutInformantResp> authentication(
      CheckoutInformantReq req, String tag) {
    return request('cust/verification/authentication', req, tag,
        (data) => CheckoutInformantResp.fromJson(data));
  }

  //身份证验证
  Future<SetTransactionPasswordResp> setTransactionPassword(
      SetTransactionPasswordReq req, String tag) {
    return request('cust/user/setTransactionPassword', req, tag,
        (data) => SetTransactionPasswordResp.fromJson(data));
  }

  //身份证验证(三步验证)
  Future<RealNameAuthResp> realNameAuth(RealNameAuthReq req, String tag) {
    return request('cust/verification/realNameAuth', req, tag,
        (data) => RealNameAuthResp.fromJson(data));
  }

  static final _instance = ChecInformantApiRepository._internal();
  factory ChecInformantApiRepository() => _instance;

  ChecInformantApiRepository._internal();
}
