/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  MyApprovalPage({Key key}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<Widget> _list() {
    List<Widget> section = [];
    section.add(SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return FlatButton(
          // color: Colors.yellow,
          padding: EdgeInsets.only(top: 10.0),
          onPressed: () {
            Navigator.pushNamed(context, pageTransfer);
          },
          child: Row(
            children: [
              Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: HsgColors.accent,
                            size: 8.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 10.0),
                          child: SizedBox(
                            width: 1.0,
                            height: 100.0,
                            child: DecoratedBox(
                              decoration:
                                  BoxDecoration(color: HsgColors.divider),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: HsgStyles.homeHeaderShadow,
                padding: EdgeInsets.all(0),
                // color: Colors.green,
                margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
                child: Column(
                  children: [
                    Container(
                        width: 370,
                        // color: Colors.red,
                        child: Text(
                          "定期开立",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: HsgColors.aboutusTextCon,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      width: 370,
                      // color: Colors.yellow,
                      padding: EdgeInsets.only(top: 18),
                      child: Row(
                        children: [
                          Text(
                            "发起人",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.secondDegreeText,
                            ),
                          ),
                          SizedBox(
                            width: 250.0,
                          ),
                          Text(
                            "070365989",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.aboutusTextCon,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 370,
                      padding: EdgeInsets.only(top: 12),
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Text(
                            "创建时间",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.secondDegreeText,
                            ),
                          ),
                          SizedBox(
                            width: 180.0,
                          ),
                          Text(
                            "2011-11-02 11:12:30",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.aboutusTextCon,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));
    }, childCount: 4)));
    return section;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomScrollView(
      slivers: _list(),
    ));
  }
}
