/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  MyApprovalPage({Key key}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<Rows> toDoTask = [];
  Rows approval;
  ScrollController _sctrollController = ScrollController();
  int totalPage = 0;
  int page = 1;
  bool _showmore = false;

  void initState() {
    //网络请求
    _loadData(page, 20);
    super.initState();
    _sctrollController.addListener(() {
      setState(() {
        if (_sctrollController.position.pixels ==
            _sctrollController.position.maxScrollExtent) {
          //网络请求
          _loadData(page, 20);
        }
      });
    });
  }

  void dispose() {
    _sctrollController.dispose();
    super.dispose();
  }

//显示加载状态
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _showmore ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

//蓝色圆点
  Widget _icon() {
    return Column(
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
    );
  }

//竖直线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0),
      child: SizedBox(
        width: 1.0,
        height: 100.0,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.divider),
        ),
      ),
    );
  }

//待办任务名称
  Widget _taskName(String taskName) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          taskName,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 15.0,
              color: HsgColors.aboutusTextCon,
              fontWeight: FontWeight.bold),
        ));
  }

//发起人、创建时间
  Widget _rowInformation(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(
            width: ((MediaQuery.of(context).size.width / 1.09) - 22) / 2,
            child: Text(
              leftText,
              style: TextStyle(
                fontSize: 14.0,
                color: HsgColors.secondDegreeText,
              ),
            ),
          ),
          Container(
              width: ((MediaQuery.of(context).size.width / 1.09) - 22) / 2,
              child: Text(
                rightText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14.0,
                  color: HsgColors.aboutusTextCon,
                ),
              )),
        ],
      ),
    );
  }

  //待办列表右侧信息
  Widget _rightInfo(String taskName, String startUser, String createTime) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.09,
      decoration: HsgStyles.homeHeaderShadow,
      margin: EdgeInsets.only(left: 10.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      child: Column(
        children: [
          //待办任务名称
          _taskName(taskName),
          //发起人
          _rowInformation(intl.S.current.sponsor, startUser),
          //创建时间
          _rowInformation(intl.S.current.creation_time, createTime),
        ],
      ),
    );
  }

//待办列表
  Widget _todoInformation(
      Rows approval, String taskName, String startUser, String createTime) {
    return FlatButton(
        padding: EdgeInsets.only(top: 10.0),
        onPressed: () {
          go2Detail(approval);
        },
        child: Row(
          children: [
            //左侧图标
            Column(
              children: [
                _icon(),
                _line(),
              ],
            ),
            //右侧待办信息
            _rightInfo(taskName, startUser, createTime),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: toDoTask.length + 1,
      itemBuilder: (context, index) {
        if (index == toDoTask.length) {
          return _buildProgressIndicator();
        } else {
          return _todoInformation(toDoTask[index], toDoTask[index].taskName,
              toDoTask[index].startUser, toDoTask[index].createTime);
        }
      },
      controller: _sctrollController,
    );
  }

//跳转并传值
  void go2Detail(Rows approval) {
    Navigator.pushNamed(context, pageTaskApproval, arguments: approval);
  }

  Future<void> _loadData(
    int page,
    int pageSize,
  ) async {
    if (!_showmore) {
      setState(() {
        _showmore = true;
      });
      ProcessTaskDataRepository()
          .findUserToDoTask(
              FindUserToDoTaskReq(page, pageSize), 'findUserToDoTask')
          .then((data) {
        if (data.rows != null) {
          totalPage = data.totalPage;
          setState(() {
            _showmore = false;
            toDoTask.clear();
            toDoTask.addAll(data.rows);
          });
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
    }
  }
}
