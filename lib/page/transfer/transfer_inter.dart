/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///跨行转账
/// Author: fangluyao
/// Date: 2021-04-15
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/openAccount/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/other/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_info_by_swift_code.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/transfer/query_fee.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';
import 'data/transfer_international_data.dart';

class TransferInterPage extends StatefulWidget {
  TransferInterPage({Key key}) : super(key: key);

  @override
  _TransferInterPageState createState() => _TransferInterPageState();
}

class _TransferInterPageState extends State<TransferInterPage> {
  List<RemoteBankCard> cardList = [];

  var payeeBankCode = '';

  var payerBankCode = '';

  var payerName = '';

  var payeeName = '';

  var payeeCardNo = '';

  var _payerTransferController = new TextEditingController();

  var _focusNode = new FocusNode();

  var _swiftFocusNode = new FocusNode();

  var _payerTransferFocusNode = new FocusNode();

  var _payeeTransferFocusNode = new FocusNode();

  var _remarkController = new TextEditingController();

  var _payeeNameController = new TextEditingController();

  var _payeeAccountController = new TextEditingController();

  var _payeeTransferController = new TextEditingController();

  var _payeeAddressController = TextEditingController(); //收款地址

  var _bankSwiftController = TextEditingController(); //银行swift

  var _bankNameController = TextEditingController(); //银行名称

  //付款方币种
  String _payerCcy = '';
  List<String> _payerCcyList = [];
  int _payerIndex = 0;

  //收款方币种
  String _payeeCcy = '';
  int _payeeIndex = 0;
  List<String> _payeeCcyList = [];

  //本地币种
  String _localeCcy = '';

  //账户选择
  String _payerAccount = '';
  List<String> _payerAccountList = [];
  int _payerAccountIndex = 0;

  //余额
  String _balance = '';
  List<String> _balanceList = [];

  //汇率
  String rate = '';

  //转账费用
  List<String> transferFeeList = [];
  List<String> transferFeeCodeList = [];
  int _transferFeeIndex = 2;
  String _transferFeeCode = 'S';
  String _transferFee = S.current.service_charge3;

  RemoteBankCard _rollOutModel; //转出方账户模型
  List _rollOutList = []; //转出方账户列表

  //按钮是否能点击
  bool _isClick = false;
  var check = false;

  var _payeeAccountFocusNode = FocusNode();
  var _opt = '';

  var _countryText = '';
  var _countryCode = '';
  String _language = Intl.getCurrentLocale();

  String _pFee = '';
  String _feeCode = '';

  @override
  void initState() {
    super.initState();
    _loadLocalCcy();
    _loadTransferData();
    _actualNameReqData();
    _getTransferFeeList();

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

    _swiftFocusNode.addListener(() {
      if (_bankSwiftController.text.length == 11 && !_swiftFocusNode.hasFocus) {
        _getBankNameBySwift(_bankSwiftController.text);
      }
    });
  }

