/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 重置支付密码--身份证验证
/// Author: hlx
/// Date: 2020-12-31

import 'package:ebank_mobile/data/source/model/update_login_password.dart';
import 'package:ebank_mobile/data/source/update_login_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';

class IdIardVerificationPage extends StatefulWidget {
  @override
  _IdIardVerificationPageState createState() => _IdIardVerificationPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _IdIardVerificationPageState extends State<IdIardVerificationPage> {
  TextEditingController _account = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _idCardType = TextEditingController();
  TextEditingController _idNumber = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _msm = TextEditingController();
  TextEditingController _sms = TextEditingController();
  Timer _timer;
  int countdownTime = 0;
  TextEditingController userAccount = TextEditingController();

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getUser();
  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    userAccount.text = prefs.getString(ConfigKey.USER_ACCOUNT);
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
          title: Text(S.of(context).iDCardVerification),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(children: [
                      InputList(S.of(context).account_number, '', userAccount),
                    ]),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Text(S.of(context).pleaseFillInTheBankInformation, style: TextStyle(fontSize: 12),),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 10.0, bottom: 1.0),
                          child: Text(
                            S.of(context).pleaseFillInTheBankInformation,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        InputList(S.of(context).name, S.of(context).placeName,
                            _account),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).idType,
                            S.of(context).placeIdType, _userName),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).IdentificationNumber,
                            S.of(context).placeIdNumber, _idCardType),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).reservedMobilePhoneNumber,
                            S.of(context).placeReveredMobilePhone, _idCardType),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text(S.of(context).sendmsm),
                              Expanded(
                                child: otpTextField(),
                              ),
                              SizedBox(
                                width: 90,
                                height: 32,
                                child: _otpButton(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).submit),
                      onPressed: _submit()
                          ? () {
                              _updateLoginPassword();
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
                  )
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
      cursorColor: Colors.red,
      decoration: InputDecoration.collapsed(
        // 边色与边宽度
        hintText: S.current.placeSMS,
        hintStyle: TextStyle(
          fontSize: 14,
          color: HsgColors.textHintColor,
        ),
      ),
    );
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
        countdownTime > 0
            ? '${countdownTime}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  bool _submit() {
    if (_account.text != '' &&
        _userName.text != '' &&
        _idCardType.text != '' &&
        _sms.text != '') {
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

  //获取验证码接口
  _getVerificationCode() async {
    HSProgressHUD.show();
    final prefs = await SharedPreferences.getInstance();
    String userAcc = prefs.getString(ConfigKey.USER_ACCOUNT);
    VerificationCodeRepository()
        .sendSmsByAccount(
            SendSmsByAccountReq('modifyPwd', userAcc), 'SendSmsByAccountReq')
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

  //修改密码接口
  _updateLoginPassword() async {
    if (_userName.text != _idCardType.text) {
      Fluttertoast.showToast(msg: S.of(context).differentPwd);
    } else {
      HSProgressHUD.show();
      final prefs = await SharedPreferences.getInstance();
      String userID = prefs.getString(ConfigKey.USER_ID);
      UpdateLoginPawRepository()
          .modifyLoginPassword(
              ModifyPasswordReq(
                  _userName.text, _account.text, _sms.text, userID),
              'ModifyPasswordReq')
          .then((data) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(msg: S.current.operate_success);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        HSProgressHUD.dismiss();
      });
    }
  }
}

// ignore: must_be_immutable
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue);
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.labText),
          Expanded(
            child: TextField(
              controller: this.inputValue,
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: false, //是否自动对焦
              obscureText: false, //是否是密码
              textAlign: TextAlign.right, //文本对齐方式
              onChanged: (text) {
                //内容改变的回调
                print('change $text');
              },
              onSubmitted: (text) {
                //内容提交(按回车)的回调
                print('submit $text');
              },
              enabled: true, //是否禁用
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.placeholderText,
                hintStyle: TextStyle(
                  fontSize: 14,
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
