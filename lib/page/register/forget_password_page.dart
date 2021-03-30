import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/check_phone.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/modify_pwd_by_sms.dart';
import 'package:ebank_mobile/data/source/update_login_paw_repository.dart';

import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';

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
  String _phoneNumListen;
  String _smsListen;
  Timer _timer;
  int countdownTime = 0;
  bool _isRegister;
  String _userAccount;

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
  // ignore: must_call_super
  void initState() {
    super.initState();
    setState(() {
      _phoneNum.addListener(() {
        setState(() {
          _phoneNumListen = _phoneNum.text;
        });
      });
      _sms.addListener(() {
        setState(() {
          _smsListen = _sms.text;
        });
      });
    });
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
                getRegisterRegion(
                    context, _phoneNum, _officeAreaCodeText, _selectRegionCode),
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
                            WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                            LengthLimitingTextInputFormatter(6) //限制长度
                          ],
                        ),
                      ),
                      Container(
                        //获取验证码按钮
                        width: MediaQuery.of(context).size.width / 3,
                        child: _otpButton(),
                      )
                    ],
                  ),
                ),

                //下一步按钮
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
                  margin: EdgeInsets.all(40), //外边距
                  height: 44.0,
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    child: Text(S.of(context).next_step),
                    onPressed: _submit()
                        ? () {
                            Map listData = new Map();
                            listData = {
                              'userAccount': _userAccount,
                              'userPhone': _phoneNumListen,
                              'sms': _smsListen
                            };
                            Navigator.pushNamed(
                                context, pageResetPasswordOpenAccount,
                                arguments: listData);
                          }
                        : null,
                    // color: HsgColors.accent,
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    disabledColor: Color(0xFFD1D1D1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5) //设置圆角
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
              _checkRegister();
              FocusScope.of(context).requestFocus(FocusNode());
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
    if (_sms.text != '' && _phoneNum.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //检验用户是否注册
  _checkRegister() {
    RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    // if (characters.hasMatch(_phoneNum.text) == false) {
    //   Fluttertoast.showToast(
    //     msg: S.current.format_mobile_error,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //   );
    // }
    // if {
    HSProgressHUD.show();

    VersionDataRepository()
        .checkPhone(CheckPhoneReq(_phoneNum.text, '2'), 'checkPhoneReq')
        .then((data) {
      HSProgressHUD.dismiss();
      if (mounted) {
        setState(() {
          _isRegister = data.register;
          _userAccount = data.userAccount;
          HSProgressHUD.dismiss();

          //发送短信
          _getVerificationCode();
        });
      }
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    });
    // }
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
      Fluttertoast.showToast(
        msg: S.current.format_mobile_error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else if (!_isRegister) {
      Fluttertoast.showToast(
        msg: S.current.num_not_is_register,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } else {
      VerificationCodeRepository()
          .sendSmsByPhone(
              SendSmsByPhoneNumberReq(_phoneNum.text, 'findPwd'), 'sendSms')
          .then((data) {
        HSProgressHUD.dismiss();
        _startCountdown();

        HSProgressHUD.dismiss();
      }).catchError((e) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      });
    }
  }
}
