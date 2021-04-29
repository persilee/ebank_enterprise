import 'package:ebank_mobile/http/retrofit/base_dio.dart';
import 'package:intl/intl.dart';

generateConfigurationLink(String linkKey) {
  //先要判断当前的链接名称是哪个，在判断链接的中英文状态去进行处理
  String _linkStr = '';
  String _localLangua = '';
  String _language = Intl.getCurrentLocale();
  if (_language == 'zh_CN') {
    //简体中文
    _localLangua = '_Cn';
  } else if (_language == 'zh_HK') {
    //繁体
    _localLangua = '_Local';
  } else {
    //英文
    _localLangua = '_En';
  }
  // String str =
  // BaseDio.BASEURL + 'public/pact/url/' + linkKey + _localLangua + '.html';
  String str = 'http://68.79.26.61:9000/' +
      'public/pact/url/' +
      linkKey +
      _localLangua +
      '.html';
  print('点击了当前的链接.....key:$linkKey .....Value:$str');
  return str;
  // return 'http://68.79.26.61:9000/public/pact/url/licenseAgreement_Cn.html';
  // return 'http://68.79.26.61:9000/public/pact/url/privacyPolicy_Local.html';
}
