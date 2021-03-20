import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';
import 'package:ebank_mobile/data/source/update_login_paw_repository.dart';

import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记登录密码
/// Author: pengyikang
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

  /// 区号
  String _officeAreaCodeText = '';
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
                  //绑定状态属性
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                      ),
                      //忘记密码标题
                      getRegisterTitle(S.current.fotget_password),
                      //手机号
                      getRegisterRegion(context, _phoneNum, _officeAreaCodeText,
                          _selectRegionCode),
                      //获取验证码
                      Container(
                        height: MediaQuery.of(context).size.height / 15,
                        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xFFF5F7F9)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                //是否自动更正
                                controller: _sms,
                                autocorrect: true,
                                //是否自动获得焦点
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.current.please_input_sms,
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.textHintColor,
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter
                                      .digitsOnly, //只输入数字
                                  LengthLimitingTextInputFormatter(6) //限制长度
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: _otpButton(),
                            )
                            // InkWell(
                            //   onTap: () {
                            //     //调用获取验证码接口
                            //     _getVerificationCode();
                            //     print('获取验证码');
                            //   },
                            //   child: Container(
                            //     width: MediaQuery.of(context).size.width / 4,
                            //     child: Text(
                            //       '获取验证码',
                            //       style: TextStyle(color: Colors.blue),
                            //       textAlign: TextAlign.right,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),

                      //确定按钮
                      Container(
                        margin: EdgeInsets.all(40), //外边距
                        height: 44.0,
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          child: Text(S.of(context).next_step),
                          onPressed: _submit()
                              ? () {
                                  Navigator.pushNamed(
                                      context, pageResetPasswordOpenAccount);
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
            )));
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

  _selectRegionCode() {
    print('区号');
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionModel).code;
      });
    });
  }

  FlatButton _otpButton() {
    return FlatButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _getVerificationCode();
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
      padding: EdgeInsets.only(left: 35),
      //文字颜色
      textColor: HsgColors.blueTextColor,
      //画圆角
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(50),
      // ),
      disabledTextColor: HsgColors.blueTextColor,
      child: Text(
        countdownTime > 0
            ? '${countdownTime}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.right,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  bool _submit() {
    if (_phoneNum.text != '' && _sms.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 120;
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
      Fluttertoast.showToast(msg: S.current.format_mobile_error);
    } else {
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
      Fluttertoast.showToast(msg: S.current.not_contain_password);
    } else if ((_newPwd.text).length < 8 || (_newPwd.text).length > 16) {
      Fluttertoast.showToast(msg: S.current.password_8_16);
    } else if (number.hasMatch(_newPwd.text) == false) {
      Fluttertoast.showToast(msg: S.current.password_need_num);
    } else if (letter.hasMatch(_newPwd.text) == false) {
      Fluttertoast.showToast(msg: S.current.password_need_num);
    } else if (characters.hasMatch(_newPwd.text) == false) {
      Fluttertoast.showToast(msg: S.current.password_need_num);
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
