import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/get_card_list_bal_by_user.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_early_contract.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_limit_by_con_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_rate.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_trial.dart';
import 'package:ebank_mobile/data/source/model/get_td_product_term_rate.dart';

import 'package:ebank_mobile/data/source/model/time_deposit_contract.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract_trial.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/model/update_time_deposit_con_info.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_timeDeposit.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClientTimeDeposit {
  factory ApiClientTimeDeposit({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientTimeDeposit(dio, baseUrl: baseUrl);
  }

  /// 获取定期产品
  @POST('/tdep/timeDeposit/getTdepProducts')
  Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(
      @Body() TimeDepositProductReq req);

  //     //获取定期产品
  // Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(
  //     String tag, TimeDepositProductReq req) {
  //   return request('/tdep/timeDeposit/getTdepProducts', req, tag, (data) {
  //     List<TimeDepositProductResp> result = [];
  //     (data as List).forEach((element) {
  //       result.add(TimeDepositProductResp.fromJson(element));
  //     });
  //     return result;
  //   });
  // }

  /// 定期开立
  @POST('/tdep/timeDeposit/openTdContract')
  Future<TimeDepositContractResp> getTimeDepositContract(
      @Body() TimeDepositContractReq req);

  /// 定期开立试算
  @POST('/tdep/timeDeposit/openTdContractTrial')
  Future<TimeDepositContractTrialResp> getTimeDepositContractTrial(
      @Body() TimeDepositContractTrialReq req);

  /// 获取定期产品利率和存期
  @POST('/tdep/timeDeposit/getTdProdTermRate')
  Future<GetTdProductTermRateResp> getTdProductTermRate(
      @Body() GetTdProductTermRateReq req);

  /// 修改到期指示和结算账户
  @POST('/tdep/timeDeposit/updateTdConInfo')
  Future<UpdateTdConInfoResp> updateTimeDepositConInfo(
      @Body() UpdateTdConInfoReq req);

  /// 获取订单详情页面GetTdConInfoListResp GetTdConInfoListReq  getTdConInfoList  网银数据getTdConInfoListByPage
  @POST('/tdep/timeDeposit/getTdConInfoListByPage')
  Future<DepositRecordResp> getDepositRecordRows(@Body() DepositRecordReq req);

  /// 根据银行卡得到订单详情
  @POST('/tdep/timeDeposit/getActiveContractByCiNo')
  Future<DepositByCardResp> getDepositByCardNo(@Body() DepositByCardReq req);

  /// 根据合约号拿到订单详情
  @POST('/tdep/timeDeposit/getTdConInfo')
  Future<DepositByLimitConNoResp> getDepositLimitByConNo(
      @Body() GetDepositLimitByConNo req);

  /// 拿结清订单数据
  @POST('/tdep/timeDeposit/trialTdContract')
  Future<GetDepositTrialResp> getDepositTrial(@Body() GetDepositTrialReq req);

  /// 是否提前结清
  @POST('/tdep/timeDeposit/earlyRedTdContract')
  Future<GetDepositEarlyContractResp> getDepositEarlyContract(
      @Body() GetDepositEarlyContractReq req);

  /// 查看定期利率
  @POST('/tdep/timeDeposit/getStaticInterestRate')
  Future<DepositRateResp> getDepositRate(@Body() GetDepositRate req);

  /// 获取多张卡余额 ----账户汇总
  @POST('/cust/bankcard/getCardListBalByUser')
  Future<GetCardListBalByUserResp> getCardListBalByUser(
      @Body() GetCardListBalByUserReq req);
}
