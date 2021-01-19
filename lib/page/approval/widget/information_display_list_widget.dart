/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///展示信息列表
/// Author: wangluyao
/// Date: 2021-01-19

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

informationDisplayList(BuildContext context, Map information) {
  //列表标题
  Widget _title(String title) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  //分割线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Divider(height: 0.5, color: HsgColors.divider),
    );
  }

  List<Widget> listWidget = [];

  information.forEach((title, value) {
    listWidget.add(
      Container(
        color: HsgColors.backgroundColor,
        height: 15,
      ),
    );
    listWidget.add(
      _title(title),
    );
    listWidget.add(
      Container(
        child: Divider(height: 0.5, color: HsgColors.divider),
      ),
    );
    value.map((f) {
      listWidget.add(
        Column(
          children: [
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: Text(
                      f["title"],
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: Text(
                      f["type"],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: HsgColors.mainTabTextNormal, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            _line(),
          ],
        ),
      );
    }).toList();
  });
  return listWidget;
}
