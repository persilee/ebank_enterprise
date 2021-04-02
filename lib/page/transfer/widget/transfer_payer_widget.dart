import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/forexTrading/forex_trading_page.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账方法
/// Author: lijiawei
/// Date: 2020-12-09
class TransferPayerWidget extends StatefulWidget {
  @override
  _TransferPayerWidgetState createState() => new _TransferPayerWidgetState();
}

class _TransferPayerWidgetState extends State<TransferPayerWidget> {
  //转入币种
  String _payCcy = '';
  List<String> _payCcyList = [];
  int _payIndex = 0;

  //支付币种
  String _transferCcy = '';
  int _transferIndex = 0;
  List<String> _transferCcyList = [];

  //本地币种
  String _localeCcy = '';

  //账户选择
  String _account = '';
  List<String> _accountList = [];
  int _accountIndex = 0;

  //余额
  String _balance = '';
  List<String> _balanceList = [];

  //预计收款金额
  String _amount = '0';

  //限额
  String _limit = '';

  //汇率
  String _rate = '';

  var _transferMoneyController = new TextEditingController();

  Map data = new Map();

  @override
  void initState() {
    super.initState();
    _loadTransferData();

    _transferMoneyController.addListener(() {
      if (_transferMoneyController.text.length == 0) {
        _amount = '0';
        _rate = '-';
      }
      _rateCalculate();
    });
  }

  @override
  void dispose() {
    _transferMoneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data['payCcy'] = _payCcy;
    data['transferCcy'] = _transferCcy;
    data['account'] = _account;
    data['amount'] = _amount;
    data['rate'] = _rate;

    return SliverToBoxAdapter(
      child: Container(
        child: TransferWidget(
          data: data,
          child: Column(
            children: [
              _limitWidget(_limit),
              _transferAccount(context),
              _fullLine(),
              _transferAmount(context),
              _fullLine(),
              _transferCcyWidget(context),
              _fullLine(),
              _estimatedAmount(),
            ],
          ),
        ),
      ),
    );
  }

