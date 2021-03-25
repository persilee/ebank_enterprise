import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';
import 'package:ebank_mobile/data/source/update_login_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记密码--未开户页面
/// Author: pengyikang

class ResetPasswordNoAccount extends StatefulWidget {
  ResetPasswordNoAccount({Key key}) : super(key: key);

  @override
  _ResetPasswordNoAccountState createState() => _ResetPasswordNoAccountState();
}

class _ResetPasswordNoAccountState extends State<ResetPasswordNoAccount> {
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();
  String _newPasswordListen;
  String _confirmPasswordListen;
  Map listData = new Map();
  String _phone;
  String _accountName;
  String _sms;

  @override
  // ignore: must_call_super
  void initState() {
    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    listData = ModalRoute.of(context).settings.arguments;
    _accountName = listData['userAccount'];
    _phone = listData['userPhone'];
    _sms = listData['sms'];
    print('$_accountName>>>>>>>>>>>>>>>');
    print('$_phone>>>>>>>>>>>>>>>');

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
              child: ListView(
                children: <Widget>[
                  //注册标题
                  getRegisterTitle(
                      '${S.current.reset_password}-${S.current.please_input_password}'),
                  //输入新密码
                  getRegisterRow(
                      S.current.password_need_num, _newPassword, true),
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
                                      HSProgressHUD.showInfo(
                                          status: S.of(context).differentPwd);
                                    } else if (characters
                                                .hasMatch(_newPassword.text) ==
                                            false ||
                                        letter.hasMatch(_newPassword.text) ==
                                            false ||
                                        number.hasMatch(_newPassword.text) ==
                                            false ||
                                        ((_newPassword.text)
                                                .contains(userName) ==
                                            true) ||
                                        (_newPassword.text.length < 8 ||
                                            _newPassword.text.length > 16)) {
                                      HSProgressHUD.showInfo(
                                          status: S.current.password_need_num);
                                    } else {
                                      _updateLoginPassword();
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
            )));
  }

  bool _submit() {
    if (_confirmPassword.text != '' && _newPassword.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //修改密码接口
  _updateLoginPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    print('$userAccount>>>>>>>>>>>>>>>>>>>>>>>');
    RegExp characters = new RegExp(
        "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
    RegExp letter = new RegExp("[a-zA-Z]");
    RegExp number = new RegExp("[0-9]");
    // if (_newPassword.text != _confirmPassword.text) {
    //   Fluttertoast.showToast(
    //     msg: S.of(context).differentPwd,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //   );
    // }
    if ((_newPassword.text).contains(userAccount) == true) {
      Fluttertoast.showToast(
        msg: S.current.not_contain_password,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else if ((_newPassword.text).length < 8 ||
        (_newPassword.text).length > 16) {
      Fluttertoast.showToast(
        msg: S.current.password_8_16,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else if (number.hasMatch(_newPassword.text) == false) {
      Fluttertoast.showToast(
        msg: S.current.password_need_num,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else if (letter.hasMatch(_newPassword.text) == false) {
      Fluttertoast.showToast(
        msg: S.current.password_need_num,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else if (characters.hasMatch(_newPassword.text) == false) {
      Fluttertoast.showToast(
        msg: S.current.password_need_num,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else {
      String confirmPassword = EncryptUtil.aesEncode(_confirmPasswordListen);
      // String newPassword = EncryptUtil.aesEncode(_newPasswordListen);
      print('');
      HSProgressHUD.show();
      UpdateLoginPawRepository()
          .modifyPwdBySms(
              ModifyPwdBySmsReq(
                confirmPassword,
                _sms,
                _accountName,
              ),
              'ModifyPasswordReq')
          .then((data) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(
          msg: S.current.operate_success,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          pageResetPasswordSuccess,
          ModalRoute.withName("/"), //清除旧栈需要保留的栈 不清除就不写这句
          // arguments: listDataLogin //传值
        );

        //   Navigator.popAndPushNamed(context, pageResetPasswordSuccess);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        HSProgressHUD.dismiss();
      });
    }
  }
}
