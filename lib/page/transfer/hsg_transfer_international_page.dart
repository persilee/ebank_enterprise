/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 国际转账页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_international_transfer.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

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

  var ccyList = List();

  List<String> ccyLists = [];

  var payerName = '';

  var ccy = '';

  double money = 0;

  var payeeName = '';

  var payeeCardNo = '';

  var remark = '';

  String _changedAccountTitle = '';

  //余额
  String _changedRateTitle = '';

  String _changedCcyTitle = '';

  int _position = 0;

  String _limitMoney = '';

  //国家/地区
  List<String> countryList = ['中国', '中国香港'];
  //转账费用
  List<String> transferFeeList = ['收款人支付', '本人支付', '各付各行'];
  //汇款用途
  List<String> feeUse = [
    '贷款',
    '加工费',
    '运输费',
    '投资款',
    '还款/供款',
    '学费',
  ];
  List<String> ccyListPlay = ['CNY', 'HKD', 'EUR'];

  var _countryText = S.current.please_select;

  var _transferFee = S.current.please_select;

  var _feeUse = S.current.please_select;

  // var _payeeBank = S.current.please_select;

  int groupValue = 0;

  var bankSwift = '';

  var payerAddress = '';

  var payeeAddress = '';

  var intermediateBankSwift = '';

  List<String> passwordList = [];

  String tranferType = '2';

  var payeeNameForSelects;

  var accountSelect = '';

  var payeeBank = '';

  var _getBankSwift = S.current.please_input;

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

  //选择账号方法
  _selectAccount() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: '银行卡号',
            items: cardNoList,
            lastSelectedPosition: _position,
          );
        });
    if (result != null && result != false) {
      _changedAccountTitle = cardNoList[result];
    }

    setState(() {
      _position = result;
    });
    _getCardTotals(_changedAccountTitle);

    //_getCcy();
  }

  _getCardTotals(String _changedAccountTitle) {
    Future.wait({
      CardDataRepository().getSingleCardBal(
          GetSingleCardBalReq(_changedAccountTitle), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(_changedAccountTitle),
          'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        if (element is GetSingleCardBalResp) {
          setState(() {
            bals.clear();
            bals.addAll(element.cardListBal);
            ccyLists.clear();
            //通过卡号查询货币
            //获取集合
            List<CardBalBean> dataList = [];

            for (int i = 0; i < cardBal.length; i++) {
              CardBalBean doList = cardBal[i];
              ccyLists.add(doList.ccy);

              if (!ccyLists.contains('CNY')) {
                CardBalBean doListNew;
                cardBal.insert(0, doListNew);
              }
            }

            if (!ccyLists.contains('CNY')) {
              CardBalBean doListNew;
              dataList.insert(0, doListNew);
            }

            dataList.forEach((element) {
              String ccyCNY = element == null ? 'CNY' : element.ccy;
              ccyList.add(ccyCNY);
              String avaBAL = element == null ? '0.00' : element.avaBal;
              totalBalances.add(avaBAL);
            });
            // ccyList.add(ccyLists);

            // 添加余额
            element.cardListBal.forEach((bals) {
              totalBalances.add(bals.avaBal);
            });
          });
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            _limitMoney = element.singleLimit;
          });
        }
      });
    });
  }

  //选择货币方法
  _getCcy() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: S.of(context).currency_choice,
            items: ccyListPlay,
            // ccyLists,
            positiveButton: S.of(context).confirm,
            negativeButton: S.of(context).cancel,
            lastSelectedPosition: groupValue,
          );
        });

    if (result != null && result != false) {
      //货币种类
      // _changedCcyTitle = ccyList[result];
      groupValue = result;
      _changedCcyTitle = ccyListPlay[result];
      // //余额
      // _changedRateTitle = totalBalances[result];
    }

    setState(() {
      _position = result;
    });
  }

  //选择国家地区
  _selectCountry() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: '国家/地区',
            items: countryList,
          );
        });
    if (result != null && result != false) {
      _countryText = countryList[result];
    }

    setState(() {
      _position = result;
    });
  }

  //根据货币类型拿余额

  _getavaBal(String changedCcyTitle) {
    Future.wait({
      CardDataRepository().getSingleCardBal(
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
        title: Text(S.current.international_transfer),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          TransferPayerWidget(
              context,
              _limitMoney,
              _changedCcyTitle,
              _changedRateTitle,
              _changedAccountTitle,
              ccy,
              singleLimit,
              totalBalance,
              cardNo,
              payeeBankCode,
              money,
              _amountInputChange,
              _selectAccount,
              _getCcy,
              _getCardTotals,
              _transferMoneyController),
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
          TransferPayeeWidget(
              payeeCardNo,
              payeeName,
              accountSelect,
              payeeNameForSelects,
              _getImage,
              context,
              S.current.transfer_in,
              S.current.company_name,
              S.current.account_num,
              S.current.please_input,
              S.current.please_input,
              _nameInputChange,
              _accountInputChange,
              _companyController,
              _accountController),
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
          SliverToBoxAdapter(
            child: Container(
              height: 90,
              padding: EdgeInsets.fromLTRB(29.6, 30, 29.6, 10),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 80),
              child: RaisedButton(
                child: Text(S.current.submit),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: _isClick(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                disabledColor: HsgColors.btnDisabled,
              ),
            ),
          ),
        ],
      ),
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
      child: Image(
        image: AssetImage('images/login/login_input_account.png'),
        width: 20,
        height: 20,
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
                print('选择账号');
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
            cardNo = element.cardList[0].cardNo;
            element.cardList.forEach((e) {
              cardNoList.add(e.cardNo);
            });
            //付款方银行名字
            payeeBankCode = element.cardList[0].ciName;
            //收款方银行姓名
            payerBankCode = element.cardList[0].ciName;
            //付款方姓名
            payerName = element.cardList[0].ciName;
          });
          _getCardTotal(cardNo);
        }
      });
    });
  }

  _getCardTotal(String cardNo) {
    Future.wait({
      CardDataRepository()
          .getSingleCardBal(GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        if (element is GetSingleCardBalResp) {
          setState(() {
            //余额
            totalBalance = element.cardListBal[0].avaBal;
            ccy = element.cardListBal[0].ccy;

            element.cardListBal.forEach((element) {
              ccyListOne.clear();
              ccyListOne.add(element.ccy);
            });
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
    });
  }

  void _tranferInternational(BuildContext context) {
    setState(() {});
    HSProgressHUD.show();
    TransferDataRepository()
        .getInterNationalTransfer(
            GetInternationalTransferReq(
                money, //转账金额
                _bankSwiftController.text,
                _transferFee, //转账费用
                _changedCcyTitle, //贷方货币
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
                _feeUse),
            'getTransferByAccount')
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
    }).catchError((e) {
      setState(() {});
      HSProgressHUD.showError(status: '${e.toString()}');
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) async {
    setState(() {});
    Navigator.pushNamed(context, pageDepositRecordSucceed);
  }

  //判断是否可以点击
  _isClick() {
    if (money > 0 &&
        payeeName.length > 0 &&
        payeeCardNo.length > 0 &&
        payerAddress.length > 0 &&
        _countryText != S.current.please_select &&
        _getPayeeBank != S.current.please_select &&
        _bankSwiftController.text.length > 0 &&
        payeeAddress.length > 0 &&
        _transferFee != S.current.please_select &&
        _feeUse != S.current.please_select) {
      return () {
        _openBottomSheet();

        print('提交');
      };
    } else {
      return null;
    }
  }

  //交易密码窗口
  void _openBottomSheet() async {
    passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
        );
      },
    );
    if (passwordList != null) {
      if (passwordList.length == 6) {
        _tranferInternational(context);
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
