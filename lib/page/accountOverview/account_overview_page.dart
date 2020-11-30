import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class AccountOverviewPage extends StatefulWidget {
  @override
  _AccountOverviewPageState createState() => _AccountOverviewPageState();
}

class _AccountOverviewPageState extends State<AccountOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账户总览'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            // 总资产
            Container(
              height: 162,
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.fromLTRB(0, 19, 0, 28),
              color: HsgColors.primary,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            '总资产',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white54),
                          ),
                        ),
                        Center(
                          child: Text(
                            '￥1,000,000.00',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '净资产',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white54),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            '￥50000.00',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 1,
                            height: 30,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '总负债',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white54),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            '￥10000.00',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 活期
            Container(
              // height: 162,
              margin: EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            '活期',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      height: 125,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '合计',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '卡号 5000 0030 5001',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '卡号 5000 0030 5001',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  'HKD10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // 定期
            Container(
              height: 162,
              margin: EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            '定期',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      height: 125,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '合计',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '尾号 (5001)',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '尾号 (5001)',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // 贷款
            Container(
              height: 162,
              margin: EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            '贷款',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      height: 125,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '合计',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '尾号 (5001)',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '尾号 (5001)',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // 信用卡
            Container(
              // height: 162,
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            '信用卡',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      height: 125,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '招商信用卡',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '剩余应还',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '剩余可用额度',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  'HKD10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Divider(height: 10, color: HsgColors.textHintColor),
                  SizedBox(
                      height: 125,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '招商信用卡',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '剩余应还',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  '￥10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '剩余可用额度',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF8D8D8D)),
                                ),
                                Text(
                                  'HKD10000.00',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF262626)),
                                ),
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
}
