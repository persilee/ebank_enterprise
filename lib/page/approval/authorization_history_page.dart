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
import 'package:flutter/material.dart';

import '../../page_route.dart';

class AuthorizationHistoryPage extends StatefulWidget {
  AuthorizationHistoryPage({Key key}) : super(key: key);

  @override
  _AuthorizationHistoryPageState createState() =>
      _AuthorizationHistoryPageState();
}

enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _AuthorizationHistoryPageState extends State<AuthorizationHistoryPage> {
  LoadingStatus loadStatus; //加载状态
  int count = 0;
  int page = 1;
  ScrollController _scrollController = ScrollController();
  List<FinishTaskDetail> list = []; //页面显示的待办列表
  List<FinishTaskDetail> finishTaskList = [];
  bool _loadMore = false;
  @override
  void initState() {
    super.initState();
    //网络请求
    _loadAuthorzationRateData(page, 10);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //加载更多
        _getMore();
      }
    });
  }

  void go2Detail(FinishTaskDetail history) {
    Navigator.pushNamed(context, pageAuthorizationTaskApproval,
        arguments: history);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return _loadingView();
        } else {
          return GestureDetector(
            onTap: () {
              //  Navigator.pushNamed(context, pageAuthorizationTaskApproval);
              go2Detail(list[index]);
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
                      _getRow(S.current.sponsor, list[index].processId),
                      //待办任务名称
                      _getRow(S.current.to_do_task_name, list[index].taskName),
                      //创建时间
                      _getRow(S.current.creation_time, list[index].createTime)
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
      controller: _scrollController,
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

  Future<void> _loadAuthorzationRateData(int page, int pageSize) async {
    NeedToBeDealtWithRepository()
        .findUserFinishedTask(
            GetFindUserFinishedTaskReq(page, pageSize), 'findUserFinishedTask')
        .then((data) {
      if (data.rows != null) {
        count = data.count;
        setState(() {
          finishTaskList.clear();
          finishTaskList.addAll(data.rows);
          list.addAll(finishTaskList);
        });
      }
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
      if (list.length < count) {
        page = page + 1;
        _loadAuthorzationRateData(page, 10);
        loadStatus = LoadingStatus.STATUS_IDEL;
      } else {
        loadStatus = LoadingStatus.STATUS_LOADING;
      }
    });
  }

//加载
  Widget _loadingView() {
    var loadingIndicator = Visibility(
      visible: loadStatus == LoadingStatus.STATUS_LOADING ? false : true,
      child: SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
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

  //销毁
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
