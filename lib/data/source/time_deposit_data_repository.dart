/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: wangluyao
/// Date: 2020-12-08

import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/time_deposit_contract.dart';
import 'model/time_deposit_contract_trial.dart';
import 'model/time_deposit_product.dart';

class TimeDepositDataRepository {
  Future<List<TimeDepositProductResp>> getGetTimeDepositProduct(String tag) {
    return request('/tdep/timeDeposit/getTdepProducts', {}, tag, (data) {
      List<TimeDepositProductResp> result = [];
      (data as List).forEach((element) {
        result.add(TimeDepositProductResp.fromJson(element));
      });
      return result;
    });
  }

  Future<TimeDepositContractResp> getTimeDepositContract(
      TimeDepositContractReq req, String tag) {
    return request('/tdep/timeDeposit/openTdContract', req, tag,
        (data) => TimeDepositContractResp.fromJson(data));
  }

  Future<TimeDepositContractTrialResp> getTimeDepositContractTrial(
      TimeDepositContractTrialReq req, String tag) {
    return request('/tdep/timeDeposit/openTdContractTrial', req, tag,
        (data) => TimeDepositContractTrialResp.fromJson(data));
  }

  static final _instance = TimeDepositDataRepository._internal();
  factory TimeDepositDataRepository() => _instance;

  TimeDepositDataRepository._internal();
}
