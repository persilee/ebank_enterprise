import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/page_route.dart';
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: HsgColors.firstDegreeText,
                  ),
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      clickCallback: () {
        // Navigator.of(context)..pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return IndexPage();
          }),
          (Route route) {
            //一直关闭，直到我的或者首页时停止，停止时，整个应用只有我的和当前页面
            print(route.settings?.name);
            if (route.settings?.name == minePage ||
                route.settings?.name == "/") {
              //'/'
              return true; //停止关闭
            }
            return false; //继续关闭
          },
        );
      },
    );
  }
}
