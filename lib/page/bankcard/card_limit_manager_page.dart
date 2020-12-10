/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-11-05

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';

class CardLimitManagerPage extends StatefulWidget {
  CardLimitManagerPage({Key key}) : super(key: key);

  @override
  _CardLimitManagerPageState createState() => _CardLimitManagerPageState();
}

class _CardLimitManagerPageState extends State<CardLimitManagerPage> {
  RemoteBankCard card;
  var tranAmtLimitController = TextEditingController();
  var tranDailyAmtLimitController = TextEditingController();
  var tranDailyNumLimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    card = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Amount Limit'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: Text('Account No.')),
                Text(card.cardNo)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 14),
            child: Text(
              'Current Availble: Daily limit HKD 5.000.000.00, Yearly limit: No Limit, Daily Number Of Transactions: No Limit',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: Text('Transaction Amount Limit')),
                          Container(
                            width: 130,
                            height: 22,
                            child: TextField(
                              autofocus: true,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14),
                              controller: tranAmtLimitController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '0.00',
                                  contentPadding: EdgeInsets.all(0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Colors.grey,
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: Text('Daily Amount of Transaction')),
                          Container(
                            width: 130,
                            height: 22,
                            child: TextField(
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14),
                              controller: tranDailyAmtLimitController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '0.00',
                                  contentPadding: EdgeInsets.all(0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Divider(
                        color: Colors.grey,
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(child: Text('Daily Number of Transaction')),
                          Container(
                            width: 130,
                            height: 22,
                            child: TextField(
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14),
                              controller: tranDailyNumLimitController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '0',
                                  contentPadding: EdgeInsets.all(0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(top: 8),
                    ),
                  ])),
          Container(
              margin: EdgeInsets.only(top: 50, left: 32, right: 32),
              height: 44,
              child: FlatButton(
                  child: Text(
                    'Modify',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ))),
          Container(
              margin: EdgeInsets.only(top: 20, left: 32, right: 32),
              height: 44,
              child: FlatButton(
                  child: Text(
                    'Lock',
                  ),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey)))),
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 14),
            child: Text(
              '''Note:
1. The daily limit can be adjusted up to 5 million.
2. If the account is locked, when you need to unlock it, please bring your ID and go to the counter to unlock it.''',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              strutStyle: StrutStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
