import 'dart:convert';
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
import 'package:ebank_mobile/data/source/model/my_approval_data.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../page_route.dart';

class MyApprovalPage extends StatefulWidget {
  final title;

  MyApprovalPage({Key key, this.title}) : super(key: key);

  @override
  _MyApprovalPageState createState() => _MyApprovalPageState();
}

class _MyApprovalPageState extends State<MyApprovalPage> {
  List<FindUserTaskDetail> toDoTask = [];
  List<Rows> _listData = []; //页面显示的待办列表
  ScrollController _scrollController;
  int count = 0;
  int page = 1;
  bool _isLoading = false; //加载状态
  bool _isDate = false;
  RefreshController _refreshController;

  ///////////////
  List<Data> _testListData = [];
  int _testPageIndex = 1;
  bool _isMoreData = false;

  // bool refresh;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    // _loadData();
    _testLoadData(false);
  }

  void _testLoadData(bool isLoadMore) async {
    if (isLoadMore) {
      _testPageIndex++;
    } else {
      _testPageIndex = 1;
    }
    _isLoading = true;
    if (!isLoadMore) await Future.delayed(Duration(seconds: 2));
    rootBundle.loadString('assets/json/my_approval.json').then((value) {
      Map map = json.decode(value);
      MyApprovalData data = MyApprovalData.fromJson(map);
      print(data.toJson());
      _isLoading = true;
      if (this.mounted) {
        setState(() {
          if (_testPageIndex == 1) {
            _testListData.addAll(data.data.sublist(0, 9));
          } else if (_testPageIndex == 2) {
            _testListData.addAll(data.data.sublist(9, data.data.length));
            _isMoreData = true;
          }
          _isLoading = false;
        });
      }
    });
  }

//蓝色圆点
  Widget _icon() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Icon(
        Icons.fiber_manual_record,
        color: Color(0xff3394D4),
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
  Widget _rightInfo(Data rows) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff46529F).withOpacity(0.1),
            spreadRadius: 1.0,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
      ),
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
  Widget _todoInformation(Data rows) {
    return Container(
      height: 136.0,
      padding: EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () {
          go2Detail(rows);
        },
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Row(
              children: [
                Container(
                  width: 20.0,
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
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? HsgLoading()
        : _testListData.length > 0
            ? CustomRefresh(
                controller: _refreshController,
                onLoading: () async {
                  await Future.delayed(Duration(seconds: 1));
                  _testLoadData(true);
                  //加载更多完成
                  _refreshController.loadComplete();
                  //显示没有更多数据
                  if (_isMoreData) _refreshController.loadNoData();
                  // _refreshController.loadNoData();
                },
                onRefresh: () {
                  _testLoadData(false);
                  //刷新完成
                  _refreshController.refreshCompleted();
                  _refreshController.footerMode.value = LoadStatus.canLoading;
                },
                content: ListView.builder(
                  // itemCount: list.length,
                  padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
                  itemCount: _testListData.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return _todoInformation(_testListData[index]);
                  },
                ),
              )
            : notDataContainer(context, S.current.no_data_now);
  }

//跳转并传值
  void go2Detail(Data rows) {
    Navigator.pushNamed(context, pageTaskApproval,
        arguments: {"data": rows, "title": widget.title});
  }

  Future<void> _loadData() async {
    _isLoading = true;
    FindUserTodoTaskModel findUserTodoTaskModel = await ApiClient()
        .findUserTodoTask(BaseBody(
            body: FindUserTodoTaskBody(
                    page: 1,
                    pageSize: 20,
                    tenantId: 'EB',
                    custId: '818000000113')
                .toJson()));

    if (this.mounted) {
      setState(() {
        _listData.addAll(findUserTodoTaskModel.body.rows);
        _isLoading = false;
      });
    }

    print('findUserTodoTaskResponse: ${findUserTodoTaskModel.toJson()}');
  }

//加载更多
  _getMore() {}

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }
}
