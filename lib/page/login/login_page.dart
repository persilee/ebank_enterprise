/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/http/hsg_http.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_text_field_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/progressHUD.dart';
import '../../util/encrypt_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  var _changeLangBtnTltle = 'English'; // S.current.english;

  final TextEditingController _accountTC =
      TextEditingController(text: 'fangluyao');
  final TextEditingController _passwordTC =
      TextEditingController(text: 'b0S25X5Y');

  var _account = 'fangluyao'; //'18033412021';
  var _password = 'b0S25X5Y'; //'123456';

  @override
  void initState() {
    super.initState();
    // 添加监听
    _accountTC.addListener(() {
      _account = _accountTC.text;
    });
    // 添加监听
    _passwordTC.addListener(() {
      _password = _passwordTC.text;
    });
    Intl.defaultLocale = 'en';
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

    Widget contentDetailWidget = Column(
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
          height: 45,
          margin: EdgeInsets.only(top: 36.5),
          child: InputView(
            _accountTC,
            imgName: 'images/login/login_input_account.png',
            textFieldPlaceholder: S.of(context).login_account_placeholder,
            isCiphertext: false,
          ),
        ),
        //密码输入框
        Container(
          height: 45,
          margin: EdgeInsets.only(top: 16.0),
          child: InputView(
            _passwordTC,
            imgName: 'images/login/login_input_password.png',
            textFieldPlaceholder: S.of(context).please_input_password,
            isCiphertext: true,
          ),
        ),
        //忘记按钮
        Container(
          height: 20,
          margin: EdgeInsets.only(top: 10, right: 35, left: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //ForgetButton('忘记账户？'),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: ForgetButton(S.of(context).fotget_password_q, () {
                  setState(() {
                    Navigator.pushNamed(context, pageForgetPassword);
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
            S.of(context).login,
            _isLoading ? null : () => _login(context),
          ),
        ),
      ],
    );

    Widget contentWidget = new Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: contentDetailWidget,
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
        .login(LoginReq(username: _account, password: password), 'login')
        .then((value) {
      HSProgressHUD.dismiss();
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
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, pageIndexName);
  }

  ///保存数据
  _saveUserConfig(BuildContext context, LoginResp resp) async {
    ///登录页面清空数据
    HsgHttp().clearUserCache();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ConfigKey.USER_ACCOUNT, resp.userAccount);
    prefs.setString(ConfigKey.USER_ID, resp.userId);
    if (resp.custId == null || resp.custId == '') {
      prefs.setString(ConfigKey.CUST_ID, '');
    } else {
      prefs.setString(ConfigKey.CUST_ID, resp.custId);
    }

    _showMainPage(context);
  }

  ///判断是否能点击登录按钮
  bool _judgeCanLogin() {
    if (_account.toString().length == 0 || _account == null) {
      HSProgressHUD.showInfo(status: S.of(context).please_input_account);
      return false;
    }

    if (_password.toString().length == 0 || _password == null) {
      HSProgressHUD.showInfo(status: S.of(context).please_input_password);
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
          _selectLanguage(context);
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

  _selectLanguage(BuildContext context) async {
    List<String> languages = [
      'English',
      '中文',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.select_language,
              items: languages,
            ));
    String language;
    if (result != null && result != false) {
      switch (result) {
        case 0:
          language = Language.EN;
          break;
        case 1:
          language = Language.ZH_CN;
          break;
      }
    } else {
      return;
    }

    Language.saveSelectedLanguage(language);
    setState(() {
      title = languages[result];
      HSGBankApp.setLocale(context, Language().getLocaleByLanguage(language));
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
                  //是否自动更正
                  autocorrect: false,
                  //是否自动获得焦点
                  autofocus: false,
                  controller: textEC,
                  obscureText: this.isCiphertext,
                  style: TextStyle(
                    fontSize: 15,
                    color: HsgColors.firstDegreeText,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: this.textFieldPlaceholder,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: HsgColors.textHintColor,
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
              onClick();
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
        color: HsgColors.accent,
        disabledColor: HsgColors.hintText,
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
