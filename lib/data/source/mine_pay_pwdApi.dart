import 'package:ebank_mobile/data/source/model/set_payment_pwd.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 支付密码
/// Author: hlx
/// Date: 2020-12-30
import 'package:ebank_mobile/http/hsg_http.dart';

class PaymentPwdRepository {
  //修改支付密码
  Future<SetPaymentPwdResp> updateTransPassword(
      SetPaymentPwdReq req, String tag) {
    return request('cust/user/updateTransPassword', req, tag,
        (data) => SetPaymentPwdResp.fromJson(data));
  }

  static final _instance = PaymentPwdRepository._internal();
  factory PaymentPwdRepository() => _instance;

  PaymentPwdRepository._internal();
}
