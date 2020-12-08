/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  TransferPage({Key key}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  var _partnerListData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('转账功能'),
      // ),
      body: Stack(
        children: [
          //为了下拉后顶部三个选项和导航栏不出现颜色断层（正常下拉，如果下拉超过220高度同样会断层）
          Container(
            color: HsgColors.primary,
            height: 220,
          ),
          Container(
            child: CustomScrollView(
              slivers: _sliversSection(_gridFeatures, _listFeatures),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _sliversSection(List gridData, List listData) {
    List<Widget> section = [];
    section.add(SliverAppBar(
      pinned: true,
      title: Text('转账功能'),
    ));

    section.add(SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            color: HsgColors.primary,
            height: 110,
            child: _graphicButton(
              gridData[index]['btnTitle'],
              gridData[index]['btnIcon'],
              35,
              () {
                String title = gridData[index]['btnTitle'];
                if ('行内转账' == title) {
                  //行内转账
                  //Navigator.pushNamed(context, pageTransfer);
                } else if (S.of(context).transfer_appointment == title) {
                  //'预约转账'
                } else if (S.current.transfer_record == title) {
                  //转账记录
                }
              },
            ),
          );
        },
        childCount: gridData.length,
      ),
    ));

    section.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (content, index) {
          return Container(
            height: 50,
            color: Colors.white,
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${listData[index]['btnTitle']}',
                      style: TextStyle(
                          color: HsgColors.firstDegreeText, fontSize: 15),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: HsgColors.firstDegreeText,
                    size: 18,
                  ),
                ],
              ),
              onPressed: () {},
            ),
          );
        },
        childCount: listData.length,
      ),
    ));

    section.add(SliverToBoxAdapter(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: HsgColors.commonBackground,
              height: 10,
            ),
            Container(
              color: Colors.white,
              height: 40,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                '最近转账账号',
                style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ],
        ),
      ),
    ));

    section.add(SliverList(
      delegate: SliverChildBuilderDelegate(
        (content, index) {
          return Container(
            height: 70,
            decoration: BoxDecoration(
              //背景色
              color: Colors.white,
              //设置底部边框
              border: new Border(
                bottom: BorderSide(color: HsgColors.divider, width: 0.5),
              ),
            ),
            child: FlatButton(
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: AssetImage(
                          'images/transferIcon/transfer_sample_placeholder.png'),
                      width: 46,
                      height: 46,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '张三',
                              style: TextStyle(
                                color: HsgColors.secondDegreeText,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '500000879001',
                              style: TextStyle(
                                color: HsgColors.describeText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      '转出',
                      style: TextStyle(
                        color: HsgColors.accent,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () {
                      print('转出');
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: HsgColors.accent, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          );
        },
        childCount: 2,
      ),
    ));

    section.add(SliverToBoxAdapter(
      child: Container(
        // color: HsgColors.commonBackground,
        height: 20,
      ),
    ));

    return section;
  }

  ///上图下文字的按钮
  Widget _graphicButton(
      String title, String iconName, double iconWidth, VoidCallback onClick) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.only(left: 2, right: 2),
        onPressed: onClick,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 28),
              child: Image(
                image: AssetImage(iconName),
                width: iconWidth,
                height: iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HsgColors.describeText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, Object>> _gridFeatures = [
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_timely.png',
      'btnTitle': '行内转账'
    },
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_plan.png',
      'btnTitle': S.current.transfer_appointment
    },
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_record.png',
      'btnTitle': S.current.transfer_record
    },
  ];

  List<Map<String, Object>> _listFeatures = [
    {'btnIcon': '', 'btnTitle': '国际转账'},
  ];
}
