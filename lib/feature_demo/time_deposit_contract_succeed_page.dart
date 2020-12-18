/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */
import 'package:ebank_mobile/feature_demo/time_deposit_record_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class DepositContractSucceed extends StatefulWidget {
  DepositContractSucceed({Key key}) : super(key: key);

  @override
  _DepositContractSucceed createState() => _DepositContractSucceed();
}

class _DepositContractSucceed extends State<DepositContractSucceed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.operation_successful),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 250,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
                  child: Text(
                    S.current.operation_successful,
                    style: TextStyle(fontSize: 30),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Text(
              S.current.turn_to_current_success_sub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
            ),
          ),
          Container(
            width: 10,
            height: 85,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, pageTimeDepositRecord);
              },
              textColor: Colors.blue,
              color: Colors.blue[500],
              child: (Text(S.current.complete,
                  style: TextStyle(color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }
}
