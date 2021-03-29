import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_bank_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  var _transferMoneyController = TextEditingController(); //转账金额

  var _payerAddressController = TextEditingController(); //汇款地址

  var _payeeAddressController = TextEditingController(); //收款地址

  var _companyController = TextEditingController(); //公司名

  var _accountController = TextEditingController(); //账号

  var _bankSwiftController = TextEditingController(); //银行swift

  var _middleBankSwiftController = TextEditingController(); //中间行swift

  var _remarkController = TextEditingController();

  //国家/地区
  List<String> countryList = [];
  //转账费用
  List<String> transferFeeList = [];
  int _transferFeeIndex = 0;
  //汇款用途
  List<String> feeUse = [];
  int _feeUseIndex = 0;
  //List<String> ccyListPlay = ['CNY', 'HKD', 'EUR'];

  var _countryText = '';

  var _countryCode = '';

  var _transferFee = '';

  var _feeUse = '';

  var payeeBank = '';

  var _getPayeeBank = '';

  var payeeBankCode = '';

  var payerBankCode = '';

  var payerName = '';

  var payeeName = '';

  int _position = 0;

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
  String _rate = '';

  //限额
  String _limit = '';

  //转账数据
  List<String> transferData = [];

  String _language = Intl.getCurrentLocale();

  var check = false;

  @override
  void initState() {
    super.initState();
    _loadTransferData();
    _getTransferFeeList();
    _getFeeUseList();

    _transferMoneyController.addListener(() {
      if (_transferMoneyController.text.length == 0) {
        _amount = '0';
      }
      // if (_payCcy == _transferCcy) {
      //   setState(() {
      //     _amount = _transferMoneyController.text;
      //   });
      // } else {
      //   _rateCalculate();
      // }
      _rateCalculate();
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

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (_arguments != null && !check) {
        Rows listPartner = _arguments;
        _companyController.text = listPartner.payeeName;
        _accountController.text = listPartner.payeeCardNo;
        _countryText = listPartner.district;
        _getPayeeBank = _language == 'zh_CN'
            ? listPartner.payeeBankLocalName
            : listPartner.payeeBankEngName;
        _bankSwiftController.text = listPartner.bankSwift;
        _middleBankSwiftController.text = listPartner.midBankSwift;
        _payeeAddressController.text = listPartner.payeeAddress;
        _remarkController.text = listPartner.remark;
        //付款方银行
        payeeBankCode = listPartner.bankCode;
        //收款方银行
        payerBankCode = listPartner.payerBankCode;
        payeeName = listPartner.payeeName;
        payerName = listPartner.payerName;
        if (listPartner.paysMethod != null) {
          // _transferFeeIndex = int.parse(listPartner.paysMethod);
          _transferFee =
              listPartner.paysMethod == '' ? '' : listPartner.paysMethod;
        }
        if (listPartner.rollInPurpose != null) {
          // _feeUseIndex = int.parse(listPartner.rollInPurpose);
          _feeUse =
              listPartner.rollInPurpose == '' ? '' : listPartner.rollInPurpose;
        }
        // _transferFee = listPartner.paysMethod;
        // _feeUse = listPartner.rollInPurpose;
        check = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_1),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 15,
                ),
              ),
              //转账金额和币种
              TransferAccount(
                payCcy: _payCcy,
                transferCcy: _transferCcy,
                limit: _limit,
                account: _account,
                balance: _balance,
                amount: _amount,
                rate: _rate,
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
            SelectInkWell(
              title: S.current.state_area,
              item: _countryText,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectCountry();
              },
            ),
            _getLine(),
            //收款银行
            SelectInkWell(
              title: S.current.receipt_bank,
              item: _getPayeeBank,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectBank();
              },
            ),
            _getLine(),
            //银行SWIFT
            TextFieldContainer(
              title: S.current.bank_swift,
              hintText: S.current.please_input,
              keyboardType: TextInputType.text,
              controller: _bankSwiftController,
              callback: _isClick,
              length: 11,
              isRegEXp: true,
              regExp: "[a-zA-Z]",
              isUpperCase: true,
            ),
            _getLine(),
            //中间行
            TextFieldContainer(
              title: S.current.middle_bank_swift,
              hintText: S.current.please_input,
              keyboardType: TextInputType.text,
              controller: _middleBankSwiftController,
              callback: _isClick,
              length: 11,
              isRegEXp: true,
              regExp: "[a-zA-Z]",
              isUpperCase: true,
            ),
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
            SelectInkWell(
              title: S.current.Transfer_fee,
              item: _transferFee,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectTransferFee();
              },
            ),
            _getLine(),
            //汇款用途
            SelectInkWell(
              title: S.current.remittance_usage,
              item: _feeUse,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectFeeUse();
              },
            ),
            _getLine(),
            //转账附言
            TextFieldContainer(
              title: S.current.transfer_postscript,
              hintText: S.current.not_required,
              keyboardType: TextInputType.text,
              controller: _remarkController,
              callback: _isClick,
              length: 140,
            ),
            _getLine()
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
              callback: _isClick,
              isWidget: true,
              length: 35,
              // isRegEXp: true,
              // regExp: _language == 'zh_CN' ? '[\u4e00-\u9fa5]' : '[a-zA-Z]',
            ),
            TextFieldContainer(
              title: S.current.receipt_side_account,
              hintText: S.current.hint_input_receipt_account,
              keyboardType: TextInputType.number,
              controller: _accountController,
              callback: _isClick,
              length: 20,
              isRegEXp: true,
              regExp: '[0-9]',
            ),
          ],
        ),
      ),
    );
  }

