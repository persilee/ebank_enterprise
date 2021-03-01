import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';
import 'package:ebank_mobile/data/source/update_login_paw_repository.dart';

import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/mine/change_logPswd_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记登录密码
/// Author: pyk
/// Date: 2020-02-26

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _phoneNum = TextEditingController();
  TextEditingController _newPwd = TextEditingController();
  TextEditingController _confimPwd = TextEditingController();
  TextEditingController _sms = TextEditingController();
  Timer _timer;
  int countdownTime = 0;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).reset_password),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        InputList(S.of(context).newPwd,
                            S.of(context).placeNewPwd, _newPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).confimPwd,
                            S.of(context).placeConfimPwd, _confimPwd),
                        // Divider(
                        //     height: 1,
                        //     color: HsgColors.divider,
                        //     indent: 3,
                        //     endIndent: 3),
                        // InputList(S.of(context).phone_num,
                        //     S.of(context).please_input, _phoneNum),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width / 7,
                                  child: Text(S.of(context).phone_num),
                                ),
                                Expanded(
                                    child: Container(
                                  child: TextField(
                                    controller: _phoneNum,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: S.of(context).please_input,
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: HsgColors.textHintColor,
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            )),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text(S.of(context).sendmsm),
                              Expanded(
                                child: otpTextField(),
                              ),
                              SizedBox(
                                width: 90,
                                height: 32,
                                child: _otpButton(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).confirm),
                      onPressed: _submit()
                          ? () {
                              _updateLoginPassword();
                            }
                          : null,
                      color: HsgColors.accent,
                      textColor: Colors.white,
                      disabledTextColor: Colors.white,
                      disabledColor: Color(0xFFD1D1D1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5) //设置圆角
                          ),
                    ),
                  )
                ],
              )),
        ));
  }

  //验证码输入框
  TextField otpTextField() {
    return TextField(
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      controller: _sms,
      decoration: InputDecoration.collapsed(
        hintText: S.current.please_input,
        hintStyle: TextStyle(
          fontSize: 14,
          color: HsgColors.textHintColor,
        ),
      ),
    );
  }

  //获取验证码按钮
  OutlineButton _otpButton() {
    return OutlineButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _getVerificationCode();
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
      padding: EdgeInsets.symmetric(horizontal: 8),
      //文字颜色
      textColor: HsgColors.blueTextColor,
      borderSide: BorderSide(color: HsgColors.blueTextColor, width: 0.5),
      //画圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      disabledTextColor: HsgColors.describeText,
      disabledBorderColor: HsgColors.describeText,
      child: Text(
        countdownTime > 0 ? '${countdownTime}s' : '获取验证码',
        style: TextStyle(fontSize: 14),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  bool _submit() {
    if (_phoneNum.text != '' &&
        _newPwd.text != '' &&
        _confimPwd.text != '' &&
        _sms.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //获取验证码接口
  _getVerificationCode() async {
    RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    if (characters.hasMatch(_phoneNum.text) == false) {
      HSProgressHUD.showInfo(status: S.current.format_mobile_error);
    } else {
      HSProgressHUD.show();
      VerificationCodeRepository()
          .sendSmsByPhone(
              SendSmsByPhoneNumberReq(_phoneNum.text, 'findPwd'), 'sendSms')
          .then((data) {
        _startCountdown();
        setState(() {
          _sms.text = '123456';
        });
        HSProgressHUD.dismiss();
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        HSProgressHUD.dismiss();
      });
    }
  }

  //修改密码接口
  _updateLoginPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    RegExp characters = new RegExp(
        "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
    RegExp letter = new RegExp("[a-zA-Z]");
    RegExp number = new RegExp("[0-9]");
    if (_newPwd.text != _confimPwd.text) {
      Fluttertoast.showToast(msg: S.of(context).differentPwd);
    } else if ((_newPwd.text).contains(userAccount) == true) {
      HSProgressHUD.showInfo(status: S.current.not_contain_password);
    } else if ((_newPwd.text).length < 8 || (_newPwd.text).length > 16) {
      HSProgressHUD.showInfo(status: S.current.password_8_16);
    } else if (number.hasMatch(_newPwd.text) == false) {
      HSProgressHUD.showInfo(status: S.current.password_need_num);
    } else if (letter.hasMatch(_newPwd.text) == false) {
      HSProgressHUD.showInfo(status: S.current.password_need_low_and_top);
    } else if (characters.hasMatch(_newPwd.text) == false) {
      HSProgressHUD.showInfo(status: S.current.password_need_special_font);
    } else {
      String password = EncryptUtil.aesEncode(_confimPwd.text);
      HSProgressHUD.show();

      UpdateLoginPawRepository()
          .modifyPwdBySms(
              ModifyPwdBySmsReq(
                password,
                _sms.text,
                userAccount,
              ),
              'ModifyPasswordReq')
          .then((data) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(msg: S.current.operate_success);
        Navigator.pop(context, pageLogin);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        HSProgressHUD.dismiss();
      });
    }
  }
}
