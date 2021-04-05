/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29

import 'package:dio/dio.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_model.dart';
import 'package:ebank_mobile/data/source/model/early_red_td_contract_detail_model.dart'
    as EarlyRedModel;
import 'package:ebank_mobile/data/source/model/approval/find_all_finished_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/international_transfer_detail_model.dart'
    as InternationalModel;
import 'package:ebank_mobile/data/source/model/one_to_one_transfer_detail_model.dart'
    as OneToOneModel;
import 'package:ebank_mobile/data/source/model/open_td_contract_detail_model.dart'
    as OpenTDModel;
import 'package:ebank_mobile/data/source/model/approval/transfer_plan_detail_model.dart'
    as TransferPlanModel;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class MyToDoTaskDetailPage extends StatefulWidget {
  final ApprovalTask data;
  final String title;

  MyToDoTaskDetailPage({Key key, this.data, this.title}) : super(key: key);

  @override
  _MyToDoTaskDetailPageState createState() => _MyToDoTaskDetailPageState();
}

class _MyToDoTaskDetailPageState extends State<MyToDoTaskDetailPage> {
  ScrollController _controller;
  String _comment = '';
  bool _offstage = true;
  bool _isLoading = false;
  List<Widget> _openTdList = [];
  List<Widget> _earlyRedTdList = [];
  List<Widget> _oneToOneList = [];
  List<Widget> _internationalList = [];
  List<Widget> _transferPlanList = [];
  List<Widget> _finishedList = [];
  final f = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _loadData() async {
    _isLoading = true;
    String _processKey = widget.data.processKey;
    String _taskId = widget.data.taskId;
    var _contractModel;
    try {
      // 请求任务详情接口
      _contractModel = await ApiClient().findToDoTaskDetail(
          FindTodoTaskDetailBody(processId: widget.data.processId));

      // 根据任务id请求该任务的审批历史
      FindAllFinishedTaskModel _allFinishedTaskModel =
          await ApiClient().findAllFinishedTask(
        FindTaskBody(
          page: 1,
          pageSize: 6,
          tenantId: 'EB',
          custId: '818000000113',
          taskId: _taskId,
        ),
      );
      _allFinishedTaskModel.rows.forEach((data) {
        _finishedList.add(_buildAvatar(
          'https://api.lishaoy.net/files/22/serve?size=medium',
          data.applicantName,
        ));
      });

      // openTdContractApproval - 开立定期存单
      if (_processKey == 'openTdContractApproval') {
        _loadOpenTdData(_contractModel);
      }
      //earlyRedTdContractApproval - 定期提前结清
      else if (_processKey == 'earlyRedTdContractApproval') {
        _loadEarlyRedData(_contractModel);
      }
      // oneToOneTransferApproval - 行内转账
      else if (_processKey == 'oneToOneTransferApproval') {
        _loadOneToOneData(_contractModel);
      }
      // internationalTransferApproval - 国际汇款
      else if (_processKey == 'internationalTransferApproval') {
        _loadInternationalData(_contractModel);
      }
      // transferPlanApproval - 预约转账
      else if (_processKey == 'transferPlanApproval') {
        _loadTransferPlanData(_contractModel);
      }
    } catch (e) {
      if ((e as DioError).error is NeedLogin) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return LoginPage();
        }), (Route route) {
          print(route.settings?.name);
          return true;
        });
      } else {
        print('error: ${e.toString()}');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  // transferPlanApproval - 预约转账
  void _loadTransferPlanData(_contractModel) {
    TransferPlanModel.TransferPlanDetailModel transferPlanDetailModel =
        TransferPlanModel.TransferPlanDetailModel.fromJson(_contractModel);
    TransferPlanModel.OperateEndValue data =
        transferPlanDetailModel.operateEndValue;
    if (this.mounted) {
      setState(() {
        _transferPlanList.add(_buildTitle('计划信息'));
        _transferPlanList.add(_buildContentItem('计划名称', data?.planName ?? ''));
        _transferPlanList.add(_buildContentItem('预约频率', data?.frequency ?? ''));
        _transferPlanList
            .add(_buildContentItem('首次转账时间', data?.startDate ?? ''));
        _transferPlanList.add(_buildContentItem('截止日期', data?.endDate ?? ''));
        _transferPlanList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _transferPlanList.add(_buildTitle('收款信息'));
        _transferPlanList.add(_buildContentItem('账号', data?.payeeCardNo ?? ''));
        _transferPlanList.add(_buildContentItem('账户名称', data?.payeeName ?? ''));
        _transferPlanList
            .add(_buildContentItem('货币', data?.creditCurrency ?? ''));
        _transferPlanList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _transferPlanList.add(_buildTitle('付款信息'));
        _transferPlanList.add(_buildContentItem('账号', data?.payerCardNo ?? ''));
        _transferPlanList.add(_buildContentItem('账户名称', data?.payerName ?? ''));
        _transferPlanList
            .add(_buildContentItem('货币', data?.debitCurrency ?? ''));
        _transferPlanList.add(_buildContentItem(
            '金额', f.format(double.parse(data?.amount)) ?? ''));
        _transferPlanList.add(_buildContentItem('附言', data?.remark ?? ''));
        _isLoading = false;
      });
    }
  }

  // internationalTransferApproval - 国际汇款
  void _loadInternationalData(_contractModel) {
    InternationalModel.InternationalTransferDetailModel
        internationalTransferDetailModel =
        InternationalModel.InternationalTransferDetailModel.fromJson(
            _contractModel);
    InternationalModel.OperateEndValue data =
        internationalTransferDetailModel.operateEndValue;
    if (this.mounted) {
      setState(() {
        _internationalList.add(_buildTitle('收款信息'));
        _internationalList
            .add(_buildContentItem('账号', data?.payeeCardNo ?? ''));
        _internationalList
            .add(_buildContentItem('账户名称', data?.payeeName ?? ''));
        _internationalList
            .add(_buildContentItem('货币', data?.creditCurrency ?? ''));
        _internationalList.add(_buildContentItem(
            '金额',
            f.format(double.parse(data?.amount) *
                    double.parse(data?.exchangeRate)) ??
                ''));
        _internationalList
            .add(_buildContentItem('参考汇率', data?.exchangeRate ?? ''));
        _internationalList
            .add(_buildContentItem('国家/地区', data?.district ?? ''));
        _internationalList
            .add(_buildContentItem('SWIFT Code', data?.bankSwift ?? ''));
        _internationalList
            .add(_buildContentItem('收款银行', data?.payeeBankCode ?? ''));
        _internationalList
            .add(_buildContentItem('收款地址', data?.payeeAddress ?? ''));
        _internationalList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _internationalList.add(_buildTitle('付款信息'));
        _internationalList
            .add(_buildContentItem('账号', data?.payerCardNo ?? ''));
        _internationalList
            .add(_buildContentItem('账户名称', data?.payerName ?? ''));
        _internationalList
            .add(_buildContentItem('货币', data?.debitCurrency ?? ''));
        _internationalList.add(_buildContentItem(
            '金额', f.format(double.parse(data?.amount)) ?? ''));
        _internationalList
            .add(_buildContentItem('手续费支付方式', data?.costOptions ?? ''));
        _internationalList.add(_buildContentItem('附言', data?.remark ?? ''));
        _isLoading = false;
      });
    }
  }

  // oneToOneTransferApproval - 行内转账
  void _loadOneToOneData(_contractModel) {
    OneToOneModel.OneToOneTransferDetailModel oneToOneTransferDetailModel =
        OneToOneModel.OneToOneTransferDetailModel.fromJson(_contractModel);
    OneToOneModel.OperateEndValue data =
        oneToOneTransferDetailModel.operateEndValue;
    if (this.mounted) {
      setState(() {
        _oneToOneList.add(_buildTitle('收款信息'));
        _oneToOneList.add(_buildContentItem('账号', data?.payeeCardNo ?? ''));
        _oneToOneList.add(_buildContentItem('账户名称', data?.payeeName ?? ''));
        _oneToOneList.add(_buildContentItem('货币', data?.creditCurrency ?? ''));
        _oneToOneList.add(_buildContentItem(
            '金额',
            f.format(double.parse(data?.amount) *
                    double.parse(data?.exchangeRate)) ??
                ''));
        _oneToOneList.add(_buildContentItem('参考汇率', data?.exchangeRate ?? ''));
        _oneToOneList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _oneToOneList.add(_buildTitle('付款信息'));
        _oneToOneList.add(_buildContentItem('账号', data?.payerCardNo ?? ''));
        _oneToOneList.add(_buildContentItem('账户名称', data?.payerName ?? ''));
        _oneToOneList.add(_buildContentItem('货币', data?.debitCurrency ?? ''));
        _oneToOneList.add(_buildContentItem(
            '金额', f.format(double.parse(data?.amount)) ?? ''));
        _oneToOneList.add(_buildContentItem('附言', data?.remark ?? ''));
        _isLoading = false;
      });
    }
  }

  // earlyRedTdContractApproval - 定期提前结清
  void _loadEarlyRedData(_contractModel) {
    EarlyRedModel.EarlyRedTdContractDetailModel earlyRedTdContractDetailModel =
        EarlyRedModel.EarlyRedTdContractDetailModel.fromJson(_contractModel);
    EarlyRedModel.OperateEndValue data =
        earlyRedTdContractDetailModel.operateEndValue;
    if (this.mounted) {
      setState(() {
        _earlyRedTdList.add(_buildTitle('基本信息'));
        _earlyRedTdList.add(_buildContentItem('合约号', data?.conNo ?? ''));
        _earlyRedTdList.add(
            _buildContentItem('存单金额', f.format(double.parse(data?.bal)) ?? ''));
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
        _earlyRedTdList.add(_buildContentItem(
            '手续费', f.format(double.parse(data?.hdlFee)) ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            '罚金', f.format(double.parse(data?.pnltFee)) ?? ''));
        _earlyRedTdList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _earlyRedTdList.add(_buildTitle('结算信息'));
        _earlyRedTdList.add(_buildContentItem('结算账号', data?.settDdAc ?? ''));
        _earlyRedTdList.add(_buildContentItem('结算金额', data?.settBal ?? ''));
        _isLoading = false;
      });
    }
  }

  // openTdContractApproval - 开立定期存单
  void _loadOpenTdData(_contractModel) {
    OpenTDModel.OpenTdContractDetailModel openTdContractDetailModel =
        OpenTDModel.OpenTdContractDetailModel.fromJson(_contractModel);
    OpenTDModel.OperateEndValue data =
        openTdContractDetailModel?.operateEndValue;
    if (this.mounted) {
      setState(() {
        _openTdList.add(_buildTitle('基本信息'));
        _openTdList.add(_buildContentItem('产品', data?.prodName ?? ''));
        _openTdList.add(_buildContentItem('存款期限', data?.tenor ?? ''));
        _openTdList.add(
            _buildContentItem('金额', f.format(double.parse(data?.bal)) ?? ''));
        _openTdList.add(_buildContentItem('年利率', ''));
        _openTdList.add(_buildContentItem('存单货币', data?.ccy ?? ''));
        _openTdList.add(_buildContentItem('到期指示', data?.instCode ?? ''));
        _openTdList.add(_buildContentItem('结算账户', data?.settDdAc ?? ''));
        _openTdList.add(_buildContentItem('扣款账户', data?.oppAc ?? ''));
        _isLoading = false;
      });
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
      body: _isLoading
          ? HsgLoading()
          : SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  //提示
                  _tips(),
                  // 根据processKey动态显示 任务详情
                  _buildTaskDetail(_processKey),
                  // 审批历史
                  if (_finishedList.length > 0) _buildHistoryTask(context),
                  //我的审批
                  _myApproval(context),
                ],
              ),
            ),
    );
  }

  Column _buildTaskDetail(String _processKey) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 15)),
        if (_processKey == 'openTdContractApproval') ..._openTdList,
        if (_processKey == 'earlyRedTdContractApproval') ..._earlyRedTdList,
        if (_processKey == 'oneToOneTransferApproval') ..._oneToOneList,
        if (_processKey == 'internationalTransferApproval') ..._internationalList,
        if (_processKey == 'transferPlanApproval') ..._transferPlanList,
      ],
    );
  }

  Widget _buildHistoryTask(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context, pageAuthorizationTaskApprovalHistoryDetail);
        },
        child: _buildHistoryItem('审批历史', true),
      ),
    );
  }

  //签收按钮被点击时改变offstage
  void _toggle() {
    setState(() {
      _offstage = !_offstage;
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
        maxLines: 4,
        enabled: !_offstage,
        decoration: InputDecoration(
          fillColor: Color(0xffF7F7F7),
          filled: _offstage,
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
          _comment = value;
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
    if (!_offstage) {
      return Container(
        child: Row(
          children: [
            // 驳回至发起人按钮
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
                  if (_comment.length != 0) {
                    _rejectToStartTask();
                  } else {
                    _alertDialog();
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            // 驳回按钮
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
                  if (_comment.length != 0) {
                    _rejectTask();
                  } else {
                    _alertDialog();
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            // 解锁按钮
            Expanded(
              flex: 1,
              child: CustomButton(
                margin: EdgeInsets.all(0),
                text: Text(
                  S.current.approval_unlock,
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                clickCallback: () {
                  if (_comment.length != 0) {
                    _doUnclaimTask();
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
      // 锁定按钮
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
                // 认领任务
                _doClaimTask();
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
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          _buildTitle(S.current.my_approval),
          Container(
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
          _approvalComments(),
          //审批意见输入框
          _inputApprovalComments(),
          //底部按钮
          _button(),
          !_offstage
              ? CustomButton(
                  clickCallback: () {
                    if (_comment.length != 0) {
                      _completeTask();
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
          !_offstage
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
                            ..._finishedList,
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
                child: Image(
                  image: AssetImage(
                      'images/home/heaerIcon/home_header_person.png'),
                  fit: BoxFit.cover,
                  height: 22.0,
                  width: 22.0,
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

  // 认领任务
  void _doClaimTask() async {
    try {
      await ApiClient().doClaimTask(FindTaskBody(taskId: widget.data.taskId));
      _toggle();
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  // 取消认领任务
  void _doUnclaimTask() async {
    try {
      await ApiClient().doUnclaimTask(FindTaskBody(taskId: widget.data.taskId));
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  // 驳回
  void _rejectTask() async {
    try {
      CompleteTaskModel completeTaskModel = await ApiClient().completeTask(
        CompleteTaskBody(
          approveResult: false,
          comment: _comment,
          rejectToStart: false,
          taskId: widget.data.taskId,
        ),
      );
      if(completeTaskModel.msgCd == '0000') {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  // 驳回至发起人
  void _rejectToStartTask() async {
    try {
      CompleteTaskModel completeTaskModel = await ApiClient().completeTask(
        CompleteTaskBody(
          approveResult: false,
          comment: _comment,
          rejectToStart: true,
          taskId: widget.data.taskId,
        ),
      );
      if(completeTaskModel.msgCd == '0000') {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  // 完成任务
  void _completeTask() async {
    try {
      CompleteTaskModel completeTaskModel = await ApiClient().completeTask(
        CompleteTaskBody(
          approveResult: true,
          comment: _comment,
          rejectToStart: false,
          taskId: widget.data.taskId,
        ),
      );
      if(completeTaskModel.msgCd == '0000') {
        Navigator.pushReplacementNamed(
            context, pageDepositRecordSucceed,
            arguments: 'taskApproval');
      }
    } catch (e) {
      print(e);
    }
  }
}
