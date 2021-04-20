// import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';

// /// Copyright (c) 2020 深圳高阳寰球科技有限公司
// /// 修改登录密码
// /// Author: CaiTM
// /// Date: 2020-12-30

// import 'package:ebank_mobile/data/source/model/update_login_password.dart';
// import 'package:ebank_mobile/http/hsg_http.dart';

// import 'model/reset_forget_password.dart';

// class UpdateLoginPawRepository {
//   //根据账户名字修改密码
//   Future<ModifyPasswordResp> modifyLoginPassword(
//       ModifyPasswordReq req, String tag) {
//     return request('/cust/user/modifyPassword', req, tag,
//         (data) => ModifyPasswordResp.fromJson(data));
//   }

//   //根据手机短信修改密码
//   Future<ModifyPwdBySmsResp> modifyPwdBySms(ModifyPwdBySmsReq req, String tag) {
//     return request('/cust/user/modifyPwdBySmsCode', req, tag,
//         (data) => ModifyPwdBySmsResp.fromJson(data));
//   }

//   //忘记密码找回密码
//   Future<ResetForgetPasswordResp> resetForgetPassword(
//       ResetForgetPassword req, String tag) {
//     return request('/cust/user/resetForgetPassword', req, tag,
//         (data) => ResetForgetPasswordResp.fromJson(data));
//   }

//   static final _instance = UpdateLoginPawRepository._internal();
//   factory UpdateLoginPawRepository() => _instance;

//   UpdateLoginPawRepository._internal();
// }
