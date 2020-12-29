import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class ForexTradingRepository {
  //账户可用余额查询
  Future<GetCardBalResp> getCardBalByCardNo(GetCardBalReq req, String tag) {
    return request('/cust/bankcard/getCardBalByCardNo', req, tag,
        (data) => GetCardBalResp.fromJson(data));
  }

  //计算汇率
  Future<TransferTrialResp> transferTrial(TransferTrialReq req, String tag) {
    return request('/ddep/transfer/transferTrial', req, tag,
        (data) => TransferTrialResp.fromJson(data));
  }

  //外汇买卖
  Future<DoTransferAccoutResp> doTransferAccout(
      DoTransferAccoutReq req, String tag) {
    return request('/ddep/transfer/doTransferAccout', req, tag,
        (data) => DoTransferAccoutResp.fromJson(data));
  }

  static final _instance = ForexTradingRepository._internal();
  factory ForexTradingRepository() => _instance;

  ForexTradingRepository._internal();
}
