import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:flutter/material.dart';

class OpenAccountIdentifyResultsSuccessfulPage extends StatefulWidget {
  const OpenAccountIdentifyResultsSuccessfulPage({Key key}) : super(key: key);

  @override
  _OpenAccountIdentifyResultsSuccessfulPageState createState() =>
      _OpenAccountIdentifyResultsSuccessfulPageState();
}

class _OpenAccountIdentifyResultsSuccessfulPageState
    extends State<OpenAccountIdentifyResultsSuccessfulPage> {
  AuthIdentityResp _valueData;

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _valueData = data['valueData'];
    print('${_valueData.toJson()}');

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
                    'images/openAccount/open_account_identify_results_successful.png'),
                width: 138,
                height: 118,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 60),
              child: Text(
                S.of(context).openAccout_identify_results_successful,
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
                S.of(context).openAccout_identify_results_successful_tip,
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
                title: S.of(context).complete,
                click: () {
                  _showTypeTips(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTypeTips(BuildContext context) {
    HsgShowTip.openAccountSuccessfulTip(
      context,
      (value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return IndexPage();
          }),
          (Route route) {
            //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
            print(route.settings?.name);
            if (route.settings?.name == "/") {
              return true; //停止关闭
            }
            return false; //继续关闭
          },
        );
        // print(value);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   pageResetPayPwdOtp,
        //   ModalRoute.withName('/'), //清除旧栈需要保留的栈 不清除就不写这句
        //   arguments: {"data": '11'}, //传值
        // );
      },
    );
  }
}
