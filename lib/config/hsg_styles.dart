import 'package:flutter/material.dart';

class HsgStyles {
  static BoxDecoration homeHeaderShadow = HsgShadow(Colors.white);
}

/// 阴影
// ignore: non_constant_identifier_names
BoxDecoration HsgShadow(Color bgColor) {
  return BoxDecoration(
    border: new Border.all(
      style: BorderStyle.none, //没有边框
    ),
    color: bgColor, // 底色
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 10, //阴影范围
        spreadRadius: 0.18, //阴影浓度
        color: Color(0x0F46529F), //阴影颜色
      ),
    ],
    borderRadius: BorderRadius.circular(5.0), // 圆角也可控件一边圆角大小
  );
}
