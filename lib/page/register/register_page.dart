import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';

import 'package:ebank_mobile/generated/l10n.dart';

import 'package:ebank_mobile/page/register/component/register_86.dart';
import 'package:ebank_mobile/page/register/component/register_getSms.dart';
import 'package:ebank_mobile/page/register/component/register_row.dart';
import 'package:ebank_mobile/page/register/component/register_title.dart';
import 'package:ebank_mobile/page_route.dart';

import 'package:flutter/gestures.dart';

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
  TextEditingController _sms = TextEditingController(); //短信
  String _smsListen;
  TextEditingController _phoneNum = TextEditingController(); //手机号
  String _phoneNumListen;
  TextEditingController _userName = TextEditingController(); //用户名
  String _userNameListen;
  Timer _timer;
  int countdownTime = 0;
  bool _checkBoxValue = false; //复选框默认值
  bool _isRegister = false;

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
      _userName.addListener(() {
        setState(() {
          _userNameListen = _userName.text;
        });
        print("$_userNameListen>>>>>>>>>");
      });
    });
  }

  _phoneNumberChange(String phoneNumber) {
    _phoneNumListen = phoneNumber;
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
                    S.current.please_input_username, _userName, false),
                GetSms(
                  phone: _phoneNum,
                  sms: _sms,
                  smsType: 'register',
                  officeAreaCodeText: _officeAreaCodeText,
                  isRegister: true,
                  isForget: false,
                ),

                // //获取验证码
                // Container(
                //   height: MediaQuery.of(context).size.height / 15,
                //   margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(5)),
                //       color: Color(0xFFF5F7F9)),
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 20),
                //         width: MediaQuery.of(context).size.width / 2,
                //         child: TextField(
                //           //是否自动更正
                //           controller: _sms,
                //           autocorrect: true,
                //           //是否自动获得焦点
                //           autofocus: true,
                //           decoration: InputDecoration(
                //             border: InputBorder.none,
                //             hintText: S.current.please_input_sms,
                //             hintStyle: TextStyle(
                //               fontSize: 15,
                //               color: HsgColors.textHintColor,
                //             ),
                //           ),
                //           inputFormatters: <TextInputFormatter>[
                //             WhitelistingTextInputFormatter.digitsOnly, //只输入数字
                //             LengthLimitingTextInputFormatter(6) //限制长度
                //           ],
                //         ),
                //       ),
                //       Container(
                //         alignment: Alignment.center,
                //         width: MediaQuery.of(context).size.width / 3,
                //         child: _otpButton(),
                //       )
                //     ],
                //   ),
                // ),
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
                                    Fluttertoast.showToast(
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        msg: S.current.register_check_username);
                                  } else {
                                    Map listData = new Map();
                                    listData = {
                                      'accountName': _userNameListen,
                                      'sms': _smsListen,
                                      'phone': _phoneNumListen,
                                      'areaCode': _officeAreaCodeText
                                    };

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
            ),
          ),
        ),
      ),
    );
  }

  bool _submit() {
    if (_phoneNum.text != '' &&
        _userName.text != '' &&
        _smsListen.length > 5 &&
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

//圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
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
}
