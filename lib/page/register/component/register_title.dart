import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 注册页面标题
/// Author: pengyikang

Widget getRegisterTitle(String title) {
  return Container(
    color: Colors.white,
    margin: EdgeInsets.fromLTRB(26.5, 0, 0, 34),
    child: Text(
      title,
      style: TextStyle(fontSize: 24),
    ),
  );
}
