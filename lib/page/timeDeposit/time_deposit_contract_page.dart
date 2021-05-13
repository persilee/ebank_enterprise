import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 定期开立购买页面
/// Author: wangluyao
/// Date: 2020-12-14
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract_trial.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_td_prod_inst_code.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_td_product_term_rate.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/money_text_input_formatter.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class TimeDepositContract extends StatefulWidget {
  // final TdepProducHeadDTO productList; //头部文件
  // final List<TdepProductDTOList> producDTOList;//详情列表文件
  final TdepProductDTOList producDTOList;
  TimeDepositContract({Key key, this.producDTOList}) // 哈哈标记  this.productList,
      : super(key: key);

  @override
  _TimeDepositContractState createState() =>
      _TimeDepositContractState(producDTOList); //哈哈标记
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
  List<String> cards = [];
  RemoteBankCard card;
  String custID;
  String _cardCcy = '';
  String _cardBal = '';
  List<String> _cardCcyList = [];
  List<String> _cardBalList = [];
  List<List<CardBalBean>> myCardListBal;
  String _prodType = '';

  double bal = 0.00;
  String instCode = '';

  // TdepProducHeadDTO productList;
  // List<TdepProductDTOList> producDTOList;//列表
  TdepProductDTOList _detailProducDTOList;

  _TimeDepositContractState(this._detailProducDTOList); //哈哈标记 this.productList

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
  bool _isShow = false;
  // bool _showTermRate = false;
  bool _isDeposit = false;

  void initState() {
    super.initState();
    _network();
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

  //存入金额提示
  Widget _amountPrompt() {
    if ((inputValue.text).length == 0) {
      _isShow = false;
    }
    return !_isShow
        ? Container()
        : Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(top: 10.0, left: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _amountPromptShowStr(),
                    style: TextStyle(
                      color: HsgColors.redText,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  String _amountPromptShowStr() {
    String showStr = '';

    if (double.parse(_maxAmt) <= 0) {
      showStr = S.current.tdContract_min_amount +
          FormatUtil.formatSringToMoney(_minAmt.toString());
    } else if (double.parse(inputValue.text) <= double.parse(_minAmt)) {
      showStr = S.current.tdContract_min_amount +
          FormatUtil.formatSringToMoney(_minAmt.toString());
    } else {
      showStr = S.current.tdContract_max_amount +
          FormatUtil.formatSringToMoney(_maxAmt.toString());
    }

    return showStr;
  }

  //到期本息
  Widget _showMatAmt() {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 15.0, bottom: 10.0),
      child: Row(
        children: [
          Container(
            child: Text(
              S.current.contract_settlement_amt,
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
          autofocus: false,
          style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 18.0),
          inputFormatters: [
            // LengthLimitingTextInputFormatter(12),
            FilteringTextInputFormatter.allow(
              ccy == 'JPY' ? RegExp("[0-9]") : RegExp("[0-9.]"),
            ),
            MoneyTextInputFormatter(),
          ],
          onChanged: (value) {
            double.parse(value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1'));
            //输入金额大于起存金额时进行网络请求,计算到期金额
            if (double.parse(_maxAmt) > 0) {
              // 有做限制的
              if (double.parse(inputValue.text) >= double.parse(_minAmt) &&
                  double.parse(inputValue.text) <= double.parse(_maxAmt)) {
                _requestTotalData(); //进行试算
              } else {
                matAmt = '0.00';
                _amount = '0.00';
                _isShow = true;
              }
            } else {
              //存款没有限制
              if (double.parse(inputValue.text) >= double.parse(_minAmt)) {
                _requestTotalData(); //进行试算
              } else {
                matAmt = '0.00';
                _amount = '0.00';
                _isShow = true;
              }
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: S.current.deposit_min_with_value +
                FormatUtil.formatSringToMoney(widget.producDTOList
                    .minAmt), //占位文本   _minAmt.toString() producDTOList.minAmt
            hintStyle: TextStyle(
              color: HsgColors.hintText,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  void _requestTotalData() {
    _isShow = false;
    //获取预计支付金额
    _rateCalculate();

    _loadDepositData(
      accuPeriod,
      auctCale,
      double.parse(inputValue.text),
      _detailProducDTOList.bppdCode, //哈哈标记
      ccy,
      custID,
      depositType,
      '', // tenor
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
  Widget _termChangeBtn(BuildContext context) {
    //哈哈标记  List<TdepProductDTOList> producDTOList
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: FlatButton(
              onPressed: () {
                _selectTerm(context); //哈哈标记
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
  _selectTerm(BuildContext context) async {
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
        }
      });

      //选择之后需要进行试算
      if (double.parse(inputValue.text) >= double.parse(_minAmt)) {
        _requestTotalData(); //进行试算
        setState(() {});
      } else {
        setState(() {
          matAmt = '0.00';
          _amount = '0.00';
          _isShow = true;
        });
      }
    }
  }

  //产品名称和年利率
  Widget _titleSection() {
    // 哈哈标记 TdepProducHeadDTO tdepProduct
    //List<TdepProductDTOList> producDTOList 哈哈标记
    String name;
    String language = Intl.getCurrentLocale();
    if (language.contains('en')) {
      name = _detailProducDTOList.engName;
    } else {
      name = _detailProducDTOList.lclName;
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
          _amountPrompt(),
          _showMatAmt(),
          _background(),
        ],
      ),
    );
  }

//付款账户弹窗
  _selectAccount(BuildContext context) async {
    List<String> accounts = [];
    for (var i = 0; i < cards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(cards[i]));
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
      _rateCalculate();
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
    List<String> accounts = [];
    for (var i = 0; i < cards.length; i++) {
      accounts.add(FormatUtil.formatSpace4(cards[i]));
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

//判断是否可以点击
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
      margin: EdgeInsets.fromLTRB(30, 40, 30, 30),
      child: CustomButton(
        isLoading: _isDeposit,
        isEnable: _ifClick(),
        isOutline: false,
        margin: EdgeInsets.all(0),
        text: Text(
          S.current.deposit_now,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
        clickCallback: () {
          if (double.parse(_cardBal) < double.parse(_checkAmount)) {
            HSProgressHUD.showToastTip(
              S.current.tdContract_balance_insufficient,
            );
          } else {
            String productName;
            String language = Intl.getCurrentLocale();
            if (language.contains('en')) {
              productName = _detailProducDTOList.engName;
            } else {
              productName = _detailProducDTOList.lclName;
            }

            String oppAc =
                _changedAccountTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
            String settDdAc =
                _changedSettAcTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
            String stlAc = settDdAc;
            if (_prodType == '020' && instCode == '3') {
              stlAc = '';
            } else if (_prodType == '027' && instCode == '6') {
              stlAc = '';
            }

            TimeDepositContractReq reqData = TimeDepositContractReq(
              accuPeriod,
              rate,
              auctCale,
              bal,
              _detailProducDTOList.bppdCode,
              ccy,
              custID,
              depositType,
              instCode,
              oppAc,
              '',
              _detailProducDTOList.engName,
              stlAc,
              '',
              '',
              intAc: _prodType == '020' ? '' : settDdAc,
            );

            Navigator.pushNamed(context, pageTimeDepositContractPreview,
                arguments: {
                  'productName': productName ?? '',
                  'depositTerm': _changedTermBtnTiTle ?? '',
                  'instructions': _changedInstructionTitle ?? '',
                  'reqData': reqData
                });

            // _loadContractData(
            //   accuPeriod,
            //   rate,
            //   auctCale,
            //   bal,
            //   _detailProducDTOList.bppdCode, //哈哈
            //   ccy,
            //   custID,
            //   depositType,
            //   instCode,
            //   _changedAccountTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            //   '',
            //   _detailProducDTOList.engName, //哈哈标记改动
            //   _changedSettAcTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            //   '',
            //   '',
            // );
          }
        },
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
        child:
            // _showTermRate
            //     ? HsgLoading()
            // :
            ListView(
          children: [
            _background(),
            _titleSection(
                //产品名称和年利率
                // productList,
                // producDTOList,//哈哈标记
                ),
            _remark(), // 产品描述
            _termChangeBtn(context), // 选择存款期限
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

  Future<void> _network() async {
    HSProgressHUD.show();

    await _getTdProdTermRate();

    await _loadData();

    await _getInsCode();

    HSProgressHUD.dismiss();
  }

//获取卡列表
  Future<bool> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    custID = prefs.getString(ConfigKey.CUST_ID);
    // CardDataRepository()
    try {
      GetCardListResp resp =
          await ApiClientAccount().getCardList(GetCardListReq());
      if (resp.cardList != null) {
        if (this.mounted) {
          setState(() {
            cards.clear();
            // cards.addAll(data.cardList);
            resp.cardList.forEach((element) {
              bool isContainer = cards.contains(element.cardNo);
              if (!isContainer) {
                cards.add(element.cardNo);
              }
            });
            cards = cards.toSet().toList();
            _changedAccountTitle = FormatUtil.formatSpace4(cards[0]);
            _getCardBal(cards[0].replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
          });
        }
      }
      return true;
    } catch (e) {
      HSProgressHUD.showToast(e);
      return false;
    }
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
      _checkAmount = inputValue.text;
    } else {
      _payerAmount = AiDecimalAccuracy.parse(inputValue.text).toDouble();

      try {
        TransferTrialResp data = await ApiClient().transferTrial(
            TransferTrialReq(
                opt: "S",
                buyAmount: _payerAmount.toString(),
                buyCcy: ccy,
                sellAmount: '0',
                sellCcy: _cardCcy));
        if (this.mounted) {
          setState(() {
            _amount = FormatUtil.formatSringToMoney((data.optExAmt).toString());
            _checkAmount = data.optExAmt;
          });
        }
      } catch (e) {
        HSProgressHUD.showToast(e);
      }
    }
  }

  //数据初值
  void _first() {
    if (_terms.length == 0 ||
        _accuPeriods.length == 0 ||
        _auctCales.length == 0 ||
        _rates.length == 0) {
      return;
    }
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

//定期开立试算
  Future<void> _loadDepositData(
      String accuPeriod,
      String auctCale,
      double bal,
      String bppdCode,
      String ccy,
      String ciNo,
      String depositType,
      String tenor) async {
    ApiClientTimeDeposit()
        .getTimeDepositContractTrial(TimeDepositContractTrialReq(
            accuPeriod, auctCale, bal, bppdCode, ccy, ciNo, depositType, tenor))
        .then((value) {
      if (this.mounted) {
        setState(() {
          matAmt = FormatUtil.formatSringToMoney((value.matAmt).toString());
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  //获取付款账户余额
  _getCardBal(String cardNo) {
    Future.wait({
      // CardDataRepository()
      ApiClientAccount().getCardBalByCardNo(
        GetSingleCardBalReq(cardNo),
      ),
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
      HSProgressHUD.showToast(e);
    });
  }

  ///根据产品代码获取产品支持的待办指示
  Future<bool> _getTdProdInstCode() async {
    try {
      GetTdProductInstCodeResp resp = await ApiClientTimeDeposit()
          .getTdProdInstCode(GetTdProductInstCodeReq(
              this._detailProducDTOList.bppdCode ?? ''));
      if (resp != null) {
        List<String> instructionDataList = [];
        List<String> instructionList = [];
        for (var i = 0; i < instructionDatas.length; i++) {
          if (resp.insCodes.contains(instructionDatas[i])) {
            instructionDataList.add(instructionDatas[i]);
            instructionList.add(instructions[i]);
          }
        }
        setState(() {
          instructionDatas = instructionDataList;
          instructions = instructionList;
          _prodType = resp.prdAcCd ?? '';
        });
      }
      return true;
    } catch (e) {
      HSProgressHUD.showToast(e);
      return false;
    }
  }

  //获取到期指示列表
  Future<bool> _getInsCode() async {
    // PublicParametersRepository()
    try {
      GetIdTypeResp resp =
          await ApiClientOpenAccount().getIdType(GetIdTypeReq("EXP_IN"));
      if (resp.publicCodeGetRedisRspDtoList != null) {
        resp.publicCodeGetRedisRspDtoList.forEach((element) {
          if (this.mounted) {
            // setState(() {
            if (language == 'zh_CN') {
              instructions.add(element.cname);
            } else if (language == 'zh_HK') {
              instructions.add(element.chName);
            } else {
              instructions.add(element.name);
            }
            instructionDatas.add(element.code);
            // });
          }
        });
        return _getTdProdInstCode();
      }
      return false;
    } catch (e) {
      HSProgressHUD.showToast(e);
      return false;
    }
  }

  // //立即存入接口
  // Future<void> _loadContractData(
  //     String accuPeriod,
  //     String annualInterestRate,
  //     String auctCale,
  //     double bal,
  //     String bppdCode,
  //     String ccy,
  //     String ciNo,
  //     String depositType,
  //     String instCode,
  //     String oppAc,
  //     String payPassword,
  //     String prodName,
  //     String settDdAc,
  //     String smsCode,
  //     String tenor) async {
  //   if (this.mounted) {
  //     setState(() {
  //       _isDeposit = true;
  //     });
  //   }
  //   // HSProgressHUD.show();
  //   // TimeDepositDataRepository()

  //   String stlAc = settDdAc;
  //   if (_prodType == '020' && instCode == '3') {
  //     stlAc = '';
  //   } else if (_prodType == '027' && instCode == '6') {
  //     stlAc = '';
  //   }
  //   ApiClientTimeDeposit()
  //       .getTimeDepositContract(
  //     TimeDepositContractReq(
  //         accuPeriod,
  //         annualInterestRate,
  //         auctCale,
  //         bal,
  //         bppdCode,
  //         ccy,
  //         ciNo,
  //         depositType,
  //         instCode,
  //         oppAc,
  //         payPassword,
  //         prodName,
  //         stlAc,
  //         smsCode,
  //         tenor,
  //         intAc: _prodType == '020' ? '' : settDdAc),
  //   )
  //       .then((value) {
  //     if (this.mounted) {
  //       setState(() {
  //         // HSProgressHUD.dismiss();
  //         _isDeposit = false;
  //         Navigator.popAndPushNamed(context, pageDepositRecordSucceed,
  //             arguments: 'timeDepositProduct');
  //       });
  //     }
  //   }).catchError((e) {
  //     if (this.mounted) {
  //       setState(() {
  //         _isDeposit = false;
  //         HSProgressHUD.showToast(e);
  //       });
  //     }
  //   });
  // }

  //获取定期产品利率和存期
  Future<bool> _getTdProdTermRate() async {
    // if (this.mounted) {
    //   setState(() {
    //     _showTermRate = true;
    //   });
    // }
    // HSProgressHUD.show();
    try {
      GetTdProductTermRateResp resp = await ApiClientTimeDeposit()
          .getTdProductTermRate(GetTdProductTermRateReq(
              _detailProducDTOList.ccy, _detailProducDTOList.bppdCode));
      if (this.mounted) {
        setState(() {
          if (resp != null) {
            ccy = resp.ccy;
            _minAmt = resp.minAmt;
            _maxAmt = resp.maxAmt;
            if (resp.recordLists != null) {
              resp.recordLists.forEach((value) {
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
        // HSProgressHUD.dismiss();
        // _showTermRate = false;
      }
      return true;
    } catch (e) {
      HSProgressHUD.showToast(e);
      return false;
    }
  }
}
