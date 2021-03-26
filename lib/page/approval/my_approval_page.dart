import 'dart:ffi';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_body.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  final title;

  MyApprovalPage({Key key, this.title}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

//加载状态
enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<FindUserTaskDetail> toDoTask = [];
  List<Rows> _listData = []; //页面显示的待办列表
  // FindUserTaskDetail dataA = FindUserTaskDetail("60001", "0", "一对一转账", "6001",
  //     "transfer", "776108151173808128", "2020-11-12 09:12:24");
  // FindUserTaskDetail dataB = FindUserTaskDetail("60002", "0", "定期开立", "6002",
  //     "transfer", "776108151173808128", "2020-11-12 10:22:08");
  // FindUserTaskDetail dataC = FindUserTaskDetail("60003", "0", "定期开立", "6003",
  //     "transfer", "776108151173808128", "2020-11-12 11:27:11");
  // FindUserTaskDetail approval;
  ScrollController _sctrollController = ScrollController();
  int count = 0;
  int page = 1;
  LoadingStatus loadStatus; //加载状态
  bool _isDate = false;
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();


  // bool refresh;

  @override
  void initState() {
    super.initState();
    // list.add(dataA);
    // list.add(dataB);
    // list.add(dataC);
    _loadData();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // refrestIndicatorKey.currentState.show();
    // });
    // _sctrollController.addListener(() {
    //   if (_sctrollController.position.pixels ==
    //       _sctrollController.position.maxScrollExtent) {
    //     //加载更多
    //     _getMore();
    //   }
    // });
    // NotificationCenter.instance.addObserver('refresh', (object) {
    //   setState(() {
    //     if (object) {
    //       _loadData();
    //     }
    //   });
    // });
  }

//加载
  Widget _loadingView() {
    var loadingIndicator = Visibility(
      visible: loadStatus == LoadingStatus.STATUS_LOADING ? true : false,
      child: SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(HsgColors.accent),
        ),
      ),
    );
    return Row(
      children: <Widget>[loadingIndicator],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

//蓝色圆点
  Widget _icon() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Icon(
        Icons.fiber_manual_record,
        color: Color(int.parse('0xff3394D4')),
        size: 10.0,
      ),
    );
  }

//竖直线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(right: 10.0, top: 6.0),
      child: SizedBox(
        width: 1.0,
        height: 116.0,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.divider),
        ),
      ),
    );
  }

//待办任务名称
  Widget _taskName(String taskName) {
    return Text(
      taskName,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: 15.0,
          color: HsgColors.aboutusTextCon,
          fontWeight: FontWeight.bold),
    );
  }

//发起人、创建时间
  Widget _rowInformation(String leftText, String rightText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(
            fontSize: 14.0,
            color: HsgColors.toDoDetailText,
          ),
        ),
        Text(
          rightText,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14.0,
            color: HsgColors.aboutusTextCon,
          ),
        ),
      ],
    );
  }

  //待办列表右侧信息
  Widget _rightInfo(Rows rows) {
    return Card(
      elevation: 6.0,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //待办任务名称
            _taskName(rows.taskName),
            //发起人
            _rowInformation(intl.S.current.sponsor, rows.startUser),
            //创建时间
            _rowInformation(intl.S.current.creation_time, rows.createTime),
          ],
        ),
      ),
    );
  }

//待办列表
  Widget _todoInformation(Rows rows) {
    return Container(
      height: 136.0,
      padding: EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: (){
          go2Detail(rows);
        },
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Row(
              children: [
                Container(
                  width: 16.0,
                ),
                Expanded(child: _rightInfo(rows)),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                children: [
                  _icon(),
                  _line(),
                ],
              ),
            ),
          ],
        ),
      ),
    );


    //   FlatButton(
    //   padding: EdgeInsets.only(top: 10.0),
    //   onPressed: () {
    //     go2Detail(approval);
    //   },
    //   child: Row(
    //     children: [
    //       //左侧图标
    //       // Column(
    //       //   children: [
    //       //     _icon(),
    //       //     _line(),
    //       //   ],
    //       // ),
    //       //右侧待办信息
    //       _rightInfo(taskName, startUser, createTime),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        // itemCount: list.length,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: _listData.length,
        controller: _sctrollController,
        itemBuilder: (context, index) {
          return _todoInformation(_listData[index]);
          },
      ),
    );
  }

//跳转并传值
  void go2Detail(Rows rows) {
    Navigator.pushNamed(context, pageTaskApproval,
        arguments: {"data": rows, "title": widget.title});
  }

  Future<void> _loadData() async {
    FindUserTodoTaskModel findUserTodoTaskModel = await ApiClient().findUserTodoTask(BaseBody(body: FindUserTodoTaskBody(
      page: 1,
      pageSize: 10,
      tenantId: 'EB',
      custId: '818000000113'
    ).toJson()));

    setState(() {
      _listData.addAll(findUserTodoTaskModel.body.rows);
    });

    print('findUserTodoTaskResponse: ${findUserTodoTaskModel.toJson()}');
  }

//加载更多
  _getMore() {
    if (loadStatus == LoadingStatus.STATUS_IDEL) {
      setState(() {
        loadStatus = LoadingStatus.STATUS_LOADING;
      });
    }
    setState(() {
      if (_listData.length >= count) {
        loadStatus = LoadingStatus.STATUS_IDEL;
      } else {
        page = page + 1;
        _loadData();
        loadStatus = LoadingStatus.STATUS_LOADING;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sctrollController.dispose();
  }
}
