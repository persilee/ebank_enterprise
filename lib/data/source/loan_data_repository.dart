/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-07
import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class LoanDataRepository{
  Future<GetLoanListResp> getLoanList(GetLoanListReq req,String tag) {
    return request('/loan/masters/getLoanMastList', req, tag,
        (data) => GetLoanListResp.fromJson(data));
  }

  static final _instance = LoanDataRepository._internal();
  factory LoanDataRepository() => _instance;

  LoanDataRepository._internal();
}