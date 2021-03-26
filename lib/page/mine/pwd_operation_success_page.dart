import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
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
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                _button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //完成按钮
  Widget _button() {
    return CustomButton(
      margin: EdgeInsets.all(40),
      text: Text(
        S.of(context).complete,
        style: TextStyle(color: Colors.white),
      ),
      clickCallback: () {
        Navigator.of(context)..pop();
      },
    );
  }
}
