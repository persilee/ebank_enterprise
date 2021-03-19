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
import 'package:fluttertoast/fluttertoast.dart';

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
  List<String> _transferCcyList = ['HKD', 'CNY', 'USD', 'LAK', 'EUR'];

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

  //按钮是否能点击
  bool _isClick = false;

  //交易密码
  var check = false;

  @override
  void initState() {
    super.initState();

    _loadTransferData();
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
            limit: _limit,
            account: _account,
            balance: _balance,
            transferMoneyController: _transferMoneyController,
            callback: _boolBut,
            payCcyDialog: payCcyDialog,
            transferCcyDialog: transferCcyDialog,
            accountDialog: _accountDialog,
          ),
          //收款方
          _payeeWidget(),
          //附言
          _remarkWidget(),
          //提交按钮
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
              title: S.of(context).receipt_side_name,
              hintText: S.of(context).hint_input_receipt_name,
              widget: _getImage(),
              keyboardType: TextInputType.text,
              controller: _nameController,
              callback: _boolBut,
              isWidget: true,
            ),
            TextFieldContainer(
              title: S.of(context).receipt_side_account,
              hintText: S.of(context).hint_input_receipt_account,
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
      _getCardTotal(_account);
    }
  }

  //提交按钮
  Widget _submitButton() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 100, bottom: 50),
        child: HsgButton.button(
            title: S.current.next_step, click: _isClick ? _judgeDialog : null),
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
        pageTransferInternalPreview,
        arguments: TransferInternalData(
          _account,
          '123',
          _transferCcy,
          _nameController.text,
          _accountController.text,
          _transferMoneyController.text,
          _payCcy,
          _remarkController.text,
        ),
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
        Navigator.pushNamed(context, pageTranferPartner, arguments: '0').then(
          (value) {
            setState(() {
              if (value != null) {
                Rows rowListPartner = value;
                _nameController.text = rowListPartner.payeeName;
                _accountController.text = rowListPartner.payeeCardNo;
              }
              _boolBut();
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
      _payCcyList.clear();
      _payCcy = _localeCcy;
      _payCcyList.add(_localeCcy);
      _balance = '10000';
      _limit = '5000';
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
}
