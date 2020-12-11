/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-07

import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

import 'model/get_loan_rate.dart';

class LoanDataRepository {
  Future<GetLoanRateResp> getLoanRateList(
      GetLoanRateReq loanRateReq, String tag) {
    return request('/loan/products/getProdList', loanRateReq, tag,
        (data) => GetLoanRateResp.fromJson(data));
  }

  Future<GetLoanListResp> getLoanList(GetLoanListReq req, String tag) {
    return request('/loan/masters/getLoanMastList', req, tag,
        (data) => GetLoanListResp.fromJson(data));
  }

  static final _instance = LoanDataRepository._internal();
  factory LoanDataRepository() => _instance;

  LoanDataRepository._internal();
}
