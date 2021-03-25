import 'package:ebank_mobile/data/source/model/checkout_informant.dart';
import 'package:ebank_mobile/data/source/model/set_transaction_password.dart';
import 'package:ebank_mobile/data/source/model/real_name_auth_by_three_factor.dart';

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

  //设置交易密码
  Future<SetTransactionPasswordResp> setTransactionPassword(
      SetTransactionPasswordReq req, String tag) {
    return request('cust/user/setTransactionPassword', req, tag,
        (data) => SetTransactionPasswordResp.fromJson(data));
  }

  //身份证验证(三步验证)
  Future<RealNameAuthByThreeFactorResp> realNameAuth(
      RealNameAuthByThreeFactorReq req, String tag) {
    return request('cust/verification/realNameAuthByThreeFactor', req, tag,
        (data) => RealNameAuthByThreeFactorResp.fromJson(data));
  }

  static final _instance = ChecInformantApiRepository._internal();
  factory ChecInformantApiRepository() => _instance;

  ChecInformantApiRepository._internal();
}
