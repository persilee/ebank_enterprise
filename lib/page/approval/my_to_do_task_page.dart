/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 我的待办页面
/// Author: wangluyao
/// Date: 2020-12-21
import 'package:dio/dio.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_error_page.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';

import '../../page_route.dart';

class MyToDoTaskPage extends StatefulWidget {
  final title;

  MyToDoTaskPage({Key key, this.title}) : super(key: key);

  @override
  _MyToDoTaskPageState createState() => _MyToDoTaskPageState();
}

class _MyToDoTaskPageState extends State<MyToDoTaskPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  RefreshController _refreshController;
  List<ApprovalTask> _listData = [];
  int _page = 1;
  bool _isLoading = false;
  bool _isMoreData = false;
  bool _isShowErrorPage = false;
  Widget _hsgErrorPage;

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
    super.build(context);
    return _isLoading
        ? HsgLoading()
        : CustomRefresh(
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
            content: _isShowErrorPage
                ? _hsgErrorPage
                : _listData.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 18.0),
                        itemCount: _listData.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return _todoInformation(_listData[index]);
                        },
                      )
                    : HsgErrorPage(
                        isEmptyPage: true,
                        buttonAction: () {
                          _loadData();
                        },
                      ),
          );
  }

  //加载数据
  Future<void> _loadData({bool isLoadMore = false}) async {
    isLoadMore ? _page++ : _page = 1;
    _isLoading = true;
    try {
      FindUserTodoTaskModel response = await ApiClient().findUserTodoTask(
        FindTaskBody(
            page: _page,
            pageSize: 10,
            tenantId: 'EB',
            custId: SpUtil.getString(ConfigKey.CUST_ID)),
      );
      if (this.mounted) {
        setState(() {
          if (isLoadMore == false && _page == 1) {
            _listData.clear();
          }
          _listData.addAll(response.rows);
          _isLoading = false;
          _isShowErrorPage = false;
          if (response.rows.length <= 10 && response.totalPage <= _page) {
            _isMoreData = true;
          }
        });
      }
    } catch (e) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isShowErrorPage = true;
          _hsgErrorPage = HsgErrorPage(
            error: e.error,
            buttonAction: () {
              _loadData();
            },
          );
        });
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
        Expanded(
          flex: 1,
          child: Text(
            leftText,
            style: TextStyle(
              fontSize: 14.0,
              color: HsgColors.toDoDetailText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            rightText,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.0,
              color: HsgColors.aboutusTextCon,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
            Padding(padding: EdgeInsets.only(top: 1.0)),
            //待办任务id
            _rowInformation(
                intl.S.current.approve_task_id, approvalTask?.taskId ?? ''),
            //发起人
            _rowInformation(
                intl.S.current.sponsor, approvalTask?.applicantName ?? ''),
            //创建时间
            _rowInformation(
                intl.S.current.creation_time, approvalTask?.createTime ?? ''),
          ],
        ),
      ),
    );
  }

  //待办列表
  Widget _todoInformation(ApprovalTask approvalTask) {
    return Container(
      height: 156.0,
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
    Navigator.pushNamed(context, pageTaskApproval,
        arguments: {"data": approvalTask, "title": widget.title}).then((value) {
      _loadData();
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
        height: 136.0,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.divider),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
