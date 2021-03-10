/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/account_overview_all_data.dart';
import 'model/get_account_overview_info.dart';

class AccountOverviewRepository {
  // 根据UserID获取用户多张卡余额（欧亚修改的账户总览接口）
  Future<AccOverviewDataResp> getCardListBalById(
      AccOverviewDataReq req, String tag) {
    return request('cust/bankcard/getCardListBalByUser', req, tag,
        (data) => AccOverviewDataResp.fromJson(data));
  }

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
