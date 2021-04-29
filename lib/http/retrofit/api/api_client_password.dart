import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/checkout_informant.dart';

import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';
import 'package:ebank_mobile/data/source/model/real_name_auth_by_three_factor.dart';
import 'package:ebank_mobile/data/source/model/reset_forget_password.dart';
import 'package:ebank_mobile/data/source/model/set_payment_pwd.dart';
import 'package:ebank_mobile/data/source/model/set_transaction_password.dart';
import 'package:ebank_mobile/data/source/model/update_login_password.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ebank_mobile/data/source/model/send_message.dart';

import '../base_dio.dart';

part 'api_client_password.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClientPassword {
  factory ApiClientPassword({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientPassword(dio, baseUrl: baseUrl);
  }

  /// 获取验证码通过账号
  @POST('/cust/codes/sendSmsByAccount')
  Future<SendSmsByAccountResp> sendSmsByAccount(
      @Body() SendSmsByAccountReq req);

  /// 发送短信验证码
  @POST('/cust/codes/sendSms')
  Future<SendSmsByPhoneNumberResp> sendSmsByPhone(
      @Body() SendSmsByPhoneNumberReq req);

  //发送通知短信
  @POST('/cust/codes/sendMessage')
  Future<SendMessageResp> sendMessage(
      @Body() SendMessageReq req);


  /// 验证交易密码
  @POST('/cust/user/verifyTransPwdNoSms')
  Future<VerifyTransPwdNoSmsResp> verifyTransPwdNoSms(
      @Body() VerifyTransPwdNoSmsReq req);

  /// 根据账户名字修改密码
  @POST('/cust/user/modifyPassword')
  Future<ModifyPasswordResp> modifyLoginPassword(@Body() ModifyPasswordReq req);

  /// 根据手机短信修改密码
  @POST('/cust/user/modifyPwdBySmsCode')
  Future<ModifyPwdBySmsResp> modifyPwdBySms(@Body() ModifyPwdBySmsReq req);

  /// 忘记密码找回密码
  @POST('/cust/user/resetForgetPassword')
  Future<ResetForgetPasswordResp> resetForgetPassword(
      @Body() ResetForgetPassword req);

  /// 修改交易密码
  @POST('cust/user/updateTransPassword')
  Future<SetPaymentPwdResp> updateTransPassword(@Body() SetPaymentPwdReq req);

  /// 修改交易密码（身份验证）
  @POST('cust/verification/authentication')
  Future<CheckoutInformantResp> authentication(
      @Body() CheckoutInformantReq req);

  /// 设置交易密码
  @POST('cust/user/setTransactionPassword')
  Future<SetTransactionPasswordResp> setTransactionPassword(
      @Body() SetTransactionPasswordReq req);

  /// 身份证验证(三步验证)
  @POST('cust/verification/realNameAuthByThreeFactor')
  Future<RealNameAuthByThreeFactorResp> realNameAuth(
      @Body() RealNameAuthByThreeFactorReq req);
}
