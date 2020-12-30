/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///预约转账页面
/// Author: wangluyao
/// Date: 2020-12-28

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OpenTransferPage extends StatefulWidget {
  OpenTransferPage({Key key}) : super(key: key);

  @override
  _OpenTransferPageState createState() => _OpenTransferPageState();
}

class _OpenTransferPageState extends State<OpenTransferPage> {
  String groupValue = "0";

  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }

  Widget _listItem(BuildContext context, value) {
    var deviceSize = MediaQuery.of(context).size;
    print(value['type']);
    return groupValue == value['type']
        ? RaisedButton(
            color: Color(0xFFDCF0FF),
            onPressed: () {
              print('切换${value}');
              updateGroupValue(value['type']);
            },
            child: Text(
              value['title'],
              style: TextStyle(color: HsgColors.accent),
            ),
          )
        : OutlineButton(
            onPressed: () {
              print('切换${value}');
              updateGroupValue(value['type']);
            },
            child: Text(value['title']),
          );
  }

  Widget _transferInfo() {
    String groupValue = "1";
    List frequency = [
      {
        "title": "仅一次",
        "type": "0",
      },
      {
        "title": "每日",
        "type": "1",
      },
      {
        "title": "每月",
        "type": "2",
      },
      {
        "title": "每年",
        "type": "3",
      }
    ];
    return Column(
      children: [
        Container(
          color: HsgColors.backgroundColor,
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Container(
                child: Text(
                  '计划名称',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ),
              Expanded(
                  child: Container(
                // color: Colors.red,
                // margin: EdgeInsets.only(left: 20),
                child: TextField(
                  textAlign: TextAlign.right,
                  autocorrect: false,
                  autofocus: false,
                  style: TextStyle(
                      color: HsgColors.firstDegreeText, fontSize: 14.0),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  // ],
                  onChanged: (value) {
                    // double.parse(
                    //     value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1'));
                    print("输入的计划名称是:$value");
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: '请输入计划名称',
                    hintStyle: TextStyle(
                      color: HsgColors.hintText,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )),

              // Container(
              // child:
              // Row(
              //   children: [
              //     Container(
              //       child: Text(
              //         '预约频率',
              //         style: TextStyle(color: Colors.black, fontSize: 14.0),
              //       ),
              //     ),
              // Container(
              //     child: GridView.count(
              //         crossAxisCount: 4,
              //         crossAxisSpacing: 10.0,
              //         mainAxisSpacing: 10.0,
              //         childAspectRatio: 3 / 1,
              //         shrinkWrap: true,
              //         children:
              //             // frequency.asMap().keys.map((value) {
              //             //   return _listItem(context, value);
              //             // }).toList(),
              //             [
              //       RaisedButton(
              //         color: Color(0xFFDCF0FF),
              //         onPressed: () {
              //           // print('切换${value}');
              //           // updateGroupValue(value['type']);
              //           Text(
              //             '仅一次',
              //             style: TextStyle(color: HsgColors.accent),
              //           );
              //         },
              //         child: Text(
              //           // value['title'],
              //           '仅一次',
              //           style: TextStyle(color: Colors.black),
              //         ),
              //       ),
              //       RaisedButton(
              //         color: Color(0xFFDCF0FF),
              //         onPressed: () {
              //           // print('切换${value}');
              //           // updateGroupValue(value['type']);
              //           Text(
              //             '仅一次',
              //             style: TextStyle(color: HsgColors.accent),
              //           );
              //         },
              //         child: Text(
              //           // value['title'],
              //           '仅一次',
              //           style: TextStyle(color: Colors.black),
              //         ),
              //       ),
              //       RaisedButton(
              //         color: Color(0xFFDCF0FF),
              //         onPressed: () {
              //           // print('切换${value}');
              //           // updateGroupValue(value['type']);
              //           Text(
              //             '仅一次',
              //             style: TextStyle(color: HsgColors.accent),
              //           );
              //         },
              //         child: Text(
              //           // value['title'],
              //           '仅一次',
              //           style: TextStyle(color: Colors.black),
              //         ),
              //       ),
              //     ]))
              // ],
              // ),
              // ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                child: Text('预约频率'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _payee() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('预约转账'),
          actions: <Widget>[
            Container(
              child: Text.rich(TextSpan(
                  text: '转账计划',
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 3.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint("转账计划");
                    })),
            )
          ],
        ),
        body: (Container(
          child: _transferInfo(),
        )));
  }
}