  //限额
  Widget _limitWidget(String limit) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.transfer_amount,
            style: TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
          ),
          // Text(
          //   S.current.tran_limit_amt_with_value +
          //       '：' +
          //       FormatUtil.formatSringToMoney(limit),
          //   style: TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
          // ),
        ],
      ),
    );
  }

  //转账金额
  Widget _transferAmount(context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Text(S.current.transfer_amount),
          ),
          Container(
            child: FlatButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                payCcyDialog();
              },
              child: Row(
                children: [
                  _inputAmount(context),
                  _ccyWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //金额输入
  Widget _inputAmount(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.7,
      child: TextField(
        //是否自动更正
        autocorrect: false,
        //是否自动获得焦点
        autofocus: false,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 18,
          color: HsgColors.firstDegreeText,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
          LengthLimitingTextInputFormatter(12),
        ],
        controller: _transferMoneyController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.current.int_input_tran_amount,
          hintStyle: TextStyle(
            fontSize: 16,
            color: HsgColors.textHintColor,
          ),
        ),
        onChanged: (text) {
          // callback();
        },
      ),
    );
  }

  //币种
  Widget _ccyWidget() {
    return Row(
      children: [
        Container(
          // padding: EdgeInsets.only(left: 3),
          margin: EdgeInsets.only(left: 3),
          child: Text(
            _payCcy,
            style: TextStyle(
              color: HsgColors.firstDegreeText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        Icon(
          // Icons.arrow_drop_down,
          Icons.keyboard_arrow_down,
          color: Color(0xff282828),
          // color: HsgColors.firstDegreeText,
        ),
      ],
    );
  }

  //转出账户
  _transferAccount(context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            child: Text(
              S.current.transfer_from_account,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _accountDialog();
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _account,
                        style:
                            TextStyle(color: Color(0xff262626), fontSize: 14),
                      ),
                      Text(
                        S.current.balance_with_value +
                            '：' +
                            _payCcy +
                            ' ' +
                            FormatUtil.formatSringToMoney(_balance),
                        style:
                            TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Image(
                  color: HsgColors.firstDegreeText,
                  image: AssetImage(
                      'images/home/listIcon/home_list_more_arrow.png'),
                  width: 7,
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //转出币种
  _transferCcyWidget(context) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      color: Colors.white,
      child: SelectInkWell(
        title: S.current.transfer_from_ccy,
        item: _transferCcy,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          transferCcyDialog();
        },
      ),
    );
  }

  //预计金额
  // Widget _estimatedAmount() {
  //   return Container(
  //       padding: EdgeInsets.all(15),
  //       color: Colors.white,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             width: 150,
  //             child: Text(
  //               S.current.estimated_collection_amount,
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           Text(FormatUtil.formatSringToMoney(amount)),
  //         ],
  //       ));
  // }

  //预计金额
  Widget _estimatedAmount() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            child: Text(
              S.current.estimated_collection_amount,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                FormatUtil.formatSringToMoney(_amount),
                style: TextStyle(color: Color(0xff262626), fontSize: 14),
              ),
              Text(
                S.current.rate_of_exchange + '：' + _rate,
                style: TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //实线
  _fullLine() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Divider(
        color: HsgColors.divider,
        height: 0.5,
      ),
    );
  }

  //币种弹窗
  Future payCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _payCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _payIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payIndex = result;
        _payCcy = _payCcyList[result];
      });
      // _getCardTotal(_account);
      _loadData(_account);
    }
  }

  Future transferCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _transferCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _transferIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _transferIndex = result;
        _transferCcy = _transferCcyList[result];
      });
      // if (_payCcy == _transferCcy) {
      //   setState(() {
      //     _amount = _transferMoneyController.text;
      //     _xRate = '1';
      //   });
      // } else {
      //   _rateCalculate();
      // }
    }
    _rateCalculate();
  }

  //账号弹窗
  _accountDialog() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: _accountList,
            lastSelectedPosition: _accountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accountIndex = result;
        _account = _accountList[result];
      });
      // _getCardTotal(_account);
      _loadData(_account);
    }
  }

  //默认初始卡号
  _loadTransferData() async {
    final prefs = await SharedPreferences.getInstance();
    _localeCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    Future.wait({
      CardDataRepository().getCardList('GetCardList'),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          if (this.mounted) {
            setState(() {
              //付款方卡号
              _account = element.cardList[0].cardNo;
              element.cardList.forEach((e) {
                _accountList.add(e.cardNo);
              });
            });
          }
          _loadData(_account);
          _loadLocalCcy();
        }
      });
    });
  }

  _loadData(String cardNo) async {
    CardDataRepository()
        .getCardBalByCardNo(GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq')
        .then((element) {
      if (this.mounted) {
        setState(() {
          //初始币种和余额
          if (_payCcy == '' || _balance == '') {
            _payCcy = element.cardListBal[0].ccy;
            _balance = element.cardListBal[0].currBal;
            element.cardListBal.forEach((element) {
              if (element.ccy == _localeCcy) {
                _payCcy = element.ccy;
                _balance = element.currBal;
              }
            });
          }
          _payCcyList.clear();
          _balanceList.clear();
          _payIndex = 0;
          element.cardListBal.forEach((element) {
            _payCcyList.add(element.ccy);
            _balanceList.add(element.currBal);
          });
          if (_payCcyList.length == 0) {
            _payCcyList.add(_localeCcy);
            _balanceList.add('0.0');
          }
          if (_payCcyList.length > 1) {
            for (int i = 0; i < _payCcyList.length; i++) {
              if (_payCcy == _payCcyList[i]) {
                _balance = _balanceList[i];
                break;
              } else {
                _payIndex++;
              }
            }
          } else {
            _payCcy = _payCcyList[0];
            _balance = _balanceList[0];
          }
          if (!_payCcyList.contains(_payCcy)) {
            _payCcy = _payCcyList[0];
            _balance = _balanceList[0];
            _payIndex = 0;
          }
          _getTransferCcySamePayCcy();
          _rateCalculate();
        });
      }
    }).catchError((e) {});
  }

  //收款方币种与转账币种相同
  _getTransferCcySamePayCcy() {
    setState(() {
      _transferIndex = 0;
      for (int i = 0; i < _transferCcyList.length; i++) {
        if (_transferCcyList[i] == _payCcy) {
          _transferCcy = _payCcy;
          break;
        } else {
          _transferIndex++;
        }
      }
    });
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("CCY"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _transferCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _transferCcyList.add(e.code);
        });
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    double _payerAmount = 0;
    if (_transferMoneyController.text == '') {
      if (this.mounted) {
        setState(() {
          _amount = '0';
          _rate = '-';
        });
      }
    } else {
      _payerAmount =
          AiDecimalAccuracy.parse(_transferMoneyController.text).toDouble();
      ForexTradingRepository()
          .transferTrial(
              TransferTrialReq(
                  amount: _payerAmount,
                  corrCcy: _transferCcy,
                  defaultCcy: _payCcy),
              'TransferTrialReq')
          .then((data) {
        if (this.mounted) {
          setState(() {
            _amount = data.optExAmt;
            _rate = data.optExRate;
          });
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }
}
