import 'package:dio/dio.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易密码弹窗
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/http/retrofit/app_exceptions.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hsg_text_field_dialog.dart';

// ignore: must_be_immutable
class HsgPasswordDialog extends StatefulWidget {
  final String title;

  String resultPage = '';
  Object arguments = '';
  Function(String password) returnPasswordFunc;

  HsgPasswordDialog({
    Key key,
    this.title,
    this.resultPage,
    this.arguments,
    this.returnPasswordFunc,
  });

  @override
  _HsgPasswordDialogState createState() => _HsgPasswordDialogState();
}

class _HsgPasswordDialogState extends State<HsgPasswordDialog> {
  List<String> keyboardNum = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  List<String> passwordList = [];

  String password = '';

  @override
  Widget build(BuildContext context) {
    Widget passwordBoxTitle;

    if (widget.title != null) {
      passwordBoxTitle = Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
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

  List<Widget> _passwordBox() {
    List<Widget> passwordbox = [];
    for (var i = 0; i < 6; i++) {
      passwordbox.add(
        Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > i ? '●' : '',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: HsgColors.firstDegreeText,
            ),
          ),
        ),
      );
    }
    return passwordbox;
  }

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
              password = EncryptUtil.aesEncode(passwordList.join());
              // password = passwordList.join();
              _verifyTradePaw(
                  password, context, widget.resultPage, widget.arguments);
            }
          },
        ),
      );
    }
    return keyboardBut;
  }

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
          password = EncryptUtil.aesEncode(passwordList.join());
          // password = passwordList.join();
          _verifyTradePaw(
              password, context, widget.resultPage, widget.arguments);
        }
      },
    );
  }

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

  _verifyTradePaw(String payPassword, BuildContext context, String resultPage,
      Object arguments) async {
    HSProgressHUD.show();
    ApiClientPassword()
        .verifyTransPwdNoSms(VerifyTransPwdNoSmsReq(payPassword))
        .then((data) {
      HSProgressHUD.dismiss();
      if (widget.returnPasswordFunc != null) {
        widget.returnPasswordFunc(password);
      }
      if (resultPage == '') {
        Navigator.pushNamed(context, resultPage, arguments: arguments);
      }
      Navigator.pop(context, true);
    }).catchError((e) {
      passwordList.clear();
      (context as Element).markNeedsBuild();
      // if (e.toString() == 'ECUST031') {
      //   HSProgressHUD.showToastTip('交易密码错误！请重试',);
      // } else {
      //   HSProgressHUD.showToastTip('未设置交易密码！',);
      // }
      HSProgressHUD.showToast(e);
      // (context as Element).markNeedsBuild();
    });
  }
}
