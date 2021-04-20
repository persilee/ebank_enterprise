// import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';

// /// Copyright (c) 2020 深圳高阳寰球科技有限公司
// /// 获取验证码
// /// Author: CaiTM
// /// Date: 2020-12-30

// import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
// import 'package:ebank_mobile/http/hsg_http.dart';

// class VerificationCodeRepository {
//   Future<SendSmsByAccountResp> sendSmsByAccount(
//       SendSmsByAccountReq req, String tag) {
//     return request('/cust/codes/sendSmsByAccount', req, tag,
//         (data) => SendSmsByAccountResp.fromJson(data));
//   }

//   //根据手机号发送验证码
//   Future<SendSmsByPhoneNumberResp> sendSmsByPhone(
//       SendSmsByPhoneNumberReq req, String tag) {
//     return request('/cust/codes/sendSms', req, tag,
//         (data) => SendSmsByPhoneNumberResp.fromJson(data));
//   }

//   static final _instance = VerificationCodeRepository._internal();
//   factory VerificationCodeRepository() => _instance;

//   VerificationCodeRepository._internal();
// }
