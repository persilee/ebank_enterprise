import 'package:ebank_mobile/authentication/auth_identity.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OpenAccountIdentifyResultsFailurePage extends StatelessWidget {
  const OpenAccountIdentifyResultsFailurePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(S.of(context).openAccout_application_results),
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
                '有关人士信息识别失败',
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
                title: '重新识别',
                click: () {
                  _qianliyanSDK(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: HsgButton.whiteButton(
                title: '退出开户',
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

  void _qianliyanSDK(BuildContext context) {
    String _language = Intl.getCurrentLocale();
    String lang = _language == 'en' ? 'en' : 'zh';
    String countryRegions = _language == 'zh_CN' ? 'CN' : 'TW';

    AuthIdentity()
        .startAuth(
      new AuthIdentityReq("DLEAED", "74283428974321", lang, countryRegions,
          "1"), //passport001zh  DLEAED
    )
        .then((value) {
      Fluttertoast.showToast(
        msg: value.result,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pushNamed(context, pageOpenAccountIdentifyResultsFailure);
    }).catchError((e) {
      // HSProgressHUD.showError(status: '${e.toString()}');
      Fluttertoast.showToast(
        msg: '${e.toString()}',
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
