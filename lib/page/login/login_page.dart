import 'dart:async';

import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/global_config.dart';
import '../../widget/progressHUD.dart';
import '../../util/encrypt_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  var _loginText = '登录';
  var _changeLangBtnTltle = '中文';

  final TextEditingController _accountTC =
      TextEditingController(text: '18033412021');
  final TextEditingController _passwordTC =
      TextEditingController(text: '123456');

  var _account = '18033412021';
  var _password = '123456';

  @override
  void initState() {
    super.initState();
    // 添加监听
    _accountTC.addListener(() {
      _account = _accountTC.text.toLowerCase();
      _accountTC.value = _accountTC.value.copyWith(
        text: _account,
      );
    });
    // 添加监听
    _passwordTC.addListener(() {
      _password = _passwordTC.text.toLowerCase();
      _passwordTC.value = _passwordTC.value.copyWith(
        text: _password,
      );
    });
  }

  @override
  void dispose() {
    // 释放
    _accountTC.dispose();
    _passwordTC.dispose();
    super.dispose();
  }

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
                  _accountTC,
                  imgName: 'images/login/login_input_account.png',
                  textFieldPlaceholder: '邮箱/手机号/用户ID',
                  isCiphertext: false,
                ),
              ),
              //密码输入框
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: InputView(
                  _passwordTC,
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
                child: UnderButtonView(
                  _loginText,
                  _isLoading ? null : () => _login(context),
                ),
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
  }

  ///登录操作
  _login(BuildContext context) {
    if (!_judgeCanLogin()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    HSProgressHUD.show();

    String password = EncryptUtil.aesEncode(_password);
    UserDataRepository()
        .login(LoginReq(userPhone: _account, password: password), 'login')
        .then((value) {
      HSProgressHUD.showSuccess(status: '${value.actualName}');
      _saveUserConfig(context, value);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      HSProgressHUD.showError(status: '${e.toString()}');
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
  _saveUserConfig(BuildContext context, LoginResp resp) async {
    ///登录页面清空数据
    HsgHttp().clearUserCache();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.USER_ACCOUNT, resp.userPhone);
    prefs.setString(ConfigKey.USER_ID, resp.userId);

    _showMainPage(context);
  }

  ///判断是否能点击登录按钮
  bool _judgeCanLogin() {
    if (_account.toString().length == 0 || _account == null) {
      HSProgressHUD.showInfo(status: '请输入账号');
      return false;
    }

    if (_password.toString().length == 0 || _password == null) {
      HSProgressHUD.showInfo(status: '请输入密码');
      return false;
    }

    return true;
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
  InputView(this.textEC,
      {this.imgName, this.textFieldPlaceholder, this.isCiphertext});

  final String imgName;
  final String textFieldPlaceholder;
  final bool isCiphertext;
  final TextEditingController textEC;

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
                  controller: textEC,
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
class UnderButtonView extends StatefulWidget {
  final String title;
  final void Function() loginBtnClick;

  UnderButtonView(this.title, this.loginBtnClick);

  @override
  _UnderButtonViewState createState() => _UnderButtonViewState();
}

class _UnderButtonViewState extends State<UnderButtonView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width - 30.0,
        height: 44.0,
        color: kColorTheme,
        disabledColor: kColor204,
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: new Text(
          widget.title,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        onPressed: widget.loginBtnClick,
      ),
    );
  }
}
