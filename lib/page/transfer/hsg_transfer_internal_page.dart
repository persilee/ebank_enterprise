import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///行内转账页面
/// Author: lijiawei
/// Date: 2020-12-09
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/approval/get_card_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';

import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';
import 'data/transfer_internal_data.dart';

class TransferInternalPage extends StatefulWidget {
  TransferInternalPage({Key key}) : super(key: key);

  @override
  _TransferInternalPageState createState() => _TransferInternalPageState();
}

class _TransferInternalPageState extends State<TransferInternalPage> {
  SliverToBoxAdapter _gaySliver = SliverToBoxAdapter(
    child: Container(
      height: 15,
    ),
  );

  var totalBalance = '0.0';

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

  String _changedCcyTitle = '';

  var payeeNameForSelects = '';

  var _transferMoneyController = new TextEditingController();
  var _focusNode = new FocusNode();

  var _remarkController = new TextEditingController();

  var _nameController = new TextEditingController();

  var _accountController = new TextEditingController();

  var accountSelect = '';

  var _loacalCurrBal = '';

  String _inputPassword = '';

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
  String _xRate = '';

  //按钮是否能点击
  bool _isClick = false;

  //交易密码
  var check = false;

  String _language = Intl.getCurrentLocale();

  var _accountFocusNode = FocusNode();
  bool _isAccount = true; //账号是否存在

