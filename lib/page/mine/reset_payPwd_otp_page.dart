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
import 'package:ebank_mobile/widget/custom_button.dart';
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
  TextEditingController _sms = TextEditingController();
  String _officeAreaCodeText = '86';
  Timer _timer;
  int countdownTime = 0;
  String _phone = '';
  var _belongCustStatus = '0'; //用户状态

  @override
  void initState() {
    super.initState();
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
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).resetPayPsd),
        centerTitle: true,
        elevation: 1,
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
                  CustomButton(
                    margin: EdgeInsets.all(40),
                    text: Text(
                      S.of(context).next_step,
                      style: TextStyle(color: Colors.white),
                    ),
                    isEnable: _submit(),
                    clickCallback: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _submitData();
                    },
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
      if (this.mounted) {
        setState(() {
          _belongCustStatus =
              data.belongCustStatus != null ? data.belongCustStatus : ''; //用户状态
          _phone = data.userPhone != null ? data.userPhone : ''; //手机号
          if (data.areaCode != null) {
            _officeAreaCodeText = data.areaCode; //区号
          }
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      print('${e.toString()}');
    });
  }

  //提交按钮
  _submitData() async {
    //请求验证手机号验证码，成功后跳转到身份验证界面
    RegExp number_6 = new RegExp(r'^\d{6}$');
    if (!number_6.hasMatch(_sms.text)) {
      Fluttertoast.showToast(
        msg: S.current.sms_error,
        gravity: ToastGravity.CENTER,
      );
    } else {
      //请求-未写
      HSProgressHUD.show();
      //请求成功后跳转，传数据
      Map map = new Map();
      map['certificateNo'] = '0';
      map['certificateType'] = '0';
      map['phoneNumber'] = _phone;
      map['belongCustStatus'] = _belongCustStatus;
      _belongCustStatus == '6'
          ? Navigator.pushNamed(context, iDcardVerification, arguments: _phone)
          : Navigator.pushNamed(context, setPayPage, arguments: map);
      //请求结束-无论成功与否
      HSProgressHUD.dismiss();
    }
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
      if (this.mounted) {
        setState(() {
          if (countdownTime < 1) {
            _timer.cancel();
          } else {
            countdownTime -= 1;
          }
        });
      }
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
      onPressed: (countdownTime > 0 || _phone == '')
          ? null
          : () {
              FocusScope.of(context).requestFocus(FocusNode());
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
      disabledTextColor: Colors.white,
      disabledColor: HsgColors.hintText,
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
    HSProgressHUD.show();
    VerificationCodeRepository()
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq(_phone, 'transactionPwd'), 'sendSms')
        .then((data) {
      _startCountdown();
      if (this.mounted) {
        setState(() {
          // _sms.text = '123456';
        });
      }
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
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
        hintText: S.current.please_enter,
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
