import 'package:ebank_mobile/config/hsg_colors.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///行内转账页面
/// Author: lijiawei
/// Date: 2020-12-09
import 'package:ebank_mobile/data/source/card_data_repository.dart';

import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';

import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  var _currBal;

  List<String> ccyLists = [];

  var payerName = '';

  var ccy = '';

  double money = 0;

  var payeeName = '';

  var payeeCardNo = '';

  var remark = '';

  String _changedAccountTitle = '';

  String _changedCcyTitle = '';

  int _position = 0;

  String _limitMoney = '';

  var payeeNameForSelects = '';

  var _transferMoneyController = TextEditingController();

  var _remarkController = TextEditingController();

  var _nameController = TextEditingController();

  var _accountController = TextEditingController();

  var accountSelect = '';

  var _loacalCurrBal = '';

  String _inputPassword = '';

  //支付币种
  String _payCcy = 'CNY';
  List<String> _payCcyList = ['HKD', 'CNY', 'USD'];
  int _payIndex = 0;

  //转出币种
  String _transferCcy = '';
  int _transferIndex = 0;
  List<String> _transferCcyList = ['HKD', 'CNY', 'USD'];

  //账户选择
  String _account = '1234 5678 1234';
  List<String> _accountList = ['1234 5678 1234', '1234 5678 1234'];
  int _accountIndex = 0;

  //转账数据
  List<String> transferData = [];

  //交易密码

  var check = false;

  @override
  void initState() {
    super.initState();

    _transferMoneyController.addListener(() {
      _amountInputChange(_transferMoneyController.text); //金额输入框时调用
    });
    _loadTransferData();
  }

  _amountInputChange(String title) {
    money = double.parse(title);
  }

  _nameInputChange(String name) {
    payeeName = name;
    print("$payeeName ---------------");
  }

  _accountInputChange(String account) {
    payeeCardNo = account;
    print("$payeeCardNo  +++++++++++++");
  }

  _transferInputChange(String transfer) {
    remark = transfer;
  }

  //选择货币
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
            // if (ccyList.length > 1) {
            //   if (_changedCcyTitle == 'USD') {
            //     _position = 2;
            //   } else if (_changedCcyTitle == 'CNY') {
            //     _position = 0;
            //   }
            // } else {
            //   _position = 0;
            // }
            // if (_changedCcyTitle != 'USD' &&
            //     ccyList.length < 3 &&
            //     ccyList.length > 0) {
            //   _changedCcyTitle = 'USD';
            //   _currBal = _loacalCurrBal;
            // }
            // if (element.cardListBal.length == 0) {
            //   _currBal = '';
            //   _changedCcyTitle = 'CNY';
            //   ccyList.add('CNY');
            //   _position = 0;
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
        slivers: [
          _gaySliver,
          //转账金额和币种
          TransferAccount(
            payCcy: _payCcy,
            transferCcy: _transferCcy,
            limit: '500',
            account: _account,
            balance: '200',
            transferMoneyController: _transferMoneyController,
            payCcyDialog: payCcyDialog,
            transferCcyDialog: transferCcyDialog,
            accountDialog: _accountDialog,
          ),
          //收款方
          _payeeWidget(),
          //附言
          _remarkWidget(),
          //提交按钮
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: HsgButton.button(
                  title: '下一步',
                  click: _boolBut()
                      ? () {
                          Navigator.pushNamed(
                              context, pageTransferInternalPreview,
                              arguments: transferData);
                        }
                      : null),
            ),
          ),
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
              title: '收款方名称',
              hintText: '请输入收款方名称',
              widget: _getImage(),
              keyboardType: TextInputType.text,
              controller: _nameController,
              callback: _boolBut,
              isWidget: true,
            ),
            TextFieldContainer(
              title: '收款人账号',
              hintText: '请输入收款人账号',
              keyboardType: TextInputType.number,
              controller: _accountController,
              callback: _boolBut,
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
            '收款方',
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
          title: '转账附言',
          hintText: '转账',
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
        _payCcy = _payCcyList[_payIndex];
      });
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
        _transferCcy = _transferCcyList[_transferIndex];
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
        _account = _accountList[_accountIndex];
      });
    }
  }

  //按钮是否能点击
  _boolBut() {
    if (_transferMoneyController.text != '' &&
        _nameController.text != '' &&
        _accountController.text != '' &&
        _transferCcy != '') {
      transferData.add(_payCcy);
      transferData.add(_transferMoneyController.text);
      transferData.add(_account);
      transferData.add("121.5");
      transferData.add(_nameController.text);
      transferData.add(_accountController.text);
      transferData.add(_transferCcy);
      transferData.add(_remarkController.text);
      return true;
    } else {
      return false;
    }
  }

  //增加转账伙伴图标
  Widget _getImage() {
    return InkWell(
      onTap: () {
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

  //默认初始卡号
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
            //余额
            element.cardListBal.forEach((element) {
              ccyListOne.clear();
              ccyListOne.add(element.ccy);
              // if (element.ccy == 'USD') {
              //   _currBal = element.currBal;
              //   _changedCcyTitle = 'USD';
              //   _loacalCurrBal = _currBal;
              // }
              if (element.ccy == 'CNY') {
                _currBal = element.currBal;
                _changedCcyTitle = 'CNY';
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
    // RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
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
                  payerName,
                  //附言
                  remark,
                  //验证码
                  smsCode),
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
