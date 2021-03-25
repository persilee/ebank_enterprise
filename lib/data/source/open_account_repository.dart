import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/face_sign_businessid.dart';

class OpenAccountRepository {
  //快速开户（上传开户录入信息，获取业务编号）
  Future<OpenAccountQuickSubmitDataResp> quickAccountOpening(
      OpenAccountQuickSubmitDataReq req, String tag) {
    return request('/cust/corporationCust/quickAccountOpening', req, tag,
        (data) => OpenAccountQuickSubmitDataResp.fromJson(data));
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
