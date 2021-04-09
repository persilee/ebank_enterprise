import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期开立购买页面
/// Author: wangluyao
/// Date: 2020-12-14
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_td_product_term_rate.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract_trial.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/money_text_input_formatter.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class TimeDepositContract extends StatefulWidget {
  final TdepProducHeadDTO productList;
  final List<TdepProductDTOList> producDTOList;
  TimeDepositContract({Key key, this.productList, this.producDTOList})
      : super(key: key);

  @override
  _TimeDepositContractState createState() =>
      _TimeDepositContractState(productList, producDTOList);
}

class _TimeDepositContractState extends State<TimeDepositContract> {
  String _changedAccountTitle = S.current.hint_please_select;
  String _changedSettAcTitle = S.current.hint_please_select;
  String _changedTermBtnTiTle = S.current.hint_please_select;
  String _changedInstructionTitle = S.current.hint_please_select;
  int _acPosition = 0;
  int _settAcPosition = 0;
  String _changedRateTitle = '';
  String accuPeriod = '0';
  String auctCale = '0';
  String depositType = 'A';
  String ccy = '';
  String rate = '0';
  String matAmt = '0.00';
  List<RemoteBankCard> cards = [];
  RemoteBankCard card;
  String custID;
  String _cardCcy = '';
  String _cardBal = '';
  List<String> _cardCcyList = [];
  List<String> _cardBalList = [];
  List<List<CardBalBean>> myCardListBal;

  double bal = 0.00;
  String instCode = '';

  TdepProducHeadDTO productList;
  List<TdepProductDTOList> producDTOList;
  _TimeDepositContractState(this.productList, this.producDTOList);

  TimeDepositContractTrialReq contractTrialReq;
  TextEditingController inputValue = TextEditingController();

  String _amount = '0.00';
  String language = Intl.getCurrentLocale();
  List<String> instructions = [];
  String _checkAmount = '0.00';
  List<String> instructionDatas = [];
  List<String> _termCodes = [];
  List<String> _rates = [];
  List<String> _terms = [];
  List<String> _accuPeriods = [];
  List<String> _auctCales = [];
  String _minAmt = '';
  String _maxAmt = '';

  void initState() {
    super.initState();
    _getTdProdTermRate();

    //网络请求
    _loadData();
    // _first();
    _getInsCode();
  }

//背景色
  Widget _background() {
    return Container(
      color: HsgColors.commonBackground,
      height: 15,
    );
  }

//右箭头图标
  Widget _rightArrow() {
    return Container(
      width: 20,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: HsgColors.nextPageIcon,
      ),
    );
  }

//分割线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Divider(height: 0.5, color: HsgColors.divider),
    );
  }

//垂直分割线
  Widget _verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20.0),
      width: 0.5,
      child: Column(
        children: [
          SizedBox(
            width: 1,
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(color: HsgColors.divider),
            ),
          ),
        ],
      ),
    );
  }

//显示一列文字
  Widget _displayColumn(String upperText, String nextText) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      width: (MediaQuery.of(context).size.width - 60.5) / 2,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              //上文字
              upperText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HsgColors.topText),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              //下文字
              nextText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: upperText == S.current.year_interest_rate
                      ? HsgColors.redText
                      : HsgColors.aboutusTextCon,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

