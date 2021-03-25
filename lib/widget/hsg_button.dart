/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///按钮
/// Author: fangluyao
/// Date: 2021-01-08

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class HsgButton {
  static Widget button({
    String title,
    Function click,
  }) {
    return Container(
      // padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF1775BA),
          Color(0xFF3A9ED1),
        ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 50,
        child: RaisedButton(
          onPressed: click,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          // color: Color(0xFF3A9ED1),
          color: Colors.transparent,
          elevation: 0, // 正常时阴影隐藏
          highlightElevation: 0, // 点击时阴影隐藏
          disabledColor: HsgColors.btnDisabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  static Widget defaultButton({
    String title,
    Function click,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 45,
        child: RaisedButton(
          onPressed: click,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          color: HsgColors.blueTextColor,
          disabledColor: HsgColors.btnDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  static Widget whiteButton({
    String title,
    Function click,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 45,
        child: RaisedButton(
          onPressed: click,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: HsgColors.firstDegreeText),
            textAlign: TextAlign.center,
          ),
          color: Colors.white,
          disabledColor: HsgColors.btnDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 0.5,
              color: HsgColors.notSelectedBtn,
            ),
          ),
        ),
      ),
    );
  }
}
