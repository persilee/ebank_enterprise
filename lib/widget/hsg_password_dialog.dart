/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易密码弹窗
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'hsg_text_field_dialog.dart';

// ignore: must_be_immutable
class HsgPasswordDialog extends StatelessWidget {
  final String title;
  List<String> keyboardNum = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List<String> passwordList = [];
  String password = '';
  String resultPage = '';
  Object arguments = '';

  TextEditingController _editingController = TextEditingController();
  String inputText = '';

  HsgPasswordDialog({Key key, this.title, this.resultPage, this.arguments});

  @override
  Widget build(BuildContext context) {
    Widget passwordBoxTitle;

    if (title != null) {
      passwordBoxTitle = Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.clear,
              size: 18,
              color: HsgColors.firstDegreeText,
            ),
          )
        ],
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, right: 7),
                child: passwordBoxTitle,
              ),
              Divider(
                height: 0.5,
                color: HsgColors.divider,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 50, right: 50),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1,
              ),
              children: _passwordBox(),
            ),
          ),
          Container(
            color: Color(0xFFD1D1D1),
            child: _passwordKeyboard(context),
          ),
        ],
      ),
    );
  }

  Column _passwordKeyboard(BuildContext context) {
    return Column(
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 1),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 2.5,
          ),
          children: _keyboardButtonNum(context),
        ),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 1),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1.0,
            childAspectRatio: 2.5,
          ),
          children: [
            Container(),
            Container(
              child: _keyboardButtonZero(context),
            ),
            Container(
              child: _keyboardButtonDel(context),
            ),
          ],
        )
      ],
    );
  }

  //密码框
  List<Widget> _passwordBox() {
    List<Widget> passwordbox = [];
    for (var i = 0; i < 6; i++) {
      passwordbox.add(
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > i ? '*' : '',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: HsgColors.firstDegreeText,
            ),
          ),
        ),
      );
    }
    return passwordbox;
  }

  //键盘按钮1-9
  List<Widget> _keyboardButtonNum(BuildContext context) {
    List<Widget> keyboardBut = [];
    for (var item in keyboardNum) {
      keyboardBut.add(
        FlatButton(
          color: Colors.white,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 25,
              color: HsgColors.firstDegreeText,
            ),
          ),
          onPressed: () {
            if (passwordList.length < 6) {
              passwordList.add(item);
              (context as Element).markNeedsBuild();
            }
            if (passwordList.length == 6) {
              // password = EncryptUtil.aesEncode(passwordList.join());
              password = passwordList.join();
              _verifyTradePaw(password, context, resultPage, arguments);
            }
          },
        ),
      );
    }
    return keyboardBut;
  }

  //键盘按钮0
  FlatButton _keyboardButtonZero(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      child: Text(
        '0',
        style: TextStyle(
          fontSize: 25,
          color: HsgColors.firstDegreeText,
        ),
      ),
      onPressed: () {
        if (passwordList.length < 6) {
          passwordList.add('0');
          (context as Element).markNeedsBuild();
        }
        if (passwordList.length == 6) {
          // password = EncryptUtil.aesEncode(passwordList.join());
          password = passwordList.join();
          _verifyTradePaw(password, context, resultPage, arguments);
        }
      },
    );
  }

  //键盘按钮删除
  FlatButton _keyboardButtonDel(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (passwordList.length > 0) {
          passwordList.removeLast();
          (context as Element).markNeedsBuild();
        }
      },
      child: Icon(
        Icons.backspace_outlined,
        color: HsgColors.firstDegreeText,
      ),
    );
  }

  //验证交易密码
  _verifyTradePaw(String payPassword, BuildContext context, String resultPage,
      Object arguments) async {
    VerifyTradePawRepository()
        .verifyTransPwdNoSms(
            VerifyTransPwdNoSmsReq(payPassword), 'VerifyTransPwdNoSmsReq')
        .then((data) {
      Navigator.pop(context, true);
      //Navigator.of(context)..pop()..pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return HsgTextFieldDialog(
              editingController: _editingController,
              onChanged: (value) {
                inputText = value;
                print(inputText);
              },
              confirmCallback: (){},
              sendCallback: (){},
            );
          });

      //Navigator.pushNamed(context, resultPage);
      if (resultPage == '') {
        Navigator.of(context)..pop()..pop();
      } else {
        Navigator.pushNamed(context, resultPage, arguments: arguments);
      }
    }).catchError((e) {
      if (e.toString() == 'ECUST031') {
        Fluttertoast.showToast(msg: '交易密码错误！请重试');
      } else {
        Fluttertoast.showToast(msg: '未设置交易密码！');
      }
      Fluttertoast.showToast(msg: e.toString());
      passwordList.clear();
      (context as Element).markNeedsBuild();
    });
  }
}
