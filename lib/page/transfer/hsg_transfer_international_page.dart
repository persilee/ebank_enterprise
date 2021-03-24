/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 国际转账页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_international_transfer.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/util/format_text_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';
import 'data/transfer_international_data.dart';

class TransferInternationalPage extends StatefulWidget {
  TransferInternationalPage({Key key}) : super(key: key);

  @override
  _TransferInternationalPageState createState() =>
      _TransferInternationalPageState();
}

class _TransferInternationalPageState extends State<TransferInternationalPage> {
  SliverToBoxAdapter _gaySliver = SliverToBoxAdapter(
    child: Container(
      height: 15,
    ),
  );

  var totalBalance = '0.0';

  var bals = [];

  var cardNo = '';
  var singleLimit = '';

  String inpuntStr;
  List<RemoteBankCard> cardList = [];
  List<CardBalBean> cardBal = [];

  var payeeBankCode = '';

  var payerBankCode = '';

  List<String> totalBalances = [];

  var cardNoList = List<String>();

  var ccyListOne = List<String>();

  var ccyList = ['CNY'];

  List<String> ccyLists = [];

  var payerName = '';

  var ccy = '';

  double money = 0;

  var payeeName = '';

  var payeeCardNo = '';

  var remark = '';

  String _changedAccountTitle = '';

  //余额
  var _currBal;

  var _loacalCurrBal = '';

  String _changedRateTitle = '';

  String _changedCcyTitle = '';

  int _position = 0;

  String _limitMoney = '';

  //国家/地区
  List<String> countryList = [];
  //转账费用
  List<String> transferFeeList = [];
  //汇款用途
  List<String> feeUse = [];
  //List<String> ccyListPlay = ['CNY', 'HKD', 'EUR'];

  var _countryText = S.current.please_select;

  var _transferFee = S.current.please_select;

  var _feeUse = S.current.please_select;

  // var _payeeBank = S.current.please_select;

  var bankSwift = '';

  var payerAddress = '';

  var payeeAddress = '';

  var intermediateBankSwift = '';

  List<String> passwordList = [];

  String tranferType = '2';

  var payeeNameForSelects;

  var _accountSelect = '';

  var payeeBank = '';

  var _getPayeeBank = '';

  var _transferMoneyController = TextEditingController(); //转账金额

  var _payerAddressController = TextEditingController(); //汇款地址

  var _payeeAddressController = TextEditingController(); //收款地址

  var _companyController = TextEditingController(); //公司名

  var _accountController = TextEditingController(); //账号

  var _bankSwiftController = TextEditingController(); //银行swift

  var _middleBankSwiftController = TextEditingController(); //中间行swift

  var _remarkController = TextEditingController();

  var check = false;

  //支付币种
  String _payCcy = '';
  List<String> _payCcyList = [];
  int _payIndex = 0;

  //转出币种
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

  //转账数据
  List<String> transferData = [];

  String _language = Intl.getCurrentLocale();

  String middleBankSwift = '';

  @override
  void initState() {
    super.initState();
    _loadTransferData();
    _getTransferFeeList();
    _getFeeUseList();

    _transferMoneyController.addListener(() {
      if (_payCcy == _transferCcy) {
        setState(() {
          _amount = _transferMoneyController.text;
        });
      } else {
        _rateCalculate();
      }
    });
  }

