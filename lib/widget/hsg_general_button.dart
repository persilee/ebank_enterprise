import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget HsgBottomBtn(String title, VoidCallback onClick,
    {double marginCro, double marginVer, double btnHeight}) {
  if (marginCro == null) marginCro = 25.0;
  if (marginVer == null) marginVer = 15.0;
  if (btnHeight == null) btnHeight = 45.0;

  return Container(
    padding: EdgeInsets.only(
        left: marginCro, right: marginCro, top: marginVer, bottom: marginVer),
    height: btnHeight + marginVer * 2,
    child: CupertinoButton(
      disabledColor: HsgColors.btnDisabled,
      padding: EdgeInsets.all(5),
      color: HsgColors.accent,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onPressed: onClick,
    ),
  );
}
