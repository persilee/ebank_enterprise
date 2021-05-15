import 'dart:async';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记用户名页面
/// Author: pengyikang
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/check_phone.dart';
import 'package:ebank_mobile/data/source/model/account/check_sms.dart';
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

class ForgetUserName extends StatefulWidget {
  ForgetUserName({Key key}) : super(key: key);

  @override
  _ForgetUserNameState createState() => _ForgetUserNameState();
}

class _ForgetUserNameState extends State<ForgetUserName> {
  TextEditingController _phoneNum = TextEditingController();
  TextEditingController _sms = TextEditingController();
  String _phoneNumListen;
  String _smsListen;
  Timer _timer;
  int countdownTime = 0;
  String _accountName;
  bool _isRegister;
  bool _isInput = false; //判断是否点击获取验证码
  bool _isCommit = false; //点击下一步进行二次校验
  String _smsCode = '';

  /// 区号
  String _officeAreaCodeText = '';

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
          child: ListView(
            children: [
              //忘记用户名标题
              getRegisterTitle(S.current.forget_username),
              //忘记用户名区号
              getRegisterRegion(
                  context, _phoneNum, _officeAreaCodeText, _selectRegionCode),

              //获取验证码
              //    SizedBox(
              //   height: 20,
              // ),
              // GetSms(
              //   phone: _phoneNum,
              //   officeAreaCodeText: _officeAreaCodeText,
              //   smsType: 'findAccount',
              //   sms: _sms,
              //   isRegister: false,
              //   isForget: true,
              // ),

              // //获取验证码
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
                        enabled: true,
                        //_isInput,
                        //是否自动获得焦点
                        autofocus: true,
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
                        ],
                        //限制长度
                        keyboardType: TextInputType.number,
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
                        child: Text(
                          S.current.submit,
                          style: (TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                          //textDirection: Colors.white,
                        ),
                        onPressed: _submit()
                            ? () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _checkRegisterBysencond();
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
    );
  }

  bool _submit() {
    if (_phoneNum.text != '' && _sms.text.length > 5 && _isInput) {
      return true;
    } else {
      return false;
    }
  }

  //获取地区
  _selectRegionCode() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionNewModel).areaCode;
      });
    });
  }

  //发送短信
  FlatButton _otpButton() {
    return FlatButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              FocusScope.of(context).requestFocus(FocusNode());
              _checkRegister();
              FocusScope.of(context).requestFocus(FocusNode());
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
      // padding: EdgeInsets.only(left: 35),
      //文字颜色
      textColor: HsgColors.blueTextColor,

      disabledTextColor: HsgColors.blueTextColor,
      child: Text(
        countdownTime > 0
            ? '${countdownTime}s'
            : S.of(context).getVerificationCode,
        textAlign: TextAlign.right,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  //检验手机号码注册情况及验证码
  _checkRegister() {
    HSProgressHUD.show();
    ApiClientAccount()
        .checkPhone(CheckPhoneReq(_phoneNum.text, '2'))
        .then((data) {
      if (mounted) {
        setState(() {
          _accountName = data.userAccount;
          _isRegister = data.register;
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
  }

  //获取验证码接口
  _getVerificationCode() async {
    ApiClientPassword()
        .sendSmsByPhone(
      SendSmsByPhoneNumberReq(
          _officeAreaCodeText, //地区号
          _phoneNum.text, //电话号
          'findAccount', //短信类型
          'SCNAOFGUN', //smsTemplateId,
          'MB',
          msgBankId: '999'),
    )
        .then((data) {
      if (mounted) {
        setState(() {
          _startCountdown();
          _smsCode = data.smsCode;
          _isInput = true;
          HSProgressHUD.dismiss();
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
        .checkSms(CheckSmsReq(_phoneNum.text, 'findAccount', _smsListen, 'MB'))
        .then((data) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          //校验是否注册
          if (!data.checkResult) {
            HSProgressHUD.showToastTip(
              S.current.num_not_is_register,
            );
          } //跳转至下一页面
          else {
            Navigator.popAndPushNamed(context, pageFindUserNameSuccess,
                arguments: _accountName);
            HSProgressHUD.dismiss();
          }
        });
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
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

  //释放_timer
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