//弹窗按钮左侧文本
  Widget _leftText(String leftText) {
    return Container(
      width: leftText == S.current.tdContract_estimated_payment_amount
          ? ((MediaQuery.of(context).size.width - 12) / 2) - 15
          : ((MediaQuery.of(context).size.width - 32) / 2) - 15,
      child: Text(
        leftText,
        style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 14.0),
      ),
    );
  }

  //显示选择的值
  Widget _display(String display, String leftText) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      width: leftText == S.current.tdContract_estimated_payment_amount
          ? ((MediaQuery.of(context).size.width - 12) / 2) - 10
          : ((MediaQuery.of(context).size.width - 32) / 2) - 10,
      alignment: Alignment.centerRight,
      child: leftText == S.current.payment_account
          ? (display == S.current.hint_please_select
              ? Text(
                  display,
                  style: TextStyle(
                    color: HsgColors.hintText,
                    fontSize: 14.0,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        display,
                        style: TextStyle(
                          color: HsgColors.aboutusTextCon,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Text(
                        S.current.balance_with_value +
                            " " +
                            _cardCcy +
                            ":" +
                            FormatUtil.formatSringToMoney(_cardBal),
                        style: TextStyle(
                          color: HsgColors.secondDegreeText,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ))
          : (display == S.current.hint_please_select
              ? Text(
                  display,
                  style: TextStyle(
                    color: HsgColors.hintText,
                    fontSize: 14.0,
                  ),
                )
              : Column(
                  children: [
                    Text(
                      display,
                      style: TextStyle(
                        color: HsgColors.aboutusTextCon,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                )),
    );
  }

  //显示币种
  Widget _showCcy() {
    return Container(
      child: Text(
        ccy,
        textAlign: TextAlign.center,
        style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 18.0),
      ),
    );
  }

  //到期本息
  Widget _showMatAmt() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Container(
            child: Text(
              S.current.contract_principal_and_interest,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontSize: 13.0,
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            child: Text(
              ccy + ":" + matAmt,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontSize: 13.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //输入本金
  Widget _inputBal() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: TextField(
          controller: inputValue,
          autocorrect: true,
          autofocus: true,
          style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 18.0),
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
            FilteringTextInputFormatter.allow(
              RegExp("[0-9.]"),
            ),
            MoneyTextInputFormatter(),
          ],
          onChanged: (value) {
            double.parse(value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1'));
            //输入金额大于起存金额时进行网络请求,计算到期金额
            if (double.parse(inputValue.text) >= double.parse(_minAmt) &&
                double.parse(inputValue.text) <= double.parse(_maxAmt)) {
              _loadDepositData(
                accuPeriod,
                auctCale,
                double.parse(inputValue.text),
                productList.bppdCode,
                ccy,
                custID,
                depositType,
                '', // tenor
              );
              //获取预计支付金额
              inputValue.addListener(() {
                if (_cardCcy == ccy) {
                  _amount = inputValue.text;
                } else {
                  _rateCalculate();
                }
              });
            } else {
              matAmt = '0.00';
              _amount = '0.00';
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: S.current.deposit_min_with_value + _minAmt,
            hintStyle: TextStyle(
              color: HsgColors.hintText,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  // 产品描述
  Widget _remark() {
    return Container(
      color: HsgColors.commonBackground,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10.0),
      child: Text(
        S.current.no_advance_withdrawal,
        style: TextStyle(
          color: HsgColors.describeText,
          fontSize: 12.0,
        ),
      ),
    );
  }

  // 选择存款期限按钮
  Widget _termChangeBtn(
      BuildContext context, List<TdepProductDTOList> producDTOList) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: FlatButton(
              onPressed: () {
                _selectTerm(context, producDTOList);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _leftText(S.current.deposit_time_limit),
                  _display(_changedTermBtnTiTle, S.current.deposit_time_limit),
                  _rightArrow(),
                ],
              ),
            ),
          ),
          _background(),
        ],
      ),
    );
  }

  //预计支付金额
  Widget _expectedPayment() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: FlatButton(
              onPressed: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _leftText(S.current.tdContract_estimated_payment_amount),
                  _display(
                      _amount, S.current.tdContract_estimated_payment_amount),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//选择付款账户按钮
  Widget _accountChangeBtn() {
    return Container(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _selectAccount(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _leftText(S.current.payment_account),
            _display(_changedAccountTitle, S.current.payment_account),
            _rightArrow(),
          ],
        ),
      ),
    );
  }

  //选择支付币种按钮
  Widget _ccyChangeBtn() {
    return Container(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _selectCcy(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _leftText(S.current.tdContract_payment_currency),
            _display(_cardCcy, S.current.tdContract_payment_currency),
            _rightArrow(),
          ],
        ),
      ),
    );
  }

  //选择结算账户按钮
  Widget _settAcChangeBtn() {
    return Container(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _selectSettAc(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _leftText(S.current.settlement_account),
            _display(_changedSettAcTitle, S.current.settlement_account),
            _rightArrow(),
          ],
        ),
      ),
    );
  }

  //选择到期指示按钮
  Widget _instructionChangeBtn() {
    return Container(
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _selectInstruction(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _leftText(S.current.due_date_indicate),
            _display(_changedInstructionTitle, S.current.due_date_indicate),
            _rightArrow(),
          ],
        ),
      ),
    );
  }

