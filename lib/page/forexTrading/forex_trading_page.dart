/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 外汇买卖
/// Author: CaiTM
/// Date: 2020-12-21

import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForexTradingPage extends StatefulWidget {
  @override
  _ForexTradingPageState createState() => _ForexTradingPageState();
}

class _ForexTradingPageState extends State<ForexTradingPage> {
  List<String> _accList = [];
  List<String> _accIcon = [];
  List<String> _paymentCcyList = ['CNY', 'EUR', 'HKD'];
  List<String> _incomeCcyList = ['CNY', 'EUR', 'HKD', 'USD'];
  List<RemoteBankCard> cards = [];
  int _paymentAccId = -1;
  int _incomeAccId = -1;
  int _paymentCcyId = 0;
  int _incomeCcyId = 0;
  String _paymentAcc = '';
  String _incomeAcc = '';
  String _paymentCcy = '';
  String _incomeCcy = '';
  String _incomeName = '';
  String _incomeBackCode = '';
  String _balance = '0.00';
  TextEditingController _payAmtController = TextEditingController();
  String _rate = '';
  String _incomeAmt = '';

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
        title: Text(S.current.foreign_exchange),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 15),
                padding: CONTENT_PADDING,
                child: _formColumn(),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 12),
                padding: CONTENT_PADDING,
                child: Text(
                  S.current.foreign_exchange_explain,
                  style: TextStyle(
                    fontSize: 12,
                    color: HsgColors.describeText,
                  ),
                ),
              ),
              //確定按鈕
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: HsgButton.button(
                  title: S.current.confirm,
                  click: _boolBut()
                      ? () {
                          _openBottomSheet();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _boolBut() {
    if (_paymentAcc != '' &&
        _paymentCcy != '' &&
        _incomeAcc != '' &&
        _incomeCcy != '' &&
        _payAmtController.text != '' &&
        _rate != '' &&
        _incomeAmt != '') {
      return true;
    } else {
      return false;
    }
  }

  Column _formColumn() {
    return Column(
      children: [
        SelectInkWell(
          title: S.current.debit_accno,
          item: _paymentAcc,
          onTap: () {
            _accountBottomSheet(true, _paymentAccId);
          },
        ),
        SelectInkWell(
          title: S.current.debit_currency,
          item: _paymentCcy,
          onTap: () {
            _currencyShowDialog(true, _paymentCcyId, _paymentCcyList);
          },
        ),
        ItemContainer(
          title: S.current.available_balance,
          item: _balance,
        ),
        Container(
          height: 50,
          child: _payAmtTextField(),
        ),
        SelectInkWell(
          title: S.current.debit_accno,
          item: _incomeAcc,
          onTap: () {
            _accountBottomSheet(false, _incomeAccId);
          },
        ),
        SelectInkWell(
          title: S.current.debit_currency,
          item: _incomeCcy,
          onTap: () {
            _currencyShowDialog(false, _incomeCcyId, _incomeCcyList);
          },
        ),
        ItemContainer(
          title: S.current.rate_of_exchange,
          item: _rate,
        ),
        ItemContainer(
          title: S.current.credit_amount,
          item: _incomeAmt,
        ),
      ],
    );
  }

  //支出金额输入框
  Container _payAmtTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.current.debit_amount),
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
    );
  }

  //账户选择弹窗
  void _accountBottomSheet(bool isAcc, int index) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.of(context).account_lsit,
            items: _accList,
            icons: _accIcon,
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {
      setState(() {
        if (isAcc) {
          _paymentAccId = result;
          _paymentAcc = _accList[_paymentAccId];
          if (_paymentAcc != '' && _paymentCcy != '') {
            _getCardBal(_paymentAcc);
          }
        } else {
          _incomeAccId = result;
          _incomeAcc = _accList[_incomeAccId];
          cards.forEach((item) {
            if (_incomeAcc == item.cardNo) {
              _incomeName = item.ciName;
              _incomeBackCode = item.bankCode;
            }
          });
        }
        _transferTrial();
      });
    }
  }

  //币种选择弹窗
  void _currencyShowDialog(bool isCcy, int index, List<String> dataList) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: S.current.currency_option,
            items: dataList,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {
      setState(() {
        if (isCcy) {
          _paymentCcyId = result;
          _paymentCcy = dataList[_paymentCcyId];
          if (_paymentAcc != '' && _paymentCcy != '') {
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

  //交易密码窗口
  void _openBottomSheet() async {
    final isPassword = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
        );
      },
    );
    if (isPassword != null && isPassword == true) {
      _submitFormData();
    }
  }

  _getCardList() {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          cards.clear();
          _accIcon.clear();
          cards = data.cardList;
          _accList.clear();
          data.cardList.forEach((item) {
            _accList.add(item.cardNo);
            _accIcon.add(item.imageUrl);
          });
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //获取账户可用余额
  _getCardBal(String cardNo) {
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

  //计算汇率
  _transferTrial() {
    if (_paymentAcc != '' &&
        _paymentCcy != '' &&
        _incomeAcc != '' &&
        _incomeCcy != '' &&
        _payAmtController.text != '') {
      double _amount =
          AiDecimalAccuracy.parse(_payAmtController.text).toDouble();
      ForexTradingRepository()
          .transferTrial(
              TransferTrialReq(
                  amount: _amount,
                  corrCcy: _incomeCcy,
                  defaultCcy: _paymentCcy),
              'TransferTrialReq')
          .then((data) {
        setState(() {
          // _rate = data.rate;
          // _incomeAmt = data.resultAmount;
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
    }
  }

  _submitFormData() {
    HSProgressHUD.show();
    ForexTradingRepository()
        .doTransferAccout(
            DoTransferAccoutReq(_incomeAmt, _incomeCcy, _paymentCcy, _incomeAcc,
                _paymentAcc, _incomeName, _incomeBackCode),
            'DoTransferAccoutReq')
        .then((data) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(msg: S.current.operate_success);
      Navigator.pop(context, pageIndex);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.dismiss();
    });
  }
}

class SelectInkWell extends StatelessWidget {
  final String title;
  final String item;
  final void Function() onTap;
  SelectInkWell({Key key, this.title, this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
        ),
        child: _getSelectRow(),
      ),
    );
  }

  Row _getSelectRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: item == ''
                  ? Text(S.current.please_select,
                      style: TextStyle(color: HsgColors.textHintColor))
                  : Text(item),
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
}

class ItemContainer extends StatelessWidget {
  final String title;
  final String item;
  ItemContainer({Key key, this.title, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: HsgColors.divider, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(item)],
      ),
    );
  }
}
