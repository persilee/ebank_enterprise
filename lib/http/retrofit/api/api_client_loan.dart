import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/loan/get_loan_money_caculate.dart';
import 'package:ebank_mobile/data/source/model/loan/get_loan_rate.dart';
import 'package:ebank_mobile/data/source/model/loan/get_schedule_detail_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_account_model.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_application.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_applyfor_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_creditlimit_cust.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_detail_modelList.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_prepayment_model.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_product_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_repayment_record.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_trail_commit.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_trial_rate.dart';

import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_loan.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClientLoan {
  factory ApiClientLoan({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientLoan(dio, baseUrl: baseUrl);
  }

  /// 贷款利率接口
  @POST('/loan/products/getProdList')
  Future<GetLoanRateResp> getLoanRateList(@Body() GetLoanRateReq req);

  /// 贷款详情接口
  @POST('/loan/contracts/applyForLoan')
  Future<LoanApplicationResp> getLoanApplication(
      @Body() LoanApplicationReq req);

  /// 获取贷款产品接口
  @POST('loan/products/getLnProdList')
  Future<LoanProductListResp> loanGetProductListRequest(
      @Body() LoanProductListReq req);

  /// 贷款申请提交接口
  @POST('/loan/contracts/applyForLoan')
  Future<LoanApplicationResp> submitLoanApplication(
      @Body() LoanApplicationReq req);

  /// 贷款申请里面--》我的申请记录接口
  @POST('loan/contracts/myLoanApplys')
  Future<LoanApplyFoyListResp> loanApplyforListData(
      @Body() LoanApplyFoyListReq req);

  /// 我的贷款列表接口
  @POST('/loan/masters/getLoanAccountList')
  Future<LoanAccountMastModelResp> getLoanAccountList(
      @Body() LoanAccountMastModelReq req);

  /// 贷款合约列表接口
  @POST('/loan/masters/getLoanMastList')
  Future<LoanDetailMastModelResp> getLoanList(
      @Body() LoanDetailMastModelReq req);

  /// 查询还款记录详情列表接口
  @POST('loan/repayments/getLoanRepaymentHistory')
  Future<LoanRepaymentRecordResp> getScheduleRecordDetailList(
      @Body() LoanRepaymentRecordReq req);

  /// 查询还款计划详情列表接口
  @POST('loan/schedules/getScheduleDetailList')
  Future<GetScheduleDetailListResp> getSchedulePlanDetailList(
      @Body() GetScheduleDetailListReq req);

  /// 输入金额的试算接口
  @POST('loan/repayments/postAdvanceRepayment')
  Future<GetLoanCaculateResp> getLoanCaculate(@Body() GetLoanCaculateReq req);

  /// 提交还款接口
  @POST('loan/repayments/postRepayment')
  Future<LoanPrepaymentModelResp> postRepayment(
      @Body() LoanPrepaymentModelReq req);

  /// 贷款领用界面试算的接口
  @POST('loan/contracts/loanTrial')
  Future<LoanTrailResp> loanPilotComputingInterface(@Body() LoanTrailReq req);

  /// 贷款领用最终确定提交接口
  @POST('loan/contracts/loanWithdrawal')
  Future<LoanTrailCommitResp> loanFinalWithdrawInterface(
      @Body() LoanTrailCommitReq req);

  // //贷款领用界面获取当前贷款利率的接口
  // Future<LoantIntereRateResp> loanGetRateInterface(
  //     LoanIntereRateReq req, String tag) {
  //   return request('loan/interestRate/queryInterestRate', req, tag,
  //       (data) => LoantIntereRateResp.fromJson(data));
  // }

// Future<LoanGetIntereRateResp> loanCalculateRate

  /// 贷款领用界面查询客户授信额度信息的接口
  @POST('loan/contracts/getCreditlimitByCust')
  Future<LoanGetCreditlimitResp> loanCreditlimitInterface(
      @Body() LoanGetCreditlimitReq req);
}
