/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-08

import 'package:ebank_mobile/data/source/model/add_partner.dart';
import 'package:ebank_mobile/data/source/model/delete_partner.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class TransferDataRepository {
  Future<TransferPartnerListResp> getTransferPartnerList(
      GetTransferPartnerListReq req, String tag) {
    return request('/ddep/transferpartner/getTransferPartnerList', req, tag,
        (data) => TransferPartnerListResp.fromJson(data));
  }

  //添加范本请求
  Future<AddPartnerResp> addPartner(AddPartnerReq req, String tag) {
    return request('ddep/transferpartner/addTransferPartner', req, tag,
        (data) => AddPartnerResp.fromJson(data));
  }

  //删除范本请求
  Future<DeletePartnerResp> deletePartner(DeletePartnerReq req, String tag) {
    return request('ddep/transferpartner/deleteTransferPartner', req, tag,
        (data) => DeletePartnerResp.fromJson(data));
  }

  
  Future<TransferByAccountResp> getTransferByAccount(
      GetTransferByAccount req, String tag) {
    return request('/ddep/transfer/doTransferAccout', req, tag,
        (data) => TransferByAccountResp.fromJson(data));
  }

  static final _instance = TransferDataRepository._internal();
  factory TransferDataRepository() => _instance;

  TransferDataRepository._internal();
}
