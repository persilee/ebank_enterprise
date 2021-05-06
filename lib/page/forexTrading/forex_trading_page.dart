/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 外汇买卖
/// Author: CaiTM
/// Date: 2020-12-21

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/foreign_ccy.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_ccy_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_ccy_holiday.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_bill.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForexTradingPage extends StatefulWidget {
  @override
  _ForexTradingPageState createState() => _ForexTradingPageState();
}

class _ForexTradingPageState extends State<ForexTradingPage> {
  List<String> _accList = [];
  List<String> _accIcon = [];
  List<String> _payerCcyList = [];
  List<String> _payeeCcyList = [];
  List<RemoteBankCard> cards = [];
  int _payerAccId = -1;
  int _payeeAccId = -1;
  int _payerCcyId = 0;
  int _payeeCcyId = 0;
  String _payerAcc = '';
  String _payeeAcc = '';
  String _payerCcy = '';
  String _payeeCcy = '';
  String _incomeName = '';
  String _incomeBackCode = '';
  String _balance = '0.00';
  TextEditingController _payerTransferController = TextEditingController();
  TextEditingController _payeeTransferController = TextEditingController();
  String _rate = '';
  FocusNode _payerTransferFocusNode = new FocusNode();
  FocusNode _payeeTransferFocusNode = new FocusNode();
  String _holidayFlg = '';
  bool _isHoliday = false;
  String _time = '';
  var _opt = '';

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();

    //转出金额焦点监听
    _payerTransferFocusNode.addListener(() {
      if (_payerTransferFocusNode.hasFocus) {
        if (_payerTransferController.text.length > 0) {
          setState(() {
            _payeeTransferController.text = '';
          });
        }
      } else {
        if (_payerTransferController.text.length > 0) {
          if (double.parse(_payerTransferController.text) <= 0) {
            _payerTransferController.text = '';
            HSProgressHUD.showToastTip(
              S.of(context).input_amount_msg1,
            );
          } else {
            setState(() {
              _opt = 'S';
              _rateCalculate();
            });
          }
        }
      }
      _boolBut();
    });

