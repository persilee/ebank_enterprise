import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final double height;
  final Widget text;
  final EdgeInsetsGeometry margin;
  final Gradient gradientColor;
  final BorderRadiusGeometry borderRadius;
  final bool isOutline;
  final VoidCallback clickCallback;
  final bool isEnable;

  const CustomButton({
    Key key,
    this.height = 44.0,
    this.text,
    this.margin,
    this.gradientColor,
    this.borderRadius,
    this.isOutline = false,
    this.clickCallback,
    this.isEnable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: isEnable ? BoxDecoration(
        gradient: isOutline ? LinearGradient(colors: [Colors.transparent, Colors.transparent]) :
        (gradientColor ?? LinearGradient(colors: [Color(0xff1775BA), Color(0xff3A9ED1)])), // 渐变色
        borderRadius: borderRadius ?? BorderRadius.circular(5.0),
      ) : BoxDecoration(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          primary: isOutline ? Colors.transparent : Colors.transparent, // 设为透明色
          onPrimary: Colors.blue.withOpacity(0.36),
          elevation: 1, // 正常时阴影隐藏
          shadowColor: Colors.transparent,
          minimumSize: Size(66, 44),
          side: isOutline ? BorderSide(color: Color(0xff3394D4), width: 1) : BorderSide(color: Colors.transparent, width: 0),
        ),
        onPressed: isEnable ? clickCallback ?? (){} : null,
        child: Container(
          alignment: Alignment.center,
          child: text ?? Text(
            'button',
            style: TextStyle(color: isOutline ? Color(0xff3394D4) : Colors.white, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}