  @override
  void dispose() {
    _transferMoneyController.dispose();
    _payerAddressController.dispose();
    _payeeAddressController.dispose();
    _companyController.dispose();
    _accountController.dispose();
    _bankSwiftController.dispose();
    _middleBankSwiftController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  // //付款方地址
  // _addressChange(String address) {
  //   payerAddress = address;
  // }

  // //收款方地址
  // _addressTwoChange(String addressTwo) {
  //   payeeAddress = addressTwo;
  // }

  // //中间行Swift
  // _middleSwift(String middleSwift) {
  //   intermediateBankSwift = middleSwift;
  // }

  // //银行Swift
  // _bankSwift(String bankSwifts) {
  //   bankSwift = bankSwifts;
  // }

  // //转账附言
  // _transferInputChange(String transfer) {
  //   remark = transfer;
  // }

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
      _getCardTotal(_account);
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
    }
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
      _getCardTotal(_account);
    }
  }

  //选择国家地区
  _selectCountry() {
    // FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _countryText = _language == 'zh_CN'
            ? (value as CountryRegionModel).nameZhCN
            : (value as CountryRegionModel).nameEN;
      });
    });
  }

  //根据货币类型拿余额
  // _getavaBal(String changedCcyTitle) {
  //   Future.wait({
  //     CardDataRepository().getCardBalByCardNo(
  //         GetSingleCardBalReq(_changedAccountTitle), 'GetSingleCardBalReq'),
  //   }).then((value) {
  //     value.forEach((element) {
  //       // 通过货币查询余额
  //       if (element is GetSingleCardBalResp) {
  //         setState(() {
  //           bals.clear();
  //           bals.add(element.cardListBal);
  //           if (bals.contains(changedCcyTitle)) {}
  //         });
  //       }
  //     });
  //   });
  // }

  //选择收款银行
  _selectBank() {
    Navigator.pushNamed(context, pageSelectBank, arguments: '2').then(
      (data) {
        if (data != null) {
          Banks _bankReceive;
          setState(
            () {
              _bankReceive = data;
              //银行swift
              _bankSwiftController.text = _bankReceive.bankSwift;
              //收款银行名字
              _getPayeeBank = _bankReceive.localName;
            },
          );
        }
      },
    );
  }

  //转账费用
  _selectTransferFee() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.current.Transfer_fee,
            items: transferFeeList,
          );
        });
    if (result != null && result != false) {
      _transferFee = transferFeeList[result];
    }
    setState(() {
      _position = result;
    });
  }

  //汇款用途
  _selectFeeUse() async {
    final result = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return BottomMenu(
          title: S.current.remittance_usage,
          items: feeUse,
        );
      },
    );
    if (result != null && result != false) {
      _feeUse = feeUse[result];
    }
    setState(() {
      _position = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;

    setState(() {
      if (_arguments != null && !check) {
        Rows listPartner = _arguments;
        _companyController.text = listPartner.payeeName;
        _accountController.text = listPartner.payeeCardNo;
        _countryText = listPartner.district;
        // _getPayeeBank = listPartner.payeeBankLocalName == null
        //     ? ""
        //     : listPartner.payeeBankLocalName;
        _bankSwiftController.text = listPartner.bankSwift;
        _payeeAddressController.text = listPartner.payeeAddress;
        check = false;
        print("===================================");
        print(listPartner.payeeBankLocalName);
        print(listPartner.district);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_1),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: HsgColors.commonBackground,
          child: CustomScrollView(
            slivers: [
              _gaySliver,
              TransferAccount(
                payCcy: _payCcy,
                transferCcy: _transferCcy,
                limit: _limit,
                account: _account,
                balance: _balance,
                amount: _amount,
                transferMoneyController: _transferMoneyController,
                callback: _isClick,
                payCcyDialog: payCcyDialog,
                transferCcyDialog: transferCcyDialog,
                accountDialog: _accountDialog,
              ),
              _payerAddress(),
              _payeeWidget(),
              _fourWidget(),
              _fiveWidget(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  //汇款地址
  Widget _payerAddress() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        margin: EdgeInsets.only(top: 20),
        color: Colors.white,
        child: Column(
          children: [
            _getAddress(S.current.remittance_address, S.current.please_input,
                _payerAddressController),
            _getLine(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: _getRedText(S.current.remitter_address_prompt),
            ),
          ],
        ),
      ),
    );
  }

  //收款方
  Widget _payeeWidget() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            _payeeName(),
            TextFieldContainer(
              title: S.current.receipt_side_name,
              hintText: S.current.hint_input_receipt_name,
              widget: _getImage(),
              keyboardType: TextInputType.text,
              controller: _companyController,
              // callback: _boolBut,
              isWidget: true,
              length: 35,
              isRegEXp: true,
              regExp: _language == 'zh_CN' ? '[\u4e00-\u9fa5]' : '[a-zA-Z]',
            ),
            TextFieldContainer(
              title: S.current.receipt_side_account,
              hintText: S.current.hint_input_receipt_account,
              keyboardType: TextInputType.number,
              controller: _accountController,
              // callback: _boolBut,
              length: 20,
              isRegEXp: true,
              regExp: '[0-9]',
            ),
          ],
        ),
      ),
    );
  }

  //第四部分
  Widget _fourWidget() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            _getRedText(S.current.international_transfer_account_prompt),
            //国家地区
            _getSelectColumn(
                S.current.state_area, _countryText, _selectCountry),
            _getLine(),
            //收款银行
            _getSelectColumn(
                S.current.receipt_bank, _getPayeeBank, _selectBank),
            _getLine(),
            //银行SWIFT
            _getInputColumn(S.current.bank_swift, S.current.please_input, 11,
                true, "[a-zA-Z]", _bankSwiftController),
            _getLine(),

            //中间行
            _getInputColumn(S.current.middle_bank_swift, S.current.not_required,
                11, true, "[a-zA-Z]", _middleBankSwiftController, isUpperCase: true),
            _getLine(),
            //收款地址
            _getAddress(S.current.collection_address, S.current.please_input,
                _payeeAddressController),
            _getLine(),
          ],
        ),
      ),
    );
  }

  //第五部分
  Widget _fiveWidget() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            //转账费用
            _getSelectColumn(
                S.current.Transfer_fee, _transferFee, _selectTransferFee),
            _getLine(),
            //汇款用途
            _getSelectColumn(
                S.current.remittance_usage, _feeUse, _selectFeeUse),
            _getLine(),
            //转账附言
            _getInputColumn(
              S.current.transfer_postscript,
              S.current.not_required,
              140,
              false,
              '',
              _remarkController,
            ),
            _getLine()
          ],
        ),
      ),
    );
  }

  Widget _payeeName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            S.current.receipt_side,
            style: TextStyle(color: HsgColors.describeText, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _getImage() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, pageTranferPartner, arguments: '2').then(
          (value) {
            setState(
              () {
                if (value != null) {
                  Rows rowListPartner = value;
                  _companyController.text = rowListPartner.payeeName;
                  _accountController.text = rowListPartner.payeeCardNo;
                  _countryText = rowListPartner.district;
                  // _getPayeeBank = rowListPartner.payeeBankLocalName;
                  _bankSwiftController.text = rowListPartner.bankSwift;
                  _payeeAddressController.text = rowListPartner.payeeAddress;
                } else {}
              },
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Image(
          image: AssetImage('images/login/login_input_account.png'),
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  //红色字体
  _getRedText(String redText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Text(
        redText,
        style: TextStyle(color: Color(0XFFA61F23), fontSize: 13.5),
      ),
    );
  }

  //获取地址
  _getAddress(String topText, String inputText,
      TextEditingController _payerAddressController) {
    var _topRow = [
      Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              topText,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ),
        ]),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: TextField(
            //是否自动更正
            autocorrect: false,
            //是否自动获得焦点
            autofocus: false,
            controller: _payerAddressController,
            textAlign: TextAlign.right,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(105) //限制长度
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: inputText,
              hintStyle: TextStyle(
                fontSize: 15,
                color: HsgColors.textHintColor,
              ),
            ),
          ),
        ),
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.width / 5,
      color: Colors.white,
      child: Column(
        children: _topRow,
      ),
    );
  }

