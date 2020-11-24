import 'dart:async';

import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/linear_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/global_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  var _loginText = 'LOGIN';
  var _changeLangBtnTltle = '中文';

  @override
  Widget build(BuildContext context) {
    Widget backgroundImgWidget = new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login/login_bg_password.png'),
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget contentWidget = new Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //选择语言按钮
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    //填充左侧，使button自适应宽度
                    Expanded(child: Container()),
                    LanguageChangeBtn(_changeLangBtnTltle),
                  ],
                ),
              ),
              //头部logo
              Container(
                margin: EdgeInsets.only(top: 45),
                child: HeaderLogoView(),
              ),
              //账号输入框
              Container(
                margin: EdgeInsets.only(top: 36.5),
                child: InputView(
                  imgName: 'images/login/login_input_accout.png',
                  textFieldPlaceholder: '邮箱/手机号/用户ID',
                  isCiphertext: false,
                ),
              ),
              //密码输入框
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: InputView(
                  imgName: 'images/login/login_input_password.png',
                  textFieldPlaceholder: '请输入密码',
                  isCiphertext: true,
                ),
              ),
              //忘记按钮
              Container(
                margin: EdgeInsets.only(top: 10, right: 35, left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //ForgetButton('忘记账户？'),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: ForgetButton('忘记密码？', () {
                        setState(() {
                          print('忘记密码');
                        });
                      }),
                    )
                  ],
                ),
              ),
              //登录按钮
              Container(
                margin: EdgeInsets.only(top: 40, left: 36.0, right: 36.0),
                child: UnderButtonView(() {
                  _login(context);
                }),
              )
            ],
          ),
        ),
      ),
    );

    return MaterialApp(
      home: Stack(
        children: [
          backgroundImgWidget,
          contentWidget,
        ],
      ),
    );
    // return Scaffold(
    // appBar: AppBar(
    //   title: Text("Login"),
    //   bottom: LinearLoading(
    //     isLoading: _isLoading,
    //   ),
    // ),
    // body: Center(
    //   child: RaisedButton(
    //     child: Text(
    //       _loginText,
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     onPressed: _isLoading ? null : () => _login(context),
    //     color: Colors.pinkAccent,
    //   ),
    // ),
    // );
  }

  ///登录操作
  _login(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    UserDataRepository().login(LoginReq(), 'login').then((value) {
      Fluttertoast.showToast(msg: "Login Success. User: ${value.actualName}");
      _showMainPage(context);
      _saveUserConfig(value);
    }).catchError((e) {
      Fluttertoast.showToast(msg: "Login Failed. Message: ${e.toString()}");
    });
  }

  ///登录成功-跳转操作
  _showMainPage(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, pageCardList);
  }

  ///保存数据
  _saveUserConfig(LoginResp resp) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.USER_ACCOUNT, resp.userPhone);
    prefs.setString(ConfigKey.USER_ID, resp.userId);
  }
}

/// 语言选择按钮
// ignore: must_be_immutable
class LanguageChangeBtn extends StatefulWidget {
  String title;

  LanguageChangeBtn(this.title);

  @override
  _LanguageChangeBtnState createState() => _LanguageChangeBtnState(title);
}

class _LanguageChangeBtnState extends State<LanguageChangeBtn> {
  String title;

  _LanguageChangeBtnState(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(right: 15),
      child: FlatButton(
        onPressed: () {
          print('LanguageChangeBtn.title == ${widget.title}');
          setState(() {
            title = 'English';
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeTitle2(String titleString) {
    setState(() {
      title = titleString;
    });
  }
}

/// 头部logo
class HeaderLogoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/login/login_header_logo.png',
      width: 195,
      height: 45.5,
    );
  }
}

///输入模块，带提示图标
class InputView extends StatelessWidget {
  InputView({this.imgName, this.textFieldPlaceholder, this.isCiphertext});

  final String imgName;
  final String textFieldPlaceholder;
  final bool isCiphertext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      margin: EdgeInsets.only(left: 35.0, right: 35.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Image(
              image: AssetImage(imgName),
              width: 19.5,
              height: 19.5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: TextField(
                  autofocus: true,
                  obscureText: this.isCiphertext,
                  style: TextStyle(
                    fontSize: 15,
                    color: kColor38,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: this.textFieldPlaceholder,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: kColorPlaceholder,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 忘记按钮
class ForgetButton extends StatelessWidget {
  ForgetButton(this.title, this.onClick);

  final String title;

  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text.rich(
        TextSpan(
          text: title,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.white,
            fontSize: 12,
          ),
          //设置点击事件
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print('title == $title');
              // languaeChangeBtn.changTitle('titles');
              // languaeChangeBtn.createState().changeTitle2('titleString');
              onClick();
              // _LanguageChangeBtnState().changeTitle2('哈哈');
              // languaeChangeBtn
            },
        ),
      ),
    );
  }
}

///底部按钮
class UnderButtonView extends StatelessWidget {
  final Function loginBtnClick;
  // const UnderButtonView({Key key, this.loginBtnClick}) : super(key: key);
  UnderButtonView(this.loginBtnClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width - 30.0,
        height: 44.0,
        color: kColorTheme,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: new Text(
          '登录',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        onPressed: () {
          print('登录');
          loginBtnClick();
        },
      ),
    );
  }
}
