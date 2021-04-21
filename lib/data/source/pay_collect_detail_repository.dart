// /// Copyright (c) 2020 深圳高阳寰球科技有限公司
// /// 收支明细
// /// Author: CaiTM
// /// Date: 2020-12-10

// import 'package:ebank_mobile/http/hsg_http.dart';
// import 'model/get_pay_collect_detail.dart';

// class PayCollectDetailRepository {
//   Future<GetRevenueByCardsResp> getRevenueByCards(
//       GetRevenueByCardsReq req, String tag) {
//     return request('universal/transhis/getRevenueByCards', req, tag,
//         (data) => GetRevenueByCardsResp.fromJson(data));
//     // return request('/universal/transhis/queryTransHis', req, tag,
//     //     (data) => GetRevenueByCardsResp.fromJson(data));
//   }

//   static final _instance = PayCollectDetailRepository._internal();
//   factory PayCollectDetailRepository() => _instance;

//   PayCollectDetailRepository._internal();
// }
