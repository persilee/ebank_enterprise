import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/material.dart';

class OpenAccountResultsPage extends StatelessWidget {
  const OpenAccountResultsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('申请结果'),
      ),
      body: Container(
        width: size.width,
        color: HsgColors.commonBackground,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70),
              child: Image(
                image: AssetImage(
                    'images/time_depost/time_deposit_contract_succeed.png'),
                width: 65,
                height: 65,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 60),
              child: Text(
                '开户申请提交成功',
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
                '我们将于3个工作日内完成审核，审核结果将以邮件通知您，也可以登录APP查询进度',
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
              child: HsgButton.button(
                title: S.of(context).complete,
                click: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => new IndexPage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
