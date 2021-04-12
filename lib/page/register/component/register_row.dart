import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册账号普通行
/// Author: pengyikang
Widget getRegisterRow(
    String hintText, TextEditingController controlText, bool password,
    [List<TextInputFormatter> inputFormatters]) {
  return Container(
    margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
    padding: EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color(0xFFF5F7F9)),
    child: TextField(
      //是否自动更正
      // autocorrect: true,
      // //是否自动获得焦点
      // autofocus: true,
      // onChanged: (value) {
      //   value = controlText.text;
      // },
      inputFormatters: inputFormatters,
      controller: controlText,
      obscureText: password,
      // textAlign: TextAlign.right,
      // onChanged: ,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15,
          color: HsgColors.textHintColor,
        ),
      ),
    ),
  );
}
