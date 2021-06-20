///
///@desc   修改交易密码
///@author hlx
///
import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/mine/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/set_payment_pwd.dart';
import 'package:ebank_mobile/data/source/model/update_login_password.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _phoneNo = '';
  String _areaCodeStr = '';
  Timer _timer;
  int endSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _oldPwd.addListener(() {
      setState(() {});
    });
    _newPwd.addListener(() {
      setState(() {});
    });
    _confimPwd.addListener(() {
      setState(() {});
    });
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setPayPwd),
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
                  margin: EdgeInsets.only(bottom: 10, top: 16),
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          S.of(context).plaseSetPayPsd,
                          style:
                              TextStyle(color: Color(0xEE7A7A7A), fontSize: 13),
                        ),
                      ),
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
                            Container(
                              width: 120,
                              child: Text(
                                S.of(context).sendmsm,
                                style: FIRST_DEGREE_TEXT_STYLE,
                              ),
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
                          endIndent: 3),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    S.of(context).set_pay_password_prompt,
                    style: TextStyle(color: HsgColors.hintText, fontSize: 13),
                  ),
                ),
                CustomButton(
                  margin: EdgeInsets.all(40),
                  text: Text(
                    S.of(context).submit,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  isEnable: _submit(),
                  clickCallback: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _submitData();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //提交按钮
  _submitData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);

    String oldPwd = EncryptUtil.aesEncode(_oldPwd.text);
    String newPwd = EncryptUtil.aesEncode(_newPwd.text);
    print(oldPwd);
    print(newPwd);

    RegExp number_6 = new RegExp(r'^\d{6}$');
    if (!number_6.hasMatch(_sms.text)) {
      HSProgressHUD.showToastTip(
        S.current.sms_error,
      );
    } else if (_newPwd.text != _confimPwd.text) {
      HSProgressHUD.showToastTip(
        S.current.differentPwd,
      );
    } else if (_newPwd.text == _oldPwd.text) {
      HSProgressHUD.showToastTip(
        S.current.sms_error,
      );
    } else if (_newPwd.text != _confimPwd.text) {
      //两次密码是否相等
      HSProgressHUD.showToastTip(
        S.current.differentPwd,
      );
    } else if (_newPwd.text == _oldPwd.text) {
      //新密码等于旧密码
      HSProgressHUD.showToastTip(
        S.current.differnet_old_new_pwd,
      );
    } else if (!number_6.hasMatch(_newPwd.text)) {
      HSProgressHUD.showToastTip(
        S.current.set_pay_password_prompt,
      );
    } else {
      HSProgressHUD.show();
      final prefs = await SharedPreferences.getInstance();
      String userID = prefs.getString(ConfigKey.USER_ID);
      String account = prefs.getString(ConfigKey.USER_ACCOUNT);
      String phone = prefs.getString(ConfigKey.USER_PHONE);

      ApiClientPassword()
          .modifyLoginPassword(ModifyPasswordReq(newPwd, oldPwd, _sms.text,
              userID, account, phone, 'transactionPwd'))
          .then((data) {
        HSProgressHUD.showToastTip(
          S.current.operate_success,
        );
        Navigator.of(context)..pop();
        Navigator.pushReplacementNamed(context, pagePwdOperationSuccess);
        HSProgressHUD.dismiss();
      }).catchError((e) {
        HSProgressHUD.showToast(e);
      });

      // ApiClientPassword()
      //     .updateTransPassword(
      //   SetPaymentPwdReq(oldPwd, newPwd, userID, _sms.text),
      // )
      //     .then((data) {
      //   HSProgressHUD.showToastTip(
      //     S.current.changPwsSuccess,
      //   );
      //   Navigator.of(context)..pop();
      //   Navigator.pushReplacementNamed(context, pagePwdOperationSuccess);
      //   HSProgressHUD.dismiss();
      // }).catchError((e) {
      //   HSProgressHUD.showToast(e);
      // });
    }
  }

  bool _submit() {
    if (_oldPwd.text != '' &&
        _newPwd.text != '' &&
        _confimPwd.text != '' &&
        _sms.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //倒计时方法
  _startCountdown() {
    endSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 120;
    final call = (timer) {
      if (this.mounted) {
        setState(() {
          if (endSeconds < DateTime.now().millisecondsSinceEpoch ~/ 1000) {
            _timer.cancel();
          }
        });
      }
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  _otpEnable() {
    if (_oldPwd.text.length > 0 &&
        _newPwd.text.length > 0 &&
        _confimPwd.text.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  //获取验证码按钮
  FlatButton _otpButton() {
    bool otpEnable =
        (endSeconds <= DateTime.now().millisecondsSinceEpoch ~/ 1000 &&
            _otpEnable());
    return FlatButton(
      onPressed: otpEnable
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              _getVerificationCode();
            }
          : null,
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
        endSeconds > DateTime.now().millisecondsSinceEpoch ~/ 1000
            ? '${endSeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  //获取用户信息
  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    // String userID = prefs.getString(ConfigKey.USER_ID);
    String phoneStr = prefs.getString(ConfigKey.USER_PHONE);
    String areacodeStr = prefs.getString(ConfigKey.USER_AREACODE);

    if (mounted) {
      setState(() {
        _phoneNo = phoneStr ?? '';
        _areaCodeStr = areacodeStr ?? '86';
      });
    }
  }

  //获取验证码接口 -- 修改交易密码
  _getVerificationCode() async {
    HSProgressHUD.show();
    ApiClientPassword()
        .sendSmsByPhone(
      SendSmsByPhoneNumberReq(
          _areaCodeStr, _phoneNo, 'transactionPwd', 'SCNAOCHGTSPW', 'MB',
          msgBankId: '999'),
    )
        .then((data) {
      _startCountdown();
      if (this.mounted) {
        setState(() {
          // _sms.text = '123456';
        });
      }
      HSProgressHUD.dismiss();
    }).catchError((e) {
      HSProgressHUD.showToast(e);
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
      style: TEXTFIELD_TEXT_STYLE,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
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
          Container(
            width: 180,
            child: Text(
              this.labText,
              style: FIRST_DEGREE_TEXT_STYLE,
            ),
          ),
          Expanded(
            child: TextField(
              controller: this.inputValue,
              keyboardType: TextInputType.number,
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: true, //是否自动对焦
              obscureText: true, //是否是密码
              textAlign: TextAlign.right, //文本对齐方式
              style: TEXTFIELD_TEXT_STYLE,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                LengthLimitingTextInputFormatter(6), //限制长度
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
