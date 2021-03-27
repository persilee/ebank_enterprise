/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 开户面签相关接口
/// Author: 李家伟
/// Date: 2021-03-23

import 'package:ebank_mobile/data/source/model/open_account_information_supplement_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/face_sign_businessid.dart';

class OpenAccountRepository {
  //快速开户（上传开户录入信息，获取业务编号）
  Future<OpenAccountQuickSubmitDataResp> submitQuickCustTempInfo(
      OpenAccountQuickSubmitDataReq req, String tag) {
    return request('/cust/corporationCust/submitQuickCustTempInfo', req, tag,
        (data) => OpenAccountQuickSubmitDataResp.fromJson(data));
  }

  //面签后补录信息
  Future<OpenAccountInformationSupplementDataResp> supplementQuickPartnerInfo(
      OpenAccountInformationSupplementDataReq req, String tag) {
    return request('/cust/corporationCust/supplementQuickPartnerInfo', req, tag,
        (data) => OpenAccountInformationSupplementDataResp.fromJson(data));
  }

  //快速开户
  Future<OpenAccountQuickResp> quickAccountOpening(
      OpenAccountQuickReq req, String tag) {
    return request('/cust/corporationCust/quickAccountOpening', req, tag,
        (data) => OpenAccountQuickResp.fromJson(data));
  }

  //面签获取BusinessID
  Future<FaceSignIDRespons> getFaceSignBusiness(FaceSignIDReq req, String tag) {
    return request('/cust/corporationCust/getBusinessByPhone', req, tag,
        (data) => FaceSignIDRespons.fromJson(data));
  }

  static final _instance = OpenAccountRepository._internal();
  factory OpenAccountRepository() => _instance;

  OpenAccountRepository._internal();
}
