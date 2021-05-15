import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/register_by_account.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/data/source/model/send_message.dart';

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
                  S.of(context).password_need_num,
                  _newPassword,
                  true,
                  <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(16),
                    FilteringTextInputFormatter.allow(RegExp(
                        "[a-zA-Z0-9,\\`,\\£¥•‘“,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]"))
                  ],
                ),
                //再次输入密码
                getRegisterRow(
                  S.current.placeConfimPwd,
                  _confirmPassword,
                  true,
                  <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(16),
                    FilteringTextInputFormatter.allow(RegExp(
                        "[a-zA-Z0-9,\\`,\\£¥•‘“,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]"))
                  ],
                ),
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
                            style: (TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                            //textDirection: Colors.white,
                          ),
                          onPressed: _submit()
                              ? () {
                                  // final prefs =
                                  //     await SharedPreferences.getInstance();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  //特殊字符
                                  RegExp characters = new RegExp(
                                      "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
                                  RegExp letter = new RegExp("[A-Z]");
                                  RegExp minAZ = new RegExp("[a-z]");
                                  RegExp number = new RegExp("[0-9]");
                                  if ((_newPassword.text !=
                                      _confirmPassword.text)) {
                                    HSProgressHUD.showToastTip(
                                      S.of(context).differentPwd,
                                    );
                                  } else if (number.hasMatch(
                                              _newPassword.text) ==
                                          false ||
                                      letter.hasMatch(_newPassword.text) ==
                                          false ||
                                      characters.hasMatch(_newPassword.text) ==
                                          false ||
                                      minAZ.hasMatch(_newPassword.text) ==
                                          false ||
                                      ((_newPassword.text).length < 8 ||
                                          (_newPassword.text).length > 16)) {
                                    HSProgressHUD.showToastTip(
                                      S.current.password_need_num,
                                    );
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
    String userType = "2";
    String password = EncryptUtil.aesEncode(_newPassword.text);

    print("$_registerAccount>>>>>>>>>>>>>>");
    HSProgressHUD.show();
    ApiClientAccount()
        .registerByAccount(RegisterByAccountReq(
            _areaCode, password, _registerAccount, _userPhone, userType, _sms))
        .then((value) {
      HSProgressHUD.dismiss();
      if (mounted) {
        setState(() {
          Map listDataLogin = new Map();
          //传用户名和密码到成功页面已用于调用登录接口跳转至首页
          listDataLogin = {
            'accountName': _registerAccount,
            'password': password,
          };
          //传值跳转到指定页面
          Navigator.of(context).pushNamedAndRemoveUntil(pageRegisterSuccess,
              ModalRoute.withName("/"), //清除旧栈需要保留的栈 不清除就不写这句
              arguments: listDataLogin //传值
              );
        });
        //发送异步通知短信
        _sendMessage();
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  //注册成功发送短信
  _sendMessage() async {
    ApiClientPassword()
        .sendMessage(SendMessageReq(_areaCode, _userPhone, 'register',
            _registerAccount, 'SCNAOCREGU', 'MB',
            msgBankId: '999'))
        .then((value) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
    // }
  }

  bool _submit() {
    if (_newPassword.text != '' && _confirmPassword.text != '') {
      return true;
    } else {
      return false;
    }
  }
}
