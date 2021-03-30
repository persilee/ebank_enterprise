import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 重置密码成功页面
/// Author: pengyikang

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //修改颜色
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
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
                        S.current.changPwsSuccess,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1775BA),
                        Color(0xFF3A9ED1),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: FlatButton(
                          child: Text(
                            S.current.complete,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            //  Navigator.of(context)..pop()..pop();
                            // Navigator.pop(context,page)
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return LoginPage();
                            }), (Route route) {
                              //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
                              print(route.settings?.name);
                              // if (route.settings?.name == "/") {
                              //   return true; //停止关闭
                              // }
                              return false; //关闭所有页面
                            });
                          },
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
