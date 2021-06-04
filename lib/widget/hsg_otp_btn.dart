import 'dart:async';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HSGOTPBtn extends StatefulWidget {
  final int time;
  bool isCutdown;
  final VoidCallback otpCallback;
  bool isEndCutdown;

  HSGOTPBtn({
    Key key,
    this.time = 120,
    this.isCutdown = false,
    this.otpCallback,
    this.isEndCutdown = false,
  }) : super(key: key);

  @override
  _HSGOTPBtnState createState() => _HSGOTPBtnState();
}

class _HSGOTPBtnState extends State<HSGOTPBtn> {
  Timer _timer;
  int _countdownTime;

  bool _btnIsLoading = false;
  bool _btnIsEnable = true;

  @override
  void initState() {
    _countdownTime = widget.isCutdown == true ? widget.time : 0;
    if (widget.isCutdown) {
      _startCountdown();
    }

    if (widget.isEndCutdown) {
      _countdownTime = 0;
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
    _countdownTime = widget.time;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        onPressed: widget.otpCallback,
        child: Text(
          _countdownTime > 0
              ? '${_countdownTime}s'
              : S.of(context).getVerificationCode,
          style: TextStyle(
            color: _btnIsEnable ? Color(0xff3394D4) : Colors.grey,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
