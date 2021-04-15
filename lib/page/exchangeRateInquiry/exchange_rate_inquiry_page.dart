/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 汇率查询
/// Author: CaiTM
/// Date: 2020-12-28

import 'dart:ui';
import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_ex_rate.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/money_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateInquiryPage extends StatefulWidget {
  @override
  _ExchangeRateInquiryPageState createState() =>
      _ExchangeRateInquiryPageState();
}

class _ExchangeRateInquiryPageState extends State<ExchangeRateInquiryPage> {
  // List<String> _primitiveCcyList = ['HKD'];
  List<String> _primitiveCcyList = [];
  // List<String> _objectiveCcyList = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];
  List<String> _objectiveCcyList = [];
  List<RecordLists> rateList = [];
  // List<Map<String, Object>> rateList = [
  //   {'ccy': 'USD', 'selling': '7.8820', 'buying': '7.7524'},
  //   {'ccy': 'EUR', 'selling': '9.6058', 'buying': '9.5005'},
  //   {'ccy': 'GBP', 'selling': '10.6166', 'buying': '10.5376'},
  //   {'ccy': 'CAD', 'selling': '6.2332', 'buying': '6.0684'},
  //   {'ccy': 'AUD', 'selling': '6.1162', 'buying': '5.9481'}
  // ];
  TextEditingController _amtController = TextEditingController();
  String updateDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
  int _primitiveCcyId = 0;
  int _objectiveCcyId = 0;
  String _primitiveCcy = '--';
  String _objectiveCcy = '--';
  String _primitiveCcyAmt = '0.00';
  bool _isSwap = true;
  bool _isLoading = false; //加载状态
  RefreshController _refreshController = new RefreshController();
  FocusNode _focusNode = new FocusNode();

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCcyList();
    _getExchangeRateList();
    // _focusNode.addListener(() {
    //   _amountConversion();
    // });
    _amtController.addListener(() {
      _amountConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_primitiveCcyList.length > 0) {
      setState(() {
        _primitiveCcy = _primitiveCcyList[_primitiveCcyId];
      });
    }
    if (_objectiveCcyList.length > 0) {
      setState(() {
        _objectiveCcy = _objectiveCcyList[_objectiveCcyId];
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.current.exchange_rate),
        centerTitle: true,
      ),
      body: Container(
        color: HsgColors.commonBackground,
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
              color: HsgColors.commonBackground,
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
            // Expanded(
            //   child: RefreshIndicator(
            //     child: _listContent(),
            //     onRefresh: _getExchangeRateList,
            //   ),
            // ),
            Expanded(
              child: _isLoading
                  ? HsgLoading()
                  : rateList.length > 0
                      ? CustomRefresh(
                          controller: _refreshController,
                          onLoading: () {
                            //加载更多完成
                            _refreshController.loadComplete();
                            //显示没有更多数据
                            _refreshController.loadNoData();
                          },
                          onRefresh: () {
                            _getExchangeRateList();
                            _refreshController.refreshCompleted();
                            _refreshController.footerMode.value =
                                LoadStatus.canLoading;
                          },
                          content: _listContent(),
                        )
                      : notDataContainer(context, S.current.no_data_now),
            ),
          ],
        ),
      ),
    );
  }

  Row _listTitle() {
    TextStyle style =
        TextStyle(fontSize: 15, color: HsgColors.secondDegreeText);
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              S.current.currency,
              style: style,
            ),
          ),
        ),
        // Expanded(
        //   child: Center(
        //     child: Text(
        //       S.current.currency,
        //       style: style,
        //     ),
        //   ),
        // ),
        Expanded(
          child: Center(
            child: Text(
              S.current.selling_price,
              style: style,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              S.current.buying_price,
              style: style,
            ),
          ),
        ),
        // Expanded(
        //   child: Center(
        //     child: Text(
        //       '中间价',
        //       style: style,
        //     ),
        //   ),
        // ),
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
                    rateList[index].ccy,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              // Expanded(
              //   child: Center(
              //     child: Text(
              //       rateList[index].ccy2,
              //       style: TextStyle(fontSize: 15),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Center(
                  child: Text(
                    rateList[index].fxSell,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    rateList[index].fxBuy,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              // Expanded(
              //   child: Center(
              //     child: Text(
              //       rateList[index].mid,
              //       style: TextStyle(fontSize: 15),
              //     ),
              //   ),
              // ),
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
      focusNode: _focusNode,
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
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.allow(
          RegExp("[0-9.]"),
        ),
        MoneyTextInputFormatter(),
      ],
      // onChanged: (text) {
      //   _amountConversion();
      // },
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
          child: CurrencyInkWell(
            item: _primitiveCcy,
            onTap: () {
              _currencyShowDialog(true, _primitiveCcyId, _primitiveCcyList);
            },
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 5),
            child: InkWell(
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
          child: CurrencyInkWell(
            item: _objectiveCcy,
            onTap: () {
              _currencyShowDialog(false, _objectiveCcyId, _objectiveCcyList);
            },
          ),
        )
      ],
    );
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

  //货币互换
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

      _amtController.text = '';
      _primitiveCcyAmt = '';
    });
    _amountConversion();
  }

  // //计算兑换金额
  // _amountConversion() {
  //   for (var i = 0; i < rateList.length; i++) {
  //     setState(() {
  //       if (_amtController.text != '') {
  //         AiDecimalAccuracy _amount =
  //             AiDecimalAccuracy.parse(_amtController.text);
  //         AiDecimalAccuracy _rate = AiDecimalAccuracy.parse(rateList[i].fxBuy);

  //         if (rateList[i].ccy == _objectiveCcy) {
  //           double newAmt = _isSwap
  //               ? (_amount / _rate).toDouble()
  //               : (_amount * _rate).toDouble();
  //           _primitiveCcyAmt = newAmt.toStringAsFixed(4);
  //         }

  //         if (rateList[i].ccy == _primitiveCcy) {
  //           double newAmt = _isSwap
  //               ? (_amount * _rate).toDouble()
  //               : (_amount / _rate).toDouble();
  //           _primitiveCcyAmt = newAmt.toStringAsFixed(4);
  //         }
  //       } else {
  //         _primitiveCcyAmt = '0.00';
  //       }
  //     });
  //   }
  // }

