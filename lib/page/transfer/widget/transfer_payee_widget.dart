/*
 * 
 * Created Date: Thursday, December 10th 2020, 5:34:04 pm
 * Author: pengyikang
 * 获取用户姓名及账号方法
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget transferPayeeWidget(
  String accountName,
  String payeeName, //从输入框拿回来的回参
  String accountForSelect,
  String payeeNameForSelect,
  Function() _getImage,
  BuildContext context,
  String oneRowText,
  String towRowleft,
  String threeRowLeft,
  String twoRowRight,
  String threeRowRight,
  Function(String inputStr) nameChange,
  Function(String inputStr) accountChange, [
  TextEditingController _nameController,
  TextEditingController _accountController,
]) {
  print('$payeeNameForSelect oooooooooooooooooooooo');
  print('$payeeName   pppppppp');

  return SliverToBoxAdapter(
    child: Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(0, 20, 15, 0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    oneRowText,
                    style:
                        TextStyle(color: HsgColors.describeText, fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          Container(
            child: Row(
              children: [
                _fiveRowLeft(towRowleft),
                _fiveRowRight(nameChange, twoRowRight, payeeNameForSelect,
                    payeeName, _nameController),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                ),
                _getImage(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
          //账号
          Container(
            child: Row(
              children: [
                //获取账户
                _fiveRowLeft(threeRowLeft),
                _fiveRowRight(accountChange, threeRowRight, accountForSelect,
                    accountName, _accountController),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _fiveRowLeft(String name) {
  return Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Text(
      name,
      style: TextStyle(
        color: HsgColors.firstDegreeText,
        fontSize: 14,
      ),
    ),
  );
}

Widget _fiveRowRight(Function nameChanges, String hintText, String forSelect,
    String forInput, TextEditingController _controller) {
  return Expanded(
    child: Container(
      child: TextField(
        // 是否自动更正
        autocorrect: false,
        //是否自动获得焦点
        autofocus: false,
        controller: _controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: HsgColors.textHintColor,
          ),
        ),
      ),
    ),
  );
}
