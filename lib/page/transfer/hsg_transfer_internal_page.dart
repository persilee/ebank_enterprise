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
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_general_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var singleLimit = '0.0';
  // var dailyLimitAmt = '0.0';
  // var dailyLimit = '0';
  String inpuntStr;

  RemoteBankCard card;

  var _isLoading = false;

  var payeeBankCode = '';

  var payerBankCode = '';

  var cardNoList = List();

  var payerName = '';

  var ccy = '';

  double money = 0;

  var payeeName = '';

  var payeeCardNo = '';

  var remark = '';

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
              ccy,
              singleLimit,
              inpuntStr,
              totalBalance,
              cardNo,
              payeeBankCode,
              money,
              payeeName,
              payeeCardNo,
              remark,
              _amountInputChange,
              _nameInputChange,
              _accountInputChange,
              _transferInputChange),
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
            payeeBankCode = element.cardList[0].bankCode;
            //收款方银行姓名
            payerBankCode = element.cardList[0].bankCode;
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
            bals.clear();
            bals.addAll(element.cardListBal);

            totalBalance = element.totalAmt;

            ccy = element.cardListBal[0].ccy;
          });
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            //限额
            singleLimit = element.singleLimit;

            // dailyLimit = element.singleDayCountLimit.toString();
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
    Navigator.pushNamed(context, pageTransfer);
  }
}
