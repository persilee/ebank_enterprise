
/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-10

// import 'package:ebank_mobile/config/hsg_colors.dart';
// import 'package:ebank_mobile/data/source/loan_data_repository.dart';
// import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class RepayPlanPage extends StatefulWidget {
  @override
  _RepayPlanState createState() => _RepayPlanState();
}

class _RepayPlanState extends State<RepayPlanPage> {
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String contactNo = '';

  @override
  void initState() {
    super.initState();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  Future<void> _loadData() async {}

  @override
  Widget build(BuildContext context) {
    Loan loanDetail = ModalRoute.of(context).settings.arguments;
    contactNo = loanDetail.contactNo;

    var stackList = Stack(
      fit: StackFit.loose,
      children: [
        Align(
          heightFactor: 200,
          widthFactor: 163,
          child: Positioned(
            left: 21,
            top: 100,
            bottom: 15,
            child: VerticalDivider(
              width: 1,
              color: Color(0x07000000),
            ),
          ),
        ),
        listViewList(context),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repayment_plan),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: Column(
          children: [
            _getHeader(loanDetail),
            Expanded(
              child: stackList,
            ),
          ],
        ),
        onRefresh: _loadData,
      ),
    );
  }

  //生成ListView
  Widget listViewList(BuildContext context) {
    List<Widget> _list = new List();
    for (int i = 0; i < 6; i++) {
      _list.add(getListViewBuilder(_getContent()));
    }
    return new ListView(
      children: _list,
    );
  }

  //封装ListView.Builder
  Widget getListViewBuilder(Widget function) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //获取头部(贷款本金，贷款余额)
  Widget _getHeader(Loan loanDetail) {
    var topBox = SizedBox(
      child: Row(
        children: [
          //贷款金额
          Text(
            S.of(context).loan_principal + ":",
            style: TextStyle(fontSize: 13, color: Color(0xFF262626)),
          ),
          Text(
            " HKD " + FormatUtil.formatSringToMoney(loanDetail.loanAmt),
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          ),
        ],
      ),
    );
    var bottomBox = SizedBox(
      child: Row(
        children: [
          //贷款余额
          Text(
            S.of(context).loan_balance2 + ":",
            style: TextStyle(fontSize: 13, color: Color(0xFF262626)),
          ),
          Text(
            " HKD " + FormatUtil.formatSringToMoney(loanDetail.unpaidPrincipal),
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 21, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          topBox,
          Padding(padding: EdgeInsets.only(top: 10)),
          bottomBox,
          Padding(padding: EdgeInsets.only(top: 13)),
          Container(
            height: 20,
            child: Divider(
              height: 0,
              color: Color(0xFFE9E9E9),
            ),
          ),
        ],
      ),
    );
  }

  //获取内容(左[日期] 中[时间轴] 右[还款详情])
  Widget _getContent() {
    var leftCont = Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            child: Text(
              "04-18",
              style: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
            ),
          ),
          SizedBox(
            child: Text(
              "2020",
              style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
            ),
          ),
        ],
      ),
    );
    var stackCont = Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.loose,
      textDirection: TextDirection.rtl,
      children: [
        Align(
          heightFactor: 2,
          child: Opacity(
              opacity: 0.2,
              child: Container(
                width: 7,
                height: 7,
                child: CircleAvatar(
                  radius: 6.0,
                ),
              )),
        ),
        Opacity(
            opacity: 0.1,
            child: Container(
              width: 15,
              height: 15,
              child: CircleAvatar(
                radius: 6.0,
              ),
            )),
      ],
    );
    var centerCont = Container(
      // height: 65,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          stackCont,
        ],
      ),
    );
    var rightCont = Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "28.00",
                style: TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
              ),
              Text(
                "  (" + "已还清" + ")  ",
                style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
              ),
              Text(
                "还款",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4871FF),
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          SizedBox(
            child: Text(
              "含本金 0.00+利息 28.00+罚息 0.00",
              style: TextStyle(fontSize: 13, color: Color(0xFF9C9C9C)),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          SizedBox(
            width: 217,
            child: Divider(
              height: 0,
              color: Color(0xFFE4E4E4),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leftCont,
          centerCont,
          rightCont,
        ],
      ),
    );
  }
}
