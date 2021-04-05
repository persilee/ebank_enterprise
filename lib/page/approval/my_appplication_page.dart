/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 我的申请页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */


import 'package:dio/dio.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';

class MyApplicationPage extends StatefulWidget {
  final title;
  MyApplicationPage({Key key, this.title}) : super(key: key);

  @override
  _MyApplicationPageState createState() => _MyApplicationPageState();
}

enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _MyApplicationPageState extends State<MyApplicationPage> {
  ScrollController _scrollController;
  RefreshController _refreshController;
  List<ApprovalTask> _listData = [];
  int _page = 1;
  bool _isLoading = false;
  bool _isMoreData = false;


  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? HsgLoading()
        : _listData.length > 0
        ? CustomRefresh(
      controller: _refreshController,
      onLoading: () async {
        await _loadData(isLoadMore: true);
        //加载更多完成
        _refreshController.loadComplete();
        //显示没有更多数据
        if (_isMoreData) _refreshController.loadNoData();
      },
      onRefresh: () async {
        await _loadData();
        //刷新完成
        _refreshController.refreshCompleted();
        _refreshController.footerMode.value = LoadStatus.canLoading;
      },
      content: ListView.builder(
        padding:
        EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
        itemCount: _listData.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return _todoInformation(_listData[index]);
        },
      ),
    )
        : notDataContainer(context, S.current.no_data_now);
  }

  //加载数据
  Future<void> _loadData({bool isLoadMore = false}) async {
    isLoadMore ? _page ++ : _page = 1;
    _isLoading = true;
    try {
      FindUserTodoTaskModel response = await ApiClient().findUserStartTask(
        FindTaskBody(
            page: _page, pageSize: 10, tenantId: 'EB', custId: SpUtil.getString(ConfigKey.CUST_ID)),
      );
      if (this.mounted) {
        setState(() {
          if(isLoadMore == false && _page == 1) {
            _listData.clear();
          }
          _listData.addAll(response.rows);
          _isLoading = false;
          if(response.rows.length <= 10 && response.totalPage <= _page) {
            _isMoreData = true;
          }
        });
      }
    } catch (e) {
      print((e as DioError).error is NeedLogin);
      if ((e as DioError).error is NeedLogin) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
              return LoginPage();
            }), (Route route) {
          print(route.settings?.name);
          if (route.settings?.name == "/") {
            return true;
          }
          return false;
        });
      } else {
        if(this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print('error: ${e.toString()}');
      }
    }
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
  Widget _rightInfo(ApprovalTask approvalTask) {
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
            _taskName(approvalTask?.taskName ?? ''),
            Padding(padding: EdgeInsets.only(top: 2.0)),
            //待办任务id
            _rowInformation(S.current.approval_task_id, approvalTask?.taskId ?? ''),
            //发起人
            _rowInformation(S.current.sponsor, approvalTask?.applicantName ?? ''),
            //审批结果
            _rowInformation(S.current.approve_result, approvalTask?.result ?? ''),
            //审批时间
            _rowInformation(S.current.approve_create_time, approvalTask?.createTime ?? ''),
          ],
        ),
      ),
    );
  }

  //待办列表
  Widget _todoInformation(ApprovalTask approvalTask) {
    return Container(
      height: 166.0,
      padding: EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () {
          go2Detail(approvalTask);
        },
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Row(
              children: [
                Container(
                  width: 20.0,
                ),
                Expanded(child: _rightInfo(approvalTask)),
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

  //跳转并传值
  void go2Detail(ApprovalTask approvalTask) {
    Navigator.pushNamed(context, pageAuthorizationTaskApproval,
        arguments: {"data": approvalTask, "title": widget.title});
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
        height: 146.0,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.divider),
        ),
      ),
    );
  }
}
