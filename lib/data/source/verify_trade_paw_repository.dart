/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 验证交易密码接口
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class VerifyTradePawRepository {
  Future<VerifyTransPwdNoSmsResp> verifyTransPwdNoSms(
      VerifyTransPwdNoSmsReq req, String tag) {
    return request('/cust/user/verifyTransPwdNoSms', req, tag,
        (data) => VerifyTransPwdNoSmsResp.fromJson(data));
  }

  static final _instance = VerifyTradePawRepository._internal();
  factory VerifyTradePawRepository() => _instance;

  VerifyTradePawRepository._internal();
}
