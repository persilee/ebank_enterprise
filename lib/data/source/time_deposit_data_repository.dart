// /// Copyright (c) 2020 深圳高阳寰球科技有限公司
// ///定期
// /// Author: wangluyao
// /// Date: 2020-12-08

// import 'package:ebank_mobile/http/hsg_http.dart';
// import 'model/get_td_product_term_rate.dart';
// import 'model/time_deposit_contract.dart';
// import 'model/time_deposit_contract_trial.dart';
// import 'model/time_deposit_product.dart';
// import 'model/update_time_deposit_con_info.dart';

// class TimeDepositDataRepository {
//   //获取定期产品
//   Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(
//       String tag, TimeDepositProductReq req) {
//     return request('/tdep/timeDeposit/getTdepProducts', req, tag, (data) {
//       List<TimeDepositProductResp> result = [];
//       (data as List).forEach((element) {
//         result.add(TimeDepositProductResp.fromJson(element));
//       });
//       return result;
//     });
//   }

//   // //定期开立
//   // Future<TimeDepositContractResp> getTimeDepositContract(
//   //     TimeDepositContractReq req, String tag) {
//   //   return request('/tdep/timeDeposit/openTdContract', req, tag,
//   //       (data) => TimeDepositContractResp.fromJson(data));
//   // }

//   // //定期开立试算
//   // Future<TimeDepositContractTrialResp> getTimeDepositContractTrial(
//   //     TimeDepositContractTrialReq req, String tag) {
//   //   return request('/tdep/timeDeposit/openTdContractTrial', req, tag,
//   //       (data) => TimeDepositContractTrialResp.fromJson(data));
//   // }

//   // //获取定期产品利率和存期
//   // Future<GetTdProductTermRateResp> getTdProductTermRate(
//   //     GetTdProductTermRateReq req, String tag) {
//   //   return request('/tdep/timeDeposit/getTdProdTermRate', req, tag,
//   //       (data) => GetTdProductTermRateResp.fromJson(data));
//   // }

//   // //修改到期指示和结算账户
//   // Future<UpdateTdConInfoResp> updateTimeDepositConInfo(
//   //     UpdateTdConInfoReq req, String tag) {
//   //   return request('/tdep/timeDeposit/updateTdConInfo', req, tag,
//   //       (data) => UpdateTdConInfoResp.fromJson(data));
//   // }

//   static final _instance = TimeDepositDataRepository._internal();
//   factory TimeDepositDataRepository() => _instance;

//   TimeDepositDataRepository._internal();
// }
