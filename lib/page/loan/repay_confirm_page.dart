/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-18

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
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
import 'package:fluttertoast/fluttertoast.dart';

class RepayConfirmPage extends StatefulWidget {
  @override
  _RepayConfirmPageState createState() => _RepayConfirmPageState();
}

class _RepayConfirmPageState extends State<RepayConfirmPage> {
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
  //请求数据
  var acNo = '';
  var dueAmount = '';
  var instalNo = '';
  var interestAmount = '';
  var penaltyAmount = '';
  var principalAmount = '';
  var prodCode = '';
  var refNo = '';
  var repaymentAcNo = '';
  var repaymentAcType = '';
  var repaymentCiName = '';
  var repaymentMethod = '';
  var rescheduleType = '';
  var totalAmount = '';

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

    //请求数据
    acNo = '';
    dueAmount = '';
    instalNo = '';
    interestAmount = '';
    penaltyAmount = '';
    principalAmount = '';
    prodCode = '';
    refNo = '';
    repaymentAcNo = '';
    repaymentAcType = '';
    repaymentCiName = '';
    repaymentMethod = '';
    rescheduleType = '';
    totalAmount = '';
  }

  Future<void> _loadData() async {
    var req = new PostRepaymentReq(
        acNo,
        dueAmount,
        instalNo,
        interestAmount,
        penaltyAmount,
        principalAmount,
        prodCode,
        refNo,
        repaymentAcNo,
        repaymentAcType,
        repaymentCiName,
        repaymentMethod,
        rescheduleType,
        totalRepay);
    LoanDataRepository().postRepayment(req, "postRepayment").then((data) {
      if (data != null) {
        Navigator.of(context)..pop();
        Navigator.pushReplacementNamed(context, pageRepaySuccess,
            arguments: message);
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    message = ModalRoute.of(context).settings.arguments;
    Loan loanDetail = message['LoanDetail'];
    setState(() {
      message = ModalRoute.of(context).settings.arguments;
      currency = message['Currency'];
      loanInterest = message['LoanInterest'];
      debitAccount = message['DebitAccount'];
      repayPrincipal = message['RepayPrincipal'];
      repayInterest = message['RepayInterest'];
      fine = message['Fine'];
      totalRepay = message['TotalRepay'];
      restLoan =
          (message['LoanBalance'] - double.parse(message['RepayPrincipal']))
              .toString();
      //请求数据
      acNo = loanDetail.acNo;
      dueAmount = '';
      instalNo = '';
      interestAmount = repayInterest;
      penaltyAmount = fine;
      principalAmount = repayPrincipal;
      prodCode = 'LN000008';
      refNo = '';
      repaymentAcNo = loanDetail.repaymentAcNo;
      repaymentAcType = '';
      repaymentCiName = '';
      repaymentMethod = message['RepaymentMethod'];
      rescheduleType = 'I';
      totalAmount = totalRepay;
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
    passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
        );
      },
    );
    if (passwordList != null) {
      if (passwordList.length == 6) {
        _payPassword = EncryptUtil.aesEncode(passwordList.join());
        _submitRepayment();
      }
    }
  }

  void _submitRepayment() async {
    VerifyTradePawRepository()
        .verifyTransPwdNoSms(
            VerifyTransPwdNoSmsReq(_payPassword), 'VerifyTransPwdNoSmsReq')
        .then((data) {
          _loadData();
        })
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
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
