import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

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
        title: Text(S.current.deposit_record),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.current.deposit_amount,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    'HKD 1,000.00',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-11-03',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-12-17',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),

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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.current.deposit_amount,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    'HKD 1,000.00',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-11-03',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-12-17',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.current.deposit_amount,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    'HKD 1,000.00',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-11-03',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
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
                                        fontSize: 15, color: Color(0xFF8D8D8D)),
                                  ),
                                  Text(
                                    '2020-12-17',
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF262626)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          )),
    );
  }
}
