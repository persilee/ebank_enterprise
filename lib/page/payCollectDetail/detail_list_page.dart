import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收支明细'),
        centerTitle: true,
        // elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: Column(
          children: [
            Container(
              height: 50,
              color: HsgColors.backgroundColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                        hint: Text('2020年12月'), items: null, onChanged: null),
                    DropdownButton(
                        hint: Text('全部账户'), items: null, onChanged: null),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 18, top: 12),
                              child: Text(
                                '12月15日',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF222121)),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 18, top: 12),
                              child: Text(
                                '12月14日',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF222121)),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 80),
                          child: Divider(
                              height: 0, color: HsgColors.textHintColor),
                        ),
                        Container(
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(18, 25, 14, 20),
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.pushNamed(context, pageDetailInfo);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 13),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'images/aboutus/aboutUs-bg.png',
                                      height: 42,
                                      width: 42,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '财付通-微信零钱充值账户',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                            Text(
                                              '-￥1000.00',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF222121)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '转账给自己 储蓄卡9342 18..',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                            Text(
                                              '余额 ￥10.00',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFACACAC)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
