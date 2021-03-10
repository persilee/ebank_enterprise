import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/http/hsg_http.dart';

class CardDataRepository {
  Future<GetCardListResp> getCardList(String tag) {
    return request('cust/bankcard/getCardListByUserId', {}, tag,
        (data) => GetCardListResp.fromJson(data));
  }

  Future<GetCardLimitByCardNoResp> getCardLimitByCardNo(
      GetCardLimitByCardNoReq req, String tag) {
    return request('cust/cardLimit/getCardLimitByCardNo', req, tag,
        (data) => GetCardLimitByCardNoResp.fromJson(data));
  }

  Future<GetSingleCardBalResp> getCardBalByCardNo(
      GetSingleCardBalReq req, String tag) {
    return request('cust/bankcard/getCardBalByCardNo', req, tag,
        (data) => GetSingleCardBalResp.fromJson(data));
  }

  static final _instance = CardDataRepository._internal();
  factory CardDataRepository() => _instance;

  CardDataRepository._internal();
}
