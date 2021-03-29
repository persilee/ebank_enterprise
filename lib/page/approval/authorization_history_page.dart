/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 授权历史记录页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/find_user_finished_task.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../page_route.dart';

class AuthorizationHistoryPage extends StatefulWidget {
  final title;

  AuthorizationHistoryPage({Key key, this.title}) : super(key: key);

  @override
  _AuthorizationHistoryPageState createState() =>
      _AuthorizationHistoryPageState();
}

enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _AuthorizationHistoryPageState extends State<AuthorizationHistoryPage> {
  LoadingStatus loadStatus; //加载状态
  int count = 0;
  int page = 1;
  ScrollController _scrollController;
  List<FinishTaskDetail> list = []; //页面显示的待办列表
  List<FinishTaskDetail> finishTaskList = [];
  FinishTaskDetail dataA = FinishTaskDetail("60001", "0", "一对一转账审批", "6001",
      "transfer", "3", "776106645288648704", "2020-11-11 14:16:24");
  FinishTaskDetail dataB = FinishTaskDetail("60002", "0", "定期开立", "6002",
      "transfer", "3", "776106645288648704", "2020-11-11 15:46:56");
  FinishTaskDetail dataC = FinishTaskDetail("60003", "0", "一对一转账审批", "6003",
      "transfer", "3", "776106645288648704", "2020-11-11 15:51:18");
  FinishTaskDetail dataD = FinishTaskDetail("60003", "0", "定期开立", "6003",
      "transfer", "3", "776106645288648704", "2020-11-11 16:02:33");
  var _future;

  bool _isLoading = false;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshController = RefreshController();
    _testLoadData();
    //网络请求
    // _loadAuthorzationRateData(page, 10);

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     //加载更多
    //     _getMore();
    //   }
    //   _future = _loadAuthorzationRateData(page, 10);
    // });
  }

  void _testLoadData() async {
    _isLoading = true;
    await Future.delayed(Duration(seconds: 2));
    list.add(dataA);
    list.add(dataB);
    list.add(dataC);
    list.add(dataD);
    if(this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void go2Detail(FinishTaskDetail history) {
    Navigator.pushNamed(context, pageAuthorizationTaskApproval,
        arguments: {"data": history, "title": widget.title});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? HsgLoading()
        : list.length > 0
            ? CustomRefresh(
                controller: _refreshController,
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                  //刷新完成
                  _refreshController.refreshCompleted();
                  _refreshController.footerMode.value = LoadStatus.canLoading;
                },
                onLoading: () async {
                  await Future.delayed(Duration(seconds: 1));
                  _refreshController.loadNoData();
                },
                content: ListView.builder(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
                  itemCount: list.length + 1,
                  // itemCount: list.length,
                  itemBuilder: (context, index) {
                    if (index == list.length) {
                      return Container();
                      // return _loadingView();
                    } else {
                      return Container(
                        height: 156.0,
                        padding: EdgeInsets.only(top: 16),
                        child: GestureDetector(
                          onTap: () {
                            go2Detail(list[index]);
                          },
                          child: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: _getColumn(index),
                                  ),
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
                  },
                  controller: _scrollController,
                ),
              )
            : notDataContainer(context, S.current.no_data_now);
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

  _getRow(String leftText, String rightText) {
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

  _getColumn(index) {
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
            _taskName(list[index].processTitle),
            //发起人
            _getRow(S.current.sponsor, list[index].startUser),
            //创建时间
            _getRow(S.current.creation_time, list[index].createTime),
            //创建时间
            _getRow('处理状态', '成功'),
          ],
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

  Future<void> _loadAuthorzationRateData(int page, int pageSize) async {
    NeedToBeDealtWithRepository()
        .findUserFinishedTask(
            GetFindUserFinishedTaskReq(page, pageSize), 'findUserFinishedTask')
        .then((data) {
      if (data.rows != null) {
        count = data.count;
        if (mounted) {
          setState(() {
            finishTaskList.clear();
            finishTaskList.addAll(data.rows);
            list.addAll(finishTaskList);
          });
        }
      }
    });
  }

  //加载更多
  _getMore() {
  }

  //销毁
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }
}
