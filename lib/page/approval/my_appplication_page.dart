/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 我的申请页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_my_application.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class MyApplicationPage extends StatefulWidget {
  MyApplicationPage({Key key}) : super(key: key);

  @override
  _MyApplicationPageState createState() => _MyApplicationPageState();
}

enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _MyApplicationPageState extends State<MyApplicationPage> {
  LoadingStatus loadStatus; //加载状态
  int count = 0;
  int page = 1;
//是否加载更多
  ScrollController _scrollController = ScrollController();
  List<MyApplicationDetail> list = []; //页面显示的待办列表
  List<MyApplicationDetail> myApplicationList = [];

  var application;

  @override
  void initState() {
    super.initState();
    //网络请求
    _loadMyApplicationData(page, 10);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //加载更多
        _getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(   
      body: _getContent(list),
    );
  }

  _getContent(List<MyApplicationDetail> list) {
       bool _isDate = false;
        if(list.length != 0){
          _isDate = true;
        }
    return _isDate? ListView.builder(   
      itemCount: list.length + 1,    
      itemBuilder: (context, index) {
        if (index == list.length) {
          return _loadingView();
        } else {
          return  GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, pageApplicationTaskApproval,
                  arguments: list);
            },
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    children: [
                      _getRow(S.current.sponsor, list[index].processId),
                      _getRow(S.current.to_do_task_name, list[index].taskName),
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
    ) : notDataContainer(context,S.current.no_data_now);
  }

  //销毁
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
          ),
        ],
      ),
    );
  }

  _loadMyApplicationData(page, pageSize) {
    var finish = false;
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
      if (data.rows != null) {
        count = data.count;
        setState(() {
          myApplicationList.clear();
          myApplicationList.addAll(data.rows);
          list.addAll(myApplicationList);
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
        _loadMyApplicationData(page, 10);
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
    return Row(
      children: <Widget>[loadingIndicator],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
