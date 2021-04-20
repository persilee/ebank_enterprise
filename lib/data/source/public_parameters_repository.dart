// import 'package:ebank_mobile/data/source/model/city_for_country.dart';
// import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';

// /// Copyright (c) 2020 深圳高阳寰球科技有限公司
// /// 获取公共参数
// /// Author: CaiTM
// /// Date: 2020-12-23

// import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
// import 'package:ebank_mobile/http/hsg_http.dart';

// class PublicParametersRepository {
//   //获取证件类型
//   Future<GetIdTypeResp> getIdType(GetIdTypeReq req, String tag) {
//     return request('/platform/publicCode/getPublicCodeByType', req, tag,
//         (data) => GetIdTypeResp.fromJson(data));
//   }

//   //获取本币
//   Future<GetLocalCurrencyResp> getLocalCurrency(
//       GetLocalCurrencyReq req, String tag) {
//     return request('/platform/publicCode/getPublicCodeByType', req, tag,
//         (data) => GetLocalCurrencyResp.fromJson(data));
//   }
//   // //获取币种列表
//   // Future<GetLocalCurrencyResp> getLocalCurrency(
//   //     GetLocalCurrencyReq req, String tag) {
//   //   return request('/platform/publicCode/getPublicCodeByType', req, tag,
//   //       (data) => GetLocalCurrencyResp.fromJson(data));
//   // }

//   ///国家信息-查询
//   Future<CountryRegionNewListResp> getCountryList(
//       CountryRegionNewListReq req, String tag) {
//     return request('/base/bpCtCnt/getCountryList', req, tag,
//         (data) => CountryRegionNewListResp.fromJson(data));
//   }

//   ///指定国家代码下所有城市代码信息-查询
//   Future<CityForCountryListResp> getCntAllBpCtCit(
//       CityForCountryListReq req, String tag) {
//     return request('/base/bpCtCit/getCntAllBpCtCit', req, tag,
//         (data) => CityForCountryListResp.fromJson(data));
//   }

//   static final _instance = PublicParametersRepository._internal();
//   factory PublicParametersRepository() => _instance;

//   PublicParametersRepository._internal();
// }
