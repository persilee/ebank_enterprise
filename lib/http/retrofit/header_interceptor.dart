import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String token = await SpUtil.getString(ConfigKey.NET_TOKEN);
    String locale = await SpUtil.getString(ConfigKey.LANGUAGE);
    String loginName = await SpUtil.getString(ConfigKey.USER_ACCOUNT);
    String userId = await SpUtil.getString(ConfigKey.USER_ID);
    options.headers.addAll({'x-kont-appkey': '6000000514984255'});
    options.headers.addAll({'x_kont_token': token});
    options.headers.addAll({'x_kont_locale': locale});
    // options.extra.addAll({'loginname': loginName});
    // options.extra.addAll({'userId': userId});

    return options;
  }
}