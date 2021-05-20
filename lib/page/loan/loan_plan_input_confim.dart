import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: longzhenqi
/// Date: 2021-05-18

import 'package:ebank_mobile/data/source/model/loan/get_loan_money_caculate.dart';
import 'package:ebank_mobile/data/source/model/loan/get_schedule_detail_list.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_detail_modelList.dart';
import 'package:ebank_mobile/data/source/model/loan/loan_repayment_confim.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class InputPlanConfimPage extends StatefulWidget {
  @override
  _InputPlanConfimPageState createState() => _InputPlanConfimPageState();
}

class _InputPlanConfimPageState extends State<InputPlanConfimPage> {
  GetLnAcScheduleRspDetlsDTOList planDetail; //还款计划信息
  LnAcMastAppDOList loanDetail; //合约帐号信息

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
    acNo = loanDetails.contactNo; //贷款账号
    loanDetail = loanDetails;

    _debitAccount = mapDetail['debitAcc'];
    _planParameterSetValue();

    var container1 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //贷款账号
          _contentColumn(S.of(context).contract_number, acNo),
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
          _contentColumn(S.of(context).debit_account, _debitAccount),
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
          S.of(context).submit,
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
        title: Text(S.of(context).repayment_with_under),
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

//点击进入下一步
  _getBtnClickListener(BuildContext context) {
    return () {
      //最终提交
      LoanRepaymentConfimReq req = LoanRepaymentConfimReq(
          acNo, //贷款合约
          planDetail.ccy, //贷款货币
          _fine, //还复利金额 ->利息罚息
          _debitAccount, //结算活期账户
          _repayInterest, //还款利息
          loanDetail.osAmt, //贷款余额
          _principel, //本金罚息
          loanDetail.loanAmt, //贷款本金
          instalNo, //还本金金额
          loanDetail.prodTyp, //产品代码
          _totalRepay, //实际还款金额
          '' //支付密码
          );
      HSProgressHUD.show();
      ApiClientLoan().loanRepaymentInterface(req).then(
        (data) async {
          HSProgressHUD.dismiss();
          if (data != null) {
            HSProgressHUD.showToastTip(S.current.loan_application_input_comfir);
            await Future.delayed(Duration(seconds: 1));
            Navigator.of(context)..pop()..pop();
          }
        },
      ).catchError((e) {
        HSProgressHUD.showToast(e);
      });
    };
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
