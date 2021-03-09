/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  MyApprovalPage({Key key}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

//加载状态
enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<FindUserTaskDetail> toDoTask = [];
  List<FindUserTaskDetail> list = []; //页面显示的待办列表
  FindUserTaskDetail approval;
  ScrollController _sctrollController = ScrollController();
  int count = 0;
  int page = 1;
  LoadingStatus loadStatus; //加载状态
  bool _isDate = false;
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool refresh;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
    _sctrollController.addListener(() {
      if (_sctrollController.position.pixels ==
          _sctrollController.position.maxScrollExtent) {
        //加载更多
        _getMore();
      }
    });
    NotificationCenter.instance.addObserver('refresh', (object) {
      setState(() {
        if (object) {
          _loadData();
        }
      });
    });
  }

//设置padding
  Widget _pad(Widget widget, {l, t, r, b}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        l ??= 0.0,
        t ??= 0.0,
        r ??= 0.0,
        b ??= 0.0,
      ),
      child: widget,
    );
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
    return _pad(
      Row(
        children: <Widget>[loadingIndicator],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      t: 20.0,
      b: 20.0,
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
            color: HsgColors.blueIcon,
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
      ),
    );
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
                color: HsgColors.toDoDetailText,
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
            ),
          ),
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
  Widget _todoInformation(FindUserTaskDetail approval, String taskName,
      String startUser, String createTime) {
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: refrestIndicatorKey,
        child: _isDate
            ? ListView.builder(
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return _loadingView();
                  } else {
                    return Column(
                      children: <Widget>[
                        Center(
                          child: _pad(
                            _todoInformation(
                                list[index],
                                list[index].processTitle,
                                list[index].startUser,
                                list[index].createTime),
                            t: 10.0,
                            b: 10.0,
                          ),
                        ),
                      ],
                    );
                  }
                },
                controller: _sctrollController,
              )
            : notDataContainer(context, S.current.no_data_now),
        onRefresh: _loadData);
  }

//跳转并传值
  void go2Detail(FindUserTaskDetail approval) {
    Navigator.pushNamed(context, pageTaskApproval, arguments: approval);
  }

  Future<void> _loadData() async {
    ProcessTaskDataRepository()
        .findUserToDoTask(FindUserToDoTaskReq(page, 10), 'findUserToDoTask')
        .then((data) {
      if (data.rows.length != 0) {
        count = data.count;
        _isDate = true;
        setState(() {
          list.clear();
          toDoTask.clear();
          toDoTask.addAll(data.rows);
          list.addAll(toDoTask);
        });
      } else {
        _isDate = false;
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

//加载更多
  _getMore() {
    if (loadStatus == LoadingStatus.STATUS_IDEL) {
      setState(() {
        loadStatus = LoadingStatus.STATUS_LOADING;
      });
    }
    setState(() {
      if (list.length >= count) {
        loadStatus = LoadingStatus.STATUS_IDEL;
      } else {
        page = page + 1;
        _loadData();
        loadStatus = LoadingStatus.STATUS_LOADING;
      }
    });
  }

  void dispose() {
    super.dispose();
    _sctrollController.dispose();
  }
}
