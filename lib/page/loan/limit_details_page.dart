/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhangqirong
/// Date: 2020-12-03

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/page_route.dart';
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
    // _loadData();
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
        child: listViewListTile(context),
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
      } else {
        Fluttertoast.showToast(msg: "Content is Empty!");
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //添加个头部
  // Widget _getHeader() {
  //   return Container(
  //     height: 162,
  //     margin: EdgeInsets.only(bottom: 12),
  //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //     color: HsgColors.primary,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Padding(padding: EdgeInsets.only(left: 15, right: 5)),
  //             Column(
  //               children: [
  //                 Text(
  //                   '个人信用贷款',
  //                   style: TextStyle(fontSize: 15, color: Colors.white),
  //                 ),
  //               ],
  //             ),
  //             Padding(padding: EdgeInsets.only(left: 10, right: 10)),
  //             Column(
  //               children: [
  //                 SizedBox(
  //                   width: 1,
  //                   height: 30,
  //                   child: DecoratedBox(
  //                     decoration: BoxDecoration(color: Colors.grey),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Padding(padding: EdgeInsets.only(left: 10, right: 10)),
  //             Column(
  //               children: [
  //                 Text(
  //                   '张*三',
  //                   style: TextStyle(fontSize: 13, color: Colors.white54),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Padding(
  //             padding: EdgeInsets.only(bottom: 15, top: 15),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Padding(padding: EdgeInsets.only(left: 15,bottom: 5, top: 5)),
  //                         Text(
  //                           '可用额度 (元)',
  //                           style:
  //                               TextStyle(fontSize: 13, color: Colors.white54),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         Padding(padding: EdgeInsets.only(left: 15,bottom: 5, top: 5)),
  //                         Text(
  //                           '200,000.00',
  //                           style: TextStyle(fontSize: 24, color: Colors.white),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Column(
  //                   children: [
  //                     //Button
  //                     Text("button"),
  //                   ],
  //                 )
  //               ],
  //             )),
  //       ],
  //     ),
  //   );
  // }

  //封装ListView.Builder
  Widget getListViewBuilder(Widget function) {
    return ListView.builder(
        // scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  //生成ListView
  Widget listViewListTile(BuildContext context) {
    List<Widget> _list = new List();
    // _list.add(getListViewBuilder(_getHeader()));

    for (int i = 0; i < loanDetails.length; i++) {
      _list.add(getListViewBuilder(limitDetailsIcon(context, loanDetails[i])));
    }
    return new ListView(
      children: _list,
    );
  }

  //额度详情-封装
  Widget limitDetailsIcon(BuildContext context, Loan loanDetail) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        //合约账号
                        S.of(context).contract_account +
                            " " +
                            loanDetail.contactNo,
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF242424)),
                      ),
                      InkWell(
                        onTap: () {
                          //此处跳转到详情
                          // Navigator.pushNamed(context, PageLoanDemo,arguments: loanDetail);
                          /* 
                           * 跳转的页面调用此方法获取数据，注意 loanDetail的类型为get_loan_list.dart文件的Loan类
                           * loanDetail = ModalRoute.of(context).settings.arguments;
                          */
                          Fluttertoast.showToast(msg: "假装跳转了!");
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: HsgColors.textHintColor,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
              height: 150,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //贷款金额
                        Text(
                          S.of(context).loan_principal,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          loanDetail.loanAmt,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //贷款余额
                        Text(
                          S.of(context).loan_balance2,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          loanDetail.unpaidPrincipal,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //开始时间
                        Text(
                          S.of(context).begin_time,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          loanDetail.disbDate,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //结束时间
                        Text(
                          S.of(context).end_time,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          loanDetail.maturityDate,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //贷款利率
                        Text(
                          S.of(context).loan_interest_rate,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                        ),
                        Text(
                          (double.parse(loanDetail.intRate) * 100)
                                  .toStringAsFixed(2) +
                              "%",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFFF8514D)),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
