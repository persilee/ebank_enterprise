import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HSGOTPBtn extends StatefulWidget {
  int time;
  final bool isCutdown;
  final VoidCallback otpCallback;

  HSGOTPBtn(
    this.time, {
    Key key,
    this.isCutdown = false,
    this.otpCallback,
  }) : super(key: key);

  @override
  _HSGOTPBtnState createState() => _HSGOTPBtnState();
}

class _HSGOTPBtnState extends State<HSGOTPBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        onPressed: widget.otpCallback,
        child: Text(
          S.current.getVerificationCode,
          style: TextStyle(
            fontSize: 15,
            color: HsgColors.primary,
          ),
        ),
      ),
    );
  }
}
