/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 国际转账页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_international_transfer.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  List<String> countryList = ['中国', '中国香港', '荷兰'];
  //转账费用
  List<String> transferFeeList = ['收款人交易', '本人交易', '各付各行'];
  //汇款用途
  List<String> feeUse = [
    '贷款',
    '加工费',
    '运输费',
    '投资款',
    '还款/供款',
    '学费',
    '参与费',
    '工资/花红/佣金',
    '服务费',
    '生活费',
    '存款转移',
    '房地产投资',
    '其他',
  ];
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
  List<String> _transferCcyList = ['HKD', 'CNY', 'USD', 'EUR', 'LAK'];

  //本地币种
  String _localeCcy = 'CNY';

  //账户选择
  String _account = '';
  List<String> _accountList = [];
  int _accountIndex = 0;

  //余额
  String _balance = '';
  List<String> _balanceList = [];

  //限额
  String _limit = '';

  //转账数据
  List<String> transferData = [];

  @override
  void initState() {
    super.initState();
    _companyController.addListener(() {
      _nameInputChange(_companyController.text); //公司名输入框内容改变时调用
    });
    _accountController.addListener(() {
      _accountInputChange(_accountController.text); //账号输入框内容改变时调用
    });
    _transferMoneyController.addListener(() {
      _amountInputChange(_transferMoneyController.text); //金额输入框内容改变时调用
    });

    _loadTransferData();
  }

  //转账金额
  _amountInputChange(String title) {
    money = double.parse(title);
  }

  //付款方地址
  _addressChange(String address) {
    payerAddress = address;
    print(">>>>>>>> $payerAddress");
  }

  //收款方地址
  _addressTwoChange(String addressTwo) {
    payeeAddress = addressTwo;
  }

  //中间行Swift
  _middleSwift(String middleSwift) {
    intermediateBankSwift = middleSwift;
  }

  //银行Swift
  _bankSwift(String bankSwifts) {
    bankSwift = bankSwifts;
  }

  //公司名
  _nameInputChange(String name) {
    setState(() {
      payeeName = name;
    });
  }

  //账号
  _accountInputChange(String account) {
    setState(() {
      payeeCardNo = account;
    });
  }

  //转账附言
  _transferInputChange(String transfer) {
    remark = transfer;
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
  // _selectCountry() async {
  //   final result = await showHsgBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return BottomMenu(
  //           title: '国家/地区',
  //           items: countryList,
  //         );
  //       });
  //   if (result != null && result != false) {
  //     _countryText = countryList[result];
  //   }

  //   setState(() {
  //     _position = result;
  //   });
  // }
  _selectCountry() {
    // FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _countryText = (value as CountryRegionModel).nameEN;
      });
    });
  }

  //根据货币类型拿余额

  // ignore: unused_element
  _getavaBal(String changedCcyTitle) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(_changedAccountTitle), 'GetSingleCardBalReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过货币查询余额
        if (element is GetSingleCardBalResp) {
          setState(() {
            bals.clear();
            bals.add(element.cardListBal);
            if (bals.contains(changedCcyTitle)) {}
          });
        }
      });
    });
  }

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
            title: '其他费用',
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
          title: '汇款用途',
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
        check = false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_1),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          TransferAccount(
            payCcy: _payCcy,
            transferCcy: _transferCcy,
            limit: _limit,
            account: _account,
            balance: _balance,
            transferMoneyController: _transferMoneyController,
            callback: _isClick,
            payCcyDialog: payCcyDialog,
            transferCcyDialog: transferCcyDialog,
            accountDialog: _accountDialog,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: EdgeInsets.only(top: 20),
              color: Colors.white,
              child: Column(
                children: [
                  _getAddress(
                      S.current.remittance_address,
                      S.current.please_input,
                      _addressChange,
                      _payerAddressController),
                  _getLine(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: _getRedText(S.current.remitter_address_prompt),
                  ),
                ],
              ),
            ),
          ),
          _payeeWidget(),
          SliverToBoxAdapter(
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
                  _getInputColumn(S.current.bank_swift, S.current.please_input,
                      _bankSwift, _bankSwiftController),
                  _getLine(),

                  //中间行
                  _getInputColumn(
                      S.current.middle_bank_swift,
                      S.current.not_required,
                      _middleSwift,
                      _middleBankSwiftController),
                  _getLine(),
                  //收款地址
                  _getAddress(
                      S.current.collection_address,
                      S.current.please_input,
                      _addressTwoChange,
                      _payeeAddressController),
                  _getLine(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
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
                      _transferInputChange,
                      _remarkController),
                  _getLine()
                ],
              ),
            ),
          ),
          _submitButton(),
        ],
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
            ),
            TextFieldContainer(
              title: S.current.receipt_side_account,
              hintText: S.current.hint_input_receipt_account,
              keyboardType: TextInputType.number,
              controller: _accountController,
              // callback: _boolBut,
            ),
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
  _getAddress(
      String topText,
      String inputText,
      Function(String inputStr) nameChange,
      TextEditingController _payerAddressController) {
    var _topRow = [
      Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              topText,
              style: TextStyle(fontSize: 13),
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: inputText,
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: HsgColors.textHintColor,
                ),
              )),
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
          '123',
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
  _getInputColumn(
      String leftText, String righteText, Function(String inputStr) moneyChange,
      [TextEditingController _controller]) {
    var rightExpand = Expanded(
      child: Container(
        child: TextField(
            //是否自动更正
            autocorrect: false,
            //是否自动获得焦点
            autofocus: false,
            controller: _controller,
            onChanged: (payeeName) {
              moneyChange(payeeName);
              print("这个是 onChanged 时刻在监听，输出的信息是：$payeeName");
            },
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: righteText,
              hintStyle: TextStyle(
                fontSize: 14,
                color: HsgColors.textHintColor,
              ),
            )),
      ),
    );
    var _leftText = Container(
      height: MediaQuery.of(context).size.width / 7,
      color: Colors.white,
      padding: EdgeInsets.only(right: 15),
      child: Row(
        children: [
          Container(
            child: Text(
              leftText,
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontSize: 14,
              ),
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
        margin: EdgeInsets.only(top: 5),
        child: Text(
          righText,
          style: righText == S.current.please_select
              ? TextStyle(
                  color: HsgColors.secondDegreeText,
                  fontSize: 15,
                )
              : TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
                ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 7, left: 5),
        child: Icon(
          Icons.arrow_forward_ios,
          color: HsgColors.firstDegreeText,
          size: 16,
        ),
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.width / 7,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              leftText,
              style: TextStyle(color: HsgColors.firstDegreeText, fontSize: 14),
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

  _loadTransferData() {
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
          _getCardTotal(_account);
          _payCcyList.clear();
          _payCcy = _localeCcy;
          _payCcyList.add(_localeCcy);
          _balance = '10000';
          _limit = '5000';
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
            //币种
            if (_payCcy == '') {
              _payCcy = element.cardListBal[0].ccy;
            }
            //余额
            if (_balance == '') {
              _balance = element.cardListBal[0].currBal;
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
          });
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            //单次限额
            singleLimit = element.singleLimit;
          });
        }
      });
    }).catchError((e) {
      _payCcyList.clear();
      _payCcy = _localeCcy;
      _payCcyList.add(_localeCcy);
      _balance = '10000';
      _limit = '5000';
    });
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
              // debitCurrency,
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
