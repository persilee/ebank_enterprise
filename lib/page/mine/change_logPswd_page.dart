/**
  @desc   修改登录密码
  @author hlx
 */
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';

class ChangeLoPS extends StatefulWidget {
  @override
  _ChangeLoPSState createState() => _ChangeLoPSState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangeLoPSState extends State<ChangeLoPS> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).setChangLoginPasd),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(S.of(context).plaseSetPsd),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合计',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          '￥10000.00',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF262626)),
                        ),
                      ]),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合计',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          '￥10000.00',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF262626)),
                        ),
                      ]),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合计',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          '￥10000.00',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF262626)),
                        ),
                      ]),
                   Container(
                  margin: EdgeInsets.all(40), //外边距
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    child: Text("提交"),
                    onPressed: () => print("提交"),
                    color: HsgColors.accent,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) //设置圆角
                        ),
                  ),
                )
                ],
              )),
        ));
  }
}