//存款期限弹窗
  _selectTerm(
      BuildContext context, List<TdepProductDTOList> producDTOList) async {
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.current.deposit_time_limit,
        items: _terms,
      ),
    );
    if (this.mounted) {
      setState(() {
        if (result != null && result != false) {
          _changedTermBtnTiTle = _terms[result];
          _changedRateTitle = _rates[result];
          accuPeriod = _accuPeriods[result];
          auctCale = _auctCales[result];
          rate = FormatUtil.formatNum(double.parse(_changedRateTitle), 2);
        } else {
          return;
        }
      });
    }
  }

  //产品名称和年利率
  Widget _titleSection(
      TdepProducHeadDTO tdepProduct, List<TdepProductDTOList> producDTOList) {
    String name;
    String language = Intl.getCurrentLocale();
    if (language == 'zh_CN') {
      name = productList.lclName;
    } else {
      name = productList.engName;
    }
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _displayColumn(S.current.product_name, name),
          _verticalLine(),
          _displayColumn(S.current.year_interest_rate, rate + '%'),
        ],
      ),
    );
  }

  // 本金输入框
  Widget _inputPrincipal(RemoteBankCard card) {
    bal = (inputValue.text).length == 0 ? 0.00 : double.parse(inputValue.text);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0, top: 10),
            child: Row(
              children: [
                _showCcy(),
                _inputBal(),
              ],
            ),
          ),
          _line(),
          _showMatAmt(),
          _background(),
        ],
      ),
    );
  }

//付款账户弹窗
  _selectAccount(BuildContext context) async {
    List<String> bankCards = [];
    List<String> accounts = [];
    List<String> ciNames = [];
    for (RemoteBankCard card in cards) {
      bankCards.add(card.cardNo);
      ciNames.add((card.ciName));
    }
    for (var i = 0; i < bankCards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(bankCards[i]));
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.payment_account,
            items: accounts,
            lastSelectedPosition: _acPosition));
    if (result != null && result != false) {
      _acPosition = result;
      _changedAccountTitle = accounts[result];
      _getCardBal(accounts[result].replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
    } else {
      return;
    }
    if (this.mounted) {
      setState(() {});
    }
  }

//支付币种弹窗
  _selectCcy(BuildContext context) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.tdContract_payment_currency,
              items: _cardCcyList,
            ));
    if (result != null && result != false) {
      _cardCcy = _cardCcyList[result];
      _cardBal = _cardBalList[result];
    } else {
      return;
    }
    if (this.mounted) {
      setState(() {});
    }
    (context as Element).markNeedsBuild();
  }

//结算账户弹窗
  _selectSettAc(BuildContext context) async {
    List<String> bankCards = [];
    List<String> accounts = [];
    List<String> ciNames = [];
    for (RemoteBankCard card in cards) {
      bankCards.add(card.cardNo);
      ciNames.add((card.ciName));
    }
    for (var i = 0; i < bankCards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(bankCards[i]));
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => HsgBottomSingleChoice(
            title: S.current.settlement_account,
            items: accounts,
            lastSelectedPosition: _settAcPosition));
    if (result != null && result != false) {
      _settAcPosition = result;
      _changedSettAcTitle = accounts[result];
    } else {
      return;
    }
    if (this.mounted) {
      setState(() {});
    }
  }

