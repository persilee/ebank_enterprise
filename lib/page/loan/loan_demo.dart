import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class LoanDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.keyboard_arrow_left,
          size: 30,
        ),
        title: Text(S.of(context).loanDetails),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            // 业务品种
            Container(
              margin: EdgeInsets.only(bottom: 12),
              //padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              color: Colors.white,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '业务品种：闪电贷',
                            ),
                            Text(
                              '贷款编号：81812',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "正常",
                              style: TextStyle(
                                color: HsgColors.loginAgreementText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '贷款金额',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              '￥10,000.00',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 1,
                              height: 30,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: HsgColors.textHintColor),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '贷款余额',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              '￥8,000.00',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 还款记录和计划
            Container(
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '还款记录',
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '待还记录',
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            // 贷款利率及时间
            Container(
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '贷款利率',
                            ),
                            Text("15.12%"),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '待还记录',
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Type arb() => S;
}
