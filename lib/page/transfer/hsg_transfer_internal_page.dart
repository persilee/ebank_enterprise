/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///行内转账页面
/// Author: lijiawei
/// Date: 2020-12-09
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_button_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

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

  var ccyList = ['USD'];

  var _currBal;

  List<String> ccyLists = [];

  var payerName = '';

  var ccy = '';

  double money = 0;

  var payeeName = '';

  var payeeCardNo = '';

  var remark = '';

  String _changedAccountTitle = '';

  // //余额
  // String _changedRateTitle = '';

  String _changedCcyTitle = '';

  int _position = 0;

  int _lastSelectedPosition = -1;

  int _accountIndex = 0;

  String _limitMoney = '';

  var payeeNameForSelects = '';

  var _transferMoneyController = TextEditingController();

  var _remarkController = TextEditingController();

  var _nameController = TextEditingController();

  var _accountController = TextEditingController();

  var accountSelect = '';

  var _loacalCurrBal = '';

  List<String> passwordList = []; //密码列表

  //支付密码

  var check = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      _nameInputChange(_nameController.text); //收款名字输入框内容改变时调用
    });
    _accountController.addListener(() {
      _accountInputChange(_accountController.text); //收款账号输入框时调用
    });
    _transferMoneyController.addListener(() {
      _amountInputChange(_transferMoneyController.text); //金额输入框时调用
    });
    _remarkController.addListener(() {
      _transferInputChange(_remarkController.text); //金额输入框时调用
    });
    _loadTransferData();
  }

  _amountInputChange(String title) {
    money = double.parse(title);
  }

  _nameInputChange(String name) {
    payeeName = name;
  }

  _accountInputChange(String account) {
    payeeCardNo = account;
  }

  _transferInputChange(String transfer) {
    remark = transfer;
  }

  //选择账号方法
  _selectAccount() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: cardNoList,
            lastSelectedPosition: _accountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accountIndex = result;
        _changedAccountTitle = cardNoList[_accountIndex];
      });
      _getCardTotals(_changedAccountTitle);
    }
    // setState(() {
    //   _position = result;
    // });
  }

  _getCardTotals(String _changedAccountTitle) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(_changedAccountTitle), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(_changedAccountTitle),
          'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        setState(() {
          if (element is GetSingleCardBalResp) {
            bals.clear();
            ccyLists.clear();
            ccyList.clear();
            _currBal = '';
            _position = 0;
            element.cardListBal.forEach((bals) {
              totalBalances.add(bals.avaBal);
            });
            // var cardListB = new List();
            element.cardListBal.forEach((cardBalBean) {
              if (cardBalBean.ccy != '') {
                ccyList.add(cardBalBean.ccy);
              }
              if (_changedCcyTitle == cardBalBean.ccy) {
                _currBal = cardBalBean.currBal.toString();
              }
            });
            if (ccyList.length > 1) {
              if (_changedCcyTitle == 'USD') {
                _position = 2;
              } else if (_changedCcyTitle == 'CNY') {
                _position = 0;
              }
            } else {
              _position = 0;
            }
            if (_changedCcyTitle != 'USD' &&
                ccyList.length < 3 &&
                ccyList.length > 0) {
              _changedCcyTitle = 'USD';
              _currBal = _loacalCurrBal;
            }
            if (element.cardListBal.length == 0) {
              _currBal = '';
              _changedCcyTitle = 'CNY';
              ccyList.add('CNY');
              _position = 0;
            }
            // bool isBenBi = false;
            // for (int j = 0; j < cardListB.length; j++) {
            //   if (cardListB[j].ccy == 'USD') {
            //     isBenBi = true;
            //   }
            //   if (isBenBi == false) {
            //     cardListB.insert(0, cardListB[j]);
            //   }
            //   _currBal = cardListB[j].currBal;
            //   ccyList.clear();
            //   ccyList.add(cardListB[j].ccy);
            // }
          }
          //查询限额
          else if (element is GetCardLimitByCardNoResp) {
            _limitMoney = element.singleLimit;
          }
        });
      });
    });
  }

  //选择货币方法
  _getCcy() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: S.current.currency_choice,
            items: ccyList,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
            lastSelectedPosition: _position,
          );
        });

    if (result != null && result != false) {
      //货币种类
      setState(() {
        _position = result;
        _changedCcyTitle = ccyList[_position];
      });
      //余额
      //  _changedRateTitle = totalBalances[result];
      _getCardTotals(_changedAccountTitle);
    }

    // setState(() {
    //   _position = result;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (_arguments != null && !check) {
        Rows rowPartner = _arguments;
        _nameController.text = rowPartner.payeeName;
        _accountController.text = rowPartner.payeeCardNo;
        _nameController.selection = TextSelection.collapsed(
            affinity: TextAffinity.downstream,
            offset: _nameController.text.length);
        _accountController.selection =
            TextSelection.collapsed(offset: _accountController.text.length);
        check = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_0),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          //拿币种和货币
          transferPayerWidget(
              context,
              _limitMoney,
              _changedCcyTitle,
              _currBal,
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
          //拿第二部分
          transferPayeeWidget(
              payeeCardNo,
              payeeName,
              accountSelect,
              payeeNameForSelects,
              _getImage,
              context,
              S.current.receipt_side,
              S.current.name,
              S.current.account_num,
              S.current.hint_input_receipt_name,
              S.current.hint_input_receipt_account,
              _nameInputChange,
              _accountInputChange,
              _nameController,
              _accountController),
          //第三部分
          transferOtherWidget(
              context, remark, _transferInputChange, _remarkController),
          //提交按钮
          getButton(S.current.submit, _isClick),
        ],
      ),
    );
  }

  //增加转账伙伴图标
  Widget _getImage() {
    return InkWell(
      onTap: () {
        //获取验证码
        _getVerificationCode();
        Navigator.pushNamed(context, pageTranferPartner, arguments: '0').then(
          (value) {
            setState(() {
              if (value != null) {
                Rows rowListPartner = value;
                _nameController.text = rowListPartner.payeeName;
                _accountController.text = rowListPartner.payeeCardNo;
              } else {}
            });
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

  //拿到默认卡号
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

  //默认显示货币和余额
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
            //余额
            // totalBalance = element.cardListBal[0].currBal;
            // ccy = element.cardListBal[0].ccy;
            element.cardListBal.forEach((element) {
              ccyListOne.clear();
              ccyListOne.add(element.ccy);
              if (element.ccy == 'USD') {
                _currBal = element.currBal;
                _changedCcyTitle = 'USD';
                _loacalCurrBal = _currBal;
              }
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

  //获取验证码接口
  _getVerificationCode() async {
    RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    // if (characters.hasMatch('123456') == false) {
    //   // HSProgressHUD.showInfo(status: S.current.format_mobile_error);
    // } else {
    HSProgressHUD.show();
    VerificationCodeRepository()
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq('13411111111', 'transactionPwd'), 'sendSms')
        .then((data) {
      // _startCountdown();
      setState(() {
        var _sms = '123456';
      });
      HSProgressHUD.dismiss();
    }).catchError((e) {
      ///  Fluttertoast.showToast(msg: e.toString());
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
                  ccy,
                  //借方货币
                  ccy,
                  //输入密码
                  '123456',
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
                  payerName,
                  //附言
                  remark,
                  //验证码
                  smsCode),
              'getTransferByAccount')
          .then((value) {
        HSProgressHUD.dismiss();
        _showContractSucceedPage(context);
      }).catchError((e) {
        setState(() {});
        HSProgressHUD.showError(status: '${e.toString()}');
      });
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) {
    Navigator.pushNamed(context, pageDepositRecordSucceed, arguments: '0');
  }

  _isClick() {
    if (money > 0 && payeeName.length > 0 && payeeCardNo.length > 0) {
      return () {
        _tranferAccount(context);
        _clean();
        // _openBottomSheet();
      };
    } else {
      return null;
    }
  }

  //交易密码窗口
  void _openBottomSheet() async {
    final passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
        );
      },
    );
    if (passwordList != null && passwordList == true) {
      if (passwordList.length == 6) {
        _clean();
      }
    }
  }

  //清空数据
  _clean() {
    setState(() {
      ccy = 'USD';
      _transferMoneyController.text = '';
      _nameController.text = '';
      _accountController.text = '';
      _remarkController.text = '';
      remark = '';
    });
  }
}
