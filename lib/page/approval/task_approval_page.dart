import 'dart:async';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/do_claim_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/model/get_process_task.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/information_display_list_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class TaskApprovalPage extends StatefulWidget {
  TaskApprovalPage({Key key}) : super(key: key);

  @override
  _TaskApprovalPageState createState() => _TaskApprovalPageState();
}

class _TaskApprovalPageState extends State<TaskApprovalPage> {
  FocusNode focusNode = FocusNode();
  bool offstage = true; //判断签收按钮是否被点击
  bool approveResult = true; //审批结果
  bool rejectToStart = true; //是否驳回至发起人
  String comment = ''; //审批意见
  var taskId = '';
  ScrollController _controller;

  Map approvalInfo = {
    "转账信息": [
      {"title": "收款账号", "type": "500000617001"},
      {"title": "账号名称", "type": "Mike"},
      {"title": "转入货币", "type": "EUR"},
    ],
    "付款信息": [
      {"title": "付款账号", "type": "500000740001"},
      {"title": "账户名称", "type": "Leo"},
      {"title": "付款银行", "type": "HISUN-高阳银行"},
      {"title": "转出货币", "type": "EUR"},
      {"title": "转出金额", "type": "1000"},
      {"title": "附言", "type": "转账"},
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      print(_controller.position);
    });
    //监听输入框
    focusNode.addListener(() {
      bool hasFocus = focusNode.hasFocus;
      // ignore: invalid_use_of_protected_member
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

//签收按钮被点击时改变offstage
  void _toggle() {
    setState(() {
      offstage = !offstage;
    });
  }

//顶部提示
  Widget _tips() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFDCE4FF),
      child: Text(
        S.current.task_approval_tips,
        style: TextStyle(
          color: HsgColors.accent,
          fontSize: 13,
        ),
      ),
    );
  }

//提示对话框
  _alertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: "提示",
            message: "请输入审批意见",
            positiveButton: '确定',
          );
        });
  }

//审批信息列表标题
  Widget _title(String title) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

//审批意见
  Widget _approvalComments() {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            S.current.approval_comment,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

//审批意见输入框
  Widget _inputApprovalComments() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: TextField(
        focusNode: focusNode,
        maxLines: 4,
        enabled: !offstage,
        decoration: InputDecoration(
          fillColor: Color(int.parse('0xffF7F7F7')),
          filled: offstage,
          hintText: S.current.please_input + '...',
          hintStyle: TextStyle(fontSize: 14.0),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: HsgColors.textHintColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: HsgColors.textHintColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HsgColors.textHintColor, width: 1),
          ),
        ),
        onChanged: (value) {
          comment = value;
        },
      ),
    );
  }

//底部按钮
  Widget _button() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 20, bottom: 15),
      child: _getToggleChild(),
    );
  }

//按钮
  Widget _buttonStyle(String buttonText) {
    return Container(
      decoration: BoxDecoration(
        color: (buttonText == S.current.approval_unlock ||
                buttonText == S.current.approval_lock)
            ? Color(int.parse('0xff4871FF'))
            : Colors.white,
        border: Border.all(color: Color(int.parse('0xff4871FF')), width: 0.5),
        borderRadius: BorderRadius.circular((4)),
      ),
      height: 40,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        disabledColor: HsgColors.btnDisabled,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 13,
            color: (buttonText == S.current.approval_unlock ||
                    buttonText == S.current.approval_lock)
                ? Colors.white
                : Colors.black,
          ),
        ),
        onPressed: () {
          if (buttonText == S.current.approval_lock) {
            _toggle();
            _doClaimTask();
            print(_controller.position.maxScrollExtent);
            WidgetsBinding.instance.addPostFrameCallback((callback){
              print("addPostFrameCallback be invoke");
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            });
          } else {
            if (comment.length != 0) {
              if (buttonText == S.current.reject_to_sponsor ||
                  buttonText == S.current.reject) {
                approveResult = false;
              }
              _getTaskApproval(buttonText == S.current.reject_to_sponsor
                  ? rejectToStart
                  : null);
              Navigator.pushReplacementNamed(context, pageDepositRecordSucceed,
                  arguments: 'taskApproval');
            } else {
              if (buttonText == S.current.approval_unlock) {
                Navigator.pop(context);
              } else {
                _alertDialog();
              }
            }
          }
        },
      ),
    );
  }

//根据输入框的状态判断底部按钮
  _getToggleChild() {
    if (!offstage) {
      return Container(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buttonStyle(S.current.reject_to_sponsor),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              flex: 1,
              child: _buttonStyle(S.current.reject),
            ),
            Padding(
                padding: EdgeInsets.only(
              left: 10,
            )),
            Expanded(
              flex: 1,
              child: _buttonStyle(S.current.approval_unlock),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 66.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buttonStyle(S.current.approval_lock),
          ],
        ),
      );
    }
  }

  //我的审批
  Widget _myApproval(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: HsgColors.backgroundColor,
            height: 15,
          ),
          _title(S.current.my_approval),
          Container(
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
          _approvalComments(),
          //审批意见输入框
          _inputApprovalComments(),
          //底部按钮
          _button(),
          !offstage
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (comment.length != 0) {
                        Navigator.pushReplacementNamed(
                            context, pageDepositRecordSucceed,
                            arguments: 'taskApproval');
                      } else {
                        _alertDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(
                        int.parse('0xff4871FF'),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 11.0),
                    ),
                    child: Text(
                      S.current.examine_and_approve,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                )
              : Container(),
          !offstage
              ? SizedBox(
                  height: 26.0,
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    String title = arguments['title'];
    FindUserTaskDetail application = arguments['data'];

    taskId = application.taskId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            _tips(), //提示
            Column(
              //审批信息列表
              children: informationDisplayList(context, approvalInfo),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, pageAuthorizationTaskApprovalHistoryDetail);
              },
              child: _buildTitle('审批历史', true),
            ),

            _myApproval(context), //我的审批
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, bool isShowAvatar) {
    return Container(
      color: Colors.white,
      height: 46,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  isShowAvatar
                      ? Row(
                    children: [
                      _buildAvatar(
                          'https://api.lishaoy.net/files/22/serve?size=medium',
                          '廖珠星'),
                      _buildAvatar(
                          'https://api.lishaoy.net/files/169/serve?size=thumbnail',
                          '康听白'),
                      _buildAvatar(
                          'https://api.lishaoy.net/files/258/serve?size=thumbnail',
                          '冯晓霞'),
                      Icon(
                        Icons.chevron_right,
                        size: 20.0,
                      ),
                    ],
                  )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Container _buildAvatar(String imageUrl, String name) {
    return Container(
      padding: EdgeInsets.only(right: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageUrl,
                  fit: BoxFit.cover,
                  width: 22.0,
                  height: 22.0,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _getTaskApproval(bool rejectToStart) {
    Future.wait({
      NeedToBeDealtWithRepository().getMyProcessTask(
          GetProcessTaskReq(approveResult, comment, rejectToStart, taskId),
          'getMyProcessTask')
    });
  }

  void _doClaimTask() {
    Future.wait({
      ProcessTaskDataRepository()
          .doClaimTask(DoClaimTaskReq(taskId), 'doClaimTask')
    });
  }
}
