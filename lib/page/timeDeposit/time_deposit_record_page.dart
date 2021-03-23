/*
 * Created Date: Friday, December 4th 2020, 10:08:07 am
 * Author: pengyikang
 * 我的存单页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'dart:math';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_list_bal_by_user.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

//加载状态
enum LoadingStatus { STATUS_LOADING, STATUS_COMPLETED, STATUS_IDEL }

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  var ccy = '';
  var totalAmt = '';
  var _defaultCcy = '';
  List<CardListBal> cardList;
  List<DepositRecord> rowList = [];
  List<DepositRecord> list = []; //页面显示的记录列表
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  double conRate;
  bool _isDate = false; //false
  LoadingStatus loadStatus; //加载状态
  int page = 1;
  int count = 0;
  ScrollController _sctrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });

    //网络请求
    _loadCardListBal();

    NotificationCenter.instance.addObserver('load', (object) {
      setState(() {
        if (object) {
          _loadDeopstData();
          _loadCardListBal();
        }
      });
    });

    _sctrollController.addListener(() {
      if (_sctrollController.position.pixels ==
          _sctrollController.position.maxScrollExtent) {
        //加载更多
        _getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          key: refrestIndicatorKey,
          child: _getContent(rowList),
          // 下拉刷新时调用_loadDeopstData
          onRefresh: _loadDeopstData),
    );
  }

//设置padding
  Widget _pad(Widget widget, {l, t, r, b}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        l ??= 0.0,
        t ??= 0.0,
        r ??= 0.0,
        b ??= 0.0,
      ),
      child: widget,
    );
  }

  //加载
  Widget _loadingView() {
    var loadingIndicator = Visibility(
      visible: loadStatus == LoadingStatus.STATUS_LOADING ? true : false,
      child: SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(HsgColors.accent),
        ),
      ),
    );
    return _pad(
      Row(
        children: <Widget>[loadingIndicator],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      t: 20.0,
      b: 20.0,
    );
  }

  //存单总额（币种）
  Widget _totalCcy() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.only(left: 0, top: 10, bottom: 30),
      child: Text(
        ' ${S.current.receipts_total_amt} (' + _defaultCcy + ')',
        textAlign: TextAlign.center,
        style: TextStyle(height: 1, fontSize: 15, color: Colors.white54),
      ),
    );
  }

  //存单总额
  Widget _totalAmt() {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
      child: Text(
        FormatUtil.formatSringToMoney(totalAmt),
        textAlign: TextAlign.center,
        style: TextStyle(height: 1, fontSize: 40, color: Colors.white),
      ),
    );
  }

  Widget _getContent(List<DepositRecord> rows) {
    // ignore: non_constant_identifier_names
    var SliverToBoxAdapters = <Widget>[
      SliverAppBar(
        pinned: true,
        title: Text(S.current.deposit_record),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF1775BA),
              Color(0xFF3A9ED1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
          child: Column(
            children: [
              _totalAmt(),
              _totalCcy(),
            ],
          ),
        ),
      ),
      //整存整取
      _isDate
          ? SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                String bal =
                    FormatUtil.formatSringToMoney('${rows[index].bal}');

                double conRate = double.parse(rows[index].conRate);
                conRate = double.parse(FormatUtil.formatNum(conRate, 2));
                var endTime = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.due_date,
                      style: TextStyle(
                          fontSize: 15, color: HsgColors.toDoDetailText),
                    ),
                    Text(
                      //到期时间
                      rows[index].mtDate,
                      style: TextStyle(
                          fontSize: 15, color: HsgColors.aboutusTextCon),
                    ),
                  ],
                );
                //存入金额
                var rate = [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.deposit_amount,
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.toDoDetailText),
                      ),
                      Text(
                        '$bal  ${rows[index].ccy}',
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.aboutusTextCon),
                      )
                    ],
                  ),
                  //利率
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.interest_rate,
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.toDoDetailText),
                      ),
                      Text(
                        //利率
                        '$conRate%',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.effective_date,
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.toDoDetailText),
                      ),
                      Text(
                        //生效时间
                        rows[index].valDate,
                        style: TextStyle(
                            fontSize: 15, color: HsgColors.aboutusTextCon),
                      ),
                    ],
                  ),
                  endTime
                ];
                var startTime = rate;
                //整存整取
                var taking = [
                  SizedBox(
                    height: 37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            S.current.deposit_taking,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: HsgColors.textHintColor),
                  SizedBox(
                    height: 125,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: startTime,
                      ),
                    ),
                  )
                ];
                var raisedButton = RaisedButton(
                    onPressed: () {
                      go2Detail(rowList[index], cardList);
                    },
                    padding: EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: taking,
                    ));
                if (index == list.length) {
                  return _loadingView();
                  // return Container();
                } else {
                  return raisedButton;
                  // Container(
                  //     margin: EdgeInsets.only(bottom: 12), child: raisedButton);
                }
              }, childCount: list.length),
            )
          : SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: notDataContainer(context, S.current.no_data_now),
              ),
            ),
    ];
    return CustomScrollView(slivers: SliverToBoxAdapters);
  }

  void go2Detail(DepositRecord deposit, List<CardListBal> cardList) {
    Navigator.pushNamed(context, pageDepositInfo,
        arguments: {'deposit': deposit, 'cardList': cardList});
  }

  Future<void> _loadDeopstData() async {
    final prefs = await SharedPreferences.getInstance();
    bool excludeClosed = true;
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      DepositDataRepository().getDepositRecordRows(
          DepositRecordReq(ciNo, '', excludeClosed, page, 10, ''),
          'getDepositRecord')
    }).then((value) {
      value.forEach((element) {
        if (element.rows.length != 0) {
          count = element.count;
          _isDate = true;
          setState(() {
            rowList.clear();
            rowList.addAll(element.rows);
            list.clear();
            list.addAll(rowList);
          });
        } else {
          _isDate = false;
        }
      });
    });
  }

  Future<void> _loadCardListBal() async {
    final prefs = await SharedPreferences.getInstance();
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      DepositDataRepository().getCardListBalByUser(
          GetCardListBalByUserReq('', [], '', ciNo), 'getCardListBalByUser')
    }).then((value) {
      value.forEach((element) {
        setState(() {
          totalAmt = element.tdTotalAmt;
          _defaultCcy = element.defaultCcy;
          cardList = element.cardListBal;
        });
      });
    });
  }

  //加载更多
  _getMore() {
    if (loadStatus == LoadingStatus.STATUS_IDEL) {
      setState(() {
        loadStatus = LoadingStatus.STATUS_LOADING;
      });
    }
    setState(() {
      if (list.length >= count) {
        loadStatus = LoadingStatus.STATUS_IDEL;
      } else {
        page = page + 1;
        _loadDeopstData();
        loadStatus = LoadingStatus.STATUS_LOADING;
      }
    });
  }
}
