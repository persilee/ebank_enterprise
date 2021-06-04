import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/account/account_overview_all_data.dart';
import 'package:ebank_mobile/data/source/model/account/get_account_overview_info.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list_bal_by_user.dart';
import 'package:ebank_mobile/data/source/model/account/get_pay_collect_detail.dart';
import 'package:ebank_mobile/data/source/model/loan/application_loan.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_get_new_rate.dart';
import 'package:ebank_mobile/data/source/model/other/foreign_ccy.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/other/get_ex_rate.dart';
import 'package:ebank_mobile/data/source/model/statement/get_electronic_statement.dart';

import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_bill.g.dart';

@RestApi(baseUrl: BaseDio.BASEURLUSE)
abstract class ApiClientBill {
  factory ApiClientBill({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientBill(dio, baseUrl: baseUrl);
  }

  /// 收支明细列表universal/transhis/queryTransHis
  @POST('universal/transhis/getRevenueByCards')
  Future<GetRevenueByCardsResp> getRevenueByCards(
      @Body() GetRevenueByCardsReq req);

  /// 账户可用余额查询
  @POST('/cust/bankcard/getCardBalByCardNo')
  Future<GetCardBalResp> getCardBalByCardNo(@Body() GetCardBalReq req);

  /// 计算汇率
  @POST('/ddep/transfer/transferTrial')
  Future<TransferTrialResp> transferTrial(@Body() TransferTrialReq req);

  /// 一对一转账
  @POST('/ddep/transfer/doTransferAccout')
  Future<DoTransferAccoutResp> doTransferAccout(
      @Body() DoTransferAccoutReq req);

  /// 外汇买卖
  @POST('/ddep/transfer/foreignCcy')
  Future<ForeignCcyResp> foreignCcy(@Body() ForeignCcyReq req);

  /// 汇率查询
  @POST('/ddep/transfer/getExRate')
  Future<GetExRateResp> getExRate(@Body() GetExRateReq req);

  /// 贷款领用界面获取当前贷款利率的接口
  @POST('loan/interestRate/queryInterestRate')
  Future<LoantIntereRateResp> loanGetRateInterface(
      @Body() LoanIntereRateReq req);

  /// 贷款领用界面获取利率新的接口
  @POST('loan/contracts/trialCalculationRate')
  Future<LoanGetNewRateResp> loanGetNewRateInterface(
      @Body() LoanGetNewRateReq req);

  /// 电子结单
  @POST('cust/minio/getFilePath')
  Future<GetFilePathResp> getFilePath(@Body() GetFilePathReq req);

  // /// 根据UserID获取用户多张卡余额（欧亚修改的账户总览接口）
  // @POST('/cust/bankcard/getCardListBalByUser')
  // Future<AccOverviewDataResp> getCardListBalById(
  //     @Body() AccOverviewDataReq req);

  /// 总资产
  @POST('/ddep/revenue/getTotalAssets')
  Future<GetTotalAssetsResp> getTotalAssets(@Body() GetTotalAssetsReq req);

  /// 获取多张卡余额 ----账户汇总
  @POST('/cust/bankcard/getCardListBalByUser')
  Future<GetCardListBalByUserResp> getCardListBalByUser(
      @Body() GetCardListBalByUserReq req);

  // /// 活期
  // @POST('/cust/bankcard/getCardListBalByUser')
  // Future<GetCardListBalByUserResp> getCardListBalByUser(
  //     @Body() GetCardListBalByUserReqToGetAccount req);
}
