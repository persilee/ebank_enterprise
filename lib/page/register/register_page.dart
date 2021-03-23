import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/send_sms_register.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';

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
import 'package:fluttertoast/fluttertoast.dart';

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

  /// 区号
  String _officeAreaCodeText = '';
  @override
  // ignore: must_call_super
  void initState() {
    _phoneNum.addListener(() {
      _phoneNumListen = _phoneNum.text;
    });
    _sms.addListener(() {
      _smsListen = _sms.text;
    });
    _userName.addListener(() {
      _userNameListen = _userName.text;
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
                      context,
                      _phoneNum,
                      _officeAreaCodeText,
                      _selectRegionCode,
                    ),
                    //输入用户名
                    getRegisterRow(
                        S.current.please_input_username, _userName, false),
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
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter
                                    .digitsOnly, //只输入数字
                                LengthLimitingTextInputFormatter(6) //限制长度
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
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
                                color: HsgColors.registerNextBtn),
                            margin: EdgeInsets.only(top: 75),
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.height / 15,
                            child: RaisedButton(
                              disabledColor: HsgColors.btnDisabled,
                              color: Colors.blue,
                              child: Text(
                                S.current.next_step,
                                style: (TextStyle(color: Colors.white)),
                              ),
                              onPressed: _submit()
                                  ? () {
                                      RegExp userName =
                                          new RegExp("[a-zA-Z0-9]{4,16}");
                                      //特殊字符
                                      RegExp characters = new RegExp(
                                          "[ ,\\`,\\~,\\!,\\@,\#,\$,\\%,\\^,\\+,\\*,\\&,\\\\,\\/,\\?,\\|,\\:,\\.,\\<,\\>,\\{,\\},\\(,\\),\\'',\\;,\\=,\",\\,,\\-,\\_,\\[,\\],]");
                                      if (userName.hasMatch(_userName.text) ==
                                              false ||
                                          characters.hasMatch(_userName.text) ==
                                              true) {
                                        Fluttertoast.showToast(
                                            msg:
                                                '用户名只能为4-16位字符、数字或者字母，不能包含特殊字符，不能重复');
                                      } else {
                                        Map listData = new Map();
                                        listData = {
                                          'accountName': _userNameListen,
                                          'sms': _smsListen,
                                          'phone': _phoneNumListen
                                        };
                                        // listData = [
                                        //   _userNameListen,
                                        //   _smsListen,
                                        //   _phoneNumListen
                                        // ];

                                        Navigator.pushNamed(
                                            context, pageRegisterConfirm,
                                            arguments: listData);
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
                )),
          )),
    );
  }

  bool _submit() {
    if (_phoneNumListen != '' &&
        _userNameListen != '' &&
        _smsListen != '' &&
        _checkBoxValue) {
      return true;
    } else {
      return false;
    }
  }

  //选择地区方法
  _selectRegionCode() {
    print('区号');
    Navigator.pushNamed(context, countryOrRegionSelectPage).then((value) {
      setState(() {
        _officeAreaCodeText = (value as CountryRegionModel).code;
      });
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

//圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _checkBoxValue = !_checkBoxValue;
          _submit();
        });
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
      height: 16,
      width: 16,
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
            _conetentJump(S.current.loan_application_agreement2, '98822'),
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement4, '99868'),
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
          Navigator.pushNamed(context, pageUserAgreement, arguments: arguments);
        },
    );
  }

  //获取注册发送短信验证码接口
  _sendSmsRegister() async {
    RegExp characters = new RegExp("^1[3|4|5|7|8][0-9]{9}");
    if (characters.hasMatch(_phoneNum.text) == false) {
      Fluttertoast.showToast(msg: S.current.format_mobile_error);
    } else {
      VersionDataRepository()
          .sendSmsRegister(SendSmsRegisterReq('', _phoneNum.text, 'register'),
              'sendSmsRegister')
          .then((value) {
        setState(() {
          _startCountdown();
          //  _sms.text = "123456";
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
    }
  }

  FlatButton _otpButton() {
    return FlatButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _sendSmsRegister();
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
}
