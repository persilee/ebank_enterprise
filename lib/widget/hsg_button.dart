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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
