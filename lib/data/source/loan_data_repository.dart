/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-07

import 'package:ebank_mobile/data/source/model/loan.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/loan_rate.dart';

class LoanDataRepository {
  Future<Loan> loan(String tag) {
    return request(
        '/loan/products/getProdList', {}, tag, (data) => Loan.fromJson(data));
  }

  Future<LoanRateResp> getLoanRateList(LoanRateReq loanRateReq, String tag) {
    return request('/loan/products/getProdList', loanRateReq, tag,
        (data) => LoanRateResp.fromJson(data));
  }

  static final _instance = LoanDataRepository._internal();
  factory LoanDataRepository() => _instance;

  LoanDataRepository._internal();
}
