import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/data/source/model/logout.dart';
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

    if (resp.msgCd == '0000') {
      LoginResp loginResp = LoginResp.fromJson(resp.body);
      return loginResp;
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
  Future<LogoutResp> logout(LogoutReq req) {
    Future<LogoutResp> resp = ApiClientAccount().logout(req);
    resp.then((value) => {
          RemoveUserDataNotAll(),
        });
    return resp;
  }

  //获取定期产品
  Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(
      TimeDepositProductReq req) {
    Future<List<TimeDepositProductResp>> resp =
        ApiClientTimeDeposit().getGetTimeDepositProduct(req);
    resp.then((value) => {});
    return resp;
  }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.NET_TOKEN, token);
  }
}
