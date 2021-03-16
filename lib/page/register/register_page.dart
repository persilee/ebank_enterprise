import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/mine/set_pay_page.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册页面
/// Author: pengyikang
/// Date: 2020-03-15
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _sms = TextEditingController();
  TextEditingController _phoneNum = TextEditingController();
  Timer _timer;
  int countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('注册'),
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  //注册标题
                  getRegisterTitle(),
                  //注册手机号
                  getRegisterRegion(context, _phoneNum),
                  //输入用户名
                  getRegisterRow('输入用户名'),
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
                            autocorrect: false,
                            //是否自动获得焦点
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '输入验证码',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: HsgColors.textHintColor,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //调用获取验证码接口
                            _otpButton();
                            print('获取验证码');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Text(
                              '获取验证码',
                              style: TextStyle(color: Colors.blue),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color(0xFFF5F7F9)),
                          margin: EdgeInsets.only(top: 75),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 15,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              '下一步',
                              style: (TextStyle(color: Colors.white)),
                              //textDirection: Colors.white,
                            ),
                            onPressed: _submit()
                                ? () {
                                    Navigator.pushNamed(context, pageHome);
                                  }
                                : null,
                          ),
                        )
                      ],
                    ),
                  ),
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

  bool _submit() {
    if (_phoneNum.text != ''
        // &&
        // _newPwd.text != '' &&
        // _confimPwd.text != '' &&
        //_sms.text != ''
        ) {
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
}
