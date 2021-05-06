/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_packaging.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/login_save_user_data.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/util/status_bar_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/encrypt_util.dart';
import '../../widget/progressHUD.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoading = false;
  var _changeLangBtnTltle = '';

  TextEditingController _accountTC = TextEditingController(); //fangluyao
  TextEditingController _passwordTC = TextEditingController(); //b0S25X5Y
  var _account = ''; //'blk101';HSG20
  var _password = ''; //'4N0021S8';Qwe123456~

  @override
  void initState() {
    super.initState();

    HSProgressHUD.dismiss();
    // 添加监听
    _accountTC.addListener(() {
      _account = _accountTC.text;
    });
    // 添加监听
    _passwordTC.addListener(() {
      _password = _passwordTC.text;
    });

    _getUserConfig();
  }

  @override
  void dispose() {
    super.dispose();
    // 释放
    _accountTC.dispose();
    _passwordTC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _language = Intl.getCurrentLocale();
    if (_language == 'zh_CN') {
      _changeLangBtnTltle = '中文（简体）';
    } else if (_language == 'zh_HK') {
      _changeLangBtnTltle = '中文（繁體）';
    } else {
      _changeLangBtnTltle = 'English';
    }

    //从忘记用户名界面拿到名字

    var _userName = ModalRoute.of(context).settings.arguments;

    setState(() {
      if (_userName == 'logout') {
        // _passwordTC.text = '';
      } else {
        _accountTC.text = _userName;
      }
    });
    Widget backgroundImgWidget = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login/login_bg_password.png'),
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget contentDetailWidget = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: ScreenUtil.instance.statusBarHeight),
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
              height: 45,
              margin: EdgeInsets.only(top: 36.5),
              child: InputView(
                _accountTC,
                imgName: 'images/login/login_input_account.png',
                textFieldPlaceholder: S.of(context).login_account_placeholder,
                isCiphertext: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp("[a-zA-Z0-9]")), //只可输入大小写字母及数字
                  LengthLimitingTextInputFormatter(16),
                ],
              ),
            ),
            //密码输入框
            Container(
              height: 45,
              margin: EdgeInsets.only(top: 16.0),
              child: InputView(
                _passwordTC,
                imgName: 'images/login/login_input_password.png',
                textFieldPlaceholder: S.of(context).password_need_num,
                isCiphertext: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  FilteringTextInputFormatter.allow(RegExp(
                      "[a-zA-Z0-9,\\`,\\£¥•‘“,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]"))
                  //"[a-zA-Z0-9,\[\]\{\}\#\%\^\*\+\=\_\\\|\~\<\>€£¥•\.\,\?\!‘\-\/\:\;\(\)\$\&\@“]"))
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //忘记用户名
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: ForgetButton(S.current.forget_username, () {
                            setState(() {
                              Navigator.pushNamed(context, pageForgetUserName);
                              print('忘记密码');
                            });
                          }),
                        )
                      ],
                    ),
                  ),
                  //忘记密码按钮
                  Container(
                    height: 20,
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 33),
                          margin: EdgeInsets.only(left: 15),
                          child:
                              ForgetButton(S.of(context).fotget_password_q, () {
                            setState(() {
                              Navigator.pushNamed(context, pageForgetPassword);
                              print('忘记密码');
                            });
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
                child: Row(
              children: [
                //注册按钮
                Container(
                  margin: EdgeInsets.only(top: 40, left: 36.0, right: 36.0),
                  child: UnderButtonView(
                      S.current.register, () => _regesiter(context), false),
                ),
                //登录按钮
                Container(
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  child: UnderButtonView(S.of(context).login,
                      _isLoading ? null : () => _login(context), true),
                )
              ],
            )),

            // Spacer(),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundImgWidget,
          contentDetailWidget,
          // Positioned(
          //   bottom: 26,
          //   right: 0,
          //   left: 0,
          //   child: Text(
          //     '@2020-2025 HSBC.com.cn.All Rights Reserved.',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 11.0,
          //         color: Colors.white, //HsgColors.aboutusTextCon,
          //         fontWeight: FontWeight.normal),
          //   ),
          // ),
        ],
      ),
    );
  }

  ///登录操作
  _login(BuildContext context) async {
    // 触摸收起键盘
    FocusScope.of(context).requestFocus(FocusNode());

    //登录以输入框的值为准
    _account = _accountTC.text;
    _password = _passwordTC.text;
    if (!_judgeCanLogin()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HSProgressHUD.show();

    String password = EncryptUtil.aesEncode(_password);

    // UserDataRepository()
    ApiClientPackaging()
        .login(LoginReq(username: _account, password: password))
        .then((value) {
      HSProgressHUD.dismiss();
      if (value.errorCode == 'ECUST010') {
        HsgShowTip.loginPasswordErrorTip(
          context,
          value.passwordErrors,
          5,
          (value) => {
            setState(() {
              _isLoading = false;
            })
          },
        );
      } else {
        _saveUserConfig(context, value);
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      HSProgressHUD.dismiss();

      if (e.toString().contains('ECUST009')) {
        HsgShowTip.loginPasswordErrorToMuchTip(
          context,
          (value) => {
            setState(() {
              _isLoading = false;
            })
          },
        );
      } else {
        HSProgressHUD.showToast(e.error);
      }
    });
  }

  //注册
  _regesiter(BuildContext context) {
    Navigator.pushNamed(context, pageRegister);
  }

  ///登录成功-跳转操作
  _showMainPage(BuildContext context) async {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacementNamed(context, pageIndexName);
  }

  ///保存数据
  _saveUserConfig(BuildContext context, LoginResp resp) {
    SaveUserData(resp, password: _password);

    _showMainPage(context);
  }

  ///获取保存的数据
  void _getUserConfig() async {
    print('_accountTC.text+${_accountTC.text}');

    final prefs = await SharedPreferences.getInstance();
    String accountStr = prefs.getString(ConfigKey.USER_ACCOUNT);
    // String passwordStr = prefs.getString(ConfigKey.USER_PASSWORD);

    setState(() {
      _accountTC.text = accountStr == null ? '' : accountStr;
      //_passwordTC.text = passwordStr == null ? '' : passwordStr;
      _passwordTC.text = '';
    });
  }

  ///判断是否能点击登录按钮
  bool _judgeCanLogin() {
    if (_account.toString().length == 0 || _account == null) {
      HSProgressHUD.showToastTip(
        S.current.please_input_account,
      );
      return false;
    }

    if (_password.toString().length == 0 || _password == null) {
      HSProgressHUD.showToastTip(
        S.current.please_input_password,
      );
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
    StatusBarUtil.setStatusBar(Brightness.dark, color: Colors.transparent);
    return Container(
      // margin: EdgeInsets.only(right: 15),
      child: FlatButton(
        onPressed: () {
          _selectLanguage(context);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.black,
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
      '中文（简体）',
      '中文（繁體）',
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
        case 2:
          language = Language.ZH_HK;
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
      {this.imgName,
      this.textFieldPlaceholder,
      this.isCiphertext,
      this.inputFormatters});
  final List<TextInputFormatter> inputFormatters;
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
                  inputFormatters: this.inputFormatters,
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
            //  decoration: TextDecoration.underline,
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
  final bool login;

  UnderButtonView(this.title, this.loginBtnClick, this.login);

  @override
  _UnderButtonViewState createState() => _UnderButtonViewState();
}

class _UnderButtonViewState extends State<UnderButtonView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 2.9,
        height: 44.0,
        color: widget.login ? HsgColors.accent : HsgColors.registerBtn,
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
