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

Widget TransferPayeeWidget(
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
  //  print('$nameChange 8888888');

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

                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                ),
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
  // _controller.addListener(() {，
  //   nameChanges(_controller.text); //输入框内容改变时调用
  // });
  // _controller.text = forSelect; //选择银行回跳那里写
  // print('$forSelect 77777777777');
  // print('$forInput  p222222');
  // forSelect = forSelect == '' ? forInput : forSelect;
  // print('$forSelect >>>>>>>>>>>>');
  // if (forSelect != forInput) {
  //   forSelect = forInput;
  // }
  //forInput = forSelect == '' ? forInput : forSelect;
  //forSelect = forInput;
  // if (forSelect == '') {
  //   forSelect = forInput;
  // }
  // if (forSelect != '' || forSelect == forInput) {
  //   forSelect = forSelect;
  // }
  // if (payeeNames == forSelect) {
  //   payeeNames = forSelect;
  //   nameChanges(forSelect);
  // }
  // else {
  //   nameChanges(payeeNames);
  // }
  return Expanded(
    child: Container(
      child: TextField(
        // 是否自动更正
        autocorrect: false,
        //是否自动获得焦点
        autofocus: true,
        controller: _controller,
        //使得光标永远在文字末尾
        // controller: TextEditingController.fromValue(
        //   TextEditingValue(
        //     text: forSelect,
        //     selection: TextSelection.fromPosition(
        //       TextPosition(
        //           affinity: TextAffinity.downstream, offset: forSelect.length),
        //     ),
        //   ),
        // ),

        textAlign: TextAlign.right,
        // onChanged: (payeeName) {
        //   // nameChanges(payeeName);
        //   // if (payeeName == forSelect) {
        //   //   nameChanges(forSelect);
        //   // } else {
        //   //   nameChanges(payeeName);
        //   // }
        //   print("这个是 onChanged 时刻在监听，输出的信息是：$payeeName");

        //   print('$forSelect 555555');
        // },
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