//到期指示弹窗
  _selectInstruction(BuildContext context) async {
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) => BottomMenu(
        title: S.current.due_date_indicate,
        items: instructions,
      ),
    );
    if (this.mounted) {
      setState(() {
        if (result != null && result != false) {
          _changedInstructionTitle = instructions[result];
          instCode = instructionDatas[result];
        } else {
          return {_changedInstructionTitle, instCode};
        }
      });
    }
  }

  _ifClick() {
    if (matAmt == '0.00' ||
        _changedTermBtnTiTle == S.current.hint_please_select ||
        _changedAccountTitle == S.current.hint_please_select ||
        _changedSettAcTitle == S.current.hint_please_select ||
        _changedInstructionTitle == S.current.hint_please_select) {
      return false;
    } else {
      return true;
    }
  }

  //确认按钮
  Widget _submitButton() {
    return Container(
      height: 45,
      margin: EdgeInsets.fromLTRB(30, 40, 30, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _ifClick()
              ? [
                  Color(0xFF1775BA),
                  Color(0xFF3A9ED1),
                ]
              : [HsgColors.btnDisabled, HsgColors.btnDisabled],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ButtonTheme(
        height: 45,
        child: FlatButton(
          onPressed: !_ifClick()
              ? null
              : () {
                  if (double.parse(_cardBal) < double.parse(_checkAmount)) {
                    Fluttertoast.showToast(
                      msg: S.current.tdContract_balance_insufficient,
                      gravity: ToastGravity.CENTER,
                    );
                  } else {
                    _loadContractData(
                      accuPeriod,
                      rate,
                      auctCale,
                      bal,
                      productList.bppdCode,
                      ccy,
                      custID,
                      depositType,
                      instCode,
                      _changedAccountTitle.replaceAll(
                          new RegExp(r"\s+\b|\b\s"), ""),
                      '',
                      productList.engName,
                      _changedSettAcTitle.replaceAll(
                          new RegExp(r"\s+\b|\b\s"), ""),
                      '',
                      '',
                    );
                  }
                },
          disabledColor: HsgColors.btnDisabled,
          child: Text(
            S.current.deposit_now,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.deposit_open),
        elevation: 1,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            _background(),
            _titleSection(
              //产品名称和年利率
              productList,
              producDTOList,
            ),
            _remark(), // 产品描述
            _termChangeBtn(context, producDTOList), // 选择存款期限
            _inputPrincipal(card), // 本金输入框
            _accountChangeBtn(), //选择付款账户
            _line(),
            _ccyChangeBtn(), //选择支付币种
            _line(),
            _expectedPayment(),
            _line(),
            _settAcChangeBtn(), //结算账户
            _line(),
            _instructionChangeBtn(), //选择到期指示
            _submitButton(),
          ],
        ),
      ),
    );
  }