//汇率换算
  Future _amountConversion() async {
    double _payerAmount = 0;
    if (_amtController.text == '') {
      if (this.mounted) {
        setState(() {
          _primitiveCcyAmt = '0.00';
        });
      }
    } else {
      _payerAmount = AiDecimalAccuracy.parse(_amtController.text).toDouble();
      // ForexTradingRepository()
      //     .transferTrial(
      //         TransferTrialReq(
      //           amount: _payerAmount,
      //           corrCcy: _objectiveCcy,
      //           defaultCcy: _primitiveCcy,
      //         ),
      //         'TransferTrialReq')
      //     .then((data) {
      //   if (this.mounted) {
      //     setState(() {
      //       _primitiveCcyAmt = data.optExAmt;
      //     });
      //   }
      // }).catchError((e) {
      //   print(e.toString());
      // });
    }
  }

  //获取币种买入卖出列表
  Future _getExchangeRateList() async {
    _isLoading = true;
    ForexTradingRepository()
        .getExRate(GetExRateReq(), 'getExRateReq')
        .then((data) {
      if (data != null) {
        rateList.clear();
        rateList.addAll(data.recordLists);
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }).catchError(() {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  // 获取币种列表
  Future _getCcyList() async {
    final prefs = await SharedPreferences.getInstance();
    //获取本地币种
    _primitiveCcyList.clear();
    _primitiveCcyList.add(prefs.getString(ConfigKey.LOCAL_CCY));
    setState(() {
      _primitiveCcy = _primitiveCcyList[0];
    });
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("CCY"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _objectiveCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _objectiveCcyList.add(e.code);
        });
        if (this.mounted) {
          setState(() {
            _objectiveCcy = _objectiveCcyList[0];
          });
        }
      }
    });
  }
}

class CurrencyInkWell extends StatelessWidget {
  final String item;
  final void Function() onTap;
  CurrencyInkWell({Key key, this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item, style: TextStyle(fontSize: 20)),
          Icon(
            Icons.arrow_drop_down,
            size: 25,
          ),
        ],
      ),
    );
  }
}