//提交按钮
  Widget _submitButton() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 100, bottom: 50),
        child: HsgButton.button(
            title: S.current.next_step,
            click: _isClick() ? _judgeDialog : null),
      ),
    );
  }

  _judgeDialog() {
    if (double.parse(_transferMoneyController.text) > double.parse(_limit) ||
        double.parse(_transferMoneyController.text) > double.parse(_balance)) {
      if (double.parse(_limit) > double.parse(_balance)) {
        Fluttertoast.showToast(
          msg: "余额不足",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xffe74c3c),
          textColor: Color(0xffffffff),
        );
      } else {
        Fluttertoast.showToast(
          msg: "超过限额",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xffe74c3c),
          textColor: Color(0xffffffff),
        );
      }
    } else {
      Navigator.pushNamed(
        context,
        pageTransferInternationalPreview,
        arguments: TransferInternationalData(
          _account,
          _amount,
          _transferCcy,
          _payerAddressController.text,
          _companyController.text,
          _accountController.text,
          _transferMoneyController.text,
          _payCcy,
          _payeeAddressController.text,
          _countryText,
          _getPayeeBank,
          _bankSwiftController.text,
          _middleBankSwiftController.text,
          _transferFee,
          _feeUse,
          _remarkController.text,
          payeeBankCode,
          payeeName,
          payerBankCode,
          payerName,
        ),
      );
    }
  }

  //拿到虚线
  _getLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
  }

  //获取输入行
  _getInputColumn(String leftText, String righteText, int length, bool isRegExp,
      String regExp, TextEditingController _controller, {bool isUpperCase = false}) {
    var rightExpand = Expanded(
      child: Container(
        child: TextField(
          //是否自动更正
          autocorrect: false,
          //是否自动获得焦点
          autofocus: false,
          controller: _controller,
          onChanged: (text) {},
          textAlign: TextAlign.right,
          // textCapitalization: TextCapitalization.characters,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(length),
            isRegExp
                ? FilteringTextInputFormatter.allow(RegExp(regExp))
                : LengthLimitingTextInputFormatter(length),
            if(isUpperCase)
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: righteText,
            hintStyle: TextStyle(
              fontSize: 15,
              color: HsgColors.textHintColor,
            ),
          ),
        ),
      ),
    );
    var _leftText = Container(
      // height: MediaQuery.of(context).size.width / 7,
      color: Colors.white,
      padding: EdgeInsets.only(right: 15),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              leftText,
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          rightExpand
        ],
      ),
    );
    return _leftText;
  }

  //获取选择行
  _getSelectColumn(String leftText, String rightText, Function selectMethod) {
    String righText = rightText == '' ? S.current.please_select : rightText;
    var _rightText = [
      Container(
        // margin: EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width / 2.5,
        child: Text(
          righText,
          style: righText == S.current.please_select
              ? TextStyle(
                  color: Color(0xffCCCCCC),
                  fontSize: 15,
                )
              : TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
                ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 5),
        child: Icon(
          Icons.arrow_forward_ios,
          color: HsgColors.firstDegreeText,
          size: 16,
        ),
      ),
    ];
    return Container(
      height: 50,
      color: Colors.white,
      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            width: MediaQuery.of(context).size.width / 2.5,
            child: Text(
              leftText,
              style: TextStyle(color: HsgColors.firstDegreeText, fontSize: 15),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                selectMethod();
              },
              child: Row(
                children: _rightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _loadTransferData() async {
    final prefs = await SharedPreferences.getInstance();
    _localeCcy = prefs.getString(ConfigKey.LOCAL_CCY);

    Future.wait({
      CardDataRepository().getCardList('GetCardList'),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          setState(() {
            //付款方卡号
            _account = element.cardList[0].cardNo;
            element.cardList.forEach((e) {
              _accountList.add(e.cardNo);
            });
            //付款方银行名字
            payeeBankCode = element.cardList[0].ciName;
            //收款方银行姓名
            payerBankCode = element.cardList[0].ciName;
            //付款方姓名
            payerName = element.cardList[0].ciName;
          });
          _getCcyList();
          _getCardTotal(_account);
          // _payCcyList.clear();
          // _payCcy = _localeCcy;
          // _payCcyList.add(_localeCcy);
          // _balance = '10000';
          // _limit = '5000';
        }
      });
    });
  }

  //默认初始货币和余额
  _getCardTotal(String cardNo) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        if (element is GetSingleCardBalResp) {
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
            //余额
            // if (_balance == '') {
            //   _balance = element.cardListBal[0].currBal;
            // }
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
          });
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            //单次限额
            _limit = element.singleLimit;
          });
        }
      });
    }).catchError((e) {
      // _payCcyList.clear();
      // _payCcy = _localeCcy;
      // _payCcyList.add(_localeCcy);
      // _balance = '10000';
      // _limit = '5000';
    });
  }

  //收款方币种与转账币种相同
  _getTransferCcySamePayCcy() {
    setState(() {
      _transferIndex = 0;
      for (int i = 0; i < _transferCcyList.length; i++) {
        print(_transferCcyList.length);
        if (_transferCcyList[i] == _payCcy) {
          _transferCcy = _payCcy;
          print(_transferCcy);
          break;
        } else {
          _transferIndex++;
          print(_transferIndex);
        }
      }
    });
  }

