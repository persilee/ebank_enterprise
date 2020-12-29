import 'package:ebank_mobile/generated/intl/messages_en.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../page_route.dart';

class OperationResultPage extends StatefulWidget {
  @override
  _OperationResultPageState createState() => _OperationResultPageState();
}

class _OperationResultPageState extends State<OperationResultPage> {
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
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 40),
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new IndexPage()));
        },
        child: Text(name),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