    //转入金额焦点监听
    _payeeTransferFocusNode.addListener(() {
      if (_payeeTransferFocusNode.hasFocus) {
        if (_payeeTransferController.text.length > 0) {
          setState(() {
            _payerTransferController.text = '';
          });
        }
      } else {
        if (_payeeTransferController.text.length > 0) {
          if (double.parse(_payeeTransferController.text) <= 0) {
            _payeeTransferController.text = '';
            HSProgressHUD.showToastTip(
              S.of(context).input_amount_msg1,
            );
          } else {
            setState(() {
              _opt = 'B';
              _rateCalculate();
            });
          }
        }
      }
      _boolBut();
    });
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
                          FocusScope.of(context).requestFocus(FocusNode());
                          // _openBottomSheet();
                          _submitFormData();
                        }
                      : null,
                  isColor: _boolBut(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _boolBut() {
    if (_payerAcc != '' &&
        _payerCcy != '' &&
        _payeeAcc != '' &&
        _payeeCcy != '' &&
        _payerTransferController.text != '' &&
        _rate != '' &&
        _payeeTransferController.text != '' &&
        !_isHoliday) {
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
          item: _payerAcc,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _accountBottomSheet(true, _payerAccId);
          },
        ),
        SelectInkWell(
          title: S.current.debit_currency,
          item: _payerCcy,
          onTap: _payerAcc == ''
              ? () {
                  HSProgressHUD.showToastTip(
                    S.of(context).forex_trading_msg1,
                  );
                }
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _currencyShowDialog(true, _payerCcyId, _payerCcyList);
                },
        ),
        ItemContainer(
          title: S.current.available_balance,
          item: FormatUtil.formatSringToMoney(_balance),
        ),
        TextFieldContainer(
          title: S.current.debit_amount,
          hintText: S.current.please_input,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _payerTransferController,
          focusNode: _payerTransferFocusNode,
          callback: _boolBut,
          isRegEXp: true,
          regExp: _payerCcy == 'JPY' ? '[0-9]' : '[0-9.]',
          length: 12,
          isMoney: true,
        ),
        SelectInkWell(
          title: S.current.credit_account,
          item: _payeeAcc,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _accountBottomSheet(false, _payeeAccId);
          },
        ),
        SelectInkWell(
          title: S.current.credit_currency,
          item: _payeeCcy,
          onTap: _payeeAcc == ''
              ? () {
                  HSProgressHUD.showToastTip(
                    S.of(context).forex_trading_msg2,
                  );
                }
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _currencyShowDialog(false, _payeeCcyId, _payeeCcyList);
                },
        ),
        TextFieldContainer(
          title: S.current.credit_amount,
          hintText: S.current.please_input,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _payeeTransferController,
          focusNode: _payeeTransferFocusNode,
          callback: _boolBut,
          isRegEXp: true,
          regExp: _payeeCcy == 'JPY' ? '[0-9]' : '[0-9.]',
          length: 12,
          isMoney: true,
        ),
        ItemContainer(
          title: S.current.rate_of_exchange,
          item: _rate,
        ),
      ],
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
            // icons: _accIcon,
            lastSelectedPosition: index,
          );
        });
    if (result != null && result != false) {
      setState(() {
        if (isAcc) {
          _payerAccId = result;
          _payerAcc = _accList[_payerAccId];
          if (_payerAcc != '') {
            _getCardBal(_payerAcc);
          }
        } else {
          _payeeAccId = result;
          _payeeAcc = _accList[_payeeAccId];
          cards.forEach((item) {
            if (_payeeAcc == item.cardNo) {
              _incomeName = item.ciName;
              _incomeBackCode = item.bankCode;
            }
          });
          _getCardCcyList(_payeeAcc);
        }
        _rateCalculate();
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
          _payerCcyId = result;
          _payerCcy = dataList[_payerCcyId];
          if (_payerAcc != '' && _payerCcy != '') {
            _getCardBal(_payerAcc);
          }
          _getCcyHoliday(_payerCcy);
        } else {
          _payeeCcyId = result;
          _payeeCcy = dataList[_payeeCcyId];
          _getCcyHoliday(_payeeCcy);
        }
        _rateCalculate();
      });
    }
  }

  _getCardList() {
    ApiClientAccount().getCardList(GetCardListReq()).then((data) {
      if (data.cardList != null) {
        if (this.mounted) {
          setState(() {
            cards.clear();
            _accIcon.clear();
            cards = data.cardList;
            _accList.clear();
            data.cardList.forEach((item) {
              _accList.add(item.cardNo);
              _accIcon.add(item.imageUrl);
            });
            _accList = _accList.toSet().toList();
          });
        }
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }

  //获取账户可用余额
  _getCardBal(String cardNo) {
    HSProgressHUD.show();
    ApiClientBill()
        .getCardBalByCardNo(GetCardBalReq(cardNo: cardNo))
        .then((data) {
      if (data.cardListBal != null && _payerCcy != S.current.please_select) {
        if (this.mounted) {
          setState(() {
            _balance = '0.00';
            _payerCcyList.clear();
            data.cardListBal.forEach((item) {
              if (_payerCcy == item.ccy) {
                _balance = item.avaBal;
              }
              _payerCcyList.add(item.ccy);
            });
          });
        }
        HSProgressHUD.dismiss();
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
      HSProgressHUD.dismiss();
    });
  }

  //计算汇率
  _rateCalculate() {
    HSProgressHUD.show();
    if (_payerAcc != '' &&
        _payerCcy != '' &&
        _payeeAcc != '' &&
        _payeeCcy != '' &&
        (_payerTransferController.text != '' ||
            _payeeTransferController.text != '')) {
      Transfer()
          .transferTrial(TransferTrialReq(
        opt: _opt,
        buyCcy: _payerCcy,
        sellCcy: _payeeCcy,
        buyAmount: _payerTransferController.text == ''
            ? '0'
            : _payerTransferController.text,
        sellAmount: _payeeTransferController.text == ''
            ? '0'
            : _payeeTransferController.text,
      ))
          .then((data) {
        if (this.mounted) {
          setState(() {
            if (_opt == 'B') {
              _payerTransferController.text = data.optExAmt;
            }
            if (_opt == 'S') {
              _payeeTransferController.text = data.optExAmt;
            }
            _rate = data.optExRate;
            _time = data.optTrTime;
          });
          _boolBut();
        }
        HSProgressHUD.dismiss();
      }).catchError((e) {
        HSProgressHUD.dismiss();
        HSProgressHUD.showToast(e.error);
      });
    } else {
      HSProgressHUD.dismiss();
    }
  }

  _submitFormData() async {
    if (double.parse(_payerTransferController.text) > double.parse(_balance)) {
      HSProgressHUD.showToastTip(
        S.current.tdContract_balance_insufficient,
      );
    } else if (_payerCcy == _payeeCcy && _payerAcc == _payeeAcc) {
      HSProgressHUD.showToastTip(
        S.current.no_account_ccy_transfer,
      );
    } else {
      Map _preview = new Map();
      _preview['buyAmt'] = _payerTransferController.text;
      _preview['buyCcy'] = _payerCcy;
      _preview['buyDac'] = _payerAcc;
      _preview['exRate'] = _rate;
      _preview['exTime'] = _time;
      _preview['prodCd'] = "FXSPTIBK";
      _preview['sellAmt'] = _payeeTransferController.text;
      _preview['sellCcy'] = _payeeCcy;
      _preview['sellDac'] = _payeeAcc;
      Navigator.pushNamed(context, pageForexTradingPreview,
          arguments: _preview);
      // ApiClientBill()
      //     .foreignCcy(
      //   ForeignCcyReq(
      //     _payerTransferController.text,
      //     _payerCcy,
      //     _payerAcc,
      //     _rate,
      //     _time,
      //     "",
      //     "FXSPTIBK",
      //     _payeeTransferController.text,
      //     _payeeCcy,
      //     _payeeAcc,
      //     "",
      //   ),
      // )
      //     .then((data) {
      //   HSProgressHUD.dismiss();
      // HSProgressHUD.showToastTip(
      //   S.current.operate_success,
      // );
      //   Navigator.pop(context, pageIndex);
      // }).catchError((e) {
      //   HSProgressHUD.dismiss();
      // HSProgressHUD.showToast(e.error);
      // });
    }
  }

  //检查假期
  Future _getCcyHoliday(String ccy) async {
    // String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Transfer().getCcyHoliday(GetCcyHolidayReq(ccy, "")).then((data) {
      if (this.mounted) {
        setState(() {
          _holidayFlg = data.holidayFlg;
        });
      }
      if (_holidayFlg == 'Y') {
        HSProgressHUD.showToastTip(
          S.current.forex_trading_msg3,
        );
        if (this.mounted) {
          setState(() {
            _isHoliday = true;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isHoliday = false;
          });
        }
      }
    });
  }

  //获取账号支持币种
  Future _getCardCcyList(String cardNo) async {
    Transfer().getCardCcyList(GetCardCcyListReq(cardNo)).then((data) {
      if (data.recordLists != null) {
        _payeeCcyList.clear();
        data.recordLists.forEach((e) {
          _payeeCcyList.add(e.ccy);
        });
      }
    });
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
