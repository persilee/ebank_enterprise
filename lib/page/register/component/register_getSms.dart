import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/check_phone.dart';
import 'package:ebank_mobile/data/source/model/send_sms_register.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册账号短信验证
/// Author: pengyikang
class GetSms extends StatefulWidget {
  final TextEditingController phone;
  final TextEditingController sms;
  final String smsType;
  final String officeAreaCodeText;
  final bool isRegister;
  final bool isForget;
  final bool isInput;
  const GetSms({
    Key key,
    this.sms,
    this.smsType,
    this.phone,
    this.officeAreaCodeText,
    this.isRegister,
    this.isForget,
    this.isInput,
  }) : super(key: key);
  @override
  _GetSmsState createState() => _GetSmsState();
}

class _GetSmsState extends State<GetSms> {
  int countdownTime = 0;
  Timer _timer;
  bool _isRegister = false;
  bool _isInput = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
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
                controller: widget.sms,
                autocorrect: true,
                //是否自动获得焦点
                autofocus: true,
                //输入框是否可用
                enabled: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.current.please_input_sms,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: HsgColors.textHintColor,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                  LengthLimitingTextInputFormatter(6),
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
    );
  }

  //检验用户是否注册
  _checkRegister() {
    HSProgressHUD.show();
    VersionDataRepository()
        .checkPhone(CheckPhoneReq(widget.phone.text, '2'), 'checkPhoneReq')
        .then((data) {
      if (mounted) {
        setState(() {
          _isRegister = data.register;
          _sendSmsRegister(_isRegister);
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
    // }
  }

  //获取注册发送短信验证码接口
  _sendSmsRegister(bool _isRegister) async {
    print('$_isRegister>>>>>>>>');
    // _isRegister ?
    if (widget.isRegister) {
      if (_isRegister) {
        HSProgressHUD.dismiss();
        Fluttertoast.showToast(
          msg: S.current.num_is_register,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } else {
        VersionDataRepository()
            .sendSmsRegister(
                SendSmsRegisterReq(widget.officeAreaCodeText, widget.phone.text,
                    widget.smsType),
                'sendSmsRegister')
            .then((value) {
          if (mounted) {
            setState(() {
              _startCountdown();
              _isInput = true;
              //  _sms.text = "123456";
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
    }
    if (widget.isForget) {
      if (!_isRegister) {
        Fluttertoast.showToast(
          msg: S.current.num_not_is_register,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } else {
        VersionDataRepository()
            .sendSmsRegister(
                SendSmsRegisterReq(widget.officeAreaCodeText, widget.phone.text,
                    widget.smsType),
                'sendSmsRegister')
            .then((value) {
          if (mounted) {
            setState(() {
              _startCountdown();
              //  _sms.text = "123456";
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
    }
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 120;
    final call = (timer) {
      if (mounted) {
        setState(() {
          if (countdownTime < 1) {
            _timer.cancel();
          } else {
            countdownTime -= 1;
          }
        });
      }
    };
    HSProgressHUD.dismiss();
    _timer = Timer.periodic(Duration(seconds: 1), call);
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
