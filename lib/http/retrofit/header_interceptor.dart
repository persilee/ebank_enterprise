import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String token = SpUtil.getString(ConfigKey.NET_TOKEN);
    String locale = SpUtil.getString(ConfigKey.LANGUAGE);
    options.headers.addAll({'x-kont-appkey': '6000000514984255'});
    options.headers.addAll({'x_kont_token': token});
    options.headers.addAll({'x_kont_locale': locale});

    return options;
  }
}