// 获取币种列表
  Future _getCcyList() async {
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

  //获取转账费用列表
  Future _getTransferFeeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("PAYS_METHOD"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        transferFeeList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN') {
            transferFeeList.add(e.cname);
          } else {
            transferFeeList.add(e.name);
          }
        });
      }
    });
  }

  //获取汇款用途列表
  Future _getFeeUseList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("ROLL_IN_PURPOSE"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        feeUse.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN') {
            feeUse.add(e.cname);
          } else {
            feeUse.add(e.name);
          }
        });
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    double _payerAmount = 0;
    if (_transferMoneyController.text == '') {
      setState(() {
        _amount = '0';
      });
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
        setState(() {
          _amount = data.optExAmt;
        });
      });
    }
  }

  _tranferInternational(BuildContext context) {
    HSProgressHUD.show();
    TransferDataRepository()
        .getInterNationalTransfer(
            GetInternationalTransferReq(
              money, //转账金额
              _bankSwiftController.text,
              _transferFee, //转账费用
              _changedCcyTitle, //贷方货feiyon币
              //借方货币
              '',
              _countryText, //国家地区
              intermediateBankSwift, //中间行swift
              payeeAddress,
              payeeBankCode,
              payeeCardNo,
              payeeName,
              payerAddress,
              payerBankCode,
              //付款方卡号
              _changedAccountTitle,
              payerName,
              remark,
              //汇款用途
              _feeUse,
            ),
            'getTransferByAccount')
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
    }).catchError((e) {
      HSProgressHUD.showError(status: '${e.toString()}');
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) async {
    Navigator.pushNamed(context, pageDepositRecordSucceed,
        arguments: 'international');
  }

  //判断是否可以点击
  _isClick() {
    if (_payeeAddressController.text.length > 0 &&
        _companyController.text.length > 0 &&
        _accountController.text.length > 0 &&
        _countryText != S.current.please_select &&
        _getPayeeBank != S.current.please_select &&
        _bankSwiftController.text.length > 0 &&
        _payerAddressController.text.length > 0 &&
        _transferFee != S.current.please_select &&
        _transferMoneyController.text != '' &&
        _feeUse != S.current.please_select) {
      return true;
    } else {
      return false;
    }
  }

  //交易密码窗口
  void _openBottomSheet() async {
    final passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
          resultPage: pageDepositRecordSucceed,
          arguments: 'international',
          isDialog: true,
        );
      },
    );
    if (passwordList != null && passwordList == true) {
      if (passwordList.length == 6) {
        //   _tranferInternational(context);
        _showContractSucceedPage(context);
        _cleanData();
      }
    }
  }

  _cleanData() {
    setState(() {
      _transferMoneyController.text = '';
      _payeeAddressController.text = '';
      _payerAddressController.text = '';
      _companyController.text = '';
      _accountController.text = '';
      _bankSwiftController.text = '';
      _middleBankSwiftController.text = '';
      _remarkController.text = '';
      _countryText = '';
      _getPayeeBank = '';
      _transferFee = '';
      _feeUse = '';
    });
  }
}
