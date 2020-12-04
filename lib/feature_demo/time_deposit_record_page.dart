import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我的存单'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: HsgColors.backgroundColor,
          child: ListView(
            children: [
              Container(
                  height: 162,
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.fromLTRB(0, 19, 0, 28),
                  color: HsgColors.primary,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '3,000.00',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                            Center(
                              child: Text(
                                '存款总额(HDK)',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white54),
                              ),
                            )
                          ],
                        ),
                      ),
                      //整存整取
                      Container(
                          margin: EdgeInsets.only(bottom: 12),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 37,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        '整存整取(HDK)',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 0, color: HsgColors.textHintColor),
                              SizedBox(
                                height: 125,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '存入金额',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF8D8D8D)),
                                          ),
                                          Text(
                                            'HKD 1,000.00',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF262626)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '利率',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF8D8D8D)),
                                          ),
                                          Text(
                                            '2.9%',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF262626)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '生效日期',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF8D8D8D)),
                                          ),
                                          Text(
                                            '2020-11-03',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF262626)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '到期日期',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF8D8D8D)),
                                          ),
                                          Text(
                                            '2020-12-17',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF262626)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))
                    ],
                  ))
            ],
          ),
        ));
  }
}
