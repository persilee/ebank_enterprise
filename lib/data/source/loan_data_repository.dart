/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款相关接口
/// Author: fanfluyao
/// Date: 2020-12-07

import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'model/get_loan_rate.dart';
import 'model/get_schedule_detail_list.dart';
import 'model/loan_application.dart';

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

  //贷款目录接口
  Future<GetLoanListResp> getLoanList(GetLoanListReq req, String tag) {
    return request('/loan/masters/getLoanMastList', req, tag,
        (data) => GetLoanListResp.fromJson(data));
  }

  //查询计划详情列表接口
  Future<GetScheduleDetailListResp> getScheduleDetailList(
      GetScheduleDetailListReq req, String tag) {
    return request('loan/schedules/getScheduleDetailList', req, tag,
        (data) => GetScheduleDetailListResp.fromJson(data));
  }

  static final _instance = LoanDataRepository._internal();
  factory LoanDataRepository() => _instance;

  LoanDataRepository._internal();
}
