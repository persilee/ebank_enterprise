/*
 * Created Date: Tuesday, December 8th 2020, 4:06:13 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/data/source/model/get_deposit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_early_contract.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_limit_by_con_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_rate.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_trial.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'model/get_deposit_limit_by_con_no.dart';
import 'model/get_deposit_record_info.dart';

class DepositDataRepository {
  //获取订单详情页面
  Future<DepositRecordResp> getDepositRecordRows(
      DepositRecordReq req, String tag) {
    return request('tdep/timeDeposit/getTdConInfoList', req, tag,
        (data) => DepositRecordResp.fromJson(data));
  }

  //根据银行卡得到订单详情
  Future<DepositByCardResp> getDepositByCardNo(
      DepositByCardReq req, String tag) {
    return request('tdep/timeDeposit/getActiveContractByCiNo', req, tag,
        (data) => DepositByCardResp.fromJson(data));
  }

  //根据合约号拿到订单详情
  Future<DepositByLimitConNoResp> getDepositLimitByConNo(
      GetDepositLimitByConNo req, String tag) {
    return request('tdep/timeDeposit/getTdConInfo', req, tag,
        (data) => DepositByLimitConNoResp.fromJson(data));
  }

  //拿结清订单数据
  Future<DepositTrialResp> getDepositTrial(GetDepositTrialReq req, String tag) {
    return request('/tdep/timeDeposit/trialTdContract', req, tag,
        (data) => DepositTrialResp.fromJson(data));
  }

  //是否提前结清
  Future<DepositEarlyContractResp> getDepositEarlyContract(
      GetDepositEarlyContractReq req, String tag) {
    return request('/tdep/timeDeposit/earlyRedTdContract', req, tag,
        (data) => DepositEarlyContractResp.fromJson(data));
  }

  //查看定期利率
  Future<DepositRateResp> getDepositRate(GetDepositRate req, String tag) {
    return request('/tdep/timeDeposit/getStaticInterestRate', req, tag,
        (data) => DepositRateResp.fromJson(data));
  }

  static final _instance = DepositDataRepository._internal();
  factory DepositDataRepository() => _instance;

  DepositDataRepository._internal();
}