  @override
  void initState() {
    super.initState();
    _loadLocalCcy();
    _loadTransferData();
    _actualNameReqData();

    _transferMoneyController.addListener(() {
      if (_transferMoneyController.text.length == 0 ||
          _transferMoneyController.text == '0') {
        setState(() {
          _amount = '0';
          _xRate = '-';
        });
      } else if (_transferCcy != '') {
        _rateCalculate();
        // _focusNode.addListener(() {
        //   _rateCalculate();
        // });
      }
    });
    _accountFocusNode.addListener(() {
      if (_accountController.text.length > 0) {
        _getCardByCardNo(_accountController.text);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _remarkController.dispose();
    _transferMoneyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (_arguments != null && !check) {
        Rows rowPartner = _arguments;
        _nameController.text = rowPartner.payeeName;
        _accountController.text = rowPartner.payeeCardNo;
        _remarkController.text = rowPartner.remark;
        payeeBankCode = rowPartner.bankCode;
        payerBankCode = rowPartner.payerBankCode;
        payeeName = rowPartner.payeeName;
        payerName = rowPartner.payerName;
        _transferCcy = rowPartner.ccy;
        check = true;
        _isAccount = false;
        _boolBut();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_0),
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
          color: HsgColors.commonBackground,
          child: CustomScrollView(
            slivers: [
              _gaySliver,
              //转账金额和币种
              TransferAccount(
                payCcy: _payCcy,
                transferCcy: _transferCcy,
                limit: _limit,
                account: _account,
                balance: _balance,
                amount: _amount,
                rate: _xRate,
                transferMoneyController: _transferMoneyController,
                callback: _boolBut,
                payCcyDialog: payCcyDialog,
                transferCcyDialog: transferCcyDialog,
                accountDialog: _accountDialog,
                focusNode: _focusNode,
              ),
              //收款方
              _payeeWidget(),
              //附言
              _remarkWidget(),
              //提交按钮
              _submitButton(),
            ],
          ),
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
              title: S.of(context).receipt_side_name,
              hintText: S.of(context).hint_input_receipt_name,
              widget: _getImage(),
              keyboardType: TextInputType.text,
              controller: _nameController,
              callback: _boolBut,
              isWidget: true,
              length: 35,
              isRegEXp: true,
              // regExp: _language == 'zh_CN' ? '[\u4e00-\u9fa5]' : '[a-zA-Z]',
              regExp: '[\u4e00-\u9fa5a-zA-Z0-9 ]',
            ),
            TextFieldContainer(
              title: S.of(context).receipt_side_account,
              hintText: S.of(context).hint_input_receipt_account,
              keyboardType: TextInputType.number,
              controller: _accountController,
              focusNode: _accountFocusNode,
              callback: _boolBut,
              length: 20,
              isRegEXp: true,
              regExp: '[0-9]',
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
            S.of(context).receipt_side,
            style: TextStyle(color: HsgColors.describeText, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  //附言
  Widget _remarkWidget() {
    return SliverToBoxAdapter(
      child: Container(
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

  //提交按钮
  Widget _submitButton() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 50),
        child: HsgButton.button(
          title: S.current.next_step,
          click: _isClick ? _judgeDialog : null,
          isColor: _isClick,
        ),
      ),
    );
  }

  _judgeDialog() {
    // if (double.parse(_transferMoneyController.text) > double.parse(_limit) ||
    if (double.parse(_transferMoneyController.text) > double.parse(_balance)) {
      // if (double.parse(_limit) > double.parse(_balance)) {
      Fluttertoast.showToast(
        msg: S.current.tdContract_balance_insufficient,
        gravity: ToastGravity.CENTER,
      );
      // } else {
      //   Fluttertoast.showToast(
      //     msg: "超过限额",
      //     gravity: ToastGravity.CENTER,
      //   );
      // }
    } else if (_isAccount) {
      Fluttertoast.showToast(
        msg: S.current.account_no_exist,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Navigator.pushNamed(
        context,
        pageTransferInternalPreview,
        arguments: TransferInternalData(
          _account,
          _transferMoneyController.text,
          _payCcy,
          _nameController.text,
          _accountController.text,
          _amount,
          _transferCcy,
          _remarkController.text,
          payeeBankCode,
          payeeName,
          payerBankCode,
          payerName,
          _xRate,
        ),
        // TransferInternalData(
        //   _account,
        //   _amount,
        //   _transferCcy,
        //   _nameController.text,
        //   _accountController.text,
        //   _transferMoneyController.text,
        //   _payCcy,
        //   _remarkController.text,
        //   payeeBankCode,
        //   payeeName,
        //   payerBankCode,
        //   _nameController.text ?? '',
        //   _xRate,
        // ),
      );
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
        _boolBut();
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

  //按钮是否能点击
  _boolBut() {
    if (_transferMoneyController.text != '' &&
        _nameController.text != '' &&
        _accountController.text != '' &&
        _transferCcy != '') {
      return setState(() {
        _isClick = true;
      });
    } else {
      return setState(() {
        _isClick = false;
      });
    }
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
                _nameController.text = rowListPartner.payeeName;
                _accountController.text = rowListPartner.payeeCardNo;
                _remarkController.text = rowListPartner.remark;
                _transferCcy =
                    _transferCcy == '' ? rowListPartner.ccy : _transferCcy;
                _isAccount = false;
              }
              _boolBut();
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
                _account = element.cardList[0].cardNo;
                payerBankCode = payeeBankCode = element.cardList[0].bankCode;
                element.cardList.forEach((e) {
                  _accountList.add(e.cardNo);
                });
                _accountList = _accountList.toSet().toList();
              });
            }
          }
          // _getCardTotal(_account);
          _loadData(_account);
          // _loadLocalCcy();
          // _payCcyList.clear();
          // _payCcy = _localeCcy;
          // _payCcyList.add(_localeCcy);
          // _balance = '10000';
          // _limit = '5000';
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
          // _getTransferCcySamePayCcy();
          _rateCalculate();
        });
      }
    }).catchError((e) {});
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
              //     _xRate = '1';
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
          _xRate = '-';
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
            _xRate = data.optExRate;
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
      // Fluttertoast.showToast(msg: e.toString(),gravity: ToastGravity.CENTER,);
    });
  }

  //根据账号查询名称
  Future _getCardByCardNo(String cardNo) async {
    TransferDataRepository()
        .getCardByCardNo(GetCardByCardNoReq(cardNo), 'getCardByCardNo')
        .then((data) {
      if (this.mounted) {
        setState(() {
          _nameController.text = data.ciName;
          _isAccount = false;
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

  //获取验证码接口
  _getVerificationCode() async {
    // RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    // if (characters.hasMatch('123456') == false) {
    //   // HSProgressHUD.showInfo(status: S.current.format_mobile_error);
    // } else {
    HSProgressHUD.show();
    VerificationCodeRepository()
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq('', '13411111111', 'transactionPwd', ''),
            'sendSms')
        .then((data) {
      // _startCountdown();
      setState(() {
        var _sms = '123456';
      });
      HSProgressHUD.dismiss();
    }).catchError((e) {
      ///  Fluttertoast.showToast(msg: e.toString(),gravity: ToastGravity.CENTER,);
      HSProgressHUD.dismiss();
    });
    // }
  }

  _tranferAccount(BuildContext context) {
    var smsCode = '123456';
    setState(() {
      HSProgressHUD.show();
      TransferDataRepository()
          .getTransferByAccount(
              GetTransferByAccount(
                //转账金额
                money,
                //贷方货币
                _changedCcyTitle,
                //借方货币
                _changedCcyTitle,
                //输入密码
                'L5o+WYWLFVSCqHbd0Szu4Q==',
                //收款方银行
                payeeBankCode,
                //收款方卡号
                payeeCardNo,
                //收款方姓名
                payeeName,
                //付款方银行
                payerBankCode,
                //付款方卡号
                cardNo,
                //付款方姓名
                _nameController.text ?? '',
                //附言
                remark,
                //验证码
                smsCode,
                _xRate,
              ),
              'getTransferByAccount')
          .then((value) {
        HSProgressHUD.dismiss();
      }).catchError((e) {
        HSProgressHUD.showError(status: '${e.toString()}');
      });
    });
  }

  //交易密码窗口
  void _openBottomSheet() async {
    final passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
          resultPage: pageDepositRecordSucceed,
          arguments: '0',
          isDialog: true,
          returnPasswordFunc: (password) {
            _inputPassword = password;
          },
        );
      },
    );
    if (passwordList != null && passwordList == true) {
      //}.length == 6) {
      // _tranferAccount(context);
      //_showContractSucceedPage(context);
      // _clean();
    }
  }
}
