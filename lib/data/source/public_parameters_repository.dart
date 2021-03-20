/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 获取公共参数
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class PublicParametersRepository {
  //获取证件类型
  Future<GetIdTypeResp> getIdType(GetIdTypeReq req, String tag) {
    return request('/platform/publicCode/getPublicCodeByType', req, tag,
        (data) => GetIdTypeResp.fromJson(data));
  }

  //获取本币
  Future<GetLocalCurrencyResp> getLocalCurrency(
      GetLocalCurrencyReq req, String tag) {
    return request('/platform/publicCode/getPublicCodeByType', req, tag,
        (data) => GetLocalCurrencyResp.fromJson(data));
  }
  // //获取币种列表
  // Future<GetLocalCurrencyResp> getLocalCurrency(
  //     GetLocalCurrencyReq req, String tag) {
  //   return request('/platform/publicCode/getPublicCodeByType', req, tag,
  //       (data) => GetLocalCurrencyResp.fromJson(data));
  // }

  static final _instance = PublicParametersRepository._internal();
  factory PublicParametersRepository() => _instance;

  PublicParametersRepository._internal();
}
