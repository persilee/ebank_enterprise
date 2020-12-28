/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-18

import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class RepaySuccessPage extends StatefulWidget {
  @override
  _RepaySuccessPageState createState() => _RepaySuccessPageState();
}

class _RepaySuccessPageState extends State<RepaySuccessPage> {
  Map message = new Map();
  var totalRepay = ''; //还款总额
  var debitAccount = ''; //扣款账号
  var currency = ''; //币种
  var money = ''; //币种+扣款账号
  @override
  void initState() {
    super.initState();
    //初始化
    currency = 'HKD';
    debitAccount = '';
    totalRepay = '0.00';
    _changeMoney(currency, totalRepay);
  }

  _changeMoney(String c, String t) {
    if (c == 'HKD') {
      money = t + ' ' + c;
    } else if (c == 'RMB') {
      money = '￥' + t;
    }
  }
  _changeAccount(String d){
    var lis = d.split(' ');
    debitAccount = lis[0]+'********'+lis[1];
  }

  @override
  Widget build(BuildContext context) {
    message = ModalRoute.of(context).settings.arguments;
    setState(() {
      currency = message['Currency'];
      debitAccount = message['DebitAccount'];
      totalRepay = FormatUtil.formatSringToMoney(message['TotalRepay']);
      _changeMoney(currency, totalRepay);
      _changeAccount(debitAccount);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repayment_succeed),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: Column(
          children: [
            _photoPart(),
            _messagePart(),
            _btnPart(),
          ],
        ),
      ),
    );
  }

  Widget _photoPart() {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            _getPadding(0, 15, 0, 0),
            Text(
              S.of(context).repayment_succeed_p,
              style: TextStyle(fontSize: 16, color: Color(0xFF282828),fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget _messagePart() {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            _divider(),
            _content(S.of(context).total_repayment, money),
            _getPadding(0, 13, 0, 0),
            _content(S.of(context).deduct_money_account, debitAccount),
            _divider(),
          ],
        ));
  }

  Widget _btnPart() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: RaisedButton(
        child: Text(
          S.of(context).confirm_message,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
        onPressed: () {
          Navigator.of(context).pop(1);
        },
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        color: Color(0xFF4871FF),
        disabledColor: HsgColors.btnDisabled,
      ),
    );
  }

  //通用组件
  Widget _content(String leftcont, String rightcont) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftcont,
              style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
            ),
            Text(
              rightcont,
              style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
            ),
          ],
        )
      ],
    );
  }

  //分割线
  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Divider(
        height: 0,
        color: HsgColors.textHintColor,
      ),
    );
  }

  Widget _getPadding(double l, double t, double r, double b) {
    return Padding(padding: EdgeInsets.fromLTRB(l, t, r, b));
  }
}
