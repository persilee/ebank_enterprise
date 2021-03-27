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
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
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

  // bool refresh;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _loadData();
  }

//加载
  Widget _loadingView() {
    return Center(
      child: Lottie.asset(
        'assets/json/loading2.json',
        width: 126,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
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
        onTap: () {
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
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? HsgLoading()
        : _listData.length > 0
            ? CustomRefresh(
                controller: _refreshController,
                onLoading: () {
                  //加载更多完成
                  _refreshController.loadComplete();
                  //显示没有更多数据
                  // _refreshController.loadNoData();
                },
                onRefresh: () {
                  //刷新完成
                  _refreshController.refreshCompleted();
                  _refreshController.footerMode.value = LoadStatus.canLoading;
                },
                content: ListView.builder(
                  // itemCount: list.length,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: _listData.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return _todoInformation(_listData[index]);
                  },
                ),
              )
            : notDataContainer(context, S.current.no_data_now);
  }

//跳转并传值
  void go2Detail(Rows rows) {
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

    if(this.mounted) {
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


