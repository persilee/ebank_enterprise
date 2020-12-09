/*
 * Created Date: Friday, December 4th 2020, 10:08:07 am
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

import '../page_route.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  var engName = '';
  var lclName = '';
  var totalName = '存款总额';
  var bal = '';
  var conRate = '';
  var valDate = '';
  var mtDate = '';
  var ccy = '';

  var totalAssets = '';
  var depositTaking = '1.000.00';
  var interstRate = '2.8%';
  var effectiveDate = '2020-11-09';
  var dueDate = '';

  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });

    //网络请求
    _loadDeopstData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            //S.current.deposit_record
            engName),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
          color: HsgColors.backgroundColor,
          child: ListView(
            children: [
              //存单金额
              Container(
                  height: 140,
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.fromLTRB(0, 19, 0, 28),
                  color: HsgColors.primary,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              '3,000.00',
                              style:
                                  TextStyle(fontSize: 35, color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Text(
                              S.current.total_deposit,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white54),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])),

              //整存整取
              Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, pageDetailInfo);
                      },
                      padding: EdgeInsets.only(bottom: 12),
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    S.current.deposit_taking,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0, color: HsgColors.textHintColor),
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
                                        S.current.deposit_amount,
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
                                        S.current.due_date,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                      Text(
                                        '2.8%',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.current.effective_date,
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
                                        S.current.due_date,
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
                      ))),

              //整存整取
              Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, pageDetailInfo);
                      },
                      padding: EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 37,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    S.current.deposit_taking,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0, color: HsgColors.textHintColor),
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
                                        S.current.deposit_amount,
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
                                        S.current.interest_rate,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                      Text(
                                        '2.9%',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.current.effective_date,
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
                                        S.current.due_date,
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
                      ))),

              //整存整取
              Container(
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, pageDetailInfo);
                      },
                      padding: EdgeInsets.only(bottom: 12),
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Text(
                                    // S.current.deposit_taking
                                    lclName,

                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0, color: HsgColors.textHintColor),
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
                                        S.current.deposit_amount,
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
                                        S.current.interest_rate,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                      Text(
                                        //'2.9%',
                                        conRate,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        S.current.effective_date,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                      Text(
                                        // '2020-11-03',
                                        effectiveDate,
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
                                        S.current.due_date,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                      Text(
                                        //totalAssets,
                                        //'2020-12-17',
                                        effectiveDate,

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
                      ))),
            ],
          )),
    );
  }

  Future<void> _loadDeopstData() async {
    bool excludeClosed = true;
    String page = '1';
    String pageSize = '200';
    DepositDataRepository()
        .getDepositRecordRows(
            DepositRecordReq(excludeClosed, page, pageSize), 'getDepositRecord')
        .then((data) {
      setState(() {
        ccy = data.rows[0].ccy;
        engName = data.rows[0].engName;
        lclName = data.rows[0].lclName;
        totalName = '存款总额';
        bal = data.rows[0].bal;
        conRate = data.rows[0].conRate;
        valDate = data.rows[0].valDate;
        mtDate = data.rows[0].mtDate;
      });
    });
  }
}