//获取地址
  _getAddress(String topText, String inputText,
      TextEditingController _payerAddressController) {
    return Container(
      height: MediaQuery.of(context).size.width / 5,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    topText,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              // width: MediaQuery.of(context).size.width - 30,
              child: TextField(
                // minLines: 1,
                // maxLines: 3,
                //是否自动更正
                autocorrect: false,
                //是否自动获得焦点
                autofocus: false,
                controller: _payerAddressController,
                textAlign: TextAlign.end,
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
        ],
      ),
    );
  }

//获取图标
  Widget _getImage() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, pageTranferPartner, arguments: '2').then(
          (value) {
            setState(
              () {
                if (value != null) {
                  Rows rowListPartner = value;
                  _companyController.text = rowListPartner.payeeName;
                  _accountController.text = rowListPartner.payeeCardNo;
                  _countryText = rowListPartner.district;
                  _getPayeeBank = _language == 'zh_CN'
                      ? rowListPartner.payeeBankLocalName
                      : rowListPartner.payeeBankEngName;
                  _bankSwiftController.text = rowListPartner.bankSwift;
                  _middleBankSwiftController.text = rowListPartner.midBankSwift;
                  _payeeAddressController.text = rowListPartner.payeeAddress;
                  _remarkController.text = rowListPartner.remark;
                  //付款方银行
                  payeeBankCode = rowListPartner.bankCode;
                  //收款方银行
                  payerBankCode = rowListPartner.payerBankCode;
                  payeeName = rowListPartner.payeeName;
                  payerName = rowListPartner.payerName;
                  if (rowListPartner.paysMethod != null) {
                    // _transferFeeIndex = int.parse(rowListPartner.paysMethod);
                    _transferFee = rowListPartner.paysMethod == ''
                        ? ''
                        : rowListPartner.paysMethod;
                  }
                  if (rowListPartner.rollInPurpose != null) {
                    // _feeUseIndex = int.parse(rowListPartner.rollInPurpose);
                    _feeUse = rowListPartner.rollInPurpose == ''
                        ? ''
                        : rowListPartner.rollInPurpose;
                  }
                }
                _isClick();
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

//收款方名称
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
      setState(() {
        _transferFeeIndex = result;
        _transferFee = transferFeeList[result];
      });
    }
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
      setState(() {
        _feeUseIndex = result;
        _feeUse = feeUse[result];
      });
    }
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

  //选择国家地区
  _selectCountry() {
    // FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _countryText = _language == 'zh_CN'
            ? (value as CountryRegionModel).nameZhCN
            : (value as CountryRegionModel).nameEN;
        _countryCode = (value as CountryRegionModel).countryCode;
      });
    });
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

  //拿到虚线
  _getLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
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
    }
    // if (_payCcy == _transferCcy) {
    //   setState(() {
    //     _amount = _transferMoneyController.text;
    //   });
    // } else {
    //   _rateCalculate();
    // }
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

  //提交按钮
  Widget _submitButton() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 50),
        child: HsgButton.button(
            title: S.current.next_step,
            click: _isClick() ? _judgeDialog : null,
            isColor: _isClick()),
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
          _countryCode,
          _rate,
        ),
      );
    }
  }

  //判断是否可以点击
  _isClick() {
    if (_payeeAddressController.text.length > 0 &&
        _companyController.text.length > 0 &&
        _accountController.text.length > 0 &&
        _countryText != '' &&
        _getPayeeBank != '' &&
        _bankSwiftController.text.length > 0 &&
        _payerAddressController.text.length > 0 &&
        _transferFee != '' &&
        _transferMoneyController.text != '' &&
        _feeUse != '') {
      return true;
    } else {
      return false;
    }
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
          if (this.mounted) {
            setState(() {
              //付款方卡号
              _account = element.cardList[0].cardNo;
              element.cardList.forEach((e) {
                _accountList.add(e.cardNo);
              });
              //付款方姓名
              // payerName = element.cardList[0].ciName;
            });
          }
          _getCcyList();
          // _getCardTotal(_account);
          _loadData(_account);
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

  //获取货币和余额
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
              // if (_payCcy == _transferCcy) {
              //   setState(() {
              //     _amount = _transferMoneyController.text;
              //   });
              // } else {
              //   _rateCalculate();
              // }
              _rateCalculate();
            });
          }
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          if (this.mounted) {
            setState(() {
              //单次限额
              _limit = element.singleLimit;
            });
          }
        }
      });
    }).catchError((e) {});
  }

  //收款方币种与转账币种相同
  _getTransferCcySamePayCcy() {
    setState(() {
      _transferIndex = 0;
      for (int i = 0; i < _transferCcyList.length; i++) {
        print(_transferCcyList.length);
        if (_transferCcyList[i] == _payCcy) {
          _transferCcy = _payCcy;
          // print(_transferCcy);
          break;
        } else {
          _transferIndex++;
          // print(_transferIndex);
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
        // setState(() {
        //   _transferFee = transferFeeList[_transferFeeIndex];
        // });
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
        // setState(() {
        //   _feeUse = feeUse[_feeUseIndex];
        // });
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
