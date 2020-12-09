import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/get_account_overview_info.dart';

class AccountOverviewRepository {
  Future<GetTotalAssetsResp> getTotalAssets(GetTotalAssetsReq req, String tag) {
    return request('ddep/revenue/getTotalAssets', req, tag,
        (data) => GetTotalAssetsResp.fromJson(data));
  }

  static final _instance = AccountOverviewRepository._internal();
  factory AccountOverviewRepository() => _instance;

  AccountOverviewRepository._internal();
}
