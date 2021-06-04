import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/account/check_phone.dart';
import 'package:ebank_mobile/data/source/model/account/check_sms.dart';
import 'package:ebank_mobile/data/source/model/account/get_bank_info_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/account/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_branch_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/account/get_user_agreement.dart';
import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/login_register/login.dart';
import 'package:ebank_mobile/data/source/model/login_register/login_Verfiy_phone.dart';
import 'package:ebank_mobile/data/source/model/login_register/logout.dart';
import 'package:ebank_mobile/data/source/model/mine/getFeedback.dart';
import 'package:ebank_mobile/data/source/model/other/get_last_version.dart';
import 'package:ebank_mobile/data/source/model/register_by_account.dart';
import 'package:ebank_mobile/data/source/model/send_sms_register.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_retained_withdraw.dart';
import 'package:ebank_mobile/http/retrofit/base_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_account.g.dart';

@RestApi(baseUrl: BaseDio.BASEURLUSE)
abstract class ApiClientAccount {
  factory ApiClientAccount({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientAccount(dio, baseUrl: baseUrl);
  }

  /// 提交意见（意见反馈）
  @POST('platform/opinion/feedbackProblem')
  Future<GetFeedbackResp> feedBack(@Body() GetFeedBackReq req);

  /// 用户协议列表
  @POST('/platform/pact/findPactList')
  Future<FindPactListResp> findUserPactList(@Body() FindPactListReq req);

  /// 用户协议详情
  @POST('/platform/pact/getPact')
  Future<GetUserAgreementResp> getUserPact(@Body() GetUserAgreementReq req);

  /// 用户网关登录
  @POST('/security/cutlogin')
  Future<BaseResponse> login(@Body() LoginReq req);

  /// 获取用户信息
  @POST('/cust/user/getUser')
  Future<UserInfoResp> getUserInfo(@Body() GetUserInfoReq req);

  /// 安全退出
  @POST('/security/logout')
  Future<LogoutResp> logout(@Body() LogoutReq req);

  /// 获取最新版本信息
  @POST('/platform/version/getLastVersion')
  Future<GetLastVersionResp> getlastVersion(@Body() GetLastVersionReq req);

  /// 校验用户是否注册接口
  @POST('/cust/regiser/checkPhone')
  Future<CheckPhoneResp> checkPhone(@Body() CheckPhoneReq req);

  /// 短信验证码校验
  @POST('/cust/codes/checkSms')
  Future<CheckSmsResp> checkSms(@Body() CheckSmsReq req);

  /// 注册发送短信验证码
  @POST('/cust/codes/sendSmsRegister')
  Future<SendSmsRegisterResp> sendSmsRegister(@Body() SendSmsRegisterReq req);

  /// 手机号注册
  @POST('/cust/regiser/registerByAccount')
  Future<RegisterByAccountResp> registerByAccount(
      @Body() RegisterByAccountReq req);

  /// 获取活期账户列表，通过userID
  @POST('/cust/bankcard/getCardListByUserId')
  Future<GetCardListResp> getCardList(@Body() GetCardListReq req);

  /// 通过活期账户号插叙限额
  @POST('/cust/cardLimit/getCardLimitByCardNo')
  Future<GetCardLimitByCardNoResp> getCardLimitByCardNo(
      @Body() GetCardLimitByCardNoReq req);

  /// 通过活期账户号查询余额
  @POST('/cust/bankcard/getCardBalByCardNo')
  Future<GetSingleCardBalResp> getCardBalByCardNo(
      @Body() GetSingleCardBalReq req);

  /// 获取银行列表
  @POST('/platform/bankInfo/findBankInfoList')
  Future<GetBankListResp> getBankList(@Body() GetBankListReq req);

  /// 根据卡号获取银行卡列表
  @POST('/platform/bankInfo/getBankInfoByCardNo')
  Future<BankInfoByCardNoResp> getBankListByCardNo(
      @Body() GetBankInfoByCardNo req);

  /// 获取银行列表
  @POST('/platform/branchInfo/queryBranchInfoList')
  Future<GetBranchListResp> getBrnachList(@Body() GetBranchListReq req);

  /// 校验手机号是否已经开过户
  @POST('/cust/user/getUserStatusByPhone')
  Future<LoginVerifyPhoneResp> forgetVerifyPhoneOpenAccount(
      @Body() LoginVerifyPhoneReq req);

  ///退出登录的时候清除验证码
  @POST('/cust/codes/removeSmsCode')
  Future removeSmsCodeRequest(@Body() String userPhone);

  ///定期存单获取最小留存金额
  @POST('/tdep/timeDeposit/getTdProdTermRate')
  Future<TimeDepositRetainedResp> regularMinimumAmountRetained(
      @Body() TimeDepositRetainedReq req);

  ///定期存单获取剩余部分支取次数
  @POST('/tdep/timeDeposit/getTdInfoByConNo')
  Future<TimeDepositWithdrawResp> regularNumberWithdrawals(
      @Body() TimeDepositWithdrawReq req);
}
