import 'package:ebank_mobile/authentication/ali_push.dart';
import 'package:ebank_mobile/data/model/push/ali_push_modal.dart';
import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/login_register/login.dart';
import 'package:ebank_mobile/data/source/model/login_register/logout.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/http/retrofit/base_response.dart';
import 'package:ebank_mobile/util/login_save_user_data.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client_timeDeposit.dart';

class ApiClientPackaging {
  /// 用户网关登录
  Future<LoginResp> login(LoginReq loginReq) async {
    BaseResponse resp = await ApiClientAccount().login(loginReq);
    _saveToken(resp.token ?? '');

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(ConfigKey.NEED_OPEN_ACCOUNT, true);

    if (resp.msgCd == '0000') {
      // || resp.msgCd == 'ECUST010') {
      LoginResp loginResp = LoginResp.fromJson(resp.body);
      loginResp.errorCode = resp.msgCd;

      if (resp.msgCd == '0000' &&
          loginResp != null &&
          loginResp.userId != null) {
        ParametersReq req2 = ParametersReq(2, [loginResp.userId]);
        try {
          ParametersResp resp = await AliPush().aliPushSetParameters(req2);
          print('alipush___${resp.success}');
        } catch (e) {
          print('$e');
        }
      }

      return loginResp;
    } else if (resp.msgCd == 'ECUST009') {
      return Future.error(AppException(resp?.msgCd, resp?.msgInfo));
    } else {
      return Future.error(AppException(resp?.msgCd, resp?.msgInfo));
    }
  }

  /// 获取用户信息
  Future<UserInfoResp> getUserInfo(GetUserInfoReq req) {
    Future<UserInfoResp> resp = ApiClientAccount().getUserInfo(req);
    resp.then((value) => {
          SaveUserDataForGetUser(
            value,
          ),
        });
    return resp;
  }

  /// 安全退出
  Future<LogoutResp> logout(LogoutReq req) async {
    LogoutResp resp = await ApiClientAccount().logout(req);
    if (req.userId != null && req.userId != '') {
      ParametersReq req2 = ParametersReq(2, [req.userId]);
      try {
        ParametersResp resp = await AliPush().aliPushCancelParameters(req2);
        print('alipush---${resp.success}');
      } catch (e) {
        print('$e');
      }
    }
    RemoveUserDataNotAll();
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ACCOUNT);
    print('USER_ACCOUNT<><><><>$userID');
    return resp;
  }

  //获取定期产品
  Future<TimeDepositProductResp> getGetTimeDepositProduct(
      TimeDepositProductReq req) {
    //这名字命名的我也是醉了
    Future<TimeDepositProductResp> resp =
        ApiClientTimeDeposit().getGetTimeDepositProduct(req);
    resp.then((value) => {});
    return resp;
  }

  // Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(
  //     TimeDepositProductReq req) { //这名字命名的我也是醉了
  //   Future<List<TimeDepositProductResp>> resp =
  //       ApiClientTimeDeposit().getGetTimeDepositProduct(req);
  //   resp.then((value) => {});
  //   return resp;
  // }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.NET_TOKEN, token);
  }
}
