/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-03

import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoanDemoPage extends StatefulWidget {
  @override
  _LoanDemoPageState createState() => _LoanDemoPageState();
}

class _LoanDemoPageState extends State<LoanDemoPage> {
  var loanTest = Loans('测试贷', '81812', '10,0000.00', '8,0000.00', '15.12%',
      '24', '10', '2018-12-26', '2018-12-26', '按月结息', '18日', '6225*******1235');
  //var _loanProductNameWithValue = '';

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();

    // 网络请求
    _loadData();
  }

  Future<void> _loadData() async {
    LoanDataRepository().loan('loan').then((data) {
      Fluttertoast.showToast(msg: "网络请求成功");
      setState(() {
        //  _loanProductNameWithValue = data.loanProductNameWithValue;
      });
    }).catchError((e) {
      // HSProgressHUD.showError(status: e.toString());
      Fluttertoast.showToast(msg: "网络请求失败");
      print('${e.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loan_detail),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: ListView(
          children: [
            // 业务品种
            Container(
              margin: EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.loan_product_name_with_value +
                                    '：' +
                                    loanTest.loanProductNameWithValue,
                              ),
                              Text(
                                S.current.loanId + '：' + loanTest.loanId,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "正常",
                              style: TextStyle(
                                color: HsgColors.loginAgreementText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.loan_amount,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                loanTest.loanAmount,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: SizedBox(
                            width: 1,
                            height: 30,
                            child: DecoratedBox(
                              decoration:
                                  BoxDecoration(color: HsgColors.textHintColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.current.loan_balance2,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                loanTest.loanBalance2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 还款记录和计划
            Container(
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.repayment_record,
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.wait_repayment_plan,
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            // 贷款利率及时间
            Container(
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.loan_interest_rate_with_symbol),
                            Text(loanTest.loanInterestRateWithSymbol),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.total_periods,
                            ),
                            Text(loanTest.totalPeriods),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.remaining_periods,
                            ),
                            Text(loanTest.remainingPeriods),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.begin_date,
                            ),
                            Text(loanTest.beginDate),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.current.end_date,
                              ),
                              Text(loanTest.endDate),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //还款方式及扣款
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.repayment_ways,
                            ),
                            Text(loanTest.repaymentWays),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.deduct_money_date),
                            Text(loanTest.deductMoneyDate),
                          ],
                        ),
                      ],
                    ),
                  )),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.deduct_money_account,
                            ),
                            Text(loanTest.deductMoneyAccount),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Type arb() => S;
}
