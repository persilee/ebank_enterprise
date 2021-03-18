/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册成功页面
/// Author: pengyikang

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

class RegisterSuccessPage extends StatefulWidget {
  RegisterSuccessPage({Key key}) : super(key: key);

  @override
  _RegisterSuccessPageState createState() => _RegisterSuccessPageState();
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.operation_successful),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //欢迎注册
          getRegisterTitle('欢迎注册'),
          Container(
            padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: Image.asset(
              'images/time_depost/time_deposit_contract_succeed.png',
              width: 64.0,
              height: 64.0,
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    '注册成功',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          //完成按钮
          Container(
              margin: EdgeInsets.only(left: 37.5, right: 37.5, top: 125),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: HsgColors.accent,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: FlatButton(
                      child: Text(
                        S.current.complete,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, pageHome);
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
