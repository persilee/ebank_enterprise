import 'package:ebank_mobile/data/source/model/get_loan_money_caculate.dart';
import 'package:ebank_mobile/data/source/model/loan_trial_rate.dart';
import 'package:ebank_mobile/data/source/model/post_repayment.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款相关接口
/// Author: fanfluyao
/// Date: 2020-12-07

import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'model/get_loan_rate.dart';
import 'model/get_schedule_detail_list.dart';
import 'model/loan_account_model.dart';
import 'model/loan_application.dart';
import 'model/loan_creditlimit_cust.dart';
import 'model/loan_detail_modelList.dart';
import 'model/loan_interest_rate.dart';
import 'model/loan_prepayment_model.dart';
import 'model/loan_product_list.dart';
import 'model/loan_record_list_model.dart';

class LoanDataRepository {
  //贷款利率接口
  Future<GetLoanRateResp> getLoanRateList(
      GetLoanRateReq loanRateReq, String tag) {
    return request('/loan/products/getProdList', loanRateReq, tag,
        (data) => GetLoanRateResp.fromJson(data));
  }

  //贷款详情接口
  Future<LoanApplicationResp> getLoanApplication(
      LoanApplicationReq loanApplicationReq, String tag) {
    return request('/loan/contracts/applyForLoan', loanApplicationReq, tag,
        (data) => LoanApplicationResp.fromJson(data));
  }

  //获取贷款产品接口
  Future<LoanProductListResp> loanGetProductListRequest(
      LoanProductListReq productReq, String tag) {
    return request('loan/products/getLnProdList', productReq, tag,
        (data) => LoanProductListResp.fromJson(data));
  }

  //贷款申请提交接口
  Future<LoanApplicationResp> submitLoanApplication(
      LoanApplicationReq loanApplicationReq, String tag) {
    print('==========$loanApplicationReq');
    return request('/loan/contracts/applyForLoan', loanApplicationReq, tag,
        (data) => LoanApplicationResp.fromJson(data));
  }

  //我的贷款列表接口
  Future<LoanAccountMastModelResp> getLoanAccountList(
      LoanAccountMastModelReq req, String tag) {
    return request('/loan/masters/getLoanAccountList', req, tag,
        (data) => LoanAccountMastModelResp.fromJson(data));
  }

  //贷款合约列表接口
  Future<LoanDetailMastModelResp> getLoanList(
      LoanDetailMastModelReq req, String tag) {
    return request('/loan/masters/getLoanMastList', req, tag,
        (data) => LoanDetailMastModelResp.fromJson(data));
  }

  //查询还款记录详情列表接口
  Future<LoanRecordListResp> getScheduleRecordDetailList(
      LoanRecordListReq req, String tag) {
    return request('loan/repayments/getLoanRepaymentHistory', req, tag,
        (data) => LoanRecordListResp.fromJson(data));
  }

  //查询还款计划详情列表接口
  Future<GetScheduleDetailListResp> getSchedulePlanDetailList(
      GetScheduleDetailListReq req, String tag) {
    return request('loan/schedules/getScheduleDetailList', req, tag,
        (data) => GetScheduleDetailListResp.fromJson(data));
  }

  //输入金额的试算接口
  Future<GetLoanCaculateResp> getLoanCaculate(
      GetLoanCaculateReq req, String tag) {
    return request('loan/repayments/postAdvanceRepayment', req, tag,
        (data) => GetLoanCaculateResp.fromJson(data));
  }

  //提交还款接口
  Future<LoanPrepaymentModelResp> postRepayment(
      LoanPrepaymentModelReq req, String tag) {
    return request('loan/repayments/postRepayment', req, tag,
        (data) => LoanPrepaymentModelResp.fromJson(data));
  }

  //贷款领用界面试算的接口
  Future<LoanTrailResp> loanPilotComputingInterface(
      LoanTrailReq req, String tag) {
    return request('loan/contracts/loanTrial', req, tag,
        (data) => LoanTrailResp.fromJson(data));
  }

  // //贷款领用界面获取当前贷款利率的接口
  // Future<LoantIntereRateResp> loanGetRateInterface(
  //     LoanIntereRateReq req, String tag) {
  //   return request('loan/interestRate/queryInterestRate', req, tag,
  //       (data) => LoantIntereRateResp.fromJson(data));
  // }

// Future<LoanGetIntereRateResp> loanCalculateRate

  //贷款领用界面查询客户授信额度信息的接口
  Future<LoanGetCreditlimitResp> loanCreditlimitInterface(
      LoanGetCreditlimitReq req, String tag) {
    return request('loan/contracts/getCreditlimitByCust', req, tag,
        (data) => LoanGetCreditlimitResp.fromJson(data));
  }

  static final _instance = LoanDataRepository._internal();
  factory LoanDataRepository() => _instance;

  LoanDataRepository._internal();
}
