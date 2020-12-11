import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-03

import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoanDemoPage extends StatefulWidget {
  @override
  _LoanDemoPageState createState() => _LoanDemoPageState();
}

class _LoanDemoPageState extends State<LoanDemoPage> {
  // var loanTest = Loans('测试贷', '81812', '10,0000.00', '8,0000.00', '15.12%',
  //     '24', '10', '2018-12-26', '2018-12-26', '按月结息', '18日', '6225*******1235');

  // @override
  // // ignore: must_call_super
  // void initState() {
  //   super.initState();

  //   // 网络请求
  //   _loadData();
  // }

  // Future<void> _loadData() async {
  //   LoanDataRepository().loan('loan').then((data) {
  //     Fluttertoast.showToast(msg: "网络请求成功");
  //     setState(() {
  //       //  _loanProductNameWithValue = data.loanProductNameWithValue;
  //     });
  //   }).catchError((e) {
  //     // HSProgressHUD.showError(status: e.toString());
  //     Fluttertoast.showToast(msg: "网络请求失败");
  //     print('${e.toString()}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    var temp = '';
    switch (loanDetail.isMaturity) {
      case '0':
        temp = '未到期';
        break;
      case '1':
        temp = '已到期';
        break;
      case '2':
        temp = '已逾期';
        break;
    }
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
                              // 业务品种
                              Text(
                                S.current.loan_product_name_with_value +
                                    '：' +
                                    loanDetail.acNo,
                              ),
                              //贷款编号
                              Text(
                                S.current.loanId + '：' + loanDetail.br,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              //是否到期
                              temp,
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
                              //贷款金额
                              Text(
                                S.current.loan_amount,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                '￥' + loanDetail.loanAmt,
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
                              //贷款余额
                              Text(
                                S.current.loan_balance2,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                '￥' + loanDetail.unpaidPrincipal,
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
                            //还款记录
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
                            //还款计划
                            Text(
                              S.current.wait_repayment_plan,
                            ),
                            InkWell(
                              onTap: () {
                                //此处跳转到还款计划详情
                                // Navigator.pushNamed(context, pageloanDemo,
                                //     arguments: loanDetail);
                                Fluttertoast.showToast(msg: "假装跳转了!");
                              },
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
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
                            Text((double.parse(loanDetail.intRate) * 100)
                                    .toStringAsFixed(2) +
                                '%'),
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
                            Text(loanDetail.termValue.toString()),
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
                            Text(loanDetail.restPeriods.toString()),
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
                            Text(loanDetail.disbDate),
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
                              Text(loanDetail.maturityDate),
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
                            Text(loanDetail.repaymentMethod),
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
                            Text(loanDetail.repaymentDay.toString() + '日'),
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
                            Text(loanDetail.repaymentAcNo),
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
