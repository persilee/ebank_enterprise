/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class LimitDetailsPage extends StatefulWidget {
  LimitDetailsPage({Key key}) : super(key: key);
  @override
  _LimitDetailsState createState() => _LimitDetailsState();
}

class _LimitDetailsState extends State<LimitDetailsPage> {
  //贷款账号
  String acNo = "";
  //客户号
  String ciNo = "";
  //合约编号
  String contactNo = "";
  //产品号
  String productCode = "";
  var loanDetails = [];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_limit_detail),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: _getlistViewList(context),
        onRefresh: _loadData,
      ),
    );
  }

  Future<void> _loadData() async {
    //请求的参数
    acNo = "";
    ciNo = "50000085";
    contactNo = "";
    productCode = "";

    LoanDataRepository()
        .getLoanList(GetLoanListReq(acNo, ciNo, contactNo, productCode),
            'getLoanMastList')
        .then((data) {
      if (data.loanList != null) {
        setState(() {
          loanDetails.clear();
          loanDetails.addAll(data.loanList);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //封装ListView.Builder
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //生成ListView
  Widget _getlistViewList(BuildContext context) {
    List<Widget> _list = new List();

    for (int i = 0; i < loanDetails.length; i++) {
      _list
          .add(_getListViewBuilder(_limitDetailsIcon(context, loanDetails[i])));
    }
    return new ListView(
      children: _list,
    );
  }

  //额度详情-封装
  Widget _limitDetailsIcon(BuildContext context, Loan loanDetail) {
    var titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          //合约账号
          S.of(context).contract_account + " " + loanDetail.contactNo,
          style: TextStyle(fontSize: 15, color: Color(0xFF242424)),
        ),
        Icon(
          Icons.keyboard_arrow_right,
        ),
      ],
    );
    var titleBox = InkWell(
      onTap: () {
        //跳转
        _selectPage(context,loanDetail);
      },
      child: SizedBox(
        height: 46,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: titleRow,
            ),
          ],
        ),
      ),
    );
    var contentColumn = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        contentRow(
            S.of(context).loan_principal,
            FormatUtil.formatSringToMoney(loanDetail.loanAmt) + " HKD",
            Color(0xFF1E1E1E)),
        contentRow(
            S.of(context).loan_balance2,
            FormatUtil.formatSringToMoney(loanDetail.unpaidPrincipal) + " HKD",
            Color(0xFF1E1E1E)),
        contentRow(
            S.of(context).begin_time, loanDetail.disbDate, Color(0xFF1E1E1E)),
        contentRow(
            S.of(context).end_time, loanDetail.maturityDate, Color(0xFF1E1E1E)),
        contentRow(
            S.of(context).loan_interest_rate,
            (double.parse(loanDetail.intRate) * 100).toStringAsFixed(2) + "%",
            Color(0xFFF8514D)),
      ],
    );
    var contentBox = SizedBox(
        height: 150,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: contentColumn,
        ));

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBox,
          Divider(
            height: 0,
            color: HsgColors.textHintColor,
            indent: 20,
            endIndent: 20,
          ),
          contentBox,
        ],
      ),
    );
  }

  Widget contentRow(String leftcont, String rightcont, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftcont,
          style: TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
        ),
        Text(
          rightcont,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }
  
  //跳转
 _selectPage(BuildContext context,Loan loanDetail) async{
   List<String> pages = [
      S.of(context).view_details,
      S.of(context).view_repayment_plan,
      S.of(context).prepayment,
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.of(context).loan_account+' '+loanDetail.contactNo,
              items: pages,
            ));
    if (result != null && result != false) {
      switch (result) {
        case 0:
          //查看详情
          Navigator.pushNamed(context, pageloanDetails, arguments: loanDetail);
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
