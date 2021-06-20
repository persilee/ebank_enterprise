import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/check_phone.dart';
import 'package:ebank_mobile/data/source/model/account/check_sms.dart';
import 'package:ebank_mobile/data/source/model/login_register/login_Verfiy_phone.dart';
import 'package:ebank_mobile/data/source/model/mine/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/openAccount/country_region_new_model.dart';

import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';

import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int endSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  bool _isRegister;
  String _userAccount;
  bool _isInput = false; //判断是否点击获取验证码
  bool _isCommit = false; //进行二次校验
  String _smsCode = '';

  /// 区号
  String _officeAreaCodeText = '86';

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
                          enabled: true,
                          style: TEXTFIELD_TEXT_STYLE,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: S.current.please_input_sms,
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: HsgColors.textHintColor,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9]")), //纯数字
                            LengthLimitingTextInputFormatter(6),
                          ], //限制长度
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        //获取验证码按钮
                        alignment: Alignment.centerRight,
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            _checkRegisterBysencond();
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
      style: FIRST_DEGREE_TEXT_STYLE,
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
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionNewModel).areaCode;
      });
    });
  }

  //释放_timer
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  FlatButton _otpButton() {
    return FlatButton(
      onPressed: endSeconds > DateTime.now().millisecondsSinceEpoch ~/ 1000
          ? null
          : () {
              FocusScope.of(context).requestFocus(FocusNode());
              _checkRegister();
            },
      //  padding: EdgeInsets.only(left: 35),
      textColor: HsgColors.blueTextColor,
      disabledTextColor: HsgColors.blueTextColor,
      child: Text(
        endSeconds > DateTime.now().millisecondsSinceEpoch ~/ 1000
            ? '${endSeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.right,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  bool _submit() {
    if (_phoneNum.text != '' && _sms.text.length > 5 && _isInput) {
      return true;
    } else {
      return false;
    }
  }

  //检验用户是否注册
  _checkRegister() {
    HSProgressHUD.show();
    // VersionDataRepository()
    ApiClientAccount().checkPhone(CheckPhoneReq(_phoneNum.text)).then((data) {
      if (mounted) {
        setState(() {
          _isRegister = data.register;
          _userAccount = data.userAccount;
          if (!_isRegister) {
            HSProgressHUD.showToastTip(
              S.current.num_not_is_register,
            );
            HSProgressHUD.dismiss();
          } else {
            _getVerificationCode();
          }
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
    // }
  }

  //二次校验
  _checkRegisterBysencond() {
    HSProgressHUD.show();
    ApiClientAccount()
        .checkSms(CheckSmsReq(_phoneNum.text, 'findPwd', _smsListen, 'MB'))
        .then((data) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          //校验是否注册
          if (!data.checkResult) {
            HSProgressHUD.showToastTip(
              S.current.num_not_is_register,
            );
          } else {
            //校验手机号是否已经开户
            _verfiyPhoneRequest();
          }
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

//校验手机号是否已经开户
  _verfiyPhoneRequest() {
    LoginVerifyPhoneReq req = LoginVerifyPhoneReq('', '', _phoneNumListen);
    ApiClientAccount().forgetVerifyPhoneOpenAccount(req).then((data) {
      Map listData = new Map();
      listData = {
        'userAccount': _userAccount,
        'userPhone': _phoneNumListen,
        'sms': _smsListen,
        'areaCode': _officeAreaCodeText
      };
      if (data != null) {
        if (data.opened) {
          //已开户才能进行设置
          Navigator.pushNamed(context, pageResetPasswordOpenAccount,
              arguments: listData);
          HSProgressHUD.dismiss();
        } else {
          //未开户
          Navigator.pushNamed(context, pageResetPasswordNoAccount,
              arguments: listData);
          HSProgressHUD.dismiss();
        }
      }
    });
  }

  //倒计时方法
  _startCountdown() {
    endSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 120;
    final call = (timer) {
      if (mounted) {
        setState(() {
          if (endSeconds < DateTime.now().millisecondsSinceEpoch ~/ 1000) {
            _timer.cancel();
          }
        });
      }
    };
    HSProgressHUD.dismiss();

    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //获取验证码接口
  _getVerificationCode() async {
    // VerificationCodeRepository()
    ApiClientPassword()
        .sendSmsByPhone(
      SendSmsByPhoneNumberReq(
          _officeAreaCodeText, _phoneNum.text, 'findPwd', 'SCNAOFTPW', 'MB',
          msgBankId: '999'),
    )
        .then((data) {
      if (mounted) {
        setState(() {
          _isInput = true;
          _smsCode = data.smsCode;
          _startCountdown();
        });
      }
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
    // }
  }
}
