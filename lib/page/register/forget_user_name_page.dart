import 'dart:async';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 忘记用户名页面
/// Author: pengyikang

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetUserName extends StatefulWidget {
  ForgetUserName({Key key}) : super(key: key);

  @override
  _ForgetUserNameState createState() => _ForgetUserNameState();
}

class _ForgetUserNameState extends State<ForgetUserName> {
  TextEditingController _phoneNum = TextEditingController();
  TextEditingController _sms = TextEditingController();
  Timer _timer;
  int countdownTime = 0;

  /// 区号
  String _officeAreaCodeText = '';
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
                  getRegisterTitle(S.current.forget_username),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color(0xFFF5F7F9)),
                          margin: EdgeInsets.only(top: 75),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 15,
                          child: RaisedButton(
                            disabledColor: HsgColors.btnDisabled,
                            color: Colors.blue,
                            child: Text(
                              S.current.submit,
                              style: (TextStyle(color: Colors.white)),
                              //textDirection: Colors.white,
                            ),
                            onPressed: _submit()
                                ? () {
                                    Navigator.pushNamed(
                                        context, pageFindUserNameSuccess);
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
    if (_phoneNum.text != '' && _sms.text != '') {
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

  //获取验证码接口
  _getVerificationCode() async {
    // RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    //if (characters.hasMatch(_phoneNum.text) == false) {
    HSProgressHUD.showInfo(status: S.current.format_mobile_error);
    //}
    // else {
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
}
