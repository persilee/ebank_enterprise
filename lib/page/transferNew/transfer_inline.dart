/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///行内转账
/// Author: fangluyao
/// Date: 2021-04-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/approval/get_card_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_ccy_list.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/transfer.dart';
import 'package:ebank_mobile/page/transfer/data/transfer_internal_data.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class TransferInlinePage extends StatefulWidget {
  TransferInlinePage({Key key}) : super(key: key);

  @override
  _TransferInlinePageState createState() => _TransferInlinePageState();
}

class _TransferInlinePageState extends State<TransferInlinePage> {
  List<RemoteBankCard> cardList = [];

  var payeeBankCode = '';

  var payerBankCode = '';

  var payerName = '';

  var payeeName = '';

  var payeeCardNo = '';

  var _payerTransferController = new TextEditingController();

  var _focusNode = new FocusNode();

  var _payerTransferFocusNode = new FocusNode();

  var _payeeTransferFocusNode = new FocusNode();

  var _remarkController = new TextEditingController();

  var _payeeNameController = new TextEditingController();

  var _payeeAccountController = new TextEditingController();

  var _payeeTransferController = new TextEditingController();

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

  //按钮是否能点击
  bool _isClick = false;
  var check = false;

  var _payeeAccountFocusNode = FocusNode();
  bool _isAccount = true; //账号是否存在
  var _opt = '';

