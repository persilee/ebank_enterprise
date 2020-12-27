import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_account_overview_info.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-16

import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/data/source/model/get_loan_money_caculate.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RepayInputPage extends StatefulWidget {
  @override
  _RepayInputPageState createState() => _RepayInputPageState();
}

class _RepayInputPageState extends State<RepayInputPage> {
  Map message = new Map();
  var currency = ''; //币种
  double max = 0; //还款最大值(贷款余额)
  var loanInterest = ''; //贷款利率
  var debitAccount = ''; //扣款账号

  var _repayInterest = ''; //还款利息
  var _fine = ''; //罚金
  var _totalRepay = ''; //还款总额
  bool _isBtnDisabled = false;

  var acNo = '';
  var instalNo = '';
  var isInterestCharge = '';
  var repayPrincipal = ''; //还款金额
  var repaymentMethod = '';
  var rescheduleType = 'I';

  //创建文本控制器实例
  TextEditingController _inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      String text = _inputController.text;

      int length = text.length;
      if (length <= 0) {
        setState(() {
          _isBtnDisabled = false;
          _repayInterest = '0.00';
          _fine = '0.00';
          _totalRepay = '0.00';
        });
      } else {
        RegExp postalcode = new RegExp(r'^(0\d)');
        if (postalcode.hasMatch(text)) {
          _inputController.text = text.substring(1);
          _inputController.selection =
              TextSelection.collapsed(offset: _inputController.text.length);
        }
        if (double.parse(_inputController.text) > max) {
          _inputController.text = formatDouble(max, 2);
          _inputController.selection =
              TextSelection.collapsed(offset: _inputController.text.length);
        }
        repayPrincipal = _inputController.text;
        if (double.parse(repayPrincipal) == max) {
          repaymentMethod = "SETTLEMENT";
        }else{
          repaymentMethod = "PART_PREPAYMENT";
        }
        _loadData();
        if (double.parse(text) != 0) {
          _isBtnDisabled = true;
        }
      }
    });
    //初始化
    currency = 'HKD';
    max = 0;
    loanInterest = '0.00%';
    debitAccount = '';
    repayPrincipal = '0.00';
    _repayInterest = '0.00';
    _fine = '0.00';
    _totalRepay = '0.00';
    repaymentMethod = "PART_PREPAYMENT";

    message.putIfAbsent('RepaymentMethod', () => repaymentMethod);
    message.putIfAbsent('LoanBalance', () => max);
    message.putIfAbsent('Currency', () => currency);
    message.putIfAbsent('TotalRepay', () => _totalRepay);
    message.putIfAbsent('RepayPrincipal', () => repayPrincipal);
    message.putIfAbsent('RepayInterest', () => _repayInterest);
    message.putIfAbsent('Fine', () => _fine);
    message.putIfAbsent('LoanInterest', () => loanInterest);
    message.putIfAbsent('DebitAccount', () => debitAccount);
  }

  Future<void> _loadData() async {
    LoanDataRepository()
        .getLoanCaculate(
            GetLoanCaculateReq(acNo, instalNo, isInterestCharge, repayPrincipal,
                repaymentMethod, rescheduleType),
            "getLoanMoneyCaculate")
        .then((data) {
      if (data != null) {
        setState(() {
          if (data.feeAmount != null) {
            _fine = data.feeAmount;
          }
          _repayInterest = data.interestAmount;
          _totalRepay = data.repaymentAmount;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    setState(() {
      message.putIfAbsent('LoanDetail', () => loanDetail);
      acNo = loanDetail.acNo;
      instalNo = loanDetail.restPeriods.toString();
      max = double.parse(loanDetail.unpaidPrincipal);
      debitAccount = FormatUtil.formatSpace4(loanDetail.repaymentAcNo);
      loanInterest =
          (double.parse(loanDetail.intRate) * 100).toStringAsFixed(2) + "%";
    });
    var container1 = Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //贷款账号
          _contentColumn(S.of(context).loan_account, loanDetail.contactNo),
          //币种
          _contentColumn(S.of(context).currency, currency),
          //贷款本金
          _contentColumn(S.of(context).loan_principal,
              FormatUtil.formatSringToMoney(loanDetail.loanAmt)),
          //贷款余额
          _contentColumn(S.of(context).loan_balance2,
              FormatUtil.formatSringToMoney(loanDetail.unpaidPrincipal)),
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
          _contentColumn(S.of(context).debit_account, debitAccount),
          //还款本金
          _repayPrincipal(loanDetail),
          //还款利息
          _contentColumn(S.of(context).repayment_interest, FormatUtil.formatSringToMoney(_repayInterest)),
          //罚金
          _contentColumn(S.of(context).fine, FormatUtil.formatSringToMoney(_fine)),
          //还款总额
          _contentColumn(S.of(context).total_repayment, FormatUtil.formatSringToMoney(_totalRepay)),
        ],
      ),
    );
    var btnNext = Padding(
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
            btnNext,
          ],
        ),
      ),
    );
  }

  _getBtnClickListener(BuildContext context) {
    if (_isBtnDisabled) {
      return () {
        //修改信息map里的信息
        message['LoanBalance'] = max;
        message['Currency'] = currency;
        message['TotalRepay'] = _totalRepay;
        message['RepayPrincipal'] = repayPrincipal;
        message['RepayInterest'] = _repayInterest;
        message['Fine'] = _fine;
        message['LoanInterest'] = loanInterest;
        message['DebitAccount'] = debitAccount;
        message['RepaymentMethod'] = repaymentMethod;
        Navigator.pushNamed(context, pageRepayConfirm, arguments: message);
      };
    } else {
      return null;
    }
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

  //还款金额输入
  Widget _repayPrincipal(Loan loanDetail) {
    var inputRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Container(
            width: 170,
            height: 21,
            child: TextField(
              controller: _inputController,
              textAlign: TextAlign.end,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(
                    RegExp("^[0-9]+[.]?[0-9]{0,2}"))
              ],
              style: TextStyle(fontSize: 14, color: Colors.black87),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: S.of(context).hint_repayment_principal,
                hintStyle: TextStyle(color: HsgColors.hintText, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                //输入框数据修改后

                setState(() {
                  repayPrincipal = _inputController.text;
                });
                // _loadData();
              },
            ),
          ),
        ),
        Container(
          width: 84,
          height: 21,
          child: OutlineButton(
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            borderSide: BorderSide(color: HsgColors.btnPrimary),
            child: Text(
              S.of(context).early_repayment,
              style: TextStyle(fontSize: 13, color: HsgColors.btnPrimary),
            ),
            onPressed: () {
              _inputController.text = formatDouble(max, 2);
              _inputController.selection =
                  TextSelection.collapsed(offset: _inputController.text.length);
              setState(() {
                repayPrincipal = _inputController.text;
              });
              // _loadData();//达到最大值后不修改了
            },
          ),
        ),
      ],
    );
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    S.of(context).repayment_principal,
                    style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                  ),
                ),
              ],
            ),
            _getPadding(0, 8, 0, 0),
            inputRow,
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                height: 0,
                color: HsgColors.textHintColor,
              ),
            ),
          ],
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
