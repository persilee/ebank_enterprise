///
///@desc   修改支付密码
///@author hlx
///
import 'dart:async';
import 'package:ebank_mobile/data/source/mine_pay_pwdApi.dart';
import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
import 'package:ebank_mobile/data/source/model/set_payment_pwd.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePayPage extends StatefulWidget {
  @override
  _ChangePayPageState createState() => _ChangePayPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ChangePayPageState extends State<ChangePayPage> {
  TextEditingController _oldPwd = TextEditingController();
  TextEditingController _newPwd = TextEditingController();
  TextEditingController _confimPwd = TextEditingController();
  TextEditingController _sms = TextEditingController();

  Timer _timer;
  int countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).setPayPwd),
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
                    padding: EdgeInsets.all(10.0),
                    child: Text(S.of(context).plaseSetPayPsd),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        InputList(S.of(context).oldPayPwd,
                            S.of(context).placeOldPwd, _oldPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).newPayPwd,
                            S.of(context).placeNewPwd, _newPwd),
                        Divider(
                            height: 1,
                            color: HsgColors.divider,
                            indent: 3,
                            endIndent: 3),
                        InputList(S.of(context).confimPayPwd,
                            S.of(context).placeConfimPwd, _confimPwd),
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
                              _submitData();
                            }
                          : null,
                      color: HsgColors.accent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5) //设置圆角
                          ),
                    ),
                  )
                ],
              )),
        ));
  }

  //提交按钮
  _submitData() async {
    if (_newPwd.text != _confimPwd.text) {
      Fluttertoast.showToast(msg: S.of(context).differentPwd);
    } else if (_newPwd.text == _oldPwd.text) {
      Fluttertoast.showToast(msg: S.of(context).differentOldNewPwd);
    } else {
      HSProgressHUD.show();
      final prefs = await SharedPreferences.getInstance();
      String userID = prefs.getString(ConfigKey.USER_ID);
      PaymentPwdRepository()
          .updateTransPassword(
        SetPaymentPwdReq(_oldPwd.text, _newPwd.text, userID, _sms.text),
        'updateTransPassword',
      )
          .then((data) {
        HSProgressHUD.showError(status: '密码修改成功');
        Navigator.pop(context);
        HSProgressHUD.dismiss();
      }).catchError((e) {
        // Fluttertoast.showToast(msg: e.toString());
        HSProgressHUD.showError(status: e.toString());
        print('${e.toString()}');
      });
    }
  }

  bool _submit() {
    if (_oldPwd.text != '' && _newPwd.text != '' && _confimPwd.text != '') {
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
}

//封装一行
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue,
      {this.isShow = false});
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();
  final bool isShow;

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
              autofocus: true, //是否自动对焦
              obscureText: true, //是否是密码
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