  @override
  void initState() {
    super.initState();
    // _loadLocalCcy();
    _loadTransferData();
    _actualNameReqData();

    _payeeAccountFocusNode.addListener(() {
      if (_payeeAccountController.text.length > 0 &&
          !_payeeAccountFocusNode.hasFocus) {
        _getCardByCardNo(_payeeAccountController.text);
        _getCardCcyList(_payeeAccountController.text);
      }
    });
    _payerTransferFocusNode.addListener(() {
      if (_payerTransferFocusNode.hasFocus) {
        if (_payerTransferController.text.length > 0) {
          setState(() {
            _payeeTransferController.text = '';
          });
        }
      } else {
        if (_payerTransferController.text.length > 0) {
          setState(() {
            _opt = 'S';
            _rateCalculate();
          });
        }
      }
      _boolBut();
      // if (_payerTransferController.text.length > 0) {
      //   setState(() {
      //     _opt = 'S';
      //     _payeeTransferController.text = '';
      //     _rateCalculate();
      //   });
      // }
      // _boolBut();
    });

    _payeeTransferFocusNode.addListener(() {
      if (_payeeTransferFocusNode.hasFocus) {
        if (_payeeTransferController.text.length > 0) {
          setState(() {
            _payerTransferController.text = '';
          });
        }
      } else {
        if (_payeeTransferController.text.length > 0) {
          setState(() {
            _opt = 'B';
            _rateCalculate();
          });
        }
      }
      _boolBut();
      // if (_payeeTransferController.text.length > 0) {
      //   setState(() {
      //     _opt = 'B';
      //     _payerTransferController.text = '';
      //     _rateCalculate();
      //   });
      // }
      // _boolBut();
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
    setState(() {
      if (_arguments != null && !check) {
        Rows rowPartner = _arguments;
        _payeeNameController.text = rowPartner.payeeName;
        _payeeAccountController.text = rowPartner.payeeCardNo;
        _remarkController.text = rowPartner.remark;
        payeeBankCode = rowPartner.bankCode;
        payerBankCode = rowPartner.payerBankCode;
        payeeName = rowPartner.payeeName;
        payerName = rowPartner.payerName;
        _payeeCcy = rowPartner.ccy;
        check = true;
        _isAccount = false;
        _boolBut();
        _getCardCcyList(_payeeAccountController.text);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_0),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _payerWidget(),
          _payeeWidget(),
          // _transferWidget(),
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
          _titleName(S.of(context).transfer_from1),
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
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    payerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
          Container(
            color: Colors.white,
            child: SelectInkWell(
              title: S.of(context).payer_currency,
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
            regExp: '[\u4e00-\u9fa5a-zA-Z0-9 ]',
          ),
          Container(
            // padding: EdgeInsets.only(right: 15, left: 15),
            color: Colors.white,
            child: SelectInkWell(
              title: S.current.transfer_from_ccy,
              item: _payeeCcy == null ? '' : _payeeCcy,
              onTap: _isAccount
                  ? () {
                      Fluttertoast.showToast(
                        msg: S.of(context).please_current_payee_account,
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  : () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _payeeCcyDialog();
                    },
            ),
          ),
          TextFieldContainer(
            title: S.of(context).transfer_to_amount,
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
          _titleName(S.current.transfer_amount),
          TextFieldContainer(
            title: S.current.to_amount + "（" + _payerCcy + "）",
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
            title: S.current.transfer_to_account + "（" + _payeeCcy + "）",
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

  //附言
  Widget _remarkWiget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextFieldContainer(
        title: S.current.transfer_postscript,
        hintText: S.current.transfer,
        keyboardType: TextInputType.text,
        controller: _remarkController,
        callback: _boolBut,
      ),
    );
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
        Navigator.pushNamed(context, pageTranferPartner, arguments: '0').then(
          (value) {
            setState(() {
              if (value != null) {
                Rows rowListPartner = value;
                _payeeNameController.text = rowListPartner.payeeName;
                _payeeAccountController.text = rowListPartner.payeeCardNo;
                _remarkController.text = rowListPartner.remark;
                _payeeCcy = _payeeCcy == '' ? rowListPartner.ccy : _payeeCcy;
                _isAccount = false;
              }
              _boolBut();
              _rateCalculate();
              _getCardCcyList(_payeeAccountController.text);
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
    if (double.parse(_payerTransferController.text) > double.parse(_balance)) {
      Fluttertoast.showToast(
        msg: S.current.tdContract_balance_insufficient,
        gravity: ToastGravity.CENTER,
      );
    } else if (_isAccount) {
      Fluttertoast.showToast(
        msg: S.current.account_no_exist,
        gravity: ToastGravity.CENTER,
      );
    }
    if (_payeeCcy == _payerCcy &&
        _payerAccount == _payeeAccountController.text) {
      Fluttertoast.showToast(
        msg: S.of(context).no_account_ccy_transfer,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Navigator.pushNamed(
        context,
        pageTransferInternalPreview,
        arguments: TransferInternalData(
          _payerAccount,
          _payerTransferController.text,
          _payerCcy,
          _payeeNameController.text,
          _payeeAccountController.text,
          _payeeTransferController.text,
          _payeeCcy,
          _remarkController.text,
          payeeBankCode,
          payeeName,
          payerBankCode,
          payerName,
          rate,
          _opt,
        ),
      );
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
      });
      _loadData(_payerAccount);
    }
  }

  //按钮是否能点击
  _boolBut() {
    if ((_payerTransferController.text != '' ||
            _payeeTransferController.text != '') &&
        _payeeNameController.text != '' &&
        _payeeAccountController.text != '' &&
        _payeeCcy != '') {
      return setState(() {
        _isClick = true;
      });
    } else {
      return setState(() {
        _isClick = false;
      });
    }
  }

  //默认初始卡号
  _loadTransferData() async {
    Future.wait({
      CardDataRepository().getCardList('GetCardList'),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          if (this.mounted) {
            if (element != null &&
                element.cardList != null &&
                element.cardList.length > 0) {
              setState(() {
                //付款方卡号
                _payerAccount = element.cardList[0].cardNo;
                payerBankCode = payeeBankCode = element.cardList[0].bankCode;
                payerName = element.cardList[0].ciName;
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
    CardDataRepository()
        .getCardBalByCardNo(GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq')
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
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("CCY"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _payeeCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _payeeCcyList.add(e.code);
        });
      }
    });
  }

  //获取账号支持币种
  Future _getCardCcyList(String cardNo) async {
    // TransferDataRepository()
    //     .getCardCcyList(GetCardCcyListReq(cardNo), 'GetCardCcyList')
    Transfer().getCardCcyList(GetCardCcyListReq(cardNo)).then((data) {
      if (data.recordLists != null) {
        _payeeCcyList.clear();
        data.recordLists.forEach((e) {
          _payeeCcyList.add(e.ccy);
        });
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    if (_payeeCcy != '' &&
        _payerCcy != '' &&
        (_payeeTransferController.text != '' ||
            _payerTransferController.text != '')) {
      // ForexTradingRepository()
      //     .transferTrial(
      //         TransferTrialReq(
      //           opt: _opt,
      //           buyCcy: _payerCcy,
      //           sellCcy: _payeeCcy,
      //           buyAmount: _payerTransferController.text == ''
      //               ? '0'
      //               : _payerTransferController.text,
      //           sellAmount: _payeeTransferController.text == ''
      //               ? '0'
      //               : _payeeTransferController.text,
      //         ),
      //         'TransferTrialReq')
              Transfer().transferTrial(
              TransferTrialReq(
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
        print(" opt: " +
            _opt +
            " sellCcy: " +
            _payeeCcy +
            " buyCcy: " +
            _payerCcy +
            " sellAmout: " +
            _payeeTransferController.text +
            " buyAmount: " +
            _payerTransferController.text);
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
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  //获取用户真实姓名
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(GetUserInfoReq(userID), "getUserInfo")
        .then((data) {
      if (this.mounted) {
        setState(() {
          payerName = data.actualName;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //根据账号查询名称
  Future _getCardByCardNo(String cardNo) async {
    // TransferDataRepository()
    //     .getCardByCardNo(GetCardByCardNoReq(cardNo), 'getCardByCardNo')
    Transfer().getCardByCardNo(GetCardByCardNoReq(cardNo)).then((data) {
      if (this.mounted) {
        setState(() {
          _payeeNameController.text = data.ciName;
          _isAccount = false;
          _boolBut();
        });
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {
          _isAccount = true;
        });
      }
      Fluttertoast.showToast(
        msg: S.current.no_account,
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
