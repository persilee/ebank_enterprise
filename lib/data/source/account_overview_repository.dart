/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/get_account_overview_info.dart';

class AccountOverviewRepository {
  // 总资产
  Future<GetTotalAssetsResp> getTotalAssets(GetTotalAssetsReq req, String tag) {
    return request('ddep/revenue/getTotalAssets', req, tag,
        (data) => GetTotalAssetsResp.fromJson(data));
  }

  // 活期
  Future<GetCardListBalByUserResp> getCardListBalByUser(
      GetCardListBalByUserReq req, String tag) {
    return request('cust/bankcard/getCardListBalByUser', req, tag,
        (data) => GetCardListBalByUserResp.fromJson(data));
  }

  // 定期
  Future<GetTdConInfoListResp> getTdConInfoList(
      GetTdConInfoListReq req, String tag) {
    return request('tdep/timeDeposit/getTdConInfoList', req, tag,
        (data) => GetTdConInfoListResp.fromJson(data));
  }

  // 定期总额
  Future<GetActiveContractByCiNoResp> getActiveContractByCiNo(
      GetActiveContractByCiNoReq req, String tag) {
    return request('tdep/timeDeposit/getActiveContractByCiNo', req, tag,
        (data) => GetActiveContractByCiNoResp.fromJson(data));
  }

  // 贷款
  Future<GetLoanMastListResp> getLoanMastList(
      GetLoanMastListReq req, String tag) {
    return request('loan/masters/getLoanMastList', req, tag,
        (data) => GetLoanMastListResp.fromJson(data));
  }

  static final _instance = AccountOverviewRepository._internal();
  factory AccountOverviewRepository() => _instance;

  AccountOverviewRepository._internal();
}
