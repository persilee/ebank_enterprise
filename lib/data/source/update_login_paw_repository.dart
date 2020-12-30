/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 修改登录密码
/// Author: CaiTM
/// Date: 2020-12-30

import 'package:ebank_mobile/data/source/model/update_login_password.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class UpdateLoginPawRepository {
  Future<ModifyPasswordResp> modifyLoginPassword(
      ModifyPasswordReq req, String tag) {
    return request('/cust/user/modifyPassword', req, tag,
        (data) => ModifyPasswordResp.fromJson(data));
  }

  static final _instance = UpdateLoginPawRepository._internal();
  factory UpdateLoginPawRepository() => _instance;

  UpdateLoginPawRepository._internal();
}
