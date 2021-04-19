import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
void SaveUserData(LoginResp resp, {String password}) async {
  ///登录页面清空数据
  HsgHttp().clearUserCache();

  final prefs = await SharedPreferences.getInstance();
  prefs.setString(ConfigKey.USER_ACCOUNT, resp.userAccount);
  prefs.setString(ConfigKey.USER_ID, resp.userId);
  prefs.setString(ConfigKey.USER_PHONE, resp.userPhone);
  prefs.setString(ConfigKey.USER_AREACODE, resp.areaCode);
  prefs.setString(ConfigKey.USER_TYPE, resp.userType);
  prefs.setString(ConfigKey.USER_BELONGCUSTSTATUS, resp.belongCustStatus);
  prefs.setBool(ConfigKey.USER_PASSWORDENABLED, resp.passwordEnabled);
  prefs.setString(ConfigKey.USER_AVATAR_URL, resp.headPortrait);

  // prefs.setString(ConfigKey.USER_PASSWORD, password);
  if (resp.custId == null || resp.custId == '') {
    prefs.setString(ConfigKey.CUST_ID, '');
  } else {
    prefs.setString(ConfigKey.CUST_ID, resp.custId);
  }
}

// ignore: non_constant_identifier_names
void SaveUserDataForGetUser(UserInfoResp resp) async {
  ///登录页面清空数据
  HsgHttp().clearUserCache();

  final prefs = await SharedPreferences.getInstance();
  prefs.setString(ConfigKey.USER_ACCOUNT, resp.userAccount);
  prefs.setString(ConfigKey.USER_ID, resp.userId);
  prefs.setString(ConfigKey.USER_PHONE, resp.userPhone);
  prefs.setString(ConfigKey.USER_AREACODE, resp.areaCode);
  prefs.setString(ConfigKey.USER_TYPE, resp.userType);
  prefs.setString(ConfigKey.USER_BELONGCUSTSTATUS, resp.belongCustStatus);
  prefs.setBool(ConfigKey.USER_PASSWORDENABLED, resp.passwordEnabled);

  if (resp.custId == null || resp.custId == '') {
    prefs.setString(ConfigKey.CUST_ID, '');
  } else {
    prefs.setString(ConfigKey.CUST_ID, resp.custId);
  }
}
