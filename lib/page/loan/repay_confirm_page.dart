/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-18

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Map message = new Map();
  //创建文本控制器实例
  TextEditingController _inputController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      var text = _inputController.text;
      if (text == '111111') {
        Navigator.of(context)..pop();
        Navigator.pushReplacementNamed(context, pageRepaySuccess,arguments: message);
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
  }

  @override
  Widget build(BuildContext context) {
    message = ModalRoute.of(context).settings.arguments;
    setState(() {
      message = ModalRoute.of(context).settings.arguments;
      currency = message['Currency'];
      loanInterest = message['LoanInterest'];
      debitAccount = message['DebitAccount'];
      repayPrincipal = FormatUtil.formatSringToMoney(message['RepayPrincipal']);
      repayInterest = FormatUtil.formatSringToMoney(message['RepayInterest']);
      fine = FormatUtil.formatSringToMoney(message['Fine']);
      totalRepay = FormatUtil.formatSringToMoney(message['TotalRepay']);
      restLoan = FormatUtil.formatSringToMoney(
          (message['LoanBalance'] - double.parse(message['RepayPrincipal']))
              .toString());
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
          _contentColumn(S.of(context).total_repayment, totalRepay),
          //还款本金
          _contentColumn(S.of(context).repayment_principal, repayPrincipal),
          //还款利息
          _contentColumn(S.of(context).repayment_interest, repayInterest),
          //罚金
          _contentColumn(S.of(context).fine, fine),
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
          _contentColumn(S.of(context).remain_loan_amount, restLoan),
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
          // __inputPassword();
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
        context: context,
        builder: (BuildContext context) {
          return __inputPassword();
        });
  }


  _test() {
    return Container(
        padding: EdgeInsets.only(top: 15),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: PinCodeTextField(
          pinBoxHeight: (MediaQuery.of(context).size.width - 90) / 6,
          pinBoxWidth: (MediaQuery.of(context).size.width - 90) / 6,
          pinBoxBorderWidth: 0.3,
          pinBoxRadius: 3,
          controller: _inputController,
          isCupertino: false,
          maxLength: 6,
          hideCharacter: true,
          maskCharacter: "·",
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

  __inputPassword() {
    return Container(
      height: 425,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Text(
              "请输入支付密码",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Divider(
              height: 0,
              color: HsgColors.textHintColor,
            ),
          ),
          _test(),
        ],
      ),
    );
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

///  继承CustomPainter ，来实现自定义图形绘制
class MyCustom extends CustomPainter {
  ///  传入的密码，通过其长度来绘制圆点
  String pwdLength;
  MyCustom(this.pwdLength);

  ///  此处Sizes是指使用该类的父布局大小
  @override
  void paint(Canvas canvas, Size size) {
    // 密码画笔
    Paint mPwdPaint;
    Paint mRectPaint;

    // 初始化密码画笔
    mPwdPaint = new Paint();
    mPwdPaint..color = Colors.black;

//   mPwdPaint.setAntiAlias(true);
    // 初始化密码框
    mRectPaint = new Paint();
    mRectPaint..color = Color(0xff707070);

    ///  圆角矩形的绘制
    RRect r = new RRect.fromLTRBR(0.0, 0.0, size.width, size.height,
        new Radius.circular(size.height / 12));

    ///  画笔的风格
    mRectPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(r, mRectPaint);

    ///  将其分成六个 格子（六位支付密码）
    var per = size.width / 6.0;
    var offsetX = per;
    while (offsetX < size.width) {
      canvas.drawLine(new Offset(offsetX, 0.0),
          new Offset(offsetX, size.height), mRectPaint);
      offsetX += per;
    }

    ///  画实心圆
    var half = per / 2;
    var radio = per / 8;
    mPwdPaint.style = PaintingStyle.fill;

    ///  当前有几位密码，画几个实心圆
    for (int i = 0; i < pwdLength.length && i < 6; i++) {
      canvas.drawArc(
          new Rect.fromLTRB(i * per + half - radio, size.height / 2 - radio,
              i * per + half + radio, size.height / 2 + radio),
          0.0,
          2 * 3.0,
          true,
          mPwdPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
