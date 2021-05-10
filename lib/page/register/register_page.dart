import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/check_phone.dart';
import 'package:ebank_mobile/data/source/model/check_sms.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/country_region_new_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';

import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';

import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

import 'package:flutter/gestures.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册页面
/// Author: pengyikang
/// Date: 2020-03-15
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _sms = TextEditingController(); //短信
  String _smsListen;
  TextEditingController _phoneNum = TextEditingController(); //手机号
  String _phoneNumListen;
  TextEditingController _userName = TextEditingController(); //用户名
  String _userNameListen;
  Timer _timer;
  int countdownTime = 0;
  bool _checkBoxValue = false; //复选框默认值
  bool _isGetSms = false; //是否点击获取验证码
  bool _isRegister = false;
  String _smsCode = ''; //后台获取短信

  /// 区号
  String _officeAreaCodeText = '86';
  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
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
    _userName.addListener(() {
      setState(() {
        _userNameListen = _userName.text;
      });
      print("$_userNameListen>>>>>>>>>");
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
                //注册标题
                getRegisterTitle(S.current.welcome_to_register),
                //注册手机号
                getRegisterRegion(
                    context, _phoneNum, _officeAreaCodeText, _selectRegionCode),
                //输入用户名
                getRegisterRow(
                  S.current.please_input_username,
                  _userName,
                  false,
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9]")), //只可输入大小写字母及数字
                    LengthLimitingTextInputFormatter(16),
                  ],
                ),
                // GetSms(
                //   phone: _phoneNum,
                //   sms: _sms,
                //   smsType: 'register',
                //   officeAreaCodeText: _officeAreaCodeText,
                //   isRegister: true,
                //   isForget: false,
                //   isInput: _isGetSms,
                // ),
                //获取验证码
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9]")), //纯数字
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width / 3,
                        child: _otpButton(),
                      )
                    ],
                  ),
                ),
                //下一步按钮
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
                            S.current.next_step,
                            style: (TextStyle(color: Colors.white)),
                          ),
                          onPressed: _submit()
                              ? () {
                                  // 触摸收起键盘
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  RegExp userName =
                                      new RegExp("[a-zA-Z0-9]{4,16}");
                                  //特殊字符
                                  RegExp characters = new RegExp(
                                      "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
                                  if (userName.hasMatch(_userName.text) ==
                                          false ||
                                      characters.hasMatch(_userName.text) ==
                                          true) {
                                    //校验用户名
                                    HSProgressHUD.showToastTip(
                                      S.current.register_check_username,
                                    );
                                  } else {
                                    _checkRegisterBysencond();
                                  }
                                }
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
                //复选框及协议文本内容
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: CONTENT_PADDING,
                  child: Row(
                    children: [_roundCheckBox(), _textContent()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //检验用户是否注册及发短信
  _checkRegister() {
    HSProgressHUD.show();
    // VersionDataRepository()
    ApiClientAccount()
        .checkPhone(CheckPhoneReq(_phoneNum.text, '2'))
        .then((data) {
      if (mounted) {
        setState(() {
          _isRegister = data.register;
          if (_isRegister) {
            HSProgressHUD.showToastTip(
              S.current.num_is_register,
            );
          } else {
            _sendSmsRegister(_isRegister);
          }
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }

  //获取注册发送短信验证码接口
  _sendSmsRegister(bool _isRegister) async {
    print('$_isRegister>>>>>>>>');
    // VerificationCodeRepository()
    ApiClientPassword()
        .sendSmsByPhone(SendSmsByPhoneNumberReq(
            _officeAreaCodeText, _phoneNum.text, 'register', 'SCNAOREGU', 'MB',userAccount: _userName.text,
            msgBankId: '999'))
        .then((value) {
      if (mounted) {
        setState(() {
          _smsCode = value.smsCode;
          HSProgressHUD.dismiss();
          _isGetSms = true;
          _startCountdown();
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
    // }
  }

  //二次校验
  _checkRegisterBysencond() {
    HSProgressHUD.show();
    // VersionDataRepository()
    ApiClientAccount()
        .checkSms(CheckSmsReq(_phoneNum.text, 'register', _smsListen, 'MB'))
        .then((data) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          //校验是否注册
          if (!data.checkResult) {
            HSProgressHUD.showToastTip(
              S.current.num_is_register,
            );
          } else {
            Map listData = new Map();
            listData = {
              'accountName': _userNameListen,
              'sms': _smsListen,
              'phone': _phoneNumListen,
              'areaCode': _officeAreaCodeText
            };
            Navigator.pushNamed(context, pageRegisterConfirm,
                arguments: listData);
            HSProgressHUD.dismiss();
          }
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 120;
    final call = (timer) {
      if (mounted) {
        setState(() {
          if (countdownTime < 1) {
            _timer.cancel();
          } else {
            countdownTime -= 1;
          }
        });
      }
    };
    HSProgressHUD.dismiss();
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //释放_timer
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

//发送短信
  FlatButton _otpButton() {
    return FlatButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              FocusScope.of(context).requestFocus(FocusNode());
              _checkRegister();
            },
      //文字颜色
      textColor: HsgColors.blueTextColor,
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
    if (_phoneNum.text != '' &&
        _userName.text != '' &&
        _sms.text.length > 5 &&
        _isGetSms &&
        _checkBoxValue) {
      return true;
    } else {
      return false;
    }
  }

  //选择地区方法
  _selectRegionCode() {
    print('区号');
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionNewModel).areaCode;
      });
    });
  }

//圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _checkBoxValue = !_checkBoxValue;
        });
        //_submit();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 25),
        child: _checkBoxValue
            ? _ckeckBoxImge("images/common/check_btn_common_checked.png")
            : _ckeckBoxImge("images/common/check_btn_common_no_check.png"),
      ),
    );
  }

  //圆形复选框是否选中图片
  Widget _ckeckBoxImge(String imgurl) {
    return Image.asset(
      imgurl,
      height: 18,
      width: 18,
    );
  }

  //协议文本内容
  Widget _textContent() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: S.current.loan_application_agreement1,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement2,
                'licenseAgreement'), //98822 企业用户服务协议
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement4,
                'privacyPolicy'), //99868  用户服务协议
          ],
        ),
      ),
    );
  }

  //协议文本跳转内容
  _conetentJump(String text, String arguments) {
    return TextSpan(
      text: text,
      style: AGREEMENT_JUMP_TEXT_STYLE,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pushNamed(context, pageUserAgreement, arguments: arguments);
        },
    );
  }
}
