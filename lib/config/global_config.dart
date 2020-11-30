import 'package:flutter/material.dart';

/// 主题色
final kColorTheme = Color.fromRGBO(72, 113, 255, 1);

/// 分割线颜色
final kColorLine = Color.fromRGBO(221, 221, 221, 0.67);

/// 占位字符颜色
final kColorPlaceholder = Color.fromRGBO(160, 160, 160, 0.6);

/// 色号38
final kColor38 = Color.fromRGBO(38, 38, 38, 1);

/// 色号122
final kColor122 = Color.fromRGBO(122, 122, 122, 1);

/// 色号156
final kColor156 = Color.fromRGBO(156, 156, 156, 1);

/// 色号204
final kColor204 = Color.fromRGBO(204, 204, 204, 1);

/// 色号221
final kColor221 = Color.fromRGBO(221, 221, 221, 1);

/// 色号247
final kColor247 = Color.fromRGBO(247, 247, 247, 1);

/// 导航栏颜色
final kNavBgColor = Color.fromRGBO(47, 50, 62, 1);

/// 导航栏阴影线颜色
final kNavShadowColor = Color.fromRGBO(47, 50, 62, 1);

/// 导航栏字体颜色
final kNavBgFontColor = Color.fromRGBO(255, 255, 255, 1);

/// 导航栏系统自带按钮颜色
final kNavSystemBtnColor = Color.fromRGBO(72, 113, 255, 1);

/// 导航栏字体字号
final kNavTextFont = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

/// 阴影
// ignore: non_constant_identifier_names
BoxDecoration HsgShadow(Color bgColor) {
  bgColor = bgColor == null ? Colors.white : bgColor;

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
