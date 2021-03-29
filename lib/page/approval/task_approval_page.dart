import 'dart:async';
import 'dart:convert';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/contract_detail_data.dart';
import 'package:ebank_mobile/data/source/model/do_claim_task.dart';
import 'package:ebank_mobile/data/source/model/find_to_do_task_detail_contract_model.dart';
import 'package:ebank_mobile/data/source/model/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/find_user_to_do_task.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_body.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/get_process_task.dart';
import 'package:ebank_mobile/data/source/model/my_approval_data.dart';
import 'package:ebank_mobile/data/source/model/transfer_detail_data.dart';
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page/approval/widget/information_display_list_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';

class TaskApprovalPage extends StatefulWidget {

  final Data data;
  final String title;

  TaskApprovalPage({Key key, this.data, this.title}) : super(key: key);

  @override
  _TaskApprovalPageState createState() => _TaskApprovalPageState();
}

class _TaskApprovalPageState extends State<TaskApprovalPage> {
  FocusNode focusNode = FocusNode();
  bool offstage = true; //判断签收按钮是否被点击
  bool approveResult = true; //审批结果
  bool rejectToStart = true; //是否驳回至发起人
  String comment = ''; //审批意见
  String taskId = '';
  ScrollController _controller;
  List<Widget> _contractList = [];
  List<Widget> _transferList = [];
  FindToDoTaskDetailContractModel _doTaskDetailContractModel;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    //监听输入框
    focusNode.addListener(() {
      bool hasFocus = focusNode.hasFocus;
      // ignore: invalid_use_of_protected_member
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });
    _loadData();
    print('aaaa');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _loadData() async {
    // String _processId = widget.data.processId;
    // String _processKey = widget.data.processKey;
    String _processKey = widget.data.type;
    int _index = widget.data.index;
    // print('_processId: $_processId');
    if(_processKey == 'openTdContractApproval' || _processKey == 'earlyRedTdContractApproval') {
      // _doTaskDetailContractModel = await ApiClient().findToDoTaskDetail(
      //     BaseBody(body: FindTodoTaskDetailBody(processId: _processId)));
      rootBundle.loadString('assets/json/contract_detail.json').then((value) {
        Map map = json.decode(value);
        ContractDetailData data = ContractDetailData.fromJson(map);
        ContractList item;
        data.contractList.forEach((element) {
          if(_index == element.index) {
            item = element;
          }
        });
        _contractList.add(_buildTitle('基本信息'));
        _contractList.add(_buildContentItem('产品', item.name));
        _contractList.add(_buildContentItem('存款期限', item.tenor));
        _contractList.add(_buildContentItem('金额', item.bal));
        _contractList.add(_buildContentItem('年利率', item.rate));
        _contractList.add(_buildContentItem('存单货币', item.ccy));
        _contractList.add(_buildContentItem('到期指示', item.inst));
        _contractList.add(_buildContentItem('结算账户', item.dAc));
        _contractList.add(_buildContentItem('扣款账户', item.oppAc));
        setState(() {});
      });
    } else {
      rootBundle.loadString('assets/json/transfer_detail.json').then((value) {
        Map map = json.decode(value);
        TransferDetailData data = TransferDetailData.fromJson(map);
        TransferList item;
        data.transferList.forEach((element) {
          if(_index == element.index) {
            item = element;
          }
        });
        _transferList.add(_buildTitle('付款方信息'));
        _transferList.add(_buildContentItem('付款账号', item.oppAc));
        _transferList.add(_buildContentItem('账户名称', item.oppAcName));
        _transferList.add(Padding(padding: EdgeInsets.only(top: 15)),);
        _transferList.add(_buildTitle('收款方信息'));
        _transferList.add(_buildContentItem('付款账号', item.dAc));
        _transferList.add(_buildContentItem('账户名称', item.dAcName));
        _transferList.add(_buildContentItem('货币', item.ccy));
        _transferList.add(_buildContentItem('金额', item.bal));
        _transferList.add(_buildContentItem('附言', item.postscript));
        setState(() {});
      });
    }
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
      color: Color(0xFFD2E4ED),
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
          fillColor: Color(0xffF7F7F7),
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

//根据输入框的状态判断底部按钮
  _getToggleChild() {
    if (!offstage) {
      return Container(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                isOutline: true,
                margin: EdgeInsets.all(0),
                text: Text(S.current.reject_to_sponsor, style: TextStyle(color: Color(0xff3394D4), fontSize: 14.0),),
                clickCallback: (){
                  if (comment.length != 0) {

                  } else {
                    _alertDialog();
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              flex: 1,
              child: CustomButton(
                isOutline: true,
                margin: EdgeInsets.all(0),
                text: Text(S.current.reject, style: TextStyle(color: Color(0xff3394D4), fontSize: 14.0),),
                clickCallback: (){
                  if (comment.length != 0) {
                    Navigator.pop(context);
                  } else {
                    _alertDialog();
                  }
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
              left: 10,
            )),
            Expanded(
              flex: 1,
              child: CustomButton(
                margin: EdgeInsets.all(0),
                text: Text(S.current.approval_unlock, style: TextStyle(color: Colors.white, fontSize: 14.0),),
                clickCallback: (){
                  if (comment.length != 0) {

                  } else {
                    _alertDialog();
                  }
                },
              ),
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
            CustomButton(
              margin: EdgeInsets.all(0),
              text: Text(S.current.approval_lock, style: TextStyle(color: Colors.white, fontSize: 14.0),),
              clickCallback: (){
                _toggle();
                // _doClaimTask();
                WidgetsBinding.instance.addPostFrameCallback((callback) {
                  _controller.animateTo(
                    _controller.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                });
              },
            ),
            // _buttonStyle(S.current.approval_lock),
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
          _buildTitle(S.current.my_approval),
          Container(
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
          _approvalComments(),
          //审批意见输入框
          _inputApprovalComments(),
          //底部按钮
          _button(),
          !offstage
              ? CustomButton(
                  clickCallback: () {
                    if (comment.length != 0) {
                      Navigator.pushReplacementNamed(
                          context, pageDepositRecordSucceed,
                          arguments: 'taskApproval');
                    } else {
                      _alertDialog();
                    }
                  },
                  text: Text(
                    S.current.examine_and_approve,
                    style: TextStyle(fontSize: 13.0, color: Colors.white),
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

    print(_doTaskDetailContractModel?.body?.operateEndValue?.matAmt);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            _tips(), //提示
            Column(
              //审批信息列表
              // children: informationDisplayList(context, approvalInfo),
              children: [
                Padding(padding: EdgeInsets.only(top: 15)),
                ..._contractList,
                ..._transferList,
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, pageAuthorizationTaskApprovalHistoryDetail);
              },
              child: _buildHistoryItem('审批历史', true),
            ),

            _myApproval(context), //我的审批
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
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

  Widget _buildContentItem(String name, String value) {
    return Container(
      height: 46,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 13.0),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 13.0, color: Color(int.parse('0xff7A7A7A'))),
                  ),
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

  Widget _buildHistoryItem(String title, bool isShowAvatar) {
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
