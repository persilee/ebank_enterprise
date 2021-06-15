import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_ccy_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_ccy_holiday.dart';
import 'package:ebank_mobile/data/source/model/approval/get_card_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/transfer/add_partner.dart';
import 'package:ebank_mobile/data/source/model/transfer/add_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/transfer/cancel_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/transfer/delete_partner.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_info_by_swift_code.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_internatinal_detail.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_international_transfer.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_plan_details.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_plan_list.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_record.dart';
import 'package:ebank_mobile/data/source/model/transfer/query_fee.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../base_dio.dart';

part 'api_client_transfer.g.dart';

@RestApi(baseUrl: BaseDio.BASEURLUSE)
abstract class Transfer {
  factory Transfer({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _Transfer(dio, baseUrl: baseUrl);
  }

//转账伙伴列表
  @POST('/ddep/transferpartner/getTransferPartnerList')
  Future<TransferPartnerListResp> getTransferPartnerList(
      @Body() GetTransferPartnerListReq req);

  //转账记录
  @POST('/ddep/history/getTransferRecordList')
  Future<GetTransferRecordResp> getTransferRecord(
      @Body() GetTransferRecordReq req);

  //添加范本请求
  @POST('/ddep/transferpartner/addTransferPartner')
  Future<AddPartnerResp> addPartner(@Body() AddPartnerReq req);

  //删除范本请求
  @POST('/ddep/transferpartner/deleteTransferPartner')
  Future<DeletePartnerResp> deletePartner(@Body() DeletePartnerReq req);

  //行内转账
  @POST('/ddep/transfer/doTransferAccout')
  Future<TransferByAccountResp> getTransferByAccount(
      @Body() GetTransferByAccount req);

  //跨行转账
  @POST('/ddep/transfer/doInternationalTransfer')
  Future<InternationalTransferResp> getInterNationalTransfer(
      @Body() GetInternationalTransferReq req);

  //根据银行SWIFT获取银行名称
  @POST('/ddep/transfer/getInfoBySwiftCode')
  Future<GetInfoBySwiftCodeResp> getInfoBySwiftCode(
      @Body() GetInfoBySwiftCodeReq req);

  //根据账号查询名称
  @POST('/cust/bankcard/checkAcName') //cust/bankcard/getCardByCardNo
  Future<GetCardByCardNoResp> getCardByCheckName(
      @Body() GetCardByCardNoReq req);

  //根据账号查询名称
  @POST('cust/bankcard/getCardByCardNo') //cust/bankcard/getCardByCardNo
  Future<GetCardByCardNoResp> getCardByCardNo(@Body() GetCardByCardNoReq req);

  //根据账号查询支持币种
  @POST('/cust/bankcard/getCardCcyList')
  Future<GetCardCcyListResp> getCardCcyList(@Body() GetCardCcyListReq req);

  //计算汇率
  @POST('/ddep/transfer/transferTrial')
  Future<TransferTrialResp> transferTrial(@Body() TransferTrialReq req);

  //预约转账
  @POST('/ddep/transferPlan/addTransferPlan')
  Future<AddTransferPlanResp> addTransferPlan(@Body() AddTransferPlanReq req);

  //转账计划
  @POST('/ddep/transferPlan/getTransferPlanList')
  Future<GetTransferPlanListResp> getTransferPlanList(
      @Body() GetTransferPlanListReq req);

  //取消转账计划
  @POST('/ddep/transferPlan/cancelTransferPlan')
  Future<CancelTransferPlanResp> cancelTransferPlan(
      @Body() CancelTransferPlanReq req);

  //转账计划详情
  @POST('/ddep/transferPlan/getTransferPlan')
  Future<GetTransferPlanDetailsResp> getTransferPlanDetails(
      @Body() GetTransferPlanDetailsReq req);

  //检查节假日
  @POST('/ddep/transfer/getCcyHoliday')
  Future<GetCcyHolidayResp> getCcyHoliday(@Body() GetCcyHolidayReq req);

  //查询费用
  @POST('/ddep/fee/queryFee')
  Future<QueryFeeResp> queryFee(@Body() QueryFeeReq req);

  //国际转账获取状态接口
  @POST('/ddep/history/getTransferRecord')
  Future<TransferInterModelResp> getInternationalStatusInterface(
      @Body() TransferInterModelReq req);
}
