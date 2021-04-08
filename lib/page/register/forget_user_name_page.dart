import 'dart:async';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记用户名页面
/// Author: pengyikang

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/check_phone.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_getSms.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                          style: (TextStyle(color: Colors.white)),
                          //textDirection: Colors.white,
                        ),
                        onPressed: _submit()
                            ? () {
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
    print('区号');
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionModel).code;
      });
    });
  }

  //发送短信
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

  //检验用户是否注册
  _checkRegister() {
    HSProgressHUD.show();
    VersionDataRepository()
        .checkPhone(CheckPhoneReq(_phoneNum.text, '2'), 'checkPhoneReq')
        .then((data) {
      if (mounted) {
        setState(() {
          _accountName = data.userAccount;
          _isRegister = data.register;
          if (!_isRegister) {
            Fluttertoast.showToast(
              msg: S.current.num_not_is_register,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
            HSProgressHUD.dismiss();
          } else {
            _getVerificationCode();
          }
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
  }

  //获取验证码接口
  _getVerificationCode() async {
    print(">>>>>>>>>>>>>>>$_accountName");
    // if (!_isRegister) {
    //   Fluttertoast.showToast(
    //     msg: S.current.num_not_is_register,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //   );
    //   HSProgressHUD.dismiss();
    // } else {
    VerificationCodeRepository()
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq(
                _officeAreaCodeText, //地区号
                _phoneNum.text, //电话号
                'findAccount', //短信类型
                '' //smsTemplateId
                ),
            'sendSms')
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

  //二次校验
  _checkRegisterBysencond() {
    print('$_smsCode+_smsCode');
    HSProgressHUD.show();
    VersionDataRepository()
        .checkPhone(CheckPhoneReq(_phoneNum.text, '2'), 'checkPhoneReq')
        .then((data) {
      if (mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          _isRegister = data.register;
          //校验是否注册
          if (!_isRegister) {
            Fluttertoast.showToast(
              msg: S.current.num_not_is_register,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
            HSProgressHUD.dismiss();
          }
          //校验短信
          else if (_sms.text != _smsCode) {
            HSProgressHUD.dismiss();
            Fluttertoast.showToast(
              msg: '您输入的验证码错误',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
            );
          }
          //跳转至下一页面
          else {
            Navigator.popAndPushNamed(context, pageFindUserNameSuccess,
                arguments: _accountName);
            HSProgressHUD.dismiss();
          }
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
      HSProgressHUD.dismiss();
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
