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

  Map transferInfo = {
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
    //监听输入框
    focusNode.addListener(() {
      bool hasFocus = focusNode.hasFocus;
      // ignore: invalid_use_of_protected_member
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });
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
            // negativeButton: '取消',
          );
        });
  }

//列表标题
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
          fillColor: HsgColors.itemClickColor,
          filled: offstage,
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
          print('输入的是:$value');
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
  Widget _buttonStyle(double buttonWidth, String buttonText) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: buttonWidth,
      decoration: BoxDecoration(
        color: (buttonText == S.current.examine_and_approve ||
                buttonText == S.current.sign)
            ? HsgColors.accent
            : Colors.white,
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      height: 40,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        disabledColor: HsgColors.btnDisabled,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 13,
            color: (buttonText == S.current.examine_and_approve ||
                    buttonText == S.current.sign)
                ? Colors.white
                : Colors.black,
          ),
        ),
        onPressed: () {
          if (buttonText == S.current.sign) {
            _toggle();
            _doClaimTask();
          } else {
            if (comment.length != 0) {
              if (buttonText == S.current.examine_and_approve) {
                print('审批');
              } else if (buttonText == S.current.reject_to_sponsor) {
                print('驳回至发起人');
                approveResult = false;
              } else if (buttonText == S.current.reject) {
                print('驳回');
                approveResult = false;
              }
              _getTaskApproval(buttonText == S.current.reject_to_sponsor
                  ? rejectToStart
                  : null);
              Navigator.pushReplacementNamed(context, pageDepositRecordSucceed,
                  arguments: 'taskApproval');
            } else {
              _alertDialog();
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buttonStyle(120, S.current.reject_to_sponsor),
            _buttonStyle(60, S.current.reject),
            _buttonStyle(60, S.current.examine_and_approve),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buttonStyle(60, S.current.sign),
        ],
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FindUserTaskDetail application = ModalRoute.of(context).settings.arguments;
    taskId = application.taskId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.task_approval),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _tips(),
            Column(
              children: informationDisplayList(context, transferInfo),
            ),
            _myApproval(context),
          ],
        ),
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
