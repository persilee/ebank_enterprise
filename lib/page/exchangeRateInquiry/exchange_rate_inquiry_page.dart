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
  List<String> ccyList1 = ['HKD'];
  List<String> ccyList2 = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];
  List<Map<String, Object>> rateList = [
    {'ccy': 'USD', 'sellingPrice': '7.7474', 'buyingPrice': '7.7527'},
    {'ccy': 'EUR', 'sellingPrice': '9.0412', 'buyingPrice': '9.0668'},
    {'ccy': 'GBP', 'sellingPrice': '9.8144', 'buyingPrice': '9.8483'},
    {'ccy': 'CAD', 'sellingPrice': '5.8003', 'buyingPrice': '5.8195'},
    {'ccy': 'AUD', 'sellingPrice': '5.5100', 'buyingPrice': '5.5331'}
  ];
  TextEditingController _amtController = TextEditingController();
  String updateDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
  int _localCcyId = 0;
  int _foreignCcyId = 0;
  String _localCcy = '';
  String _foreignCcy = '';
  String _foreignAmt = '0.00';
  bool _isSwap = true;

  @override
  Widget build(BuildContext context) {
    _localCcy = ccyList1[_localCcyId];
    _foreignCcy = ccyList2[_foreignCcyId];
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
                    child: _localAmtInput(),
                  ),
                  Container(
                    width: 40,
                  ),
                  Expanded(
                    child: _foreignAmtInput(),
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
              padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
              child: _listTitle(),
            ),
            Expanded(
              child: _listContent(),
            ),
          ],
        ),
      ),
    );
  }

  Row _listTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          S.current.currency,
          style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
        ),
        Text(
          S.current.selling_price,
          style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
        ),
        Text(
          S.current.buying_price,
          style: TextStyle(fontSize: 16, color: HsgColors.secondDegreeText),
        ),
      ],
    );
  }

  ListView _listContent() {
    return ListView.builder(
      itemCount: rateList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: _boxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                rateList[index]['ccy'],
                style: TextStyle(fontSize: 16),
              ),
              Text(
                rateList[index]['sellingPrice'],
                style: TextStyle(fontSize: 16),
              ),
              Text(
                rateList[index]['buyingPrice'],
                style: TextStyle(fontSize: 16),
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

  TextField _foreignAmtInput() {
    return TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: _foreignAmt,
        enabled: false,
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 20,
          color: _foreignAmt != '0.00' ? Colors.black : HsgColors.textHintColor,
        ),
      ),
    );
  }

  TextField _localAmtInput() {
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

  Row _getCurrencyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              _currencyList(true, _localCcyId, ccyList1);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _localCcy,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
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
        Container(
          width: 70,
          child: GestureDetector(
            onTap: () {
              _currencyList(false, _foreignCcyId, ccyList2);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _foreignCcy,
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
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
          _localCcyId = result;
          _localCcy = dataList[_localCcyId];
        } else {
          _foreignCcyId = result;
          _foreignCcy = dataList[_foreignCcyId];
        }
      });
      _amountConversion();
    }
  }

  //转换
  _currencySwap() async {
    List<String> newList = [];
    int newId = 0;
    setState(() {
      if (_amtController.text != '') {
        _isSwap = false;
      }
      newList = ccyList1;
      ccyList1 = ccyList2;
      ccyList2 = newList;

      newId = _localCcyId;
      _localCcyId = _foreignCcyId;
      _foreignCcyId = newId;

      _amountConversion();
    });
  }

  //计算转换金额
  _amountConversion() async {
    rateList.forEach((element) {
      if (element['ccy'] == _foreignCcy) {
        setState(() {
          if (_amtController.text != '') {
            double newAmt = _isSwap
                ? AiDecimalAccuracy.parse(_amtController.text).toDouble() /
                    AiDecimalAccuracy.parse(element['buyingPrice']).toDouble()
                : AiDecimalAccuracy.parse(_amtController.text).toDouble() *
                    AiDecimalAccuracy.parse(element['buyingPrice']).toDouble();
            _foreignAmt = newAmt.toStringAsFixed(2);
          } else {
            _foreignAmt = '0.00';
          }
        });
      }

      if (element['ccy'] == _localCcy) {
        setState(() {
          if (_amtController.text != '') {
            double newAmt = _isSwap
                ? AiDecimalAccuracy.parse(_amtController.text).toDouble() *
                    AiDecimalAccuracy.parse(element['buyingPrice']).toDouble()
                : AiDecimalAccuracy.parse(_amtController.text).toDouble() /
                    AiDecimalAccuracy.parse(element['buyingPrice']).toDouble();
            _foreignAmt = newAmt.toStringAsFixed(2);
          } else {
            _foreignAmt = '0.00';
          }
        });
      }
    });
  }
}
