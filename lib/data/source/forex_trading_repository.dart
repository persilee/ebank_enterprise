// import 'package:ebank_mobile/data/source/model/forex_trading.dart';
// import 'package:ebank_mobile/data/source/model/get_ex_rate.dart';
// import 'package:ebank_mobile/http/hsg_http.dart';

// import 'model/application_loan.dart';
// import 'model/foreign_ccy.dart';

// class ForexTradingRepository {
//   //账户可用余额查询
//   Future<GetCardBalResp> getCardBalByCardNo(GetCardBalReq req, String tag) {
//     return request('/cust/bankcard/getCardBalByCardNo', req, tag,
//         (data) => GetCardBalResp.fromJson(data));
//   }

//   //计算汇率
//   Future<TransferTrialResp> transferTrial(TransferTrialReq req, String tag) {
//     return request('/ddep/transfer/transferTrial', req, tag,
//         (data) => TransferTrialResp.fromJson(data));
//   }

//   //外汇买卖
//   Future<DoTransferAccoutResp> doTransferAccout(
//       DoTransferAccoutReq req, String tag) {
//     return request('/ddep/transfer/doTransferAccout', req, tag,
//         (data) => DoTransferAccoutResp.fromJson(data));
//   }

//   Future<ForeignCcyResp> foreignCcy(ForeignCcyReq req, String tag) {
//     return request('/ddep/transfer/foreignCcy', req, tag,
//         (data) => ForeignCcyResp.fromJson(data));
//   }

//   //汇率查询
//   Future<GetExRateResp> getExRate(GetExRateReq req, String tag) {
//     return request('/ddep/transfer/getExRate', req, tag,
//         (data) => GetExRateResp.fromJson(data));
//   }

//   //贷款领用界面获取当前贷款利率的接口
//   Future<LoantIntereRateResp> loanGetRateInterface(
//       LoanIntereRateReq req, String tag) {
//     return request('loan/interestRate/queryInterestRate', req, tag,
//         (data) => LoantIntereRateResp.fromJson(data));
//   }

//   static final _instance = ForexTradingRepository._internal();
//   factory ForexTradingRepository() => _instance;

//   ForexTradingRepository._internal();
// }
