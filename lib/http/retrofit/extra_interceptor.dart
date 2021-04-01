import 'package:dio/dio.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:sp_util/sp_util.dart';

class ExtraInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String userId = await SpUtil.getString(ConfigKey.USER_ID);
    String loginName = await SpUtil.getString(ConfigKey.USER_ACCOUNT);
    options.extra.addAll({'userId': userId});
    options.extra.addAll({'loginName': loginName});

    return options;
  }
}
