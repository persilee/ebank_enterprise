/*
 * Filename: d:\work\flutter\ebank_mobile_enterprise\lib\data\source\time_deposit_data_repository.dart
 * Path: d:\work\flutter\ebank_mobile_enterprise\lib\data\source
 * Created Date: Tuesday, December 8th 2020, 4:29:25 pm
 * Author: wangluyao
 * 
 * Copyright (c) 2020 Your Company
 */

import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/time_deposit_product.dart';

class TimeDepositDataRepository {
  Future<TimeDepositProductResp> getGetTimeDepositProduct(String tag) {
    return request('/tdep/timeDeposit/getTdepProducts', {}, tag,
        (data) => TimeDepositProductResp.fromJson(data));
  }

  static final _instance = TimeDepositDataRepository._internal();
  factory TimeDepositDataRepository() => _instance;

  TimeDepositDataRepository._internal();
}
