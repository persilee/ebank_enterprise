/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  MyApprovalPage({Key key}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<Rows> row = [];

  void initState() {
    super.initState();
    _loadData(1, 20);
  }

  List<Widget> _list(List<Rows> row) {
    List<Widget> section = [];
    section.add(SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return FlatButton(
          padding: EdgeInsets.only(top: 10.0),
          onPressed: () {
            Navigator.pushNamed(context, pageTaskApproval);
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
                width: 360,

                // height: 95,
                decoration: HsgStyles.homeHeaderShadow,
                // padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(left: 10.0),
                // color: Colors.green,
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
                child: Column(
                  children: [
                    Container(
                        width: 340,
                        // color: Colors.red,
                        child: Text(
                          "定期开立",
                          // row[index].taskName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: HsgColors.aboutusTextCon,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      width: 340,
                      // color: Colors.yellow,
                      padding: EdgeInsets.only(top: 15),
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
                            width: 224.0,
                          ),
                          Text(
                            "070365989",
                            // row[index].startUser,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.aboutusTextCon,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 340,
                      padding: EdgeInsets.only(top: 10, bottom: 0),
                      // color: Colors.red,
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
                            width: 150.0,
                          ),
                          Text(
                            "2011-11-02 11:12:30",
                            // row[index].createTime,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: HsgColors.aboutusTextCon,
                            ),
                          )
                        ],
                      ),
                    ),
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
      slivers: _list(row),
    ));
  }

  Future<void> _loadData(
    int page,
    int pageSize,
  ) async {
    ProcessTaskDataRepository()
        .findUserToDoTask(
            FindUserToDoTaskReq(page, pageSize), 'findUserToDoTask')
        .then((data) {
      if (data.rows != null) {
        setState(() {
          row.clear();
          row.addAll(data.rows);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
