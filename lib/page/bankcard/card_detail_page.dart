import 'package:ebank_mobile/data/source/bank_data_repository.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-11-05

import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_bank_info_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list_bal_by_user.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/linear_loading.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'card_list_page.dart';

class CardDetailPage extends StatefulWidget {
  final RemoteBankCard card;
  CardDetailPage({Key key, this.card}) : super(key: key);

  @override
  _CardDetailPageState createState() => _CardDetailPageState(card);
}

class _CardDetailPageState extends State<CardDetailPage> {
  var totalBalance = '0.0';
  var bals = [];
  var singleLimit = '0.0';
  var dailyLimitAmt = '0.0';
  var dailyLimit = '0';

  var _isLoading = true;
  RemoteBankCard card;

  _CardDetailPageState(this.card);

  @override
  void initState() {
    super.initState();
    _loadCardData(card.cardNo);
  }

  @override
  Widget build(BuildContext context) {
    // card = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.account_management),
        bottom: LinearLoading(
          isLoading: _isLoading,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: getCard(card),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.account_balance,
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("${S.current.account_balance}(CNY)")),
                      Container(
                        child: Text(FormatUtil.formatSringToMoney(totalBalance),
                            style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 16),
                ),
                Container(
                  child: Divider(),
                  margin: EdgeInsets.only(top: 8),
                ),
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bals.length,
                      itemBuilder: (BuildContext context, int position) {
                        return _getCcyRow(bals[position]);
                      }),
                  margin: EdgeInsets.only(top: 8),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(S.current.transaction_amount_limit)),
                          Container(
                            child: Text(
                                FormatUtil.formatSringToMoney(singleLimit),
                                style: TextStyle(color: Colors.grey)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Divider(),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Text(S.current.daily_amount_of_transcation)),
                          Container(
                            child: Text(
                                FormatUtil.formatSringToMoney(dailyLimitAmt),
                                style: TextStyle(color: Colors.grey)),
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Divider(),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Text(S.current.daily_number_of_transaction)),
                          Container(
                            child: Text(dailyLimit,
                                style: TextStyle(color: Colors.grey)),
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                  ])),
        ],
      ),
    );
  }

  _getCcyRow(CardBalBean bal) {
    return Row(
      children: [
        Expanded(child: Text(bal.ccy)),
        Container(
          child: Text(bal.equAmt, style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  _loadCardData(String cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      //根据卡号获取银行卡信息
      BankDataRepository().getBankListByCardNo(
          GetBankInfoByCardNo(cardNo), 'GetBankInfoByCardNo'),
      // CardDataRepository()
      //     .getSingleCardBal(GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq'),
      DepositDataRepository().getCardListBalByUser(
          GetCardListBalByUserReq('', [], '', ciNo), 'getCardListBalByUser')
    }).then((value) {
      value.forEach((element) {
        if (element is GetSingleCardBalResp) {
          // setState(() {
          //    totalBalance = element.totalAmt;
          //   bals.clear();
          //   bals.addAll(element.cardListBal);
          // });
        } else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            // singleLimit = FormatUtil.formatComma3(num)
            singleLimit = element.singleLimit;
            dailyLimitAmt = element.singleDayLimit;
            dailyLimit = element.singleDayCountLimit.toString();
          });
        } else if (element is GetCardListBalByUserResp) {
          setState(() {
            element.cardListBal.forEach((cardListBals) {
              totalBalance = cardListBals.currBal;
            });
          });
        }
      });
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: "Login Failed. Message: ${e.toString()}");
    });
  }
}
