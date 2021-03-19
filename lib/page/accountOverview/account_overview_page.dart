/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/account_overview_repository.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/account_overview_all_data.dart';
import 'package:ebank_mobile/data/source/model/get_account_overview_info.dart';
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
  // List<AccountOverviewList> ddList = [];
  // List<AccountOverviewList> tdList = [];
  List<CardListBal> ddList = [];
  List<TdConInfoList> tdList = [];
  List<LoanMastList> lnList = [];
  List<String> cardNoList = [];
  //判断是否是总资产
  bool isTotalAsset = true;
  //判断是否为总负债
  bool isTotalLiabilities = false;

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();
    // _getAccountOverviewInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).account_overview),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: CustomScrollView(
            slivers: [
              // 头部
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 19, 0, 0),
                  color: HsgColors.primary,
                  child: _accountOverviewColumn(),
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
              (lnTotal != '0.00')
                  ? isTotalLiabilities
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
                      : SliverToBoxAdapter()
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
        ));
  }

  Container _lnSliverList(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lnList[index].acNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(lnList[index].unpaidPrincipal) +
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
            tdList[index].conNo, //.cardNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(tdList[index].bal) +
                ' ' +
                tdList[index].ccy, //avaBal
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
    if (isTotalAsset) {
      colorOne = Color(0xFF152153);
      colorTwo = Color(0xFF40475F);
    } else {
      colorOne = Color(0xFF40475F);
      colorTwo = Color(0xFF152153);
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 18),
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
                  S.current.total_assets, localCcy, netAssets, colorOne),
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
              child: _netAssets(S.current.total_liability, localCcy,
                  totalLiabilities, colorTwo),
            ),

            //_totalLiability(),
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

  Column _netAssets(
      String title, String localCcy, String netAssets, Color color) {
    return Column(
      children: [
        //总资产
        Container(
          padding: EdgeInsets.only(left: 18, top: 9),
          width: MediaQuery.of(context).size.width / 2,
          color: color,
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
          color: color,
          child: Text(
            localCcy + ' ' + FormatUtil.formatSringToMoney(netAssets),
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        )
      ],
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

  _getCardList() {
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

    // 总资产
    AccountOverviewRepository()
        .getTotalAssets(
            GetTotalAssetsReq(userID, custID, localCcy), 'GetTotalAssetsReq')
        .then((data) {
      setState(() {
        if (data.totalAssets != '0') {
          totalAssets = data.totalAssets;
        }
        if (data.netAssets != '0') {
          netAssets = data.netAssets;
        }
        if (data.totalLiability != '0') {
          totalLiabilities = data.totalLiability;
        }
        // localCcy = data.ccy;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // 活期
    AccountOverviewRepository()
        .getCardListBalByUser(
            GetCardListBalByUserReq('', localCcy, custID, cardNoList),
            'GetCardListBalByUserReq')
        .then((data) {
      if (data.cardListBal != null) {
        setState(() {
          ddList = data.cardListBal;
          if (data.ddTotalAmt != '0') {
            ddTotal = data.ddTotalAmt;
          }
          if (data.tdTotalAmt != '0') {
            tdTotal = data.tdTotalAmt;
          }
          lnTotal = '1000.00';
          lnList = [
            LoanMastList('0101900000095007', '0101900000095007', custID,
                '1000.00', '1000.00')
          ];
          ddCcy = data.defaultCcy == null ? localCcy : data.defaultCcy;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // //定期
    AccountOverviewRepository()
        .getTdConInfoList(
            GetTdConInfoListReq(ciNo: custID), 'GetTdConInfoListReq')
        .then((data) {
      if (data.rows != null) {
        setState(() {
          tdList = data.rows;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // // 定期总额
    // AccountOverviewRepository()
    //     .getActiveContractByCiNo(GetActiveContractByCiNoReq(custID, userID),
    //         'GetActiveContractByCiNoReq')
    //     .then((data) {
    //   setState(() {
    //     if (data.totalAmt != '0') {
    //       tdTotal = data.totalAmt;
    //     }
    //   });
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // });

    // // 贷款
    // AccountOverviewRepository()
    //     .getLoanMastList(GetLoanMastListReq(custID), 'GetLoanMastListReq')
    //     .then((data) {
    //   if (data.lnAcMastAppDOList != null) {
    //     setState(() {
    //       lnList = data.lnAcMastAppDOList;
    //       if (data.totalLiability != '0') {
    //         lnTotal = data.totalLiability;
    //       }
    //     });
    //   }
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // });

    // AccountOverviewRepository()
    //     .getCardListBalById(AccOverviewDataReq(userID, localCcy, custID, ''),
    //         'getCardListBalById')
    //     .then((data) {
    //   setState(() {
    //     ddTotal = data.ddTotalAmt;
    //     ddList = data.cardListBal;
    //     tdTotal = data.tdTotalAmt;
    //     tdList = data.tedpListBal;
    //     if (data.totalAmt != '0') {
    //       totalAssets = data.totalAmt;
    //     }
    //     if (data.totalAmt != '0') {
    //       netAssets = data.totalAmt;
    //     }
    //     totalLiabilities = '0.00';
    //     localCcy = data.defaultCcy;
    //   });
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // });
  }
}
