import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String token = await SpUtil.getString(ConfigKey.NET_TOKEN);
    String locale = await SpUtil.getString(ConfigKey.LANGUAGE);
    // String loginName =  SpUtil.getString(ConfigKey.USER_ACCOUNT);
    // String userId = SpUtil.getString(ConfigKey.USER_ID);
    options.headers.addAll({'x-kont-appkey': '6000000514984255'});
    options.headers.addAll({'x_kont_token': token});
    options.headers.addAll({'x_kont_locale': locale});

    return options;
  }
}