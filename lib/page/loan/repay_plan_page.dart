/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-10

// import 'package:ebank_mobile/config/hsg_colors.dart';
// import 'package:ebank_mobile/data/source/loan_data_repository.dart';
// import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ebank_mobile/data/source/model/get_loan_list.dart';

class RepayPlanPage extends StatefulWidget {
  @override
  _RepayPlanState createState() => _RepayPlanState();
}

class _RepayPlanState extends State<RepayPlanPage> {
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).repayment_plan),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: refrestIndicatorKey,
        child: listViewList(context),
        onRefresh: _loadData,
      ),
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

  //生成ListView
  Widget listViewList(BuildContext context) {
    List<Widget> _list = new List();
    _list.add(getListViewBuilder(_getHeader()));
    // _list.add(getListViewBuilder(test()));
    for (int i = 0; i < 2; i++) {
      _list.add(getListViewBuilder(_getContent()));
    }
    return new ListView(
      children: _list,
    );
  }

  //获取头部
  Widget _getHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 21, 20, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                Text(
                  //贷款金额
                  S.of(context).loan_principal + ":",
                  style: TextStyle(fontSize: 13, color: Color(0xFF262626)),
                ),
                Text(
                  //贷款金额
                  " HKD " + "1,500,000.00",
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 14)),
          SizedBox(
            child: Row(
              children: [
                Text(
                  //贷款金额
                  S.of(context).loan_principal + ":",
                  style: TextStyle(fontSize: 13, color: Color(0xFF262626)),
                ),
                Text(
                  //贷款金额
                  " HKD " + "1,500.00",
                  style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
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

  //获取内容
  Widget _getContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          ),
          Container(
            // height: 65,
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Column(
              children: [
                SizedBox(
                  child: Icon(
                    Icons.donut_large,
                  ),
                ),
                Flex(
                    direction: Axis.vertical,
                    children: List.generate(1, (_) {
                      return SizedBox(
                        width: 2,
                        height: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color:
                                  // Color(0xFFF0F0F0)
                                  Colors.grey),
                        ),
                      );
                    })),
              ],
            ),
          ),
          Container(
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
          ),
        ],
      ),
    );
  }
}
