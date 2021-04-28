import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String token = SpUtil.getString(ConfigKey.NET_TOKEN);
    String localeStr = await Language.getSaveLangage();
    if (localeStr.contains('zh_cn')) {
      localeStr = 'zh_CN';
    } else if (localeStr.contains('zh_hk')) {
      localeStr = 'zh_HK';
    } else {
      localeStr = 'en_US';
    }
    String locale = localeStr;
    options.headers.addAll({'x-kont-appkey': '6000000514984255'});
    options.headers.addAll({'x_kont_token': 'token'});
    options.headers.addAll({'x_kont_locale': locale});

    return options;
  }
}
