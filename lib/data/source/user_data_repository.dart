import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/data/source/model/login.dart';

class UserDataRepository {
  Future<LoginResp> login(LoginReq loginReq, String tag) {
    return request(
        'security/cutlogin', loginReq, tag, (data) => LoginResp.fromJson(data));
  }

  static final _instance = UserDataRepository._internal();
  factory UserDataRepository() => _instance;

  UserDataRepository._internal();

  // login(LoginReq request,
  //     {OnSuccess<LoginResp> onSuccess,
  //     OnFailure onFailure,
  //     @required String tag}) {
  //   HsgHttp().post(
  //       path: 'security/cutlogin',
  //       data: BaseRequest(request.toJson()),
  //       onSuccess: (data) => onSuccess(LoginResp.fromJson(data)),
  //       onFailure: onFailure,
  //       tag: tag);
  // }
}
