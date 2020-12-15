/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: wangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class TimeDepositContract extends StatefulWidget {
  TimeDepositContract({Key key}) : super(key: key);

  @override
  _TimeDepositContractState createState() => _TimeDepositContractState();
}

class _TimeDepositContractState extends State<TimeDepositContract> {
  @override
  Widget build(BuildContext context) {
    Widget background() {
      return Container(
        color: HsgColors.backgroundColor,
        height: 15,
      );
    }

    Widget remark() {
      return Container(
          color: HsgColors.backgroundColor,
          height: 40,
          child: Container(
            padding: EdgeInsets.only(top: 10.0, left: 30.0),
            height: 10,
            child: Text('不可提前支取。'),
          ));
    }

    Widget titleSection() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.red,
            margin: EdgeInsets.only(top: 20, bottom: 20.0),
            padding: EdgeInsets.only(left: 40.0),
            height: 60,
            child: Column(children: [
              Text(
                '产品名称',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
              ),
              SizedBox(height: 10.0),
              Text(
                '整存整取（HKD）',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          // VerticalDivider(
          //   width: 40.0,
          //   color: Colors.black,
          //   indent: 30.0,
          //   endIndent: 540.0,
          // ),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20.0),
            padding: EdgeInsets.only(left: 25.0),
            height: 60,
            child: Column(
              children: [
                SizedBox(
                  width: 1,
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: HsgColors.divider),
                  ),
                ),
              ],
            ),
          ),

          // Divider(
          //   height: 10.0,
          // ),
          Container(
            //color: Colors.blue,
            margin: EdgeInsets.only(top: 20, bottom: 20.0),
            padding: EdgeInsets.only(left: 55.0),
            height: 60,
            child: Column(children: [
              Text(
                '年利率',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
              ),
              SizedBox(height: 10.0),
              Text(
                '2.5%',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('定期开立'),
        ),
        body: (ListView(
          children: [
            background(),
            titleSection(),
            remark(),
          ],
        )));
  }
}