  @override
  void dispose() {
    _payeeNameController.dispose();
    _payeeAccountController.dispose();
    _remarkController.dispose();
    _payerTransferController.dispose();
    _focusNode.dispose();
    _payerTransferFocusNode.dispose();
    _payeeTransferFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    if (_arguments != null && !check) {
      Rows rowPartner = _arguments;
      if (rowPartner.payeeName.isEmpty) {
        print('payeeNameText: ${payeeName}');
        payeeName = _payeeNameController.text;
      } else {
        _payeeNameController.text = rowPartner.payeeName;
        payeeName = rowPartner.payeeName;
        print('payeeNamePartner: ${payeeName}');
      }
      _payeeAccountController.text = rowPartner.payeeCardNo;
      _remarkController.text = rowPartner.remark;
      payeeBankCode = rowPartner.bankCode;
      payerBankCode = rowPartner.payerBankCode;

      // payerName = rowPartner.payerName;
      _payeeCcy = rowPartner.ccy;
      if (rowPartner.paysMethod == null) {
        _transferFeeCode = '';
        _transferFee = '';
      } else {
        _transferFeeCode = rowPartner.paysMethod;
      }
      _bankNameController.text = _language == 'zh_CN'
          ? rowPartner.payeeBankLocalName
          : rowPartner.payeeBankEngName;
      _bankSwiftController.text = rowPartner.bankSwift;
      _countryText = rowPartner.district;
      _countryCode = rowPartner.district;
      _payeeAddressController.text =
          rowPartner == null ? '' : rowPartner.payeeAddress;
      _boolBut();
      check = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_1),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _payerWidget(),
          _payeeWidget(),
          // _transferWidget(),
          _interWidget(),
          _remarkWiget(),
          _submitButton(),
        ],
      ),
    );
  }

  //付款方
  Widget _payerWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName(S.current.transfer_from1),
          _payerAccountWidget(),
          Container(
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    S.of(context).transfer_from_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    payerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _getLine(),
          Container(
            // padding: EdgeInsets.only(right: 15, left: 15),
            color: Colors.white,
            child: SelectInkWell(
              title: S.current.payer_currency,
              item: _payerCcy == null ? '' : _payerCcy,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _payerCcyDialog();
              },
            ),
          ),
          TextFieldContainer(
            title: S.current.to_amount,
            hintText: S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payerTransferController,
            focusNode: _payerTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: _payerCcy == 'JPY' ? '[0-9]' : '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  //收款方
  Widget _payeeWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName(S.of(context).receipt_side),
          TextFieldContainer(
            title: S.of(context).receipt_side_account,
            hintText: S.of(context).hint_input_receipt_account,
            widget: _getImage(),
            keyboardType: TextInputType.number,
            controller: _payeeAccountController,
            focusNode: _payeeAccountFocusNode,
            callback: _boolBut,
            length: 20,
            isRegEXp: true,
            regExp: '[0-9]',
            isWidget: true,
          ),
          TextFieldContainer(
            title: S.of(context).receipt_side_name,
            hintText: S.of(context).hint_input_receipt_name,
            keyboardType: TextInputType.text,
            controller: _payeeNameController,
            callback: _boolBut,
            length: 35,
            isRegEXp: true,
            // regExp: '[\u4e00-\u9fa5a-zA-Z0-9 ]',
            regExp: '[a-zA-z0-9 \-\/\?\:\(\)\.\,\'\+]',
          ),
          Container(
            child: Text(
              S.current.international_transfer_account_prompt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(right: 15, left: 15),
            color: Colors.white,
            child: SelectInkWell(
              title: S.current.transfer_from_ccy,
              item: _payeeCcy == null ? '' : _payeeCcy,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _payeeCcyDialog();
              },
            ),
          ),
          TextFieldContainer(
            title: S.current.transfer_to_amount,
            hintText: S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payeeTransferController,
            focusNode: _payeeTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: _payeeCcy == 'JPY' ? '[0-9]' : '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  //转账金额
  Widget _transferWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName("转账金额"),
          TextFieldContainer(
            title: "转出金额" + "（" + _payerCcy + "）",
            hintText: S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payerTransferController,
            focusNode: _payerTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
          TextFieldContainer(
            title: "转入金额" + "（" + _payeeCcy + "）",
            hintText: S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payeeTransferController,
            focusNode: _payeeTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  Widget _interWidget() {
    return Container(
      color: Colors.white,
      // margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
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
          //银行SWIFT
          TextFieldContainer(
            title: S.current.approve_swift_code,
            hintText: S.current.please_input,
            keyboardType: TextInputType.text,
            controller: _bankSwiftController,
            focusNode: _swiftFocusNode,
            callback: _boolBut,
            length: 11,
            isRegEXp: true,
            regExp: "[a-zA-Z0-9]",
            isUpperCase: true,
          ),
          _getLine(),
          //银行名称
          TextFieldContainer(
            title: S.current.receipt_bank,
            hintText: S.current.please_input,
            keyboardType: TextInputType.text,
            controller: _bankNameController,
            callback: _boolBut,
            length: 30,
          ),
          _getLine(),
          //收款地址
          _getAddress(S.current.collection_address, S.current.please_input,
              _payeeAddressController),
          _getLine(),
        ],
      ),
    );
  }

  //选择国家地区
  _selectCountry() {
    // FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        // _countryText = _language == 'zh_CN'
        //     ? (value as CountryRegionNewModel).cntyCnm
        //     : (value as CountryRegionNewModel).cntyNm;
        switch (_language) {
          case 'zh_CN':
            _countryText = (value as CountryRegionNewModel).cntyCnm;
            break;
          case 'zh_HK':
            _countryText = (value as CountryRegionNewModel).cntyTcnm;
            break;
          default:
            _countryText = (value as CountryRegionNewModel).cntyNm;
        }
        _countryCode = (value as CountryRegionNewModel).cntyCd;
        _boolBut();
      });
    });
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
                    style: TextStyle(
                      fontSize: 15,
                      color: HsgColors.firstDegreeText,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              // minLines: 1,
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: false,
              controller: _payerAddressController,
              textAlign: TextAlign.end,
              style: TEXTFIELD_TEXT_STYLE,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(105), //限制长度
                FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-z0-9 \-\/\?\:\(\)\.\,\'\+]')),
              ],
              decoration: InputDecoration.collapsed(
                // border: InputBorder.none,
                hintText: inputText,
                hintStyle: HINET_TEXT_STYLE,
              ),
              onChanged: ((value) {
                _boolBut();
              }),
            ),
          ),
        ],
      ),
    );
  }

  //附言
  Widget _remarkWiget() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            //转账费用
            SelectInkWell(
              title: S.current.transfer_fee,
              item: _transferFee,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectTransferFee();
              },
            ),
            _getLine(),
            TextFieldContainer(
                title: S.current.transfer_postscript,
                hintText: S.current.transfer,
                keyboardType: TextInputType.text,
                controller: _remarkController,
                callback: _boolBut,
                isRegEXp: true,
                regExp: '[a-zA-z0-9 \-\/\?\:\(\)\.\,\'\+]'),
          ],
        ));
  }

  Widget _titleName(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(color: HsgColors.describeText, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  //付款账户
  _payerAccountWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
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
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontSize: 15,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _payerAccountDialog();
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _payerAccount,
                        style:
                            TextStyle(color: Color(0xff262626), fontSize: 14),
                      ),
                      Text(
                        S.current.balance_with_value +
                            '：' +
                            _payerCcy +
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

  //增加转账伙伴图标
  Widget _getImage() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, pageTranferPartner, arguments: '2').then(
          (value) {
            setState(() {
              if (value != null) {
                Rows rowListPartner = value;
                _payeeNameController.text = rowListPartner.payeeName;
                _payeeAccountController.text = rowListPartner.payeeCardNo;
                _remarkController.text = rowListPartner.remark;
                // _payeeCcy = _payeeCcy == '' ? rowListPartner.ccy : _payeeCcy;
                _payeeCcy = rowListPartner.ccy;
                _countryText = rowListPartner.district;
                _countryCode = rowListPartner.district;
                if (_language == 'zh_CN' || _language == 'zh_HK') {
                  _bankNameController.text = rowListPartner.payeeBankLocalName;
                } else {
                  _bankNameController.text = rowListPartner.payeeBankEngName;
                }
                _bankSwiftController.text = rowListPartner.bankSwift;
                payeeBankCode = rowListPartner.bankCode;
                payerBankCode = rowListPartner.payerBankCode;
                payeeName = _payeeNameController.text;
                // payerName = rowListPartner.payerName;
                _payeeCcy = _payeeCcy == '' ? rowListPartner.ccy : _payeeCcy;
                if (rowListPartner.paysMethod == null) {
                  _transferFeeCode = '';
                  _transferFee = '';
                } else {
                  _transferFeeCode = rowListPartner.paysMethod;
                }
                _payeeAddressController.text =
                    rowListPartner == null ? '' : rowListPartner.payeeAddress;
              }
              _boolBut();
              _rateCalculate();
              _loadLocalCcy();
              _getTransferFeeList();
            });
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Image(
          image: AssetImage('images/login/login_input_account1.png'),
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  //提交按钮
  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      child: HsgButton.button(
        title: S.current.next_step,
        click: _isClick ? _judgeDialog : null,
        isColor: _isClick,
      ),
    );
  }

  _judgeDialog() {
    //判断是不是冻结户,不是正常户
    if (_rollOutModel.acSts != 'N' && _rollOutModel.acSts != '8') {
      HSProgressHUD.showToastTip(
        S.current.transfer_account_error_tip,
      );
      return;
    }
    if (double.parse(_payerTransferController.text) > double.parse(_balance)) {
      HSProgressHUD.showToastTip(
        S.current.tdContract_balance_insufficient,
      );
    } else if (_payeeCcy == _payerCcy &&
        _payerAccount == _payeeAccountController.text) {
      HSProgressHUD.showToastTip(
        S.of(context).no_account_ccy_transfer,
      );
    } else {
      _queryFee();
    }
  }

  //币种弹窗
  Future _payerCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _payerCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _payerIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payerIndex = result;
        _payerCcy = _payerCcyList[result];
        _boolBut();
      });
      _loadData(_payerAccount);
    }
  }

  Future _payeeCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _payeeCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _payeeIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payeeIndex = result;
        _payeeCcy = _payeeCcyList[result];
        _boolBut();
      });
    }
    _rateCalculate();
  }

  //账号弹窗
  _payerAccountDialog() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: _payerAccountList,
            lastSelectedPosition: _payerAccountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _payerAccountIndex = result;
        _payerAccount = _payerAccountList[result];
        _rollOutModel = _rollOutList[result];
      });
      _loadData(_payerAccount);
    }
  }

  //转账费用
  _selectTransferFee() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.current.transfer_fee,
            items: transferFeeList,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _transferFeeIndex = result;
        _transferFeeCode = transferFeeCodeList[result];
        _transferFee = transferFeeList[result];
        _boolBut();
      });
    }
  }

  //按钮是否能点击
  _boolBut() {
    if ((_payerTransferController.text != '' &&
            _payeeTransferController.text != '') &&
        _payeeNameController.text != '' &&
        _payeeAccountController.text != '' &&
        _payeeCcy != '' &&
        _countryText != '' &&
        _bankNameController.text != '' &&
        _bankSwiftController.text.length > 0 &&
        _transferFee != '' &&
        _payeeAddressController.text != '') {
      return setState(() {
        _isClick = true;
      });
    } else {
      return setState(() {
        _isClick = false;
      });
    }
  }

  //实线
  _getLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
  }

  //默认初始卡号
  _loadTransferData() async {
    Future.wait({
      // CardDataRepository().getCardList('GetCardList'),
      ApiClientAccount().getCardList(GetCardListReq()),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          _rollOutList = element.cardList;
          _rollOutModel = element.cardList[0];
          if (this.mounted) {
            if (element != null &&
                element.cardList != null &&
                element.cardList.length > 0) {
              setState(() {
                //付款方卡号
                _payerAccount = element.cardList[0].cardNo;
                // payerBankCode = payeeBankCode = element.cardList[0].bankCode;
                element.cardList.forEach((e) {
                  _payerAccountList.add(e.cardNo);
                });
                _payerAccountList = _payerAccountList.toSet().toList();
              });
            }
          }
          _loadData(_payerAccount);
        }
      });
    });
  }

  _loadData(String cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    _localeCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    // CardDataRepository()
    ApiClientAccount()
        .getCardBalByCardNo(GetSingleCardBalReq(cardNo))
        .then((element) {
      if (this.mounted) {
        setState(() {
          //初始币种和余额
          if (_payerCcy == '' || _balance == '') {
            _payerCcy = element.cardListBal[0].ccy;
            _balance = element.cardListBal[0].currBal;
            element.cardListBal.forEach((element) {
              if (element.ccy == _localeCcy) {
                _payerCcy = element.ccy;
                _balance = element.currBal;
              }
            });
          }
          _payerCcyList.clear();
          _balanceList.clear();
          _payerIndex = 0;
          element.cardListBal.forEach((element) {
            _payerCcyList.add(element.ccy);
            _balanceList.add(element.currBal);
          });
          if (_payerCcyList.length == 0) {
            _payerCcyList.add(_localeCcy);
            _balanceList.add('0.0');
          }
          if (_payerCcyList.length > 1) {
            for (int i = 0; i < _payerCcyList.length; i++) {
              if (_payerCcy == _payerCcyList[i]) {
                _balance = _balanceList[i];
                break;
              } else {
                _payerIndex++;
              }
            }
          } else {
            _payerCcy = _payerCcyList[0];
            _balance = _balanceList[0];
          }
          if (!_payerCcyList.contains(_payerCcy)) {
            _payerCcy = _payerCcyList[0];
            _balance = _balanceList[0];
            _payerIndex = 0;
          }
          _rateCalculate();
        });
      }
    }).catchError((e) {});
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("CCY")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _payeeCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _payeeCcyList.add(e.code);
        });
      }
      _payeeIndex = 0;
      for (int i = 0; i < _payeeCcyList.length; i++) {
        if (_payeeCcy == _payeeCcyList[i]) {
          break;
        } else {
          _payeeIndex++;
        }
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
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
          rate = data.optExRate;
        });
        _boolBut();
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  //获取用户真实姓名
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // payerName = (_language == 'zh_CN' || _language == 'zh_HK')
      //     ? prefs.getString(ConfigKey.CUST_LOCAL_NAME)
      //     : prefs.getString(ConfigKey.CUST_ENG_NAME);
      payerName = prefs.getString(ConfigKey.CUST_ENG_NAME);
    });
  }

  //获取转账费用列表
  Future _getTransferFeeList() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("PAY_METHOD")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        transferFeeList.clear();
        transferFeeCodeList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN') {
            transferFeeList.add(e.cname);
            transferFeeCodeList.add(e.code);
          } else if (_language == 'zh_HK') {
            transferFeeList.add(e.chName);
            transferFeeCodeList.add(e.code);
          } else {
            transferFeeList.add(e.name);
            transferFeeCodeList.add(e.code);
          }
        });
      }
      for (int i = 0; i < transferFeeCodeList.length; i++) {
        if (transferFeeCodeList[i] == _transferFeeCode) {
          if (this.mounted) {
            setState(() {
              _transferFee = transferFeeList[i];
            });
          }
          break;
        }
      }
      // }
    });
  }

  //根据银行Swift查询银行名称
  Future _getBankNameBySwift(String swift) async {
    // TransferDataRepository()
    //     .getInfoBySwiftCode(GetInfoBySwiftCodeReq(swift), 'getInfoBySwiftCode')
    Transfer().getInfoBySwiftCode(GetInfoBySwiftCodeReq(swift)).then((data) {
      if (this.mounted) {
        setState(() {
          _bankNameController.text =
              data.swiftName1 + data.swiftName2 + data.swiftName3;
          _boolBut();
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future _queryFee() async {
    HSProgressHUD.show();
    final prefs = await SharedPreferences.getInstance();
    String custId = prefs.getString(ConfigKey.CUST_ID);
    String ac = _payerAccount;
    String amt = _payerTransferController.text;
    String ccy = _payerCcy;
    if (payeeName.isEmpty) {
      payeeName = _payeeNameController.text;
    }
    if (payeeBankCode.isEmpty) {
      payeeBankCode = _bankSwiftController.text;
    }
    Transfer().queryFee(QueryFeeReq(ac, amt, ccy, custId)).then((data) {
      _pFee = data.recordLists[0].pFee;
      _feeCode = data.recordLists[0].feeC;
      if (double.parse(_pFee) > double.parse(amt)) {
        HSProgressHUD.showToastTip(
          S.current.transfer_less_than_feeAmount,
        );
      } else {
        Navigator.pushNamed(
          context,
          pageTransferInternationalPreview,
          arguments: TransferInternationalData(
            _opt,
            _payerAccount,
            _payerTransferController.text,
            _payerCcy,
            "",
            _payeeNameController.text,
            _payeeAccountController.text,
            _payeeTransferController.text,
            _payeeCcy,
            _payeeAddressController.text,
            _countryText,
            _bankNameController.text,
            _bankSwiftController.text,
            "",
            _transferFee,
            "",
            _remarkController.text,
            payeeBankCode,
            payeeName,
            payerBankCode,
            payerName,
            _countryCode,
            rate,
            // _transferFeeIndex.toString(),
            _transferFeeCode,
            _pFee,
            _feeCode,
          ),
        );
      }
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }
}
