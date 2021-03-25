import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/register_by_account.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page/register/register_success_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册账号输入密码页面
/// Author: pengyikang

class RegisterConfirmPage extends StatefulWidget {
  RegisterConfirmPage({Key key}) : super(key: key);

  @override
  _RegisterConfirmPageState createState() => _RegisterConfirmPageState();
}

class _RegisterConfirmPageState extends State<RegisterConfirmPage> {
  TextEditingController _newPassword = new TextEditingController();
  String _newPasswordListen;
  TextEditingController _confirmPassword = new TextEditingController();
  String _confirmPasswordListen;
  Map listData = new Map();
  String _registerAccount;
  String _userPhone;
  String _sms;
  String _areaCode;
  @override
  // ignore: must_call_super
  void initState() {
    _newPassword.addListener(() {
      setState(() {
        _newPasswordListen = _newPassword.text;
      });
    });
    _confirmPassword.addListener(() {
      setState(() {
        _confirmPasswordListen = _confirmPassword.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    listData = ModalRoute.of(context).settings.arguments;
    _registerAccount = listData['accountName'];
    _sms = listData['sms'];
    _userPhone = listData['phone'];
    _areaCode = listData['areaCode'];

//_registerAccount =
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: Form(
            child: ListView(
              children: <Widget>[
                //注册标题
                getRegisterTitle(
                    '${S.current.welcome_to_register}-${S.current.please_input_password}'),
                //输入新密码
                getRegisterRow(
                    S.of(context).password_need_num, _newPassword, true),
                //再次输入密码
                getRegisterRow(
                    S.current.placeConfimPwd, _confirmPassword, true),
                //下一步
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16),
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
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
                        margin: EdgeInsets.only(top: 75),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 15,
                        child: FlatButton(
                          disabledColor: HsgColors.btnDisabled,
                          //color: Colors.blue,
                          child: Text(
                            S.current.confirm,
                            style: (TextStyle(color: Colors.white)),
                            //textDirection: Colors.white,
                          ),
                          onPressed: _submit()
                              ? () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String userName =
                                      prefs.getString(ConfigKey.USER_ACCOUNT);
                                  //特殊字符
                                  RegExp characters = new RegExp(
                                      "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
                                  RegExp letter = new RegExp("[a-zA-Z]");
                                  RegExp number = new RegExp("[0-9]");
                                  if ((_newPassword.text !=
                                      _confirmPassword.text)) {
                                    Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        msg: S.of(context).differentPwd);
                                  } else if (characters
                                              .hasMatch(_newPassword.text) ==
                                          false ||
                                      letter.hasMatch(_newPassword.text) ==
                                          false ||
                                      number.hasMatch(_newPassword.text) ==
                                          false ||
                                      ((_newPassword.text).contains(userName) ==
                                          true) ||
                                      (_newPassword.text.length < 8 ||
                                          _newPassword.text.length > 16)) {
                                    Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        msg: S.current.password_need_num);
                                  } else {
                                    _registerByAccount();
                                  }
                                }
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //手机号注册接口
  _registerByAccount() async {
    String userType = "1";
    String password = EncryptUtil.aesEncode(_newPassword.text);

    print("$_areaCode>>>>>>>>>>>>>>");

    VersionDataRepository()
        .registerByAccount(
            RegisterByAccountReq(_areaCode, password, _registerAccount,
                _userPhone, userType, _sms),
            'registerByAccount')
        .then((value) {
      Map listDataLogin = new Map();
      //传用户名和密码到成功页面已用于调用登录接口跳转至首页
      listDataLogin = {
        'accountName': _registerAccount,
        'password': password,
      };
      // Navigator.popAndPushNamed(context, pageRegisterSuccess,
      //     arguments: listDataLogin);
      Navigator.of(context).pushNamedAndRemoveUntil(
          pageRegisterSuccess, ModalRoute.withName("/"), //清除旧栈需要保留的栈 不清除就不写这句
          arguments: listDataLogin //传值
          );

      setState(() {});
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  bool _submit() {
    if (_newPassword.text != '' && _confirmPassword.text != '') {
      return true;
    } else {
      return false;
    }
  }
}
