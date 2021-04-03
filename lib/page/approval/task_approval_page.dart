import 'dart:async';

import 'package:dio/dio.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/do_claim_task.dart';
import 'package:ebank_mobile/data/source/model/early_red_td_contract_detail_model.dart'
    as EarlyRedModel;
import 'package:ebank_mobile/data/source/model/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/get_process_task.dart';
import 'package:ebank_mobile/data/source/model/one_to_one_transfer_detail_model.dart'
    as OneToOneModel;
import 'package:ebank_mobile/data/source/model/open_td_contract_detail_model.dart'
    as OpenTDModel;
import 'package:ebank_mobile/data/source/need_to_be_dealt_with_repository.dart';
import 'package:ebank_mobile/data/source/process_task_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class TaskApprovalPage extends StatefulWidget {
  final ApprovalTask data;
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
  List<Widget> _openTdList = [];
  List<Widget> _earlyRedTdList = [];
  List<Widget> _oneToOneList = [];
  final f = NumberFormat("#,##0.00", "en_US");

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
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _loadData() async {
    String _processKey = widget.data.processKey;
    var _contractModel;
    try {
      _contractModel = await ApiClient().findToDoTaskDetail(
          FindTodoTaskDetailBody(processId: widget.data.processId));
    } catch (e) {
      if (e is NeedLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      } else {
        print('error: ${e.toString()}');
      }
    }
    // openTdContractApproval - 开立定期存单
    if (_processKey == 'openTdContractApproval') {
      OpenTDModel.OpenTdContractDetailModel openTdContractDetailModel =
          OpenTDModel.OpenTdContractDetailModel.fromJson(_contractModel);
      OpenTDModel.OperateEndValue data =
          openTdContractDetailModel?.operateEndValue;
      if (this.mounted) {
        setState(() {
          _openTdList.add(_buildTitle('基本信息'));
          _openTdList.add(_buildContentItem('产品', data?.prodName ?? ''));
          _openTdList.add(_buildContentItem('存款期限', data?.tenor ?? ''));
          _openTdList.add(_buildContentItem('金额', f.format(data?.bal) ?? ''));
          _openTdList.add(_buildContentItem('年利率', ''));
          _openTdList.add(_buildContentItem('存单货币', data?.ccy ?? ''));
          _openTdList.add(_buildContentItem('到期指示', data?.instCode ?? ''));
          _openTdList.add(_buildContentItem('结算账户', data?.settDdAc ?? ''));
          _openTdList.add(_buildContentItem('扣款账户', data?.oppAc ?? ''));
        });
      }
    }
    //earlyRedTdContractApproval - 定期提前结清
    else if (_processKey == 'earlyRedTdContractApproval') {
      EarlyRedModel.EarlyRedTdContractDetailModel
          earlyRedTdContractDetailModel =
          EarlyRedModel.EarlyRedTdContractDetailModel.fromJson(_contractModel);
      EarlyRedModel.OperateEndValue data =
          earlyRedTdContractDetailModel.operateEndValue;
      if (this.mounted) {
        setState(() {
          _earlyRedTdList.add(_buildTitle('基本信息'));
          _earlyRedTdList.add(_buildContentItem('合约号', data?.conNo ?? ''));
          _earlyRedTdList
              .add(_buildContentItem('存单金额', f.format(data?.bal) ?? ''));
          _earlyRedTdList.add(_buildContentItem('货币', data?.ccy ?? ''));
          _earlyRedTdList.add(_buildContentItem('存期', data?.tenor ?? ''));
          _earlyRedTdList.add(_buildContentItem('状态', data?.status ?? ''));
          _earlyRedTdList.add(_buildContentItem('生效日', data?.valueDate ?? ''));
          _earlyRedTdList.add(_buildContentItem('到期日', data?.dueDate ?? ''));
          _earlyRedTdList.add(_buildContentItem('结清本金金额', data?.matAmt ?? ''));
          _earlyRedTdList.add(
            Padding(padding: EdgeInsets.only(top: 15)),
          );
          _earlyRedTdList.add(_buildTitle('试算信息'));
          _earlyRedTdList
              .add(_buildContentItem('提前结清利率', '${data?.eryRate}%' ?? ''));
          _earlyRedTdList.add(_buildContentItem('提前结清利息', data?.eryInt ?? ''));
          _earlyRedTdList
              .add(_buildContentItem('手续费', f.format(data?.hdlFee) ?? ''));
          _earlyRedTdList
              .add(_buildContentItem('罚金', f.format(data?.pnltFee) ?? ''));
          _earlyRedTdList.add(
            Padding(padding: EdgeInsets.only(top: 15)),
          );
          _earlyRedTdList.add(_buildTitle('结算信息'));
          _earlyRedTdList.add(_buildContentItem('结算账号', data?.settDdAc ?? ''));
          _earlyRedTdList.add(_buildContentItem('结算金额', data?.settBal ?? ''));
        });
      }
    }
    // oneToOneTransferApproval - 行内转账
    else if (_processKey == 'oneToOneTransferApproval') {
      OneToOneModel.OneToOneTransferDetailModel oneToOneTransferDetailModel =
          OneToOneModel.OneToOneTransferDetailModel.fromJson(_contractModel);
      OneToOneModel.OperateEndValue data =
          oneToOneTransferDetailModel.operateEndValue;
      if (this.mounted) {
        setState(() {
          _oneToOneList.add(_buildTitle('收款信息'));
          _oneToOneList.add(_buildContentItem('账号', data?.payeeCardNo ?? ''));
          _oneToOneList.add(_buildContentItem('账户名称', data?.payeeName ?? ''));
          _oneToOneList
              .add(_buildContentItem('货币', data?.creditCurrency ?? ''));
          _oneToOneList
              .add(_buildContentItem('金额', f.format(data?.amount) ?? ''));
          _oneToOneList
              .add(_buildContentItem('参考汇率', data?.exchangeRate ?? ''));
          _oneToOneList.add(
            Padding(padding: EdgeInsets.only(top: 15)),
          );
          _oneToOneList.add(_buildTitle('付款信息'));
          _oneToOneList.add(_buildContentItem('账号', data?.payerCardNo ?? ''));
          _oneToOneList.add(_buildContentItem('账户名称', data?.payerName ?? ''));
          _oneToOneList.add(_buildContentItem('货币', data?.debitCurrency ?? ''));
          _oneToOneList
              .add(_buildContentItem('金额', f.format(data?.amount) ?? ''));
          _oneToOneList.add(_buildContentItem('附言', data?.remark ?? ''));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _processKey = widget.data.processKey;
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
              children: [
                Padding(padding: EdgeInsets.only(top: 15)),
                if (_processKey == 'openTdContractApproval') ..._openTdList,
                if (_processKey == 'earlyRedTdContractApproval')
                  ..._earlyRedTdList,
                if (_processKey == 'oneToOneTransferApproval') ..._oneToOneList,
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
                text: Text(
                  S.current.reject_to_sponsor,
                  style: TextStyle(color: Color(0xff3394D4), fontSize: 14.0),
                ),
                clickCallback: () {
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
                text: Text(
                  S.current.reject,
                  style: TextStyle(color: Color(0xff3394D4), fontSize: 14.0),
                ),
                clickCallback: () {
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
                text: Text(
                  S.current.approval_unlock,
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                clickCallback: () {
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
              text: Text(
                S.current.approval_lock,
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
              clickCallback: () {
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
