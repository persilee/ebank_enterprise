/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取公共参数
/// Author: CaiTM
/// Date: 2020-12-23
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class PublicParametersRepository {
  Future<GetPublicParametersResp> getPublicCode(
      GetPublicParametersReq req, String tag) {
    return request('/platform/publicCode/getPublicCodeByType', req, tag,
        (data) => GetPublicParametersResp.fromJson(data));
  }

  static final _instance = PublicParametersRepository._internal();
  factory PublicParametersRepository() => _instance;

  PublicParametersRepository._internal();
}
