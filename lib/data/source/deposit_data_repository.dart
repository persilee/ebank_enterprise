/*
 * Created Date: Tuesday, December 8th 2020, 4:06:13 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/data/source/model/get_deposit_by_card_no.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/get_deposit_record_info.dart';

class DepositDataRepository {
  Future<DepositRecordResp> getDepositRecordRows(
      DepositRecordReq req, String tag) {
    return request('tdep/timeDeposit/getTdConInfoList', req, tag,
        (data) => DepositRecordResp.fromJson(data));
  }

  Future<DepositByCardResp> getDepositByCardNo(
      DepositByCardReq req, String tag) {
    return request('tdep/timeDeposit/getActiveContractByCiNo', req, tag,
        (data) => DepositByCardResp.fromJson(data));
  }

  static final _instance = DepositDataRepository._internal();
  factory DepositDataRepository() => _instance;

  DepositDataRepository._internal();
}
