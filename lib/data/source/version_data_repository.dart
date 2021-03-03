/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///获取最新版本信息
/// Author: wangluyao
/// Date: 2021-03-03

import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/check_phone.dart';
import 'model/get_last_version.dart';
import 'model/register_by_account.dart';
import 'model/send_sms_register.dart';

class VersionDataRepository {
  //获取最新版本信息
  Future<GetLastVersionResp> getlastVersion(GetLastVersionReq req, String tag) {
    return request('/platform/version/getLastVersion', req, tag,
        (data) => GetLastVersionResp.fromJson(data));
  }

  //校验用户是否注册接口
  Future<CheckPhoneResp> checkPhone(CheckPhoneReq req, String tag) {
    return request('/cust/regiser/checkPhone', req, tag,
        (data) => CheckPhoneResp.fromJson(data));
  }

  //注册发送短信验证码
  Future<SendSmsRegisterResp> sendSmsRegister(
      SendSmsRegisterReq req, String tag) {
    return request('/cust/codes/sendSmsRegister', req, tag,
        (data) => SendSmsRegisterResp.fromJson(data));
  }

  //手机号注册
  Future<RegisterByAccountResp> registerByAccount(
      RegisterByAccountReq req, String tag) {
    return request('/cust/regiser/registerByAccount', req, tag,
        (data) => RegisterByAccountResp.fromJson(data));
  }
}
