/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2021-01-08

import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/get_branch_list.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class BankDataRepository{
  //获取银行列表
  Future<GetBankListResp> getBankList(
      GetBankListReq req, String tag) {
    return request('platform/bankInfo/findBankInfoList', req, tag,
        (data) => GetBankListResp.fromJson(data));
  }

  //获取银行列表
  Future<GetBranchListResp> getBrnachList(
      GetBranchListReq req, String tag) {
    return request('platform/branchInfo/queryBranchInfoList', req, tag,
        (data) => GetBranchListResp.fromJson(data));
  }

  static final _instance = BankDataRepository._internal();
  factory BankDataRepository() => _instance;

  BankDataRepository._internal();
}