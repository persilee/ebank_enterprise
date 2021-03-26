import 'package:dio/dio.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
//import 'package:ebank_mobile/data/source/account_overview_repository.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_account_overview_info.dart';
import 'package:ebank_mobile/data/source/model/get_card_list_bal_by_user.dart';
//import 'package:ebank_mobile/data/source/model/account_overview_all_data.dart';
//import 'package:ebank_mobile/data/source/model/get_account_overview_info.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountOverviewPage extends StatefulWidget {
  @override
  _AccountOverviewPageState createState() => _AccountOverviewPageState();
}

class _AccountOverviewPageState extends State<AccountOverviewPage> {
  String totalAssets = '0.00';
  String netAssets = '0.00';
  String totalLiabilities = '0.00';
  String localCcy = '';
  String ddTotal = '0.00';
  String ddCcy = '';
  String tdTotal = '0.00';
  String lnTotal = '0.00';

  List<CardListBal> ddList = [];
  List<TedpListBal> tdList = [];
  List<LnListBal> lnList = [];
  List<String> cardNoList = [];

  //判断是否是总资产
  bool isTotalAsset = true;
  //判断是否为总负债
  bool isTotalLiabilities = false;
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  // ignore: must_call_super
  void initState() {
    //下拉刷新
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
    // 网络请求
    _getCardList();
    // _getAccountOverviewInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(S.of(context).account_overview),
      //   centerTitle: true,
      //   elevation: 0,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(colors: [
      //         Color(0xFF1775BA),
      //         Color(0xFF3A9ED1),
      //       ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          RefreshIndicator(
              key: refrestIndicatorKey,
              child: Container(
                color: HsgColors.commonBackground,
                child: CustomScrollView(
                  slivers: [
                    // 头部
                    SliverAppBar(
                      title: Text(S.of(context).account_overview),
                      centerTitle: true,
                      pinned: true,
                      backgroundColor: Colors.yellowAccent[300],
                      floating: true,
                      expandedHeight: 214.3,
                      iconTheme: IconThemeData(color: Color(0xffFEFEFE)),
                      textTheme: TextTheme(
                        headline6: TextStyle(
                          color: Color(0xffFEFEFE),
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xFF1775BA),
                                  Color(0xFF3A9ED1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                          ),

                          //头部--内容开始
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1775BA),
                                  Color(0xFF3A9ED1),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                            child: _accountOverviewColumn(),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        height: 12,
                      ),
                    ),

                    // 活期
                    isTotalAsset
                        ? SliverToBoxAdapter(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(
                                S.current.demand_deposit,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: HsgColors.aboutusTextCon),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(),
                    //活期合计
                    isTotalAsset
                        ? SliverToBoxAdapter(
                            child: _ddTotalColumn(),
                          )
                        : SliverToBoxAdapter(),
                    //活期列表
                    isTotalAsset
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return _ddSliverList(index);
                            }, childCount: ddList.length),
                          )
                        : SliverToBoxAdapter(),
                    isTotalAsset
                        ? SliverToBoxAdapter(
                            child: Container(
                              height: 12,
                            ),
                          )
                        : SliverToBoxAdapter(),

                    // 定期
                    (tdTotal != '0.00')
                        ? isTotalAsset
                            ? SliverToBoxAdapter(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text(
                                    S.current.time_deposits,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: HsgColors.aboutusTextCon),
                                  ),
                                ),
                              )
                            : SliverToBoxAdapter()
                        : SliverToBoxAdapter(),
                    (tdTotal != '0.00')
                        ? isTotalAsset
                            ? SliverToBoxAdapter(
                                child: _tdTotalColumn(),
                              )
                            : SliverToBoxAdapter()
                        : SliverToBoxAdapter(),
                    (tdTotal != '0.00')
                        ? isTotalAsset
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return _tdSliverList(index);
                                }, childCount: tdList.length),
                              )
                            : SliverToBoxAdapter()
                        : SliverToBoxAdapter(),
                    isTotalAsset
                        ? SliverToBoxAdapter(
                            child: Container(
                              height: 12,
                            ),
                          )
                        : SliverToBoxAdapter(),

                    // 贷款
                    isTotalLiabilities
                        ? (lnTotal != '0.00')
                            ? SliverToBoxAdapter(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text(
                                    S.current.loan,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: HsgColors.aboutusTextCon),
                                  ),
                                ),
                              )
                            : SliverToBoxAdapter(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'images/noDataIcon/no_data_record.png'),
                                        width: 160,
                                      ),
                                      Text(
                                        S.current.no_data_now,
                                        style: FIRST_DEGREE_TEXT_STYLE,
                                      )
                                    ],
                                  ),
                                ),
                              )
                        : SliverToBoxAdapter(),
                    (lnTotal != '0.00')
                        ? isTotalLiabilities
                            ? SliverToBoxAdapter(
                                child: _lnTotalColumn(),
                              )
                            : SliverToBoxAdapter()
                        : SliverToBoxAdapter(),
                    (lnTotal != '0.00')
                        ? isTotalLiabilities
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return _lnSliverList(index);
                                }, childCount: lnList.length),
                              )
                            : SliverToBoxAdapter()
                        : SliverToBoxAdapter(),

                    SliverToBoxAdapter(
                      child: Container(
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              //下拉刷新时调用
              onRefresh: _getCardList),
        ],
      ),
    );
  }

  Container _lnSliverList(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lnList[index].cardNo,
            //acNo
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            //unpaidPrincipal
            FormatUtil.formatSringToMoney(lnList[index].currBal) +
                ' ' +
                localCcy,
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _lnTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(lnTotal) + ' ' + localCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _tdSliverList(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tdList[index].cardNo, //.cardNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(tdList[index].currBal) +
                ' ' +
                tdList[index].ccy, //currbal
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _tdTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(tdTotal) + ' ' + localCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _ddSliverList(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ddList[index].cardNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(ddList[index].equAmt) +
                ' ' +
                ddList[index].ccy,
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _ddTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(ddTotal) + ' ' + ddCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _accountOverviewColumn() {
    Color colorOne;
    Color colorTwo;
    double bottomLeft;
    double bottomRight;
    Color hintColortone;
    Color hintColortwo;
    bool shoDowOne;
    bool shoDowTwo;
    //isTotalAsset ? hintColor = Colors.white : Colors.white54;
    if (isTotalAsset) {
      colorOne = Color(0xFF3A9ED1);
      colorTwo = Color(0xFF2080C0);
      bottomLeft = 20;
      bottomRight = 0;
      hintColortone = Colors.white;
      hintColortwo = Colors.white54;
      shoDowOne = true;
      shoDowTwo = false;
    } else {
      colorOne = Color(0xFF2080C0);
      colorTwo = Color(0xFF3A9ED1);
      bottomLeft = 0;
      bottomRight = 20;
      hintColortone = Colors.white54;
      hintColortwo = Colors.white;
      shoDowOne = false;
      shoDowTwo = true;
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 27),
          child: _totalAssets(),
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //总资产
            InkWell(
              onTap: () {
                setState(() {
                  print('点击总资产');
                  isTotalAsset = true;
                  isTotalLiabilities = false;
                });
              },
              child: _netAssets(
                  S.current.total_assets,
                  localCcy,
                  netAssets, //总资产金额
                  colorOne,
                  0,
                  bottomRight,
                  colorTwo,
                  hintColortone,
                  shoDowOne,
                  true),
            ),

            //总负债
            InkWell(
              onTap: () {
                setState(() {
                  isTotalAsset = false;
                  isTotalLiabilities = true;
                  print("点击总负债 $isTotalAsset");
                });
              },
              child: _netAssets(
                  S.current.total_liability,
                  localCcy,
                  lnTotal, //总负债金额
                  colorTwo,
                  bottomLeft,
                  0,
                  colorOne,
                  hintColortwo,
                  shoDowTwo,
                  false),
            ),
          ],
        ),
      ],
    );
  }

  Column _totalLiability() {
    return Column(
      children: [
        Text(
          S.current.total_liability,
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        Text(
          localCcy + ' ' + FormatUtil.formatSringToMoney(totalLiabilities),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Container _netAssets(
    String title,
    String localCcy,
    String netAssets, //金额
    Color color, //根据资产和负债传入颜色
    double bottomleftRadius, //底部左边距圆角
    double bottomrightRadius, //底部右边距圆角
    Color backgroundColor, //大的container背景色
    Color hintColor, //字体颜色
    bool isboxShadow,
    bool isflex, //阴影偏移量
  ) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              isboxShadow
                  ? BoxShadow(
                      color: Color(0XFF192A56),
                      offset: isflex
                          ? Offset(0.0, 0.0)
                          : Offset(6.0, 0.0), //阴影xy轴偏移量
                      blurRadius: 3.0, //阴影模糊程度
                    )
                  : BoxShadow(color: Color(0xFF2F323E), blurRadius: 0.0)
            ],
            color: color,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(bottomleftRadius),
                bottomRight: Radius.circular(bottomrightRadius))),
        child: Column(
          children: [
            //总资产
            Container(
              padding: EdgeInsets.only(left: 18, top: 9),
              width: MediaQuery.of(context).size.width / 2,
              //color: color,
              child: Text(
                title,
                style: TextStyle(fontSize: 13.5, color: Colors.white54),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 18, top: 7),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 22,
              child: Text(
                  localCcy + ' ' + FormatUtil.formatSringToMoney(netAssets),
                  style: TextStyle(fontSize: 11, color: hintColor)),
            ),
          ],
        ),
      ),
    );
  }

  //净资产
  Column _totalAssets() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            S.current.net_assets,
            style: TextStyle(fontSize: 18, color: Colors.white54),
          ),
          alignment: Alignment.topLeft,
        ),
        Container(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            localCcy + ' ' + FormatUtil.formatSringToMoney(totalAssets),
            style: TextStyle(
                fontSize: 22.5,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }

  Column _dividingLine() {
    return Column(
      children: [
        SizedBox(
          width: 1,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _getCardList() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          data.cardList.forEach((item) {
            cardNoList.add(item.cardNo);
          });
        });
        _getAccountOverviewInfo();
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAccountOverviewInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    String custID = prefs.getString(ConfigKey.CUST_ID);

    setState(() {
      localCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    });

    // 一个接口拿活期，定期总额
    DepositDataRepository()
        .getCardListBalByUser(
            GetCardListBalByUserReq(
              '',
              cardNoList,
              localCcy,
              custID,
            ),
            'GetCardListBalByUserReq')
        .then((data) {
      if (data.cardListBal != null) {
        setState(() {
          //总资产
          netAssets = data.totalAmt;
          //活期列表
          ddList = data.cardListBal;
          if (data.ddTotalAmt != '0') {
            //活期合计
            ddTotal = data.ddTotalAmt;
          }
          //定期列表
          tdList = data.tedpListBal;
          if (data.tdTotalAmt != '0') {
            //定期合计
            tdTotal = data.tdTotalAmt;
          }
          //总负债
          lnTotal = data.lnTotalAmt;
          //贷款列表
          lnList = data.lnListBal;

          ddCcy = data.defaultCcy == null ? localCcy : data.defaultCcy;
          //净资产
          var netAssetCompute = double.parse(netAssets);
          var lnTotalCompute = double.parse(lnTotal);
          double totalAssetsCompute = netAssetCompute - lnTotalCompute;
          totalAssets = totalAssetsCompute.toStringAsFixed(2);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
