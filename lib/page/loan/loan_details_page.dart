/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款详情界面
/// Author: fangluyao
/// Date: 2020-12-03
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoanDetailsPage extends StatefulWidget {
  @override
  _LoanDetailsPageState createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    //判断业务状态
    var isMaturity = '';
    switch (loanDetail.isMaturity) {
      case '0':
        isMaturity = S.current.installment_status1;
        break;
      case '1':
        isMaturity = S.current.installment_status2;
        break;
      case '2':
        isMaturity = S.current.installment_status3;
        break;
      case '3':
        isMaturity = S.current.installment_status4;
        break;
      case '4':
        isMaturity = S.current.unknown;
        break;
    }
    //判断还款方式
    var repaymentMethod = '';
    switch (loanDetail.repaymentMethod) {
      case 'EPI':
        repaymentMethod = S.current.repayment_ways1;
        break;
      case 'FPI':
        repaymentMethod = S.current.repayment_ways2;
        break;
      case 'IOI':
        repaymentMethod = S.current.repayment_ways3;
        break;
      case 'IPI':
        repaymentMethod = S.current.repayment_ways4;
        break;
    }
    //业务品种、贷款金额、余额
    var container1 = Container(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        children: [
          _getSingleBox(
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
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  //是否到期
                  isMaturity,
                  style: TextStyle(
                    color: HsgColors.loginAgreementText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //贷款金额
                      Text(
                        S.current.loan_amount,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        '￥' + FormatUtil.formatSringToMoney(loanDetail.loanAmt),
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
                      decoration: BoxDecoration(color: HsgColors.textHintColor),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Text(
                        '￥' +
                            FormatUtil.formatSringToMoney(
                                loanDetail.unpaidPrincipal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //还款记录、待还计划
    var container2 = Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getSingleBox(
            Text(
              S.current.repayment_record,
            ),
            InkWell(
              onTap: () {
                //此处跳转到还款记录详情
                // Navigator.pushNamed(context, pageloanDemo,arguments: loanDetail);
                Fluttertoast.showToast(msg: "假装跳转到还款记录详情了!");
              },
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.wait_repayment_plan,
            ),
            InkWell(
              onTap: () {
                //此处跳转到还款计划详情
                Navigator.pushNamed(context, pageRepayPlan, arguments: loanDetail);
              },
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ),
        ],
      ),
    );
    //贷款利率、期数、起始到期日
    var container3 = Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getSingleBox(
            Text(S.current.loan_interest_rate_with_symbol),
            Text((double.parse(loanDetail.intRate) * 100).toStringAsFixed(2) +
                '%'),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.total_periods,
            ),
            Text(loanDetail.termValue.toString()),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.remaining_periods,
            ),
            Text(loanDetail.restPeriods.toString()),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.begin_date,
            ),
            Text(loanDetail.disbDate),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.end_date,
            ),
            Text(loanDetail.maturityDate),
          ),
        ],
      ),
    );
    //还款方式、扣款日、扣款卡号
    var container4 = Container(
      color: Colors.white,
      child: Column(
        children: [
          _getSingleBox(
            Text(
              S.current.repayment_ways,
            ),
            Text(repaymentMethod),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(S.current.deduct_money_date),
            Text(loanDetail.repaymentDay.toString() + S.current.day),
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
              Text(
                S.current.deduct_money_account,
              ),
              Text(loanDetail.repaymentAcNo)),
        ],
      ),
    );
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
            //业务品种、贷款金额、余额
            container1,
            //还款记录、待还计划
            container2,
            // 贷款利率、期数、起始到期日
            container3,
            //还款方式、扣款日、扣款卡号
            container4,
          ],
        ),
      ),
    );
  }

  //获得单条内容
  Widget _getSingleBox(Widget name, Widget content) {
    return SizedBox(
        child: Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              name,
              content,
            ],
          ),
        ],
      ),
    ));
  }

  Type arb() => S;
}
