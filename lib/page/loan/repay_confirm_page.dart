/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-18

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/data/source/model/loan_detail_modelList.dart';
import 'package:ebank_mobile/data/source/model/loan_prepayment_model.dart';
import 'package:ebank_mobile/data/source/model/post_repayment.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/model/get_loan_money_caculate.dart';

import 'limit_details_page.dart';
import 'loan_details_page.dart';

class RepayConfirmPage extends StatefulWidget {
  @override
  _RepayConfirmPageState createState() => _RepayConfirmPageState();
}

class _RepayConfirmPageState extends State<RepayConfirmPage> {
  LnAcMastAppDOList loanDetail; //合约帐号信息
  PostAdvanceRepaymentDTOList list; //利息计算信息

  List<String> passwordList = [];
  var _payPassword = '';
  var currency = ''; //币种
  var restLoan = ''; //贷款余额
  var loanInterest = ''; //贷款利率
  var debitAccount = ''; //扣款账号
  var repayPrincipal = ''; //还款金额
  var repayInterest = ''; //还款利息
  var fine = ''; //罚金
  var totalRepay = ''; //还款总额
  Map message = new Map();

  @override
  void initState() {
    super.initState();
    //初始化
    currency = 'HKD';
    restLoan = '0.00';
    loanInterest = '0.00%';
    debitAccount = '';
    repayPrincipal = '0.00';
    repayInterest = '0.00';
    fine = '0.00';
    totalRepay = '0.00';
  }

  Future<void> _loadData() async {
    var req = LoanPrepaymentModelReq(
      loanDetail.contactNo, //合约号
      loanDetail.ccy,
      double.parse(list.payPrin), //折算后的金额就是实际还款的金额
      double.parse(list.rcvInt), //还利息金额
      double.parse(loanDetail.osAmt), //贷款的余额
      double.parse(loanDetail.loanAmt), //贷款本金
      double.parse(list.payPrin), //还本金金额
      loanDetail.repaymentMethod, //还息方式
      // '1', //结算方式
      loanDetail.ccy, //结算货币
      double.parse(list.payPrin), //实际还款金额
      debitAccount,
    );
    SVProgressHUD.show();
    LoanDataRepository().postRepayment(req, "postRepayment").then((data) {
      SVProgressHUD.dismiss();
      if (data != null) {
        SVProgressHUD.showSuccess(status: S.current.repayment_succeed);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return LimitDetailsPage();
        }), (Route route) {
          //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
          if (route.settings?.name == "/limit_details_page") {
            return true; //停止关闭
          }
          return false; //继续关闭
        });
      }
    }).catchError((e) {
      SVProgressHUD.dismiss();
      SVProgressHUD.showInfo(status: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Map message = ModalRoute.of(context).settings.arguments;
    LnAcMastAppDOList loanDetail = message['accountModel']; //合约帐号信息
    this.loanDetail = loanDetail;
    PostAdvanceRepaymentDTOList list = message['calculateModel']; //利息计算信息
    this.list = list;

    setState(() {
      message = ModalRoute.of(context).settings.arguments;
      currency = list.ccy; //币种
      int totalRcv = int.parse(list.rcvPen) + int.parse(list.rcvCom);
      fine = totalRcv.toString(); //罚息总额
      totalRepay = message['totalRepay']; //还款总额
      loanInterest = loanDetail.intRate + "%"; //当前利率
      debitAccount = loanDetail.repaymentAcNo != null
          ? loanDetail.repaymentAcNo
          : '8011208000001258'; //扣款帐号
      repayPrincipal = list.payPrin; //还款本金
      repayInterest = list.rcvInt; //还款利息
      restLoan = (double.parse(loanDetail.osAmt) - double.parse(list.payPrin))
          .toString(); //用贷款余额减去还款本金
    });
    var container1 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //币种
          _contentColumn(S.of(context).currency, currency),
          //还款总额
          _contentColumn(S.of(context).total_repayment,
              FormatUtil.formatSringToMoney(totalRepay)),
          //还款本金
          _contentColumn(S.of(context).repayment_principal,
              FormatUtil.formatSringToMoney(repayPrincipal)),
          //还款利息
          _contentColumn(S.of(context).repayment_interest,
              FormatUtil.formatSringToMoney(repayInterest)),
          //罚金
          _contentColumn(
              S.of(context).fine, FormatUtil.formatSringToMoney(fine)),
        ],
      ),
    );
    var container2 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //剩余贷款
          _contentColumn(S.of(context).remain_loan_amount,
              FormatUtil.formatSringToMoney(restLoan)),
          //当前利率
          _contentColumn(S.of(context).loan_rate, loanInterest),
          //扣款账号
          _contentColumn(S.of(context).debit_account, debitAccount),
        ],
      ),
    );
    //确定提交按钮
    var btnConfirm = Container(
      padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
      child: RaisedButton(
        child: Text(
          S.of(context).confirm_message,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
        onPressed: () {
          //弹出底部弹窗输入密码
          _openBottomSheet();
        },
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
        title: Text(S.of(context).repay_confirm),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            container1,
            _getPadding(0, 15, 0, 0),
            container2,
            btnConfirm,
          ],
        ),
      ),
    );
  }

  //交易密码窗口
  void _openBottomSheet() async {
    _loadData(); //还款

    // passwordList = await showHsgBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return HsgPasswordDialog(
    //       title: S.current.input_password,
    //       resultPage: pageRepaySuccess,
    //       arguments: message,
    //     );
    //   },
    // );
    // if (passwordList != null) {
    //   if (passwordList.length == 6) {
    //     _payPassword = EncryptUtil.aesEncode(passwordList.join());
    //     _submitRepayment();
    //   }
    // }
  }

//提交还款
  void _submitRepayment() async {
    // SVProgressHUD.show();
    // VerifyTradePawRepository()
    //     .verifyTransPwdNoSms(
    //         VerifyTransPwdNoSmsReq(_payPassword), 'VerifyTransPwdNoSmsReq')
    //     .then((data) {
    //   SVProgressHUD.dismiss();
    _loadData(); //还款
    // }).catchError((e) {
    //   SVProgressHUD.dismiss();
    //   SVProgressHUD.showInfo(status: e.toString());
    // });
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
