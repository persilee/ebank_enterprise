import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              height: 40,
              color: HsgColors.backgroundColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                        hint: Text('2020年3月'), items: null, onChanged: null),
                    DropdownButton(
                        hint: Text('全部账户'), items: null, onChanged: null),
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                    height: 192,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(19, 23, 16, 22),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/aboutus/aboutUs-bg.png',
                                    height: 42,
                                    width: 42,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('财付通-微信零钱充值账户'),
                                        Text('-￥1000.00'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('转账给自己 储蓄卡9348 18..'),
                                      Text('余额 ￥10.00'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
