import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: longzhenqi
/// Date: 2021-05-18

import 'package:ebank_mobile/data/source/model/loan/get_loan_money_caculate.dart';
import 'package:ebank_mobile/data/source/model/loan/get_schedule_detail_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_detail_modelList.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class RepaymentPlanInputPage extends StatefulWidget {
  @override
  _RepaymentPlanInputState createState() => _RepaymentPlanInputState();
}

class _RepaymentPlanInputState extends State<RepaymentPlanInputPage> {
  LnAcMastAppDOList loanDetail; //合约帐号信息
  PostAdvanceRepaymentDTOList list; //利息计算信息
  GetLnAcScheduleRspDetlsDTOList planDetail; //还款计划信息

  Map message = new Map();
  double max = 0; //还款最大值(贷款余额)

  int _debit_Index = 0; //帐号索引
  List _totalAccoutList = []; //帐号列表

  var acNo = ''; //贷款账号
  var currency = ''; //币种
  var instalNo = ''; //贷款本金
  var loanInterest = ''; //贷款利率
  var _debitAccount = ''; //扣款账号
  var repayPrincipal = ''; //输入的还款金额
  var _repayInterest = ''; //还款利息
  var _fine = ''; //利息罚息
  var _principel = ''; //本金罚息
  var _totalRepay = ''; //还款总额

  var repaymentMethod = '';
  var rescheduleType = 'I';

  //创建文本控制器实例
  TextEditingController _inputController = new TextEditingController();
  FocusNode focusNode = FocusNode();

  //获取放款以及还款帐号列表
  Future<void> _loadTotalAccountData() async {
    HSProgressHUD.show();
    ApiClientAccount().getCardList(GetCardListReq()).then(
      (data) {
        HSProgressHUD.dismiss();
        if (data.cardList != null) {
          setState(() {
            _totalAccoutList.clear();
            _totalAccoutList.addAll(data.cardList);
            RemoteBankCard card = _totalAccoutList[0];
            _debitAccount = card.cardNo; //放款帐号
          });
        }
      },
    ).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTotalAccountData();
  }

  @override
  void dispose() {
    super.dispose();
    //释放
    focusNode.dispose();
  }

  //还款计划进入
  _planParameterSetValue() {
    currency = this.planDetail.ccy; //币种
    instalNo = this.planDetail.payPrin; //贷款本金
    loanInterest = this.planDetail.curRate + "%"; //贷款利率

    _repayInterest = this.planDetail.payInt; //还款利息
    _fine = this.planDetail.payCom; //利息罚息
    _principel = this.planDetail.payPen; //本金罚息
    _totalRepay = this.planDetail.payAmt; //还款总额
  }

  @override
  Widget build(BuildContext context) {
    Map mapDetail = ModalRoute.of(context).settings.arguments;
    //从还款计划进入
    GetLnAcScheduleRspDetlsDTOList detail = mapDetail['detailModel'];
    this.planDetail = detail;

    LnAcMastAppDOList loanDetails = mapDetail['loanDetail'];
    loanDetail = loanDetails;
    this.acNo = loanDetails.acNo; //贷款账号
    _planParameterSetValue();

    var container1 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //贷款账号
          _contentColumn(S.of(context).loan_account, acNo),
          //币种
          _contentColumn(S.of(context).currency, currency), //ccy
          //还款本金
          _contentColumn(S.of(context).loan_principal,
              FormatUtil.formatSringToMoney(instalNo)), //loanAmt
          //贷款利率
          _contentColumn(S.of(context).loan_interest_rate, loanInterest),
        ],
      ),
    );

    var container2 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //扣款账号
          SelectInkWell(
            title: S.current.debit_account,
            item: _debitAccount,
            onTap: () {
              _selectAccount();
            },
          ),
          //还款本金
          // _repayPrincipal(loanDetail),
          //还款利息
          _contentColumn(S.of(context).repayment_interest,
              FormatUtil.formatSringToMoney(_repayInterest)), //需要计算
          //本金罚金
          _contentColumn(S.of(context).loan_plan_principal_penalty,
              FormatUtil.formatSringToMoney(_principel)),
          //利息罚金
          _contentColumn(S.of(context).loan_plan_interest_payment,
              FormatUtil.formatSringToMoney(_fine)),
          //还款总额
          _contentColumn(S.of(context).total_repayment,
              FormatUtil.formatSringToMoney(_totalRepay)),
        ],
      ),
    );
    var btnNext = Padding(
      // 点击进入下一步
      padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
      child: RaisedButton(
        child: Text(
          S.of(context).next_step,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
        onPressed: _getBtnClickListener(context),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        color: Color(0xFF4871FF),
        disabledColor: HsgColors.btnDisabled,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repay_input),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            //贷款账号，币种，贷款本金，贷款余额，贷款利率
            container1,
            _getPadding(0, 13, 0, 0),
            //扣款账号，还款本金，还款利息，罚金，还款总额
            container2,
            btnNext, //点击下一步按钮
          ],
        ),
      ),
    );
  }

//付款账户弹窗
  _selectAccount() async {
    List<String> bankCards = [];
    List<String> accountNos = [];
    for (RemoteBankCard cards in _totalAccoutList) {
      //便利拿出帐号
      bankCards.add(cards.cardNo);
    }
    bankCards = bankCards.toSet().toList(); //去重复的数据
    for (var i = 0; i < bankCards.length; i++) {
      accountNos.add(FormatUtil.formatSpace4(bankCards[i]));
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.payment_account,
            items: accountNos,
            lastSelectedPosition: _debit_Index));
    if (result != null && result != false) {
      setState(() {
        //帐号
        _debitAccount = bankCards[result];
        // loanDetail.repaymentAcNo = bankCards[result]; //给模型赋值
        _debit_Index = result;
        // _isButton = true;
        // _checkBtnIsClick();
      });
    } else {
      return;
    }
  }

  //点击进入下一步
  _getBtnClickListener(BuildContext context) {
    return () {
      //修改信息map里的信息
      Map detailMap = Map();
      detailMap['detailModel'] = planDetail;
      detailMap['loanDetail'] = loanDetail;
      detailMap['debitAcc'] = _debitAccount;
      Navigator.pushNamed(context, pageRepaymentInputConfirm,
          arguments: detailMap);
    };
  }

  //直接删除多余的小数(不四舍五入、向上或向下)
  static formatDouble(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  Widget _getPadding(double l, double t, double r, double b) {
    return Padding(padding: EdgeInsets.fromLTRB(l, t, r, b));
  }

  //通用组件
  Widget _contentColumn(String leftcont, String rightcont) {
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftcont,
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
                Text(
                  rightcont,
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(
                height: 0,
                color: HsgColors.textHintColor,
              ),
            ),
          ],
        ));
  }
}
