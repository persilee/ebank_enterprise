/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取验证码
/// Author: CaiTM
/// Date: 2020-12-30

import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class VerificationCodeRepository {
  Future<SendSmsByAccountReq> sendSmsByAccount(
      SendSmsByAccountReq req, String tag) {
    return request('/cust/codes/sendSmsByAccount', req, tag,
        (data) => SendSmsByAccountReq.fromJson(data));
  }

  static final _instance = VerificationCodeRepository._internal();
  factory VerificationCodeRepository() => _instance;

  VerificationCodeRepository._internal();
}
