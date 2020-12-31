/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_my_application.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class MyApplicationPage extends StatefulWidget {
  MyApplicationPage({Key key}) : super(key: key);

  @override
  _MyApplicationPageState createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends State<MyApplicationPage> {
  @override
  void initState() {
    super.initState();

    //网络请求
    _loadMyApplicationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContent(rowList),
    );
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
                Navigator.pushNamed(context, pageApplicationTaskApproval,
                    arguments: rows[index]);
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
                          _getRow(S.current.sponsor, rowList[index].processId),
                          _getRow(S.current.to_do_task_name,
                              rowList[index].taskName),
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

  _loadMyApplicationData() async {
    var finish = false;
    var page = 1;
    var pageSize = 10;
    var processId = '';
    var processKey = '';
    var processStatus = true;
    var processTitle = '';
    var sort = '';
    var taskName = '';
    NeedToBeDealtWithRepository()
        .getMyApplication(
            GetMyApplicationReq(finish, page, pageSize, processId, processKey,
                processStatus, processTitle, sort, taskName),
            'tag')
        .then((data) {
      setState(() {
        rowList.clear();
        rowList.addAll(data.rows);
      });
    });
  }
}
