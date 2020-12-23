/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 交易密码弹窗
/// Author: CaiTM
/// Date: 2020-12-23

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class HsgPasswordDialog extends StatelessWidget {
  final String title;
  final List<String> keyboardNum = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  final List<String> passwordList = [];
  HsgPasswordDialog({Key key, this.title});
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
              child: Text(title),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.clear,
              size: 18,
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
            padding: EdgeInsets.only(top: 10),
            child: _passwordBox(),
          ),
          Container(
            color: Color(0xFFD1D1D1),
            child: _passwordKeyboard(context),
          ),
        ],
      ),
    );
  }

  //密码框
  Row _passwordBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 0 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 1 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 2 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 3 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 4 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFD1D1D1), width: 0.8),
          ),
          child: Text(
            passwordList.length > 5 ? '*' : '',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
      ],
    );
  }

  Column _passwordKeyboard(BuildContext context) {
    return Column(
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 2, bottom: 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            childAspectRatio: 2.5,
          ),
          children: _sliversSection(context),
        ),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
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

  FlatButton _keyboardButtonZero(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      child: Text(
        '0',
        style: TextStyle(
          fontSize: 25,
          color: Color(0xFF666666),
        ),
      ),
      onPressed: () {
        if (passwordList.length < 6) {
          passwordList.add('0');
          (context as Element).markNeedsBuild();
        }
        if (passwordList.length == 6) {
          Navigator.pop(context, passwordList);
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
      ),
    );
  }

  List<Widget> _sliversSection(BuildContext context) {
    List<Widget> section = [];
    for (var item in keyboardNum) {
      section.add(
        FlatButton(
          color: Colors.white,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF666666),
            ),
          ),
          onPressed: () {
            if (passwordList.length < 6) {
              passwordList.add(item);
              (context as Element).markNeedsBuild();
            }
            if (passwordList.length == 6) {
              Navigator.pop(context, passwordList);
            }
          },
        ),
      );
    }
    return section;
  }
}
