/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 添加按钮方法
/// Author: 彭逸康
/// Date: 2020-12-10
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

getButton(String buttonText,Function _isClick,){
    return  SliverToBoxAdapter(
            child: Container(
              height: 80,
              padding: EdgeInsets.fromLTRB(29.6, 30, 29.6, 0),
              margin: EdgeInsets.only(top: 20,bottom: 40),
              child: RaisedButton(
                child: Text(buttonText),
                textColor: Colors.white,
                color: Colors.blue[500],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: _isClick(),
                disabledColor: HsgColors.btnDisabled,
              ),
            ),
          );
  }

