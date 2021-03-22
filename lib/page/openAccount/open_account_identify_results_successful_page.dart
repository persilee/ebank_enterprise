import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';

class OpenAccountIdentifyResultsSuccessfulPage extends StatelessWidget {
  const OpenAccountIdentifyResultsSuccessfulPage({Key key}) : super(key: key);

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
                    'images/openAccount/open_account_identify_results_successful.png'),
                width: 138,
                height: 118,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 60),
              child: Text(
                '有关人士信息识别成功',
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
                '点击完成，上传识别出的用户信息，用于完成银行的账户开立.',
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

  //提示弹窗(提示语句，确认事件)
  void _showTypeTips(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            // title: S.current.prompt,
            // message: S.current.select_transfer_type_first,
            title: S.of(context).openAccout_application_results_title,
            message: S.of(context).openAccout_application_results_content,
            positiveButton: S.current.confirm,
          );
        }).then((value) {
      if (value == true) {
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
      }
    });
  }
}
