import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/mine/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HSGOTPButton extends StatefulWidget {
  final int time;
  final String smsType;
  final bool isCutdown;
  final VoidCallback otpCallback;

  const HSGOTPButton(
    this.smsType, {
    Key key,
    this.time = 120,
    this.isCutdown = false,
    this.otpCallback,
  }) : super(key: key);

  @override
  _HSGOTPButtonState createState() => _HSGOTPButtonState();
}

class _HSGOTPButtonState extends State<HSGOTPButton> {
  Timer _timer;
  int _countdownTime;

  bool _btnIsLoading = false;
  bool _btnIsEnable = true;

  @override
  void initState() {
    _countdownTime = widget.isCutdown == true ? widget.time : 0;
    if (widget.isCutdown) {
      _getVerificationCode();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  //倒计时方法
  _startCountdown() {
    final call = (timer) {
      if (mounted) {
        setState(() {
          if (_countdownTime < 1) {
            _timer.cancel();
          } else {
            _countdownTime -= 1;
          }
        });
      }
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //获取验证码接口
  _getVerificationCode() async {
    if (mounted) {
      setState(() {
        _btnIsLoading = true;
        _btnIsEnable = false;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    String userAreacode = prefs.getString(ConfigKey.USER_AREACODE);
    String userPhone = prefs.getString(ConfigKey.USER_PHONE);
    userAreacode = userAreacode != null ? userAreacode : '';
    userPhone = userPhone != null ? userPhone : '';
    ApiClientPassword()
        .sendSmsByPhone(SendSmsByPhoneNumberReq(
            userAreacode, userPhone, 'modifyPwd', 'SCNAOCHGLPW', 'MB',
            msgBankId: '999'))
        .then((data) {
      if (mounted) {
        setState(() {
          _btnIsLoading = false;
          _btnIsEnable = true;
        });
      }
      _startCountdown();
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _countdownTime = 0;
          _btnIsLoading = false;
          _btnIsEnable = true;
        });
      }
      HSProgressHUD.showToast(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      isLoading: _btnIsLoading,
      isEnable: _btnIsEnable,
      isOutline: true,
      isShowLine: false,
      margin: EdgeInsets.all(0),
      text: Text(
        _countdownTime > 0
            ? '${_countdownTime}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(
          color: _btnIsEnable ? Color(0xff3394D4) : Colors.grey,
          fontSize: 14.0,
        ),
      ),
      clickCallback: () {
        _getVerificationCode();
      },
    );
    // MaterialButton(
    //   onPressed: _countdownTime > 0
    //       ? null
    //       : () {
    //           _getVerificationCode();
    //         },
    //   //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间asdfa
    //   padding: EdgeInsets.symmetric(horizontal: 8),
    //   //文字颜色
    //   textColor: HsgColors.blueTextColor,
    //   // borderSide: BorderSide(color: HsgColors.blueTextColor, width: 0),
    //   //画圆角
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(4),
    //   ),
    //   disabledTextColor: HsgColors.describeText,
    //   // disabledBorderColor: HsgColors.describeText,
    //   child: Text(
    //     _countdownTime > 0
    //         ? '${_countdownTime}s'
    //         : S.of(context).getVerificationCode,
    //     style: TextStyle(
    //       fontSize: 14,
    //     ),
    //   ),
    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // );
  }
}
