/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 外汇买卖
/// Author: CaiTM
/// Date: 2020-12-28

import 'dart:ui';
import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExchangeRateInquiryPage extends StatefulWidget {
  @override
  _ExchangeRateInquiryPageState createState() =>
      _ExchangeRateInquiryPageState();
}

class _ExchangeRateInquiryPageState extends State<ExchangeRateInquiryPage> {
  List<String> _primitiveCcyList = ['HKD'];
  List<String> _objectiveCcyList = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];
  List<Map<String, Object>> rateList = [
    {'ccy': 'USD', 'selling': '7.8820', 'buying': '7.7524'},
    {'ccy': 'EUR', 'selling': '9.6058', 'buying': '9.5005'},
    {'ccy': 'GBP', 'selling': '10.6166', 'buying': '10.5376'},
    {'ccy': 'CAD', 'selling': '6.2332', 'buying': '6.0684'},
    {'ccy': 'AUD', 'selling': '6.1162', 'buying': '5.9481'}
  ];
  TextEditingController _amtController = TextEditingController();
  String updateDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
  int _primitiveCcyId = 0;
  int _objectiveCcyId = 0;
  String _primitiveCcy = '';
  String _objectiveCcy = '';
  String _primitiveCcyAmt = '0.00';
  bool _isSwap = true;

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
  }

  @override
  Widget build(BuildContext context) {
    _primitiveCcy = _primitiveCcyList[_primitiveCcyId];
    _objectiveCcy = _objectiveCcyList[_objectiveCcyId];
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.exchange_rate),
        centerTitle: true,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(70, 25, 70, 0),
              alignment: Alignment.center,
              child: _getCurrencyRow(),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(18, 15, 18, 15),
              child: Row(
                children: [
                  Expanded(
                    child: _primitiveCcyAmtTextField(),
                  ),
                  Container(
                    width: 40,
                  ),
                  Expanded(
                    child: _objectiveCcyAmtTextField(),
                  ),
                ],
              ),
            ),
            Container(
              color: HsgColors.backgroundColor,
              padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
              child: Text(
                S.current.rate_notes1 + updateDate + S.current.rate_notes2,
                style: TextStyle(color: HsgColors.describeText),
              ),
            ),
            Container(
              color: Color(0xFFEEF0EF),
              height: 40,
              child: _listTitle(),
            ),
            Expanded(
              child: RefreshIndicator(
                child: _listContent(),
                onRefresh: _getExchangeRateList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _listTitle() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              S.current.currency,
              style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              S.current.selling_price,
              style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              S.current.buying_price,
              style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
            ),
          ),
        ),
      ],
    );
  }

  ListView _listContent() {
    return ListView.builder(
      itemCount: rateList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: _boxDecoration(),
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    rateList[index]['ccy'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    rateList[index]['selling'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    rateList[index]['buying'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: HsgColors.divider),
      ),
    );
  }

  //金额输入框
  TextField _primitiveCcyAmtTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _amtController,
      style: TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '0.00',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HsgColors.textHintColor, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HsgColors.textHintColor, width: 0.5),
        ),
        hintStyle: TextStyle(
          fontSize: 20,
          color: HsgColors.textHintColor,
        ),
      ),
      onChanged: (text) {
        _amountConversion();
      },
    );
  }

  TextField _objectiveCcyAmtTextField() {
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: _primitiveCcyAmt,
        enabled: false,
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 20,
          color: _primitiveCcyAmt != '0.00'
              ? Colors.black
              : HsgColors.textHintColor,
        ),
      ),
    );
  }

  Row _getCurrencyRow() {
    return Row(
      children: [
        Expanded(
          child: _primitiveCcySelect(),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                _currencySwap();
              },
              child: Image(
                color: HsgColors.firstDegreeText,
                image: AssetImage('images/tabbar/tabbar_reset.png'),
                width: 25,
                height: 25,
              ),
            ),
          ),
        ),
        Expanded(
          child: _objectiveCcySelect(),
        ),
      ],
    );
  }

  GestureDetector _primitiveCcySelect() {
    return GestureDetector(
      onTap: () {
        _currencyList(true, _primitiveCcyId, _primitiveCcyList);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _primitiveCcy,
            style: TextStyle(fontSize: 20),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 25,
          ),
        ],
      ),
    );
  }

  GestureDetector _objectiveCcySelect() {
    return GestureDetector(
      onTap: () {
        _currencyList(false, _objectiveCcyId, _objectiveCcyList);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _objectiveCcy,
              style: TextStyle(fontSize: 20),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  //币种选择弹窗
  void _currencyList(bool isCcy, int index, List<String> dataList) async {
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
        _isSwap = true;
        if (isCcy) {
          _primitiveCcyId = result;
          _primitiveCcy = dataList[_primitiveCcyId];
        } else {
          _objectiveCcyId = result;
          _objectiveCcy = dataList[_objectiveCcyId];
        }
      });
      _amountConversion();
    }
  }

  //转换
  _currencySwap() {
    List<String> newCcyList = [];
    int newCcyId = 0;
    setState(() {
      if (_amtController.text != '') {
        _isSwap = false;
      }

      newCcyList = _primitiveCcyList;
      _primitiveCcyList = _objectiveCcyList;
      _objectiveCcyList = newCcyList;

      newCcyId = _primitiveCcyId;
      _primitiveCcyId = _objectiveCcyId;
      _objectiveCcyId = newCcyId;
    });
    _amountConversion();
  }

  //计算兑换金额
  _amountConversion() {
    for (var i = 0; i < rateList.length; i++) {
      setState(() {
        if (_amtController.text != '') {
          AiDecimalAccuracy _amount =
              AiDecimalAccuracy.parse(_amtController.text);
          AiDecimalAccuracy _rate =
              AiDecimalAccuracy.parse(rateList[i]['buying']);

          if (rateList[i]['ccy'] == _objectiveCcy) {
            double newAmt = _isSwap
                ? (_amount / _rate).toDouble()
                : (_amount * _rate).toDouble();
            _primitiveCcyAmt = newAmt.toStringAsFixed(4);
          }

          if (rateList[i]['ccy'] == _primitiveCcy) {
            double newAmt = _isSwap
                ? (_amount * _rate).toDouble()
                : (_amount / _rate).toDouble();
            _primitiveCcyAmt = newAmt.toStringAsFixed(4);
          }
        } else {
          _primitiveCcyAmt = '0.00';
        }
      });
    }
  }

  Future _getExchangeRateList() async {}
}
