import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///操作成功页面
/// Author: fangluyao
/// Date: 2021-01-11

import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/hsg_transfer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HsgColors.firstDegreeText,
                ),
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
          // Navigator.of(context).pushReplacement(
          //     new MaterialPageRoute(builder: (context) => new IndexPage()));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) {
            return TransferPage();
          }), (Route route) {
            //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
            print(route.settings?.name);
            if (route.settings?.name == "/hsg_index_page") {
              return true; //停止关闭
            }
            return false; //继续关闭
          });
        },
        child: Text(name),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
