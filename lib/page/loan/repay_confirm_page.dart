/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-18

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/data/source/model/post_repayment.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class RepayConfirmPage extends StatefulWidget {
  @override
  _RepayConfirmPageState createState() => _RepayConfirmPageState();
}

class _RepayConfirmPageState extends State<RepayConfirmPage> {
  var currency = ''; //币种
  var restLoan = ''; //贷款余额
  var loanInterest = ''; //贷款利率
  var debitAccount = ''; //扣款账号
  var repayPrincipal = ''; //还款金额
  var repayInterest = ''; //还款利息
  var fine = ''; //罚金
  var totalRepay = ''; //还款总额
  var pwd = '111111';
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
  //创建文本控制器实例
  TextEditingController _inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      var text = _inputController.text;
      print(text);
      if (text == pwd) {
        _loadData();
      }
    });
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
          _bottomDialog(context);
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

  //底部弹窗
  _bottomDialog(BuildContext context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return _inputPassword();
        });
  }

  Widget _inputPassword() {
    var stackTitle = Stack(
      fit: StackFit.loose,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).please_input_the_payment_password,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                color: HsgColors.hintText,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
    return Container(
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: stackTitle,
          ),
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Divider(
              height: 0,
              color: HsgColors.textHintColor,
            ),
          ),
          _pwdFrame(),
        ],
      ),
    );
  }

  Widget _pwdFrame() {
    return Container(
        padding: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: PinCodeTextField(
          pinBoxHeight: (MediaQuery.of(context).size.width - 90) / 6,
          pinBoxWidth: (MediaQuery.of(context).size.width - 90) / 6,
          pinBoxBorderWidth: 1,
          pinBoxRadius: 3,
          defaultBorderColor: HsgColors.hintText,
          hasTextBorderColor: HsgColors.hintText,
          controller: _inputController,
          isCupertino: false,
          maxLength: 6,
          hideCharacter: true,
          maskCharacter: "●",
          pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 20),
          autofocus: true,
          errorBorderColor: Colors.red,
          onTextChanged: (chara) {
            // print("chara==>$chara");
          },
          keyboardType: TextInputType.number,
        ));
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
