/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

class AuthorizationHistoryPage extends StatefulWidget {
  AuthorizationHistoryPage({Key key}) : super(key: key);

  @override
  _AuthorizationHistoryPageState createState() =>
      _AuthorizationHistoryPageState();
}

class _AuthorizationHistoryPageState extends State<AuthorizationHistoryPage> {
  @override
  void initState() {
    super.initState();

    //网络请求
    _loadAuthorzationRateData();
  }

  List<Rows> rowList = [];

  Widget _getContent(List<Rows> rows) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return SizedBox(
                child: GestureDetector(
              onTap: () {
                //  Navigator.pushNamed(context, pageAuthorizationTaskApproval);
                go2Detail(rowList[index]);
                print('选择账号');
              },
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          //发起人
                          _getRow(S.current.sponsor, rowList[index].processId),
                          //待办任务名称
                          _getRow(S.current.to_do_task_name,
                              rowList[index].taskName),
                          //创建时间
                          _getRow(S.current.creation_time,
                              rowList[index].createTime)
                        ],
                      ))
                ],
              ),
            ));
          },
          childCount: rowList.length,
        ))
      ],
    );
  }

  void go2Detail(Rows history) {
    Navigator.pushNamed(context, pageAuthorizationTaskApproval,
        arguments: history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContent(rowList),
    );
  }

  _getRow(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(leftText),
          ),
          Container(
            child: Text(
              rightText,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
              ),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  _loadAuthorzationRateData() async {
    var bool = false;
    var page = 1;
    var pageSize = 10;
    NeedToBeDealtWithRepository()
        .findUserFinishedTask(GetFindUserFinishedTaskReq(bool, page, pageSize),
            'findUserFinishedTask')
        .then((data) {
      setState(() {
        rowList.clear();
        rowList.addAll(data.rows);
      });
    });
  }
}
