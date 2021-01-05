/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///任务审批页面
/// Author: wangluyao
/// Date: 2020-12-29

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskApprovalPage extends StatefulWidget {
  TaskApprovalPage({Key key}) : super(key: key);

  @override
  _TaskApprovalPageState createState() => _TaskApprovalPageState();
}

class _TaskApprovalPageState extends State<TaskApprovalPage> {
  FocusNode focusNode = FocusNode();
  bool offstage = true;

  void _toggle() {
    setState(() {
      offstage = !offstage;
    });
  }

  _getToggleChild() {
    if (!offstage) {
      return Container(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular((5)),
              ),
              height: 40,
              child: FlatButton(
                child: Text(
                  '驳回至发起人',
                  style: TextStyle(fontSize: 13),
                ),
                onPressed: () {
                  print('驳回至发起人');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15),
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular((5)),
              ),
              height: 40,
              child: FlatButton(
                child: Text(
                  '驳回',
                  style: TextStyle(fontSize: 13),
                ),
                onPressed: () {
                  print('驳回');
                },
              ),
            ),
            Container(
              // color: HsgColors.accent,
              width: 60,

              decoration: BoxDecoration(
                color: HsgColors.accent,
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular((5)),
              ),
              height: 40,
              child: FlatButton(
                child: Text(
                  '审批',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  print('审批');
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: HsgColors.accent,
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular((5)),
            ),
            height: 40,
            width: 60,
            child: FlatButton(
              child: Text(
                '签收',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(focusNode);
              },
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      bool hasFocus = focusNode.hasFocus;
      bool hasListeners = focusNode.hasListeners;
      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(focusNode);
    // });
  }

  Map transferInfo = {
    "转账信息": [
      {"title": "收款账号", "type": "500000617001"},
      {"title": "账号名称", "type": "Mike"},
      {"title": "转入货币", "type": "EUR"},
    ]
  };
  Map paymentInfo = {
    "付款信息": [
      {"title": "付款账号", "type": "500000740001"},
      {"title": "账户名称", "type": "Leo"},
      {"title": "付款银行", "type": "HISUN-高阳银行"},
      {"title": "转出货币", "type": "EUR"},
      {"title": "转出金额", "type": "1000"},
      {"title": "附言", "type": "转账"},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('任务审批'),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                width: 400,
                color: Color(0xFFDCE4FF),
                child: Text(
                  '请确认以下信息，然后完成审批',
                  style: TextStyle(
                    color: HsgColors.accent,
                    fontSize: 13,
                  ),
                ),
              ),
              Column(
                children: _transferlistView(),
              ),
              Column(
                children: _paymentlistView(),
              ),
              _myApproval(context),
            ],
          ),
        )));
  }

  List<Widget> _transferlistView() {
    List<Widget> listWidget = [];
    transferInfo.forEach((k, v) {
      listWidget.add(Container(
        color: HsgColors.backgroundColor,
        height: 15,
      ));
      listWidget.add(Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Text(
              k,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ));
      listWidget.add(Container(
        child: Divider(height: 0.5, color: HsgColors.divider),
      ));
      v.map((f) {
        listWidget.add(Column(children: [
          Container(
            // color: Colors.green,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  // color: Colors.yellow,
                  width: 212,
                  child: Text(
                    f["title"],
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 150,
                  // color: Colors.red,
                  child: Text(f["type"],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: HsgColors.mainTabTextNormal, fontSize: 14)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
        ]));
      }).toList();
    });
    return listWidget;
  }

  List<Widget> _paymentlistView() {
    List<Widget> listWidget = [];
    paymentInfo.forEach((k, v) {
      listWidget.add(Container(
        color: HsgColors.backgroundColor,
        height: 15,
      ));
      listWidget.add(Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Text(
              k,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ));
      listWidget.add(Container(
        child: Divider(height: 0.5, color: HsgColors.divider),
      ));
      v.map((f) {
        listWidget.add(Column(children: [
          Container(
            // color: Colors.green,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  // color: Colors.yellow,
                  width: 212,
                  child: Text(
                    f["title"],
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 150,
                  // color: Colors.red,
                  child: Text(f["type"],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: HsgColors.mainTabTextNormal, fontSize: 14)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
        ]));
      }).toList();
    });
    return listWidget;
  }

  Widget _myApproval(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: HsgColors.backgroundColor,
            height: 15,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                child: Text(
                  '我的审批',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            // padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Text(
                  '审批意见',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            // color: Colors.grey,
            child: TextField(
              focusNode: focusNode,
              maxLines: 4,
              enabled: !offstage,
              decoration: InputDecoration(
                fillColor: HsgColors.itemClickColor,
                filled: offstage,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide:
                      BorderSide(color: HsgColors.textHintColor, width: 1),
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   // borderSide: BorderSide(color: Colors.green, width: 2),
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide:
                      BorderSide(color: HsgColors.textHintColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: HsgColors.textHintColor, width: 1),
                ),
              ),
            ),
          ),
          Container(
            width: 400,
            margin: EdgeInsets.only(top: 20, bottom: 15),
            // color: Colors.yellow,
            child: FlatButton(
              child: _getToggleChild(),
              // Text(
              //   '签收',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 13,
              //   ),
              // ),
              onPressed: () {
                _toggle();
                FocusScope.of(context).requestFocus(focusNode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
