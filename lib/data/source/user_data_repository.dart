// import 'package:ebank_mobile/data/source/model/get_invitee_status_by_phone.dart';
// import 'package:ebank_mobile/data/source/model/logout.dart';
// import 'package:ebank_mobile/http/hsg_http.dart';
// import 'package:ebank_mobile/data/source/model/login.dart';
// import 'package:ebank_mobile/data/source/model/get_user_info.dart';
// import 'package:ebank_mobile/util/login_save_user_data.dart';

// class UserDataRepository {
//   // Future<LoginResp> login(LoginReq loginReq, String tag) {
//   //   return request('/security/cutlogin', loginReq, tag,
//   //       (data) => LoginResp.fromJson(data));
//   // }

//   // Future<UserInfoResp> getUserInfo(GetUserInfoReq req, String tag) {
//   //   Future<UserInfoResp> requestData = request(
//   //       '/cust/user/getUser', req, tag, (data) => UserInfoResp.fromJson(data));
//   //   requestData.then((value) => {
//   //         SaveUserDataForGetUser(
//   //           value,
//   //         ),
//   //       });
//   //   return requestData;
//   // }

//   // Future<GetInviteeStatusByPhoneResp> getInviteeStatusByPhone(
//   //     GetInviteeStatusByPhoneReq req, String tag) {
//   //   return request('/agent/inviteManage/getInviteeStatusByPhone', req, tag,
//   //       (data) => GetInviteeStatusByPhoneResp.fromJson(data));
//   // }

//   // //退出
//   // Future<LogoutResp> logout(LogoutReq logoutReq, String tag) {
//   //   return request('/security/logout', logoutReq, tag,
//   //       (data) => LogoutResp.fromJson(data));
//   // }

//   static final _instance = UserDataRepository._internal();
//   factory UserDataRepository() => _instance;

//   UserDataRepository._internal();
// }
