/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 外汇买卖
/// Author: CaiTM
/// Date: 2020-12-21

import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForexTradingPage extends StatefulWidget {
  @override
  _ForexTradingPageState createState() => _ForexTradingPageState();
}

class _ForexTradingPageState extends State<ForexTradingPage> {
  List<String> accList = [''];
  List<String> ccyList1 = ['CNY', 'EUR', 'HKD'];
  List<String> ccyList2 = ['CNY', 'EUR', 'HKD', 'USD'];
  int _paymentAccId = -1;
  int _incomeAccId = -1;
  int _paymentCcyId = -1;
  int _incomeCcyId = -1;
  var _paymentAcc = S.current.please_select;
  var _incomeAcc = S.current.please_select;
  var _paymentCcy = S.current.please_select;
  var _incomeCcy = S.current.please_select;
  var _balance = '0.00';
  var _payAmtController = TextEditingController();
  var _rate = '';
  var _incomeAmt = '';

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('外汇买卖'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.only(top: 15),
                child: _formColumn(),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, top: 12),
                child: Text(
                  '上述金额为试算金额，请以实际到账金额为准！',
                  style: TextStyle(
                    fontSize: 12,
                    color: HsgColors.describeText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: _subDataButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonTheme _subDataButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      child: FlatButton(
        onPressed: _incomeAmt == ''
            ? null
            : () {
                _submitData();
              },
        color: Color(0xFF4871FF),
        disabledColor: Color(0xFFD1D1D1),
        child: Text(
          '确认',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Column _formColumn() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _accountList(true, _paymentAccId);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _paymentAccountRow(),
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        GestureDetector(
          onTap: () {
            _currencyList(true, _paymentCcyId, ccyList1);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _paymentCurrencyRow(),
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('可用余额'),
              Text(_balance),
            ],
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('支出金额'),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  controller: _payAmtController,
                  decoration: InputDecoration.collapsed(
                    hintText: S.current.please_input,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: HsgColors.textHintColor,
                    ),
                  ),
                  onChanged: (text) {
                    _transferTrial();
                  },
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        GestureDetector(
          onTap: () {
            _accountList(false, _incomeAccId);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _incomeAccountRow(),
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        GestureDetector(
          onTap: () {
            _currencyList(false, _incomeCcyId, ccyList2);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: _incomeCurrencyRow(),
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('汇率'),
              Text(_rate),
            ],
          ),
        ),
        Divider(
          height: 0.5,
          color: HsgColors.divider,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('收入金额'),
              Text(_incomeAmt),
            ],
          ),
        ),
      ],
    );
  }

  Row _incomeCurrencyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('收入币种'),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: _incomeCcy == S.current.please_select
                  ? Text(
                      _incomeCcy,
                      style: TextStyle(
                        color: HsgColors.textHintColor,
                      ),
                    )
                  : Text(_incomeCcy),
            ),
            Image(
              color: HsgColors.firstDegreeText,
              image:
                  AssetImage('images/home/listIcon/home_list_more_arrow.png'),
              width: 7,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Row _paymentCurrencyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('支出币种'),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: _paymentCcy == S.current.please_select
                  ? Text(
                      _paymentCcy,
                      style: TextStyle(
                        color: HsgColors.textHintColor,
                      ),
                    )
                  : Text(_paymentCcy),
            ),
            Image(
              color: HsgColors.firstDegreeText,
              image:
                  AssetImage('images/home/listIcon/home_list_more_arrow.png'),
              width: 7,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Row _paymentAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('支出账户'),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: _paymentAcc == S.current.please_select
                  ? Text(
                      _paymentAcc,
                      style: TextStyle(
                        color: HsgColors.textHintColor,
                      ),
                    )
                  : Text(_paymentAcc),
            ),
            Image(
              color: HsgColors.firstDegreeText,
              image:
                  AssetImage('images/home/listIcon/home_list_more_arrow.png'),
              width: 7,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Row _incomeAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('收入账户'),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: _incomeAcc == S.current.please_select
                  ? Text(
                      _incomeAcc,
                      style: TextStyle(
                        color: HsgColors.textHintColor,
                      ),
                    )
                  : Text(_incomeAcc),
            ),
            Image(
              color: HsgColors.firstDegreeText,
              image:
                  AssetImage('images/home/listIcon/home_list_more_arrow.png'),
              width: 7,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  void _accountList(bool isAcc, int index) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.of(context).account_lsit,
            items: accList,
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {
      setState(() {
        if (isAcc) {
          _paymentAccId = result;
          _paymentAcc = accList[_paymentAccId];
          if (_paymentAcc != S.current.please_select &&
              _paymentCcy != S.current.please_select) {
            _getCardBal(_paymentAcc);
          }
        } else {
          _incomeAccId = result;
          _incomeAcc = accList[_incomeAccId];
        }
        _transferTrial();
      });
    }
  }

  void _currencyList(bool isCcy, int index, List<String> dataList) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: "币种选择",
            items: dataList,
            positiveButton: '确定',
            negativeButton: '取消',
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {
      setState(() {
        if (isCcy) {
          _paymentCcyId = result;
          _paymentCcy = dataList[_paymentCcyId];
          if (_paymentAcc != S.current.please_select &&
              _paymentCcy != S.current.please_select) {
            _getCardBal(_paymentAcc);
          }
        } else {
          _incomeCcyId = result;
          _incomeCcy = dataList[_incomeCcyId];
        }
        _transferTrial();
      });
    }
  }

  _getCardList() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          accList.clear();
          data.cardList.forEach((item) {
            accList.add(item.cardNo);
          });
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getCardBal(String cardNo) async {
    ForexTradingRepository()
        .getCardBalByCardNo(GetCardBalReq(cardNo: cardNo), 'GetCardBalReq')
        .then((data) {
      if (data.cardListBal != null && _paymentCcy != S.current.please_select) {
        setState(() {
          _balance = '0.00';
          data.cardListBal.forEach((item) {
            if (_paymentCcy == item.ccy) {
              _balance = item.avaBal;
            }
          });
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _transferTrial() async {
    if (_paymentAcc != S.current.please_select &&
        _paymentCcy != S.current.please_select &&
        _incomeAcc != S.current.please_select &&
        _incomeCcy != S.current.please_select &&
        _payAmtController.text != '') {
      var _amount = AiDecimalAccuracy.parse(_payAmtController.text).toDouble();
      ForexTradingRepository()
          .transferTrial(
              TransferTrialReq(
                  amount: _amount,
                  corrCcy: _incomeCcy,
                  defaultCcy: _paymentCcy),
              'TransferTrialReq')
          .then((data) {
        setState(() {
          _rate = data.rate;
          _incomeAmt = data.resultAmount;
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
    }
  }

  _submitData() async {}
}