//获取卡列表
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    custID = prefs.getString(ConfigKey.CUST_ID);
    CardDataRepository().getCardList('getCardList').then(
      (data) {
        if (data.cardList != null) {
          if (this.mounted) {
            setState(() {
              cards.clear();
              cards.addAll(data.cardList);
              _changedAccountTitle = FormatUtil.formatSpace4(cards[0].cardNo);
              _getCardBal(
                  cards[0].cardNo.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
            });
          }
        }
      },
    ).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    double _payerAmount = 0;
    if ((inputValue.text).length == 0 ||
        double.parse(inputValue.text) < double.parse(_minAmt) ||
        double.parse(inputValue.text) > double.parse(_maxAmt)) {
      if (this.mounted) {
        setState(() {
          _amount = '0.00';
        });
      }
    } else if (_cardCcy == ccy) {
      _amount = FormatUtil.formatSringToMoney((inputValue.text).toString());
    } else {
      _payerAmount = AiDecimalAccuracy.parse(inputValue.text).toDouble();
      ForexTradingRepository()
          .transferTrial(
              TransferTrialReq(
                  amount: _payerAmount, corrCcy: _cardCcy, defaultCcy: ccy),
              'TransferTrialReq')
          .then((data) {
        if (this.mounted) {
          setState(() {
            _amount = FormatUtil.formatSringToMoney((data.optExAmt).toString());
            _checkAmount = data.optExAmt;
          });
        }
      });
    }
  }

  //数据初值
  void _first() {
    _changedTermBtnTiTle = _terms[0];
    accuPeriod = _accuPeriods[0];
    auctCale = _auctCales[0];
    rate = FormatUtil.formatNum(double.parse(_rates[0]), 2);
  }

  //判断存期
  _term(int i) {
    switch (_termCodes[i]) {
      case 'D001':
        _changedTermBtnTiTle = ('1' + S.current.tdContract_day);
        accuPeriod = '1';
        auctCale = '1';
        break;
      case 'D007':
        _changedTermBtnTiTle = ('7' + S.current.tdContract_day);
        accuPeriod = '1';
        auctCale = '7';
        break;
      case 'M001':
        _changedTermBtnTiTle = ('1' + S.current.months);
        accuPeriod = '2';
        auctCale = '1';
        break;
      case 'M002':
        _changedTermBtnTiTle = ('2' + S.current.months);
        accuPeriod = '2';
        auctCale = '2';
        break;
      case 'M003':
        _changedTermBtnTiTle = ('3' + S.current.months);
        accuPeriod = '2';
        auctCale = '3';
        break;
      case 'M004':
        _changedTermBtnTiTle = ('4' + S.current.months);
        accuPeriod = '2';
        auctCale = '4';
        break;
      case 'M005':
        _changedTermBtnTiTle = ('5' + S.current.months);
        accuPeriod = '2';
        auctCale = '5';
        break;
      case 'M006':
        _changedTermBtnTiTle = ('6' + S.current.months);
        accuPeriod = '2';
        auctCale = '6';
        break;
      case 'M007':
        _changedTermBtnTiTle = ('7' + S.current.months);
        accuPeriod = '2';
        auctCale = '7';
        break;
      case 'M008':
        _changedTermBtnTiTle = ('8' + S.current.months);
        accuPeriod = '2';
        auctCale = '8';
        break;
      case 'M009':
        _changedTermBtnTiTle = ('9' + S.current.months);
        accuPeriod = '2';
        auctCale = '9';
        break;
      case 'M010':
        _changedTermBtnTiTle = ('10' + S.current.months);
        accuPeriod = '2';
        auctCale = '10';
        break;
      case 'M011':
        _changedTermBtnTiTle = ('11' + S.current.months);
        accuPeriod = '2';
        auctCale = '11';
        break;
      case 'M015':
        _changedTermBtnTiTle = ('15' + S.current.months);
        accuPeriod = '2';
        auctCale = '15';
        break;
      case 'Y001':
        _changedTermBtnTiTle = ('1' + S.current.year);
        accuPeriod = '5';
        auctCale = '1';
        break;
      case 'Y002':
        _changedTermBtnTiTle = ('2' + S.current.year);
        accuPeriod = '5';
        auctCale = '2';
        break;
      case 'Y003':
        _changedTermBtnTiTle = ('3' + S.current.year);
        accuPeriod = '5';
        auctCale = '3';
        break;
      case 'Y004':
        _changedTermBtnTiTle = ('4' + S.current.year);
        accuPeriod = '5';
        auctCale = '4';
        break;
      case 'Y005':
        _changedTermBtnTiTle = ('5' + S.current.year);
        accuPeriod = '5';
        auctCale = '5';
        break;
      case 'Y006':
        _changedTermBtnTiTle = ('6' + S.current.year);
        accuPeriod = '5';
        auctCale = '6';
        break;
    }
  }

  Future<void> _loadDepositData(
      String accuPeriod,
      String auctCale,
      double bal,
      String bppdCode,
      String ccy,
      String ciNo,
      String depositType,
      String tenor) async {
    TimeDepositDataRepository()
        .getTimeDepositContractTrial(
            TimeDepositContractTrialReq(accuPeriod, auctCale, bal, bppdCode,
                ccy, ciNo, depositType, tenor),
            'getTimeDepositContractTrial')
        .then((value) {
      if (this.mounted) {
        setState(() {
          matAmt = FormatUtil.formatSringToMoney((value.matAmt).toString());
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //获取付款账户余额
  _getCardBal(String cardNo) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
    }).then((value) {
      value.forEach((element) {
        if (this.mounted) {
          setState(() {
            // if (_cardBal == '' || _cardCcy == S.current.hint_please_select) {
            if (element.cardListBal.length > 0) {
              _cardBal = element.cardListBal[0].currBal;
              _cardCcy = element.cardListBal[0].ccy;
            }
            // }
            _cardBalList.clear();
            _cardCcyList.clear();
            element.cardListBal.forEach((element) {
              _cardCcyList.add(element.ccy);
              _cardBalList.add(element.currBal);
            });
            _rateCalculate();
          });
        }
      });
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //获取到期指示列表
  Future _getInsCode() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("EXP_IN"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        data.publicCodeGetRedisRspDtoList.forEach((element) {
          if (this.mounted) {
            setState(() {
              if (language == 'zh_CN') {
                instructions.add(element.cname);
              } else {
                instructions.add(element.name);
              }
              instructionDatas.add(element.code);
            });
          }
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //立即存入接口
  Future<void> _loadContractData(
      String accuPeriod,
      String annualInterestRate,
      String auctCale,
      double bal,
      String bppdCode,
      String ccy,
      String ciNo,
      String depositType,
      String instCode,
      String oppAc,
      String payPassword,
      String prodName,
      String settDdAc,
      String smsCode,
      String tenor) async {
    if (this.mounted) {
      setState(() {});
    }
    HSProgressHUD.show();
    print('accuPeriod===$accuPeriod');
    TimeDepositDataRepository()
        .getTimeDepositContract(
            TimeDepositContractReq(
                accuPeriod,
                annualInterestRate,
                auctCale,
                bal,
                bppdCode,
                ccy,
                ciNo,
                depositType,
                instCode,
                oppAc,
                payPassword,
                prodName,
                settDdAc,
                smsCode,
                tenor),
            'getTimeDepositContract')
        .then((value) {
      if (this.mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          Navigator.popAndPushNamed(context, pageDepositRecordSucceed,
              arguments: 'timeDepositProduct');
        });
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {});
      }
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //获取定期产品利率和存期
  Future _getTdProdTermRate() async {
    print('productListCCy   +  ${productList.ccy}');
    print('productList.bppdCode   +  ${productList.bppdCode}');

    if (this.mounted) {
      setState(() {});
    }
    HSProgressHUD.show();
    TimeDepositDataRepository()
        .getTdProductTermRate(
            GetTdProductTermRateReq(productList.ccy, productList.bppdCode),
            'getTdProdTermRate')
        .then((data) {
      if (this.mounted) {
        setState(() {
          if (data != null) {
            ccy = data.ccy;
            _minAmt = data.minAmt;
            _maxAmt = data.maxAmt;
            if (data.recordLists != null) {
              data.recordLists.forEach((value) {
                _termCodes.add(value.term);
                _rates.add(value.intRat);
              });
              for (int i = 0; i < _termCodes.length; i++) {
                _term(i);
                _terms.add(_changedTermBtnTiTle);
                _accuPeriods.add(accuPeriod);
                _auctCales.add(auctCale);
              }
            }
            _first();
          }
        });
        HSProgressHUD.dismiss();
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
