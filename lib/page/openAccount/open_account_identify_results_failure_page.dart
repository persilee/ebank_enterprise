import 'package:ebank_mobile/authentication/auth_identity.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenAccountIdentifyResultsFailurePage extends StatefulWidget {
  const OpenAccountIdentifyResultsFailurePage({Key key}) : super(key: key);

  @override
  _OpenAccountIdentifyResultsFailurePageState createState() =>
      _OpenAccountIdentifyResultsFailurePageState();
}

class _OpenAccountIdentifyResultsFailurePageState
    extends State<OpenAccountIdentifyResultsFailurePage> {
  ///业务编号
  String _businessId = '';

  ///证件类型
  String _documentType = '';

  ///是否是快速开户
  bool _isQuick;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _businessId = data['businessId'];
    _documentType = data['documentType'];
    _isQuick = data['isQuick'];

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(S.of(context).openAccout_identify_results),
      ),
      body: Container(
        width: size.width,
        color: HsgColors.commonBackground,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage(
                    'images/openAccount/open_account_identify_results_failure.png'),
                width: 138,
                height: 118,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 60),
              child: Text(
                S.of(context).openAccout_identify_results_failure,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 15),
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HsgColors.secondDegreeText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: HsgButton.defaultButton(
                title: S.of(context).openAccout_identify_again,
                click: () {
                  _qianliyanSDK(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: HsgButton.whiteButton(
                title: S.of(context).openAccout_exit,
                click: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return IndexPage();
                  }), (Route route) {
                    //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
                    print(route.settings?.name);
                    if (route.settings?.name == "/") {
                      return true; //停止关闭
                    }
                    return false; //继续关闭
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _qianliyanSDK(BuildContext context) async {
    String _language = Intl.getCurrentLocale();
    String lang = _language == 'en' ? 'en' : 'zh';
    String countryRegions = _language == 'zh_CN' ? 'CN' : 'TW';
    String tokId = 'passport002en';
    if (_language == 'zh_CN') {
      tokId = 'passport001zh';
    } else if (_language == 'zh_HK') {
      tokId = 'passport002ft';
    } else {
      tokId = 'passport002en';
    }
    final prefs = await SharedPreferences.getInstance();
    String userPhone = prefs.getString(ConfigKey.USER_PHONE);
    String businessId = _businessId + '-' + userPhone;

    HSProgressHUD.show();

    AuthIdentity()
        .startAuth(
      new AuthIdentityReq(
          "DLEAED", businessId, lang, countryRegions, _documentType,
          tokId: tokId),
    )
        .then((value) {
      HSProgressHUD.dismiss();

      ///通过判断证件号码不为空来判断是否识别正确
      if (value.infoStr != null &&
          value.infoStr['IdNum'] != null &&
          value.infoStr['IdNum'] != '') {
        Navigator.pushNamed(
          context,
          pageOpenAccountIdentifySuccessful,
          arguments: {
            'valueData': value,
            'isQuick': _isQuick,
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: S.of(context).openAccout_identify_results_failure,
          gravity: ToastGravity.CENTER,
        );
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: '${e.toString()}',
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
