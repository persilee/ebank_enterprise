/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款详情界面
/// Author: fangluyao
/// Date: 2020-12-03
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import '../../page_route.dart';

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
          //业务品种
          _business(loanDetail.acNo, loanDetail.br, isMaturity),
          Divider(height: 0, color: HsgColors.textHintColor),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            child: Row(
              children: [
                //贷款金额
                _loanMoney(S.current.loan_amount, loanDetail.loanAmt),
                _verticalMoulding(),
                //贷款余额
                _loanMoney(S.current.loan_balance2, loanDetail.unpaidPrincipal),
              ],
            ),
          ),
        ],
      ),
    );
    //还款记录、待还计划
    var container2 = Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //跳转到还款记录
          _jumpPage(
            pageRepayRecords,
            loanDetail,
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          //跳转到待还计划
          _jumpPage(
            pageWaitRepayPlan,
            loanDetail,
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
            Text('12'), //loanDetail.termValue.toString()
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
            Text(
              S.current.remaining_periods,
            ),
            Text('10'), //loanDetail.restPeriods.toString()
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
      margin: EdgeInsets.only(bottom: 10),
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
            Text('2021-05-01' +
                S.current.day), //loanDetail.repaymentDay.toString()
          ),
          Divider(height: 0, color: HsgColors.textHintColor),
          _getSingleBox(
              Text(
                S.current.deduct_money_account,
              ),
              Text(
                  '0101238000001758')), //0101238000001758  loanDetail.repaymentAcNo.toString()
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loan_detail),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: _getContent(),
      ),

      // body: Container(
      //   color: HsgColors.backgroundColor,
      //   child: Row(
      //     children: [
      //       //业务品种、贷款金额、余额
      //       container1,

      //       // // 贷款利率、期数、起始到期日
      //       // container3,
      //       // //还款方式、扣款日、扣款卡号
      //       // container4,
      //       // //还款记录、待还计划
      //       // container2,
      //       _getContent(),
      //     ],
      //   ),
      // ),
    );
  }

  //业务品种
  Widget _business(String acNo, String br, String isMaturity) {
    return _getSingleBox(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 业务品种
            Text(
              // S.current.loan_product_name_with_value + '：' + acNo,
              "贷款账号",
              style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
            ),
            //贷款编号
            Container(
              margin: EdgeInsets.only(top: 13.5),
              child: Text(
                // S.current.loanId + '：' + br,
                acNo,
                style: TextStyle(fontSize: 16, color: HsgColors.aboutusTextCon),
              ),
            ),
          ],
        ),
      ),
      // Text(
      //   //是否到期
      //   isMaturity,
      //   style: TextStyle(
      //     color: HsgColors.loginAgreementText,
      //     fontSize: 14,
      //   ),
      // ),
      _collectButton(), //领用按钮
    );
  }

  //竖线条
  Widget _verticalMoulding() {
    return Padding(
      padding: EdgeInsets.only(right: 30),
      child: SizedBox(
        width: 1,
        height: 30,
        child: DecoratedBox(
          decoration: BoxDecoration(color: HsgColors.textHintColor),
        ),
      ),
    );
  }

  //贷款额
  Widget _loanMoney(String loanName, String money) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loanName,
            style: TextStyle(fontSize: 13, color: HsgColors.describeText),
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Text(
            // '￥' +
            FormatUtil.formatSringToMoney(money),
            style: TextStyle(fontSize: 16, color: HsgColors.aboutusTextCon),
          ),
        ],
      ),
    );
  }

  //页面跳转
  Widget _jumpPage(String jumpPage, var transfer) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, jumpPage, arguments: transfer);
      },
      // child: _getSingleBox(text, icon),
    );
  }

  //获得单条内容
  Widget _getSingleBox(Widget name, Widget content) {
    return Padding(
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
    );
  }

  Type arb() => S;

  //领用按钮
  Widget _collectButton() {
    return Container(
      width: 62.5,
      height: 28.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: HsgColors.plainBtn, width: 0.5),
        borderRadius: BorderRadius.circular((5)),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Text(
          "领用",
          style: TextStyle(
            fontSize: 13,
            color: HsgColors.plainBtn,
          ),
        ),
        onPressed: () {
          print("领用");
        },
      ),
    );
  }

//一行文字
  Widget _rowText(String leftText, String rightText, Color color) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(fontSize: 14, color: HsgColors.secondDegreeText),
          ),
          Text(
            rightText,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ],
      ),
    );
  }

//合约列表
  List<Widget> _getContent() {
    // ignore: non_constant_identifier_names
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
    List<Widget> section = [];

    section.add(
      SliverToBoxAdapter(
        child: Container(
          // margin: EdgeInsets.only(bottom: 12),
          color: Colors.white,
          child: Column(
            children: [
              //业务品种
              _business(loanDetail.acNo, loanDetail.br, isMaturity),
              Divider(height: 0, color: HsgColors.textHintColor),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                child: Row(
                  children: [
                    //贷款金额
                    // _loanMoney(S.current.loan_amount, loanDetail.loanAmt),
                    _loanMoney("额度(USD)", "10000"),
                    _verticalMoulding(),
                    //贷款余额
                    // _loanMoney(S.current.loan_balance2, loanDetail.unpaidPrincipal),
                    _loanMoney("可用额度(USD)", "8000"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    section.add(
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          //存入金额
          var rate = [
            _rowText("贷款金额", '6000 USD', HsgColors.secondDegreeText),
            _rowText("贷款余额", "6000 USD", HsgColors.secondDegreeText),
            _rowText("开始时间", "2022-01-20", HsgColors.secondDegreeText),
            _rowText("结束时间", "2022-01-20", HsgColors.secondDegreeText),
            _rowText("贷款利率", "8.80%", Color(0xFFA61F23)),
          ];
          //整存整取
          var taking = Column(
            children: [
              Container(
                height: 13,
                color: Color(0xFFF7F7F7),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 45,
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "合约账号 1209898878",
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.aboutusTextCon),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          print("点击");
                          _selectPage(context);
                        },
                        child: Image(
                          width: 15,
                          image: AssetImage(
                              'images/loanProduct/loan_apply_more.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, color: HsgColors.textHintColor),
              Container(
                // height: 125,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: rate,
                  ),
                ),
              ),
            ],
          );
          return taking;
        }, childCount: 3),
      ),
    );
    return section;
  }

  //弹窗跳转
  _selectPage(BuildContext context
      // ,
      // Loan loanDetail
      ) async {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    List<String> pages = [
      S.current.repayment_record,
      S.of(context).view_repayment_plan,
      S.of(context).prepayment,
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: "操作",
              items: pages,
            ));
    if (result != null && result != false) {
      // loanDetails.debitAccount => '0101238000001758';;
      // print('详情数据----$loanDetail.');
      switch (result) {
        case 0:
          //直接还款记录
          Navigator.pushNamed(context, pageRepayRecords, arguments: loanDetail);
          break;
        case 1:
          //查看还款计划
          Navigator.pushNamed(context, pageRepayPlan, arguments: loanDetail);
          break;
        case 2:
          //提前还款
          Navigator.pushNamed(context, pageRepayInput, arguments: loanDetail);
          break;
      }
    } else {
      return;
    }
  }
}
