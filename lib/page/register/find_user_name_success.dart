import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 找回用户名成功页面
/// Author: pengyikang

class FindUserNameSuccess extends StatefulWidget {
  FindUserNameSuccess({Key key}) : super(key: key);

  @override
  _FindUserNameSuccessState createState() => _FindUserNameSuccessState();
}

class _FindUserNameSuccessState extends State<FindUserNameSuccess> {
  String _userName;
  @override
  Widget build(BuildContext context) {
    _userName = ModalRoute.of(context).settings.arguments;

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
              //欢迎注册
              getRegisterTitle(S.current.forget_username),
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
                        S.current.find_username,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${S.current.login_account_placeholder} :$_userName',
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
                        decoration: BoxDecoration(),
                        child: FlatButton(
                          child: Text(
                            S.current.go_to_login,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     pageRegisterSuccess,
                            //     ModalRoute.withName("/"), //清除旧栈需要保留的栈 不清除就不写这句
                            //     arguments: _userName //传值
                            //     );
                            // Navigator.popAndPushNamed(context, pageHome,
                            //     arguments: _userName);
                            Navigator.pop(context, _userName);
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
