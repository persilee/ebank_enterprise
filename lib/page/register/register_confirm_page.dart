import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
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
  TextEditingController _oldPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('注册'),
          elevation: 0,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: <Widget>[
              //注册标题
              getRegisterTitle('欢迎注册'),
              //输入新密码
              getRegisterRow('输入新密码', _newPassword),
              //再次输入密码
              getRegisterRow('再次输入新密码', _oldPassword),
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
                          color: Color(0xFFF5F7F9)),
                      margin: EdgeInsets.only(top: 75),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 15,
                      child: RaisedButton(
                        disabledColor: HsgColors.btnDisabled,
                        color: Colors.blue,
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
                                if ((_newPassword.text != _oldPassword.text)) {
                                  HSProgressHUD.showInfo(
                                      status: S.of(context).differentPwd);
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
                                  HSProgressHUD.showInfo(
                                      status: S.current.password_need_num);
                                } else {
                                  Navigator.popAndPushNamed(
                                      context, pageRegisterSuccess);
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
        ));
  }

  bool _submit() {
    if (_newPassword.text.length > 0 && _oldPassword.text.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
