/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/account_overview_repository.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
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
  String ddCcy = 'HKD';
  String tdTotal = '0.00';
  String lnTotal = '0.00';
  List<CardListBal> ddList = [];
  List<TdConInfoList> tdList = [];
  List<LoanMastList> lnList = [];
  List<String> cardNoList = [];

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getCardList();
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
              // 总资产
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 19, 0, 28),
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
              SliverToBoxAdapter(
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
              ),
              SliverToBoxAdapter(
                child: _ddTotalColumn(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _ddSliverList(index);
                }, childCount: ddList.length),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 12,
                ),
              ),

              // 定期
              SliverToBoxAdapter(
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
              ),
              SliverToBoxAdapter(
                child: _tdTotalColumn(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _tdSliverList(index);
                }, childCount: tdList.length),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 12,
                ),
              ),

              // 贷款
              SliverToBoxAdapter(
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
              ),
              SliverToBoxAdapter(
                child: _lnTotalColumn(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _lnSliverList(index);
                }, childCount: lnList.length),
              ),

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
            lnList[index].unpaidPrincipal + ' HKD',
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
                lnTotal + ' HKD',
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
            tdList[index].conNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            tdList[index].bal + ' ' + tdList[index].ccy,
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
                tdTotal + ' HKD',
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
            ddList[index].equAmt + ' ' + ddList[index].ccy,
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
                ddTotal + ' ' + ddCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _accountOverviewColumn() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 18),
          child: _totalAssets(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _netAssets(),
            _dividingLine(),
            _totalLiability(),
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

  Column _netAssets() {
    return Column(
      children: [
        Text(
          S.current.net_assets,
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        Text(
          localCcy + ' ' + FormatUtil.formatSringToMoney(netAssets),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Column _totalAssets() {
    return Column(
      children: [
        Center(
          child: Text(
            S.current.total_assets,
            style: TextStyle(fontSize: 14, color: Colors.white54),
          ),
        ),
        Center(
          child: Text(
            localCcy + ' ' + FormatUtil.formatSringToMoney(totalAssets),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
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
        .getTotalAssets(GetTotalAssetsReq(userID, '8000000004', localCcy),
            'GetTotalAssetsReq')
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
        localCcy = data.ccy;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // 活期
    AccountOverviewRepository()
        .getCardListBalByUser(
            GetCardListBalByUserReq('', localCcy, '8000000004', cardNoList),
            'GetCardListBalByUserReq')
        .then((data) {
      if (data.cardListBal != null) {
        setState(() {
          ddList = data.cardListBal;
          if (data.totalAmt != '0') {
            ddTotal = data.totalAmt;
          }
          ddCcy = data.defaultCcy;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    //定期
    AccountOverviewRepository()
        .getTdConInfoList(
            GetTdConInfoListReq(ciNo: '8000000030'), 'GetTdConInfoListReq')
        .then((data) {
      if (data.rows != null) {
        setState(() {
          tdList = data.rows;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // 定期总额
    AccountOverviewRepository()
        .getActiveContractByCiNo(GetActiveContractByCiNoReq(custID, userID),
            'GetActiveContractByCiNoReq')
        .then((data) {
      setState(() {
        if (data.totalAmt != '0') {
          tdTotal = data.totalAmt;
        }
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });

    // 贷款
    AccountOverviewRepository()
        .getLoanMastList(GetLoanMastListReq(custID), 'GetLoanMastListReq')
        .then((data) {
      if (data.lnAcMastAppDOList != null) {
        setState(() {
          lnList = data.lnAcMastAppDOList;
          if (data.totalLiability != '0') {
            lnTotal = data.totalLiability;
          }
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
