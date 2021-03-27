/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-08

import 'package:ebank_mobile/data/source/model/add_partner.dart';
import 'package:ebank_mobile/data/source/model/add_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/cancel_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/delete_partner.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/get_international_transfer.dart';
import 'model/get_international_transfer_new.dart';
import 'model/get_transfer_plan_details.dart';
import 'model/get_transfer_plan_list.dart';
import 'model/get_transfer_record.dart';

class TransferDataRepository {
  Future<TransferPartnerListResp> getTransferPartnerList(
      GetTransferPartnerListReq req, String tag) {
    return request('/ddep/transferpartner/getTransferPartnerList', req, tag,
        (data) => TransferPartnerListResp.fromJson(data));
  }

  //转账记录
  Future<GetTransferRecordResp> getTransferRecord(
      GetTransferRecordReq req, String tag) {
    return request('ddep/history/getTransferRecordList', req, tag,
        (data) => GetTransferRecordResp.fromJson(data));
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

  //行内转账
  Future<TransferByAccountResp> getTransferByAccount(
      GetTransferByAccount req, String tag) {
    return request('/ddep/transfer/doTransferAccout', req, tag,
        (data) => TransferByAccountResp.fromJson(data));
  }

  //国际转账
  Future<InternationalTransferResp> getInterNationalTransfer(
      GetInternationalTransferReq req, String tag) {
    return request('/ddep/transfer/doInternationalTransfer', req, tag,
        (data) => InternationalTransferResp.fromJson(data));
  }

  //跨行转账
  Future<GetInternationalTransferNewResp> getInternationalTransferNew(
      GetInternationalTransferNewReq req, String tag) {
    return request('/ddep/transfer/doInternationalTransfer', req, tag,
        (data) => GetInternationalTransferNewResp.fromJson(data));
  }

  //预约转账
  Future<AddTransferPlanResp> addTransferPlan(
      AddTransferPlanReq req, String tag) {
    return request('/ddep/transferPlan/addTransferPlan', req, tag,
        (data) => AddTransferPlanResp.fromJson(data));
  }

  //转账计划
  Future<GetTransferPlanListResp> getTransferPlanList(
      GetTransferPlanListReq req, String tag) {
    return request('/ddep/transferPlan/getTransferPlanList', req, tag,
        (data) => GetTransferPlanListResp.fromJson(data));
  }

  //取消转账计划
  Future<CancelTransferPlanResp> cancelTransferPlan(
      CancelTransferPlanReq req, String tag) {
    return request('/ddep/transferPlan/cancelTransferPlan', req, tag,
        (data) => CancelTransferPlanResp.fromJson(data));
  }

//转账计划详情
  Future<GetTransferPlanDetailsResp> getTransferPlanDetails(
      GetTransferPlanDetailsReq req, String tag) {
    return request('/ddep/transferPlan/getTransferPlan', req, tag,
        (data) => GetTransferPlanDetailsResp.fromJson(data));
  }

  static final _instance = TransferDataRepository._internal();
  factory TransferDataRepository() => _instance;

  TransferDataRepository._internal();
}
