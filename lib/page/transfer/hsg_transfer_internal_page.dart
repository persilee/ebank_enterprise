/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/timeDeposit/time_deposit_contract_succeed_page.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/widget/hsg_general_button.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  var _isLoading = false;

  var payeeBankCode = '';

  var payerBankCode = '';

  List<String> totalBalances = [];

  var cardNoList = List<String>();

  var ccyListOne = List<String>();

  var ccyList = List();

  List<String> ccyLists = [];
  //List<String> ccyList = [];

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

  int _lastSelectedPosition = -1;

  String _limitMoney = '';

  @override
  void initState() {
    super.initState();
    _loadTransferData();
  }

  // ignore: missing_return
  Function _amountInputChange(String title) {
    money = double.parse(title);
  }

  // ignore: missing_return
  Function _nameInputChange(String name) {
    payeeName = name;
  }

  // ignore: missing_return
  Function _accountInputChange(String account) {
    payeeCardNo = account;
  }

  // ignore: missing_return
  Function _transferInputChange(String transfer) {
    remark = transfer;
  }

  //选择账号方法
  Future<Function> _selectAccount() async {
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
      // //余额
      // _changedRateTitle = totalBalances[result];
    }

    setState(() {
      _position = result;
    });
    _getCardTotals(_changedAccountTitle);

    //_getCcy();
  }

  Function _getCardTotals(String _changedAccountTitle) {
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

            // var ccyLists = List<String>();

            // element.cardListBal.forEach((ccylists) {
            //   ccyList.add(ccylists.ccy);
            //   if (!ccyList.contains('CNY')) {
            //     CardBalBean doListNew;
            //     dataList.insert(0, doListNew);
            //   }
            //   dataList.forEach((element) {
            //     String ccyCNY = element == null ? 'CNY' : element.ccy;
            //     ccyList.insert(0, ccyCNY);
            //   });
            // });

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
  Future<Function> _getCcy() async {
    //List<String> a = [];
    print('4444444444444');
    // if (ccyList == []) {
    //   ccyList.add(ccyListOne[]);
    // }
    //ccyList = ccyList == [] ? ccyListOne : ccyList;
    print('$ccyList pppppppppppppppppppppp');
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: '币种选择',
            items: ccyLists,
            //  ccyList = ccyList == [] ? ccyListOne : ccyList,
            positiveButton: '确定',
            negativeButton: '取消',
            lastSelectedPosition: _lastSelectedPosition,
          );
        });

    if (result != null && result != false) {
      //货币种类
      _changedCcyTitle = ccyList[result];
      //余额
      _changedRateTitle = totalBalances[result];
    }

    //_getCardTotals(_changedAccountTitle);
    print('9999999999999999$_changedCcyTitle');
    //加了这个可以立即显示
    setState(() {
      _position = result;
    });
    _getavaBal(_changedCcyTitle);
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
            if (bals.contains(changedCcyTitle)) {
              //_changedRateTitle = element.cardListBal[1].avaBal;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transfer_type_0),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          TransferPayerWidget(
              _limitMoney,
              _changedCcyTitle,
              _changedRateTitle,
              _changedAccountTitle,
              ccy,
              singleLimit,
              inpuntStr,
              totalBalance,
              cardNo,
              payeeBankCode,
              money,
              payeeName,
              payeeCardNo,
              _amountInputChange,
              _selectAccount,
              _getCcy,
              _getCardTotals),
          //拿第二部分
          TransferPayeeWidget(
              S.current.receipt_side,
              S.current.name,
              S.current.account_num,
              S.current.hint_input_receipt_name,
              S.current.hint_input_receipt_account,
              _nameInputChange,
              _accountInputChange),
          TransferOtherWidget(remark, _transferInputChange),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(29.6, 30, 29.6, 0),
              margin: EdgeInsets.only(top: 60),
              child: FlatButton(
                child: Text('提交'),
                textColor: Colors.white,
                color: Colors.blue[500],
                onPressed: () {
                  _tranferAccount(context);
                  print('提交');
                },
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

  void _tranferAccount(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
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
                remark),
            'getTransferByAccount')
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      HSProgressHUD.showError(status: '${e.toString()}');
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) async {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, pageDepositRecordSucceed);
  }
}
