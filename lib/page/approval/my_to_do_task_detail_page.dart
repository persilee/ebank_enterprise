/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29
import 'package:dio/dio.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/complete_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_all_finished_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/find_task_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_todo_task_detail_body.dart';
import 'package:ebank_mobile/data/source/model/approval/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/approval/international_transfer_detail_model.dart'
    as InternationalModel;
import 'package:ebank_mobile/data/source/model/approval/transfer_plan_detail_model.dart'
    as TransferPlanModel;
import 'package:ebank_mobile/data/source/model/approval/early_red_td_contract_detail_model.dart'
    as EarlyRedModel;
import 'package:ebank_mobile/data/source/model/approval/one_to_one_transfer_detail_model.dart'
    as OneToOneModel;
import 'package:ebank_mobile/data/source/model/approval/open_td_contract_detail_model.dart'
    as OpenTDModel;
import 'package:ebank_mobile/data/source/model/approval/foreign_transfer_model.dart'
    as ForeignTransferModel;
import 'package:ebank_mobile/data/source/model/approval/post_repayment_model.dart'
    as PostRepaymentModel;
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/hsg_text_field_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

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
  bool _btnIsLoadingRTS = false; // 驳回至发起人按钮
  bool _btnIsLoadingR = false; // 驳回按钮
  bool _btnIsLoadingUN = false; // 解锁按钮
  bool _btnIsLoadingL = false; // 锁定按钮
  bool _btnIsLoadingEAA = false; // 审批按钮
  bool _btnIsEnable = true;
  List<Widget> _openTdList = [];
  List<Widget> _earlyRedTdList = [];
  List<Widget> _oneToOneList = [];
  List<Widget> _internationalList = [];
  List<Widget> _transferPlanList = [];
  List<Widget> _foreignTransferList = [];
  List<Widget> _postRepaymentList = [];
  List<Widget> _finishedList = [];
  final f = NumberFormat("#,##0.00", "en_US");
  final fj = NumberFormat("#,##0", "ja-JP");

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
      // foreignTransferApproval - 外汇买卖
      else if (_processKey == 'foreignTransferApproval') {
        _loadForeignTransferData(_contractModel);
      }
      // postRepaymentApproval - 提前还款
      else if (_processKey == 'postRepaymentApproval') {
        _loadPostRepaymentData(_contractModel);
      }
    } catch (e) {
      print('error: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // postRepaymentApproval  - 提前还款
  void _loadPostRepaymentData(_contractModel) {
    PostRepaymentModel.PostRepaymentModel postRepaymentModel =
        PostRepaymentModel.PostRepaymentModel.fromJson(_contractModel);

    PostRepaymentModel.OperateEndValue data =
        postRepaymentModel.operateEndValue;

    // 添加历史审批记录
    if (postRepaymentModel.commentList.isNotEmpty) {
      postRepaymentModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _postRepaymentList.add(_buildTitle(S.current.approve_loan_information));
        _postRepaymentList.add(_buildContentItem(S.current.approve_loan_account, data?.acNo ?? ''));
        _postRepaymentList.add(_buildContentItem(S.current.approve_loan_currency, data?.ccy ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_loan_principal,
            // 处理日元没有小数
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.prin ?? '0')) ?? ''
                : f.format(double.parse(data?.prin ?? '0')) ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_loan_balance,
            // 处理日元没有小数
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.outBal ?? '0')) ?? ''
                : f.format(double.parse(data?.outBal ?? '0')) ?? ''));
        _postRepaymentList.add(_buildContentItem(S.current.approve_loan_interest_rate, data?.exRate ?? ''));
        _postRepaymentList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _postRepaymentList.add(_buildTitle(S.current.approve_loan_payment_information));
        _postRepaymentList.add(_buildContentItem(S.current.approve_debit_account, data?.ddAc ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_repayment_principal,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.principalAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.principalAmount ?? '0')) ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_repayment_interest,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.interestAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.interestAmount ?? '0')) ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_fine_amount,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.penaltyAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.penaltyAmount ?? '0')) ?? ''));
        _postRepaymentList.add(_buildContentItem(
            S.current.approve_reimbursement_amount,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.totalAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.totalAmount ?? '0')) ?? ''));
        _isLoading = false;
      });
    }
  }

  // foreignTransferApproval - 外汇买卖
  void _loadForeignTransferData(_contractModel) {
    ForeignTransferModel.ForeignTransferModel foreignTransferModel =
        ForeignTransferModel.ForeignTransferModel.fromJson(_contractModel);

    ForeignTransferModel.OperateEndValue data =
        foreignTransferModel.operateEndValue;

    // 添加历史审批记录
    if (foreignTransferModel.commentList.isNotEmpty) {
      foreignTransferModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _foreignTransferList
            .add(_buildTitle(S.current.approve_foreign_exchange_information));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_debit_account_f, data?.buyDac ?? ''));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_debit_currency, data?.buyCcy ?? ''));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_debit_amount,
            // 处理日元没有小数
            data?.buyCcy == 'JPY'
                ? fj.format(double.parse(data?.buyAmt ?? '0')) ?? ''
                : f.format(double.parse(data?.buyAmt ?? '0')) ?? ''));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_credit_account, data?.sellDac ?? ''));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_credit_currency, data?.sellCcy ?? ''));
        _foreignTransferList.add(_buildContentItem(
            S.current.approve_credit_amount,
            data?.buyCcy == 'JPY'
                ? fj.format(double.parse(data?.sellAmt ?? '0')) ?? ''
                : f.format(double.parse(data?.sellAmt ?? '0')) ?? ''));
        _foreignTransferList.add(
            _buildContentItem(S.current.rate_of_exchange, data?.exRate ?? ''));
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

    // 添加历史审批记录
    if (transferPlanDetailModel.commentList.isNotEmpty) {
      transferPlanDetailModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _transferPlanList
            .add(_buildTitle(S.current.approve_project_information));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_project_name, data?.planName ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_appointment_frequency, data?.frequency ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_first_transfer_time, data?.startDate ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_as_of_date, data?.endDate ?? ''));
        _transferPlanList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _transferPlanList
            .add(_buildTitle(S.current.approve_gathering_information));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_account, data?.payeeCardNo ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_name_account, data?.payeeName ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_currency, data?.creditCurrency ?? ''));
        _transferPlanList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _transferPlanList
            .add(_buildTitle(S.current.approve_payment_information));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_account, data?.payerCardNo ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_name_account, data?.payerName ?? ''));
        _transferPlanList.add(_buildContentItem(
            S.current.approve_currency, data?.debitCurrency ?? ''));
        _transferPlanList.add(_buildContentItem(S.current.approve_amount,
            f.format(double.parse(data?.amount ?? '0')) ?? ''));
        _transferPlanList.add(
            _buildContentItem(S.current.approve_remark, data?.remark ?? ''));
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

    // 添加历史审批记录
    if (internationalTransferDetailModel.commentList.isNotEmpty) {
      internationalTransferDetailModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _internationalList
            .add(_buildTitle(S.current.approve_gathering_information));
        _internationalList.add(_buildContentItem(
            S.current.approve_account, data?.payeeCardNo ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_name_account, data?.payeeName ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_currency, data?.creditCurrency ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_amount,
            data?.creditCurrency == 'JPY'
                ? fj.format(double.parse(data?.creditAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.creditAmount ?? '0')) ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_reference_rate, data?.exchangeRate ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_country_region, data?.district ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_swift_code, data?.bankSwift ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_collecting_bank, data?.payeeBankCode ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_collection_address, data?.payeeAddress ?? ''));
        _internationalList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _internationalList
            .add(_buildTitle(S.current.approve_payment_information));
        _internationalList.add(_buildContentItem(
            S.current.approve_account, data?.payerCardNo ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_name_account, data?.payerName ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_currency, data?.debitCurrency ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_amount,
            data?.debitCurrency == 'JPY'
                ? fj.format(double.parse(data?.debitAmount ?? '0'))
                : f.format(double.parse(data?.debitAmount ?? '0')) ?? ''));
        _internationalList.add(_buildContentItem(
            S.current.approve_payment_method, data?.costOptions ?? ''));
        _internationalList.add(
            _buildContentItem(S.current.approve_remark, data?.remark ?? ''));
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

    // 添加历史审批记录
    if (oneToOneTransferDetailModel.commentList.isNotEmpty) {
      oneToOneTransferDetailModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _oneToOneList.add(_buildTitle(S.current.approve_gathering_information));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_account, data?.payeeCardNo ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_currency, data?.creditCurrency ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_amount,
            data?.creditCurrency == 'JPY'
                ? fj.format(double.parse(data?.creditAmount ?? '0')) ?? ''
                : f.format(double.parse(data?.creditAmount ?? '0')) ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_reference_rate, data?.exchangeRate ?? ''));
        _oneToOneList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _oneToOneList.add(_buildTitle(S.current.approve_payment_information));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_account, data?.payerCardNo ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_name_account, data?.payerName ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_currency, data?.debitCurrency ?? ''));
        _oneToOneList.add(_buildContentItem(
            S.current.approve_amount,
            data?.creditCurrency == 'JPY'
                ? fj.format(double.parse(data?.debitAmount)) ?? ''
                : f.format(double.parse(data?.debitAmount)) ?? ''));
        _oneToOneList.add(
            _buildContentItem(S.current.approve_remark, data?.remark ?? ''));
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

    // 添加历史审批记录
    if (earlyRedTdContractDetailModel.commentList.isNotEmpty) {
      earlyRedTdContractDetailModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _earlyRedTdList.add(_buildTitle(S.current.approve_basic_information));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_contract_no, data?.conNo ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_certificates_deposit_amount,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.bal ?? '0')) ?? ''
                : f.format(double.parse(data?.bal ?? '0')) ?? ''));
        _earlyRedTdList.add(
            _buildContentItem(S.current.approve_currency, data?.ccy ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_deposit_term, data?.tenor ?? ''));
        _earlyRedTdList.add(
            _buildContentItem(S.current.approve_state, data?.status ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_effective_date, data?.valueDate ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_maturity_date, data?.dueDate ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_settle_the_principal_amount, data?.matAmt ?? ''));
        _earlyRedTdList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _earlyRedTdList.add(_buildTitle(S.current.approve_trial_information));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_prepay_interest_rate, '${data?.eryRate}%' ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_prepay_interest, data?.eryInt ?? ''));
        _earlyRedTdList.add(_buildContentItem(S.current.approve_poundage,
            f.format(double.parse(data?.hdlFee ?? '0')) ?? ''));
        _earlyRedTdList.add(_buildContentItem(S.current.approve_penalty,
            f.format(double.parse(data?.pnltFee ?? '0')) ?? ''));
        _earlyRedTdList.add(
          Padding(padding: EdgeInsets.only(top: 15)),
        );
        _earlyRedTdList.add(_buildTitle(S.current.approve_billing_info));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_settlement_account, data?.settDdAc ?? ''));
        _earlyRedTdList.add(_buildContentItem(
            S.current.approve_settlement_amount, data?.settBal ?? ''));
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

    // 添加历史审批记录
    if (openTdContractDetailModel.commentList.isNotEmpty) {
      openTdContractDetailModel.commentList.forEach((data) {
        // 暂时 commentList 都为空，里面的具体字段不明
        // _finishedList.add(_buildAvatar('',''));
      });
    }

    if (this.mounted) {
      setState(() {
        _openTdList.add(_buildTitle(S.current.approve_basic_information));
        _openTdList.add(
            _buildContentItem(S.current.approve_product, data?.prodName ?? ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_terms_of_deposit, data?.tenor ?? ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_amount,
            data?.ccy == 'JPY'
                ? fj.format(double.parse(data?.bal ?? '0')) ?? ''
                : f.format(double.parse(data?.bal ?? '0')) ?? ''));
        _openTdList.add(_buildContentItem(S.current.approve_interest_rate, ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_certificates_deposit_money, data?.ccy ?? ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_maturity_instructions, data?.instCode ?? ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_settlement_account, data?.settDdAc ?? ''));
        _openTdList.add(_buildContentItem(
            S.current.approve_debit_account, data?.oppAc ?? ''));
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
        title: Text(S.current.approve_task_approval_title),
        elevation: 0,
      ),
      body: _isLoading
          ? HsgLoading()
          : SingleChildScrollView(
              controller: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 提示
                  _tips(),
                  // 根据processKey动态显示 任务详情
                  _buildTaskDetail(_processKey),
                  // 审批历史
                  if (_finishedList.length > 0) _buildHistoryTask(context),
                  // 我的审批
                  _myApproval(context),
                ],
              ),
            ),
    );
  }

  Column _buildTaskDetail(String _processKey) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: EdgeInsets.only(top: 15)),
        if (_processKey == 'openTdContractApproval') ..._openTdList,
        if (_processKey == 'earlyRedTdContractApproval') ..._earlyRedTdList,
        if (_processKey == 'oneToOneTransferApproval') ..._oneToOneList,
        if (_processKey == 'internationalTransferApproval')
          ..._internationalList,
        if (_processKey == 'transferPlanApproval') ..._transferPlanList,
        if (_processKey == 'foreignTransferApproval') ..._foreignTransferList,
        if (_processKey == 'postRepaymentApproval') ..._postRepaymentList,
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
        child: _buildHistoryItem(S.current.approve_approval_history, true),
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
            title: S.current.prompt,
            message: S.current.approve_input_approval_comments,
            positiveButton: S.current.confirm,
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
            // Expanded(
            //   flex: 2,
            //   child: CustomButton(
            //     isLoading: _btnIsLoadingRTS,
            //     isEnable: _btnIsEnable,
            //     isOutline: true,
            //     margin: EdgeInsets.all(0),
            //     text: Text(
            //       S.current.reject_to_sponsor,
            //       style: TextStyle(
            //           color: _btnIsEnable ? Color(0xff3394D4) : Colors.grey,
            //           fontSize: 14.0),
            //     ),
            //     clickCallback: () {
            //       if (_comment.length != 0) {
            //         _rejectToStartTask();
            //       } else {
            //         _alertDialog();
            //       }
            //     },
            //   ),
            // ),
            // Padding(padding: EdgeInsets.only(left: 10)),
            // 驳回按钮
            Expanded(
              flex: 1,
              child: CustomButton(
                isLoading: _btnIsLoadingR,
                isEnable: _btnIsEnable,
                isOutline: true,
                margin: EdgeInsets.all(0),
                text: Text(
                  S.current.reject,
                  style: TextStyle(
                      color: _btnIsEnable ? Color(0xff3394D4) : Colors.grey,
                      fontSize: 14.0),
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
                isLoading: _btnIsLoadingUN,
                isEnable: _btnIsEnable,
                margin: EdgeInsets.all(0),
                text: Text(
                  S.current.approval_unlock,
                  style: TextStyle(
                      color: _btnIsEnable ? Colors.white : Colors.grey,
                      fontSize: 14.0),
                ),
                clickCallback: () {
                  _doUnclaimTask();
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
              isLoading: _btnIsLoadingL,
              isEnable: _btnIsEnable,
              margin: EdgeInsets.all(0),
              text: Text(
                S.current.approval_lock,
                style: TextStyle(
                    color: _btnIsEnable ? Colors.white : Colors.grey,
                    fontSize: 14.0),
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
              ? Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isLoading: _btnIsLoadingEAA,
                        isEnable: _btnIsEnable,
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
                      ),
                    ),
                  ],
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
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 13.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 13.0, color: Color(int.parse('0xff7A7A7A'))),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
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
    if (this.mounted) {
      setState(() {
        _btnIsLoadingL = true;
        _btnIsEnable = false;
      });
    }
    try {
      await ApiClient().doClaimTask(FindTaskBody(taskId: widget.data.taskId));
      if (this.mounted) {
        setState(() {
          _btnIsLoadingL = false;
          _btnIsEnable = true;
        });
      }
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
    if (this.mounted) {
      setState(() {
        _btnIsLoadingUN = true;
        _btnIsEnable = false;
      });
    }
    try {
      await ApiClient().doUnclaimTask(FindTaskBody(taskId: widget.data.taskId));
      if (this.mounted) {
        setState(() {
          _btnIsLoadingUN = false;
          _btnIsEnable = true;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  // 驳回
  void _rejectTask() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgTipsDialog(
            child: Text(S.current.approve_reject_tip),
            confirmCallback: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context);
              _rejectTaskConfirm();
            },
          );
        });
  }

  // 驳回逻辑
  void _rejectTaskConfirm() async {
    if (this.mounted) {
      setState(() {
        _btnIsLoadingR = true;
        _btnIsEnable = false;
      });
    }
    try {
      await ApiClient().completeTask(
        CompleteTaskBody(
          approveResult: false,
          comment: _comment,
          rejectToStart: false,
          taskId: widget.data.taskId,
        ),
      );
      if (this.mounted) {
        setState(() {
          _btnIsLoadingR = false;
          _btnIsEnable = true;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  // 驳回至发起人
  void _rejectToStartTask() async {
    showDialog(
        context: context,
        builder: (context) {
          return HsgTipsDialog(
            child: Text(S.current.approve_reject_to_start_tip),
            confirmCallback: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context);
              _rejectToStartTaskConfirm();
            },
          );
        });
  }

  // 驳回至发起人逻辑
  void _rejectToStartTaskConfirm() async {
    if (this.mounted) {
      setState(() {
        _btnIsLoadingRTS = true;
        _btnIsEnable = false;
      });
    }
    try {
      await ApiClient().completeTask(
        CompleteTaskBody(
          approveResult: false,
          comment: _comment,
          rejectToStart: true,
          taskId: widget.data.taskId,
        ),
      );
      if (this.mounted) {
        setState(() {
          _btnIsLoadingRTS = false;
          _btnIsEnable = true;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  //交易密码窗口
  Future<bool> _openBottomSheet() async {
    final isPassword = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgPasswordDialog(
            title: S.current.input_password,
            isDialog: false,
          );
        });
    if (isPassword != null && isPassword == true) {
      return true;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return false;
  }

  // 完成任务
  void _completeTask() async {
    print(
        'USER_PASSWORDENABLED: ${SpUtil.getBool(ConfigKey.USER_PASSWORDENABLED)}');
    bool passwordEnabled = SpUtil.getBool(ConfigKey.USER_PASSWORDENABLED);
    // 判断是否设置交易密码，如果没有设置，跳转到设置密码页面，
    // 否则，输入交易密码
    if (!passwordEnabled) {
      HsgShowTip.shouldSetTranPasswordTip(
        context: context,
        click: (value) {
          if (value == true) {
            //前往设置交易密码
            Navigator.pushNamed(context, pageResetPayPwdOtp);
          }
        },
      );
    } else {
      // 输入交易密码
      bool isPassword = await _openBottomSheet();
      // 如果交易密码正确，处理审批逻辑
      if (isPassword) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (this.mounted) {
          setState(() {
            _btnIsLoadingEAA = true;
            _btnIsEnable = false;
          });
        }
        try {
          // 请求审批接口
          var data = await ApiClient().completeTask(
            CompleteTaskBody(
              approveResult: true,
              comment: _comment,
              taskId: widget.data.taskId,
            ),
          );
          if (this.mounted) {
            setState(() {
              _btnIsLoadingEAA = false;
              _btnIsEnable = true;
            });
            Navigator.pushReplacementNamed(context, pageDepositRecordSucceed);
          }
        } catch (e) {
          print(e);
          setState(() {
            _btnIsLoadingEAA = false;
            _btnIsEnable = true;
          });
          Fluttertoast.showToast(
            msg: e.toString(),
            gravity: ToastGravity.CENTER,
          );
        }
      }
    }
  }
}
