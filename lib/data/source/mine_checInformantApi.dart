import 'package:ebank_mobile/data/source/model/checkout_informant.dart';
import 'package:ebank_mobile/data/source/model/set_payment_pwd.dart';
/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 重置支付密码--身份证验证
/// Author: hlx
/// Date: 2020-12-30
import 'package:ebank_mobile/http/hsg_http.dart';
class ChecInformantApiRepository {
  //修改支付密码
  Future<CheckoutInformantReq> authentication(CheckoutInformantReq req, String tag) {
    return request(
      'cust/user/verification', req, tag, (data) => CheckoutInformantReq.fromJson(data));
  }
  static final _instance = ChecInformantApiRepository._internal();
  factory ChecInformantApiRepository() => _instance;

  ChecInformantApiRepository._internal();
}
