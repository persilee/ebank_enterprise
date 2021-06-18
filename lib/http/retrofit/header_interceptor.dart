import 'package:dio/dio.dart';
import 'package:ebank_mobile/http/retrofit/base_dio.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class HeaderInterceptor extends Interceptor {
  static const VERSIONIOS = '1';
  static const VERSIONANDROID = '1';

  static const TYPEINT = 2;

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

    int urlType = SpUtil.getInt(ConfigKey.URL_TYPE) ?? 0;
    if (urlType == 0) {
      urlType = TYPEINT;
    }
    String baseUrl = "http://192.168.200.100:5040/";
    switch (urlType) {
      case 1: //dev
        baseUrl = "http://192.168.200.100:5040/";
        break;
      case 2: //sit
        baseUrl = "http://47.57.236.20:5040/";
        break;
      case 3: //uat
        baseUrl = "http://47.242.2.219:5040/";
        break;
      case 4: //local
        baseUrl = "http://192.168.201.65:5041/";
        break;
      case 5: //旧 Dev
        baseUrl = "http://52.82.102.241:5040/";
        break;
      case 6: //东方 Dev1
        baseUrl = "http://192.168.200.102:5040/";
        break;
      default:
    }

    options.baseUrl = baseUrl;
    options.headers.addAll({'x-kont-channel': 'CMBK'});
    options.headers.addAll({'x-kont-appkey': '6000000514984257'});
    options.headers.addAll({'x_kont_token': token});
    options.headers.addAll({'x_kont_locale': locale});

    return options;
  }
}
