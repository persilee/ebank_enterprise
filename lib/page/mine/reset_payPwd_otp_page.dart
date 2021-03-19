/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2021-03-17

import 'dart:async';
import 'dart:ui';
import 'package:ebank_mobile/data/source/model/country_region_model.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/util/small_data_store.dart';

class ResetPayPwdPage extends StatefulWidget {
  @override
  _ResetPayPwdPageState createState() => _ResetPayPwdPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ResetPayPwdPageState extends State<ResetPayPwdPage> {
  // TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _sms = TextEditingController();
  String _officeAreaCodeText = '86';
  Timer _timer;
  int countdownTime = 0;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    // _phoneNumber.addListener(() {
    //   setState(() {});
    // });
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    String argument = ModalRoute.of(context).settings.arguments;
    if (argument != null) {
      _phone = argument;
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).resetPayPsd),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16, top: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            S.of(context).plaseSetPayPsd,
                            style: TextStyle(
                                color: Color(0xEE7A7A7A), fontSize: 13),
                          ),
                        ),
                        //手机号
                        _infoFrame(S.of(context).phone_num,
                            '+' + _officeAreaCodeText + ' ' + _phone),
                        // _inputList(
                        //   S.of(context).phone_num,
                        //   S.of(context).phone_num,
                        //   _phoneNumber,
                        // ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(S.of(context).sendmsm),
                              ),
                              Expanded(
                                child: otpTextField(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              SizedBox(
                                width: 90,
                                height: 32,
                                child: _otpButton(),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: HsgColors.divider,
                          indent: 3,
                          endIndent: 3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).next_step),
                      onPressed: _submit()
                          ? () {
                              _submitData();
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
                  ),
                ],
              )),
        ),
      ),
    );
  }

  //获取用户信息
  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(
      GetUserInfoReq(userID),
      'getUserInfo',
    )
        .then((data) {
      setState(() {
        _phone = data.userPhone;
        if (data.areaCode != null) {
          _officeAreaCodeText = data.areaCode; //区号
        }
      });
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }

  //提交按钮
  _submitData() async {
    //请求验证手机号验证码，成功后跳转到身份验证界面
    Navigator.pushNamed(context, iDcardVerification);
  }

  bool _submit() {
    if (_sms.text.length > 0) {
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

  //通用框(传入左边内容和右边文字)
  Widget _infoFrame(String left, String right) {
    return Column(
      children: [
        Container(
          height: 50,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                child: Text(
                  left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _hintText(right),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Divider(
              height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
        ),
      ],
    );
  }

  //灰色文字
  Widget _hintText(String text) {
    return Container(
      width: 130,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          // color: HsgColors.hintText,
          color: Color(0xEE7A7A7A),
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //获取验证码按钮
  FlatButton _otpButton() {
    return FlatButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _getVerificationCode();
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: Color(0xeeEFF3FF),
      //文字颜色
      textColor: HsgColors.blueTextColor,
      //画圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      disabledTextColor: HsgColors.blueTextColor,
      disabledColor: Color(0xeeEFF3FF),
      child: Text(
        countdownTime > 0
            ? '${countdownTime}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  //获取验证码接口
  _getVerificationCode() async {
    // final prefs = await SharedPreferences.getInstance();
    // String userAcc = prefs.getString(ConfigKey.USER_ACCOUNT);
    // RegExp postalcode = new RegExp(r'\D');
    // if (postalcode.hasMatch(_phoneNumber.text)) {
    //   Fluttertoast.showToast(msg: '请输入正确的手机号!');
    //   return;
    // } else if (_phoneNumber.text.length <= 0) {
    //   Fluttertoast.showToast(msg: '请输入手机号!');
    //   return;
    // }
    HSProgressHUD.show();
    VerificationCodeRepository()
        // .sendSmsByAccount(
        //     SendSmsByAccountReq('modifyPwd', userAcc), 'SendSmsByAccountReq')
        // )
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq(_phone, 'transactionPwd'), 'sendSms')
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

  //验证码输入框
  TextField otpTextField() {
    return TextField(
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      controller: _sms,
      onChanged: (text) {
        setState(() {});
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(6), //限制长度
      ],
      decoration: InputDecoration.collapsed(
        hintText: S.current.placeSMS,
        hintStyle: TextStyle(
          fontSize: 14,
          color: HsgColors.textHintColor,
        ),
      ),
    );
  }

  Widget _inputList(
    String labText,
    String placeholderText,
    TextEditingController inputValue,
  ) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(labText),
          InkWell(
            onTap: () {
              print('区号');
              Navigator.pushNamed(context, countryOrRegionSelectPage)
                  .then((value) {
                setState(() {
                  if ((value as CountryRegionModel).code != null) {
                    _officeAreaCodeText = (value as CountryRegionModel).code;
                  } else {
                    _officeAreaCodeText = '86';
                  }
                });
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    '+' + _officeAreaCodeText,
                    style: TextStyle(color: HsgColors.hintText),
                  ),
                  Icon(Icons.arrow_drop_down_outlined,
                      color: HsgColors.hintText),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: inputValue,
              keyboardType: TextInputType.number,
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: true, //是否自动对焦
              obscureText: false, //是否是密码
              textAlign: TextAlign.right, //文本对齐方式
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                LengthLimitingTextInputFormatter(11), //限制长度
              ],
              onChanged: (text) {
                //内容改变的回调
                // print('change $text');
              },
              onSubmitted: (text) {
                //内容提交(按回车)的回调
                // print('submit $text');
              },
              enabled: true, //是否禁用
              // inputFormatters: <TextInputFormatter>[
              //   LengthLimitingTextInputFormatter(6), //限制长度
              // ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholderText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class InputList extends StatelessWidget {
//   InputList(this.labText, this.placeholderText, this.inputValue,
//       {this.isShow = false});
//   final String labText;
//   final String placeholderText;
//   TextEditingController inputValue = TextEditingController();
//   final bool isShow;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50.0,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(this.labText),
//           Expanded(
//             child: TextField(
//               controller: this.inputValue,
//               keyboardType: TextInputType.number,
//               maxLines: 1, //最大行数
//               autocorrect: true, //是否自动更正
//               autofocus: true, //是否自动对焦
//               obscureText: false, //是否是密码
//               textAlign: TextAlign.right, //文本对齐方式
//               inputFormatters: <TextInputFormatter>[
//                 FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
//                 LengthLimitingTextInputFormatter(11), //限制长度
//               ],
//               onChanged: (text) {
//                 //内容改变的回调
//                 // print('change $text');
//               },
//               onSubmitted: (text) {
//                 //内容提交(按回车)的回调
//                 // print('submit $text');
//               },
//               enabled: true, //是否禁用
//               // inputFormatters: <TextInputFormatter>[
//               //   LengthLimitingTextInputFormatter(6), //限制长度
//               // ],
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: this.placeholderText,
//                 hintStyle: TextStyle(
//                   fontSize: 15,
//                   color: HsgColors.textHintColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
