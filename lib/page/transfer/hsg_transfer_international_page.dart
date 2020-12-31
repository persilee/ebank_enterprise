/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/select_bank_page.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
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

  var _isLoading = false;

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

  int _lastSelectedPosition = -1;

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

  var _countryText = '';

  var _transferFee = '';

  var _feeUse = '';

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
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: '币种选择',
            items: ccyLists,
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

    //加了这个可以立即显示
    setState(() {
      _position = result;
    });
    _getavaBal(_changedCcyTitle);
  }

  //根据货币类型拿余额
  Future<Function> _getavaBal(String changedCcyTitle) {
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

  //选择国家地区
  Future<Function> _selectCountry() async {
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

  Future<Function> _selectBank() async {
    Navigator.pushNamed(context, pageSelectBank);
  }

  //转账费用
  Future<Function> _selectTransferFee() async {
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

  //汇款费用
  Future<Function> _selectFeeUse() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: '汇款用途',
            items: feeUse,
          );
        });
    if (result != null && result != false) {
      _feeUse = feeUse[result];
    }

    setState(() {
      _position = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.international_transfer),
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
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: EdgeInsets.only(top: 20),
              height: 155,
              color: Colors.white,
              child: Column(
                children: [
                  _getAddress(
                      S.current.remittance_address, S.current.please_input),
                  _getLine(),
                  Container(
                    padding: EdgeInsets.only(right: 50),
                    height: 70,
                    child: _getRedText(S.current.remitter_address_prompt),
                  ),
                ],
              ),
            ),
          ),
          TransferPayeeWidget(
              S.current.transfer_in,
              S.current.company_name,
              S.current.account_num,
              S.current.please_input,
              S.current.please_input,
              _nameInputChange,
              _accountInputChange),
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            height: 360,
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
                _getSelectColumn(S.current.receipt_bank,
                    S.current.please_select, _selectBank),
                _getLine(),
                //银行SWIFT
                _getInputColumn(S.current.bank_swift, S.current.please_input),
                _getLine(),
                //中间行
                _getInputColumn(
                    S.current.middle_bank_swift, S.current.optional),
                _getLine(),
                //收款地址
                _getAddress(
                    S.current.collection_address, S.current.please_input),
                _getLine(),
              ],
            ),
          )),
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
                      S.current.transfer_postscript, S.current.optional),
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

  _getRedText(String redText) {
    return Container(
        height: 70,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Text(
          redText,
          style: TextStyle(color: Color(0XFFA61F23), fontSize: 13.5),
        ));
  }

  _getAddress(String topText, String inputText) {
    return Container(
      height: 80,
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
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),
              ])),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                  //是否自动更正
                  autocorrect: false,
                  //是否自动获得焦点
                  autofocus: false,
                  onChanged: (payeeName) {
                    // nameChanges(payeeName);
                    print("这个是 onChanged 时刻在监听，输出的信息是：$payeeName");
                  },
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
        ],
      ),
    );
  }

  _getLine() {
    return Container(
        child: Divider(
      color: HsgColors.divider,
      height: 0.5,
    ));
  }

  _getInputColumn(String leftText, String righteText) {
    return Container(
      height: 50,
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
          Expanded(
            child: Container(
              child: TextField(
                  //是否自动更正
                  autocorrect: false,
                  //是否自动获得焦点
                  autofocus: false,
                  onChanged: (payeeName) {
                    // nameChanges(payeeName);
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
          )
        ],
      ),
    );
  }

  _getSelectColumn(String leftText, String rightText, Function selectMethod) {
    String righText = rightText == '' ? '请选择' : rightText;
    return Container(
      height: 50,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              leftText,
              style: TextStyle(color: HsgColors.firstDegreeText, fontSize: 14),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                selectMethod();
                print('选择账号');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      righText,
                      style: rightText == ''
                          ? TextStyle(
                              color: HsgColors.secondDegreeText,
                              fontSize: 13,
                            )
                          : TextStyle(
                              color: HsgColors.firstDegreeText,
                              fontSize: 13,
                            ),
                    ),
                    // child: TextField(
                    //   decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       hintText: rightText,
                    //       hintStyle: rightText == '请选择'
                    //           ? TextStyle(
                    //               color: HsgColors.hintText,
                    //               // fontSize: 14,
                    //             )
                    //           : TextStyle(
                    //               color: HsgColors.firstDegreeText,
                    //               //   fontSize: 14,
                    //             )),
                    // ),
                  )
                ],
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
