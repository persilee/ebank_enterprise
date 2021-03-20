import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2021-03-17

class PwdOperationSuccessPage extends StatefulWidget {
  @override
  _PwdOperationSuccessPageState createState() =>
      _PwdOperationSuccessPageState();
}

class _PwdOperationSuccessPageState extends State<PwdOperationSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).operation_result),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 90,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text(
                S.of(context).operation_successful,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
              ),
              _button(S.of(context).complete)
            ],
          ),
        ),
      ),
    );
  }

  //按钮
  Widget _button(String name) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(top: 40),
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text(name),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
