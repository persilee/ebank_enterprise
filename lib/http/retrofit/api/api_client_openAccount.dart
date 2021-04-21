import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/city_for_country.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/face_sign_businessid.dart';
import 'package:ebank_mobile/data/source/model/get_invitee_status_by_phone.dart';

import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/openAccount/open_account_Industry_two_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_get_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_information_supplement_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_quick_submit_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_save_data.dart';
import 'package:ebank_mobile/data/source/model/open_account_signature_result.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_openAccount.g.dart';

@RestApi(baseUrl: BaseDio.BASEURL)
abstract class ApiClientOpenAccount {
  factory ApiClientOpenAccount({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClientOpenAccount(dio, baseUrl: baseUrl);
  }

  /// 获取公共参数
  /// 个人证件：TORPC
  /// 登记注册文件类型：CGCT
  /// 公司类别类型：CORP_TYPE
  /// 商业行业性质类型：NOCI
  /// 称谓：AOTPC
  /// 个人职位类别：COPC
  @POST('/platform/publicCode/getPublicCodeByType')
  Future<GetIdTypeResp> getIdType(@Body() GetIdTypeReq req);

  /// 快速开户（上传开户录入信息，获取业务编号）
  @POST('/cust/corporationCust/submitQuickCustTempInfo')
  Future<OpenAccountQuickSubmitDataResp> submitQuickCustTempInfo(
      @Body() OpenAccountQuickSubmitDataReq req);

  /// 面签后补录信息
  @POST('/cust/corporationCust/supplementQuickPartnerInfo')
  Future<OpenAccountInformationSupplementDataResp> supplementQuickPartnerInfo(
      @Body() OpenAccountInformationSupplementDataReq req);

  /// 快速开户
  @POST('/cust/corporationCust/quickAccountOpening')
  Future<OpenAccountQuickResp> quickAccountOpening(
      @Body() OpenAccountQuickReq req);

  /// 面签获取BusinessID
  @POST('/cust/corporationCust/getBusinessByPhone')
  Future<FaceSignIDRespons> getFaceSignBusiness(@Body() FaceSignIDReq req);

  /// 上传开户数据保存
  @POST('/cust/preCust/savePreCust')
  Future<OpenAccountSaveDataResp> savePreCust(
      @Body() OpenAccountSaveDataReq req);

  /// 获取开户保存的数据
  @POST('/cust/preCust/getPreCustByStep')
  Future<OpenAccountGetDataResp> getPreCustByStep(
      @Body() OpenAccountGetDataReq req);

  /// 保存面签视频名称（完整开户面签数据）
  @POST('/cust/corporationCust/saveSignVideo')
  Future<OpenAccountInformationSupplementDataResp> saveSignVideo(
      @Body() OpenAccountInformationSupplementDataReq req);

  /// 手机APP提交面签结果（通知后台，让面签码失效）
  @POST('/cust/corporationCust/subSignatureResult')
  Future<OpenAccountSignatureResultResp> subSignatureResult(
      @Body() OpenAccountSignatureResultReq req);

  /// 国家信息-查询
  @POST('/platform/bpCtCnt/getCountryList')
  Future<CountryRegionNewListResp> getCountryList(
      @Body() CountryRegionNewListReq req);

  /// 指定国家代码下所有城市代码信息-查询
  @POST('/platform/bpCtCit/getCntAllBpCtCit')
  Future<CityForCountryListResp> getCntAllBpCtCit(
      @Body() CityForCountryListReq req);

  /// 获取本币
  @POST('/platform/publicCode/getPublicCodeByType')
  Future<GetLocalCurrencyResp> getLocalCurrency(
      @Body() GetLocalCurrencyReq req);

  /// 通过手机号获取到账号邀请状态
  @POST('/agent/inviteManage/getInviteeStatusByPhone')
  Future<GetInviteeStatusByPhoneResp> getInviteeStatusByPhone(
      @Body() GetInviteeStatusByPhoneReq req);

  /// 通过商业行业性质一级选择的code获取商业行业性质二级选项
  @POST('/platform/publicCode/getSubPublicCodeByType')
  Future<SubPublicCodeByTypeResp> getSubPublicCodeByType(
      @Body() SubPublicCodeByTypeReq req);
}
