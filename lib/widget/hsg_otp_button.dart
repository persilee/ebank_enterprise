import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HSGOTPButton extends StatefulWidget {
  final int time;
  final String smsType;
  final VoidCallback otpCallback;

  const HSGOTPButton(
    this.smsType, {
    Key key,
    this.time = 120,
    this.otpCallback,
  }) : super(key: key);

  @override
  _HSGOTPButtonState createState() => _HSGOTPButtonState();
}

class _HSGOTPButtonState extends State<HSGOTPButton> {
  Timer _timer;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    int countdownTime = widget.time;

    //倒计时方法
    _startCountdown() {
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
      String userPhone = prefs.getString(ConfigKey.USER_PHONE);
      userPhone = userPhone != null ? userPhone : '';
      // VerificationCodeRepository()
      ApiClientPassword()
          // .sendSmsByAccount(
          //     SendSmsByAccountReq('modifyPwd', userAcc), 'SendSmsByAccountReq')
          // )
          .sendSmsByPhone(
        SendSmsByPhoneNumberReq('', userPhone, widget.smsType, ''),
      )
          .then((data) {
        _startCountdown();
        setState(() {});
        HSProgressHUD.dismiss();
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
        HSProgressHUD.dismiss();
      });
    }

    return OutlineButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _getVerificationCode();
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间asdfa
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
}
