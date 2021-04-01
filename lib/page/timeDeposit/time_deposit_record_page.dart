/*
 * Created Date: Friday, December 4th 2020, 10:08:07 am
 * Author: pengyikang
 * 我的存单页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/page/approval/widget/notificationCenter.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  var ccy = ''; //币种
  var totalAmt = ''; //定期存单总额
  var _defaultCcy = ''; //默认币种
  // List<TotalAssetsCardListBal> cardList;
  List<DepositRecord> rowList = []; //定期存单列表
  List<DepositRecord> list = []; //页面显示的记录列表

  double conRate; //利率
  bool _isDate = false; //false
  LoadingStatus loadStatus; //加载状态
  int page = 1;
  int count = 0;
  ScrollController _scrollController;
  RefreshController _refreshController;
  bool _isLoading = false; //加载状态
  bool _headColor = true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    //获取定期存单列表
    _loadDeopstData();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   refrestIndicatorKey.currentState.show();
    // });

    //网络请求
    // _loadCardListBal();
    // _loadTotalAssets();

    NotificationCenter.instance.addObserver('load', (object) {
      if (this.mounted) {
        setState(() {
          if (object) {
            _loadDeopstData();
            // _loadCardListBal();
            // _loadTotalAssets();
          }
        });
      }
    });

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _headColor = false;
        } else {
          _headColor = true;
        }
      });
    });

    // _sctrollController.addListener(() {
    //   if (_sctrollController.position.pixels ==
    //       _sctrollController.position.maxScrollExtent) {
    //     //加载更多
    //     _getMore();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _getContent(rowList),
      // 下拉刷新时调用_loadDeopstData
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

  _appBar() {
    return AppBar(
      title: Text(S.current.deposit_record),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Color(0xffFEFEFE),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Color(0xffFEFEFE),
          fontSize: 18,
          fontStyle: FontStyle.normal,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF1775BA),
            Color(0xFF3A9ED1),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF1775BA),
              Color(0xFF3A9ED1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _totalAmt(),
                _totalCcy(),
              ],
            ),
          ),
        ),
        preferredSize: Size(30, 150),
      ),
    );
  }

  Widget _getContent(List<DepositRecord> rows) {
    // ignore: non_constant_identifier_names
    var SliverToBoxAdapters = <Widget>[
      // SliverAppBar(
      //   // pinned: true,
      //   title: Text(S.current.deposit_record),
      //   centerTitle: true,
      //   // backgroundColor: Colors.yellowAccent[300],
      //   // floating: true,
      //   // expandedHeight: 210.0,
      //   iconTheme: IconThemeData(
      //     color: Color(0xffFEFEFE),
      //   ),
      //   textTheme: TextTheme(
      //     headline6: TextStyle(
      //       color: Color(0xffFEFEFE),
      //       fontSize: 18,
      //       fontStyle: FontStyle.normal,
      //     ),
      //   ),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(colors: [
      //         Color(0xFF1775BA),
      //         Color(0xFF3A9ED1),
      //       ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      //     ),
      //     // height: 110,
      //   ),
      //   bottom: PreferredSize(
      //     child: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(colors: [
      //           Color(0xFF1775BA),
      //           Color(0xFF3A9ED1),
      //         ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      //       ),
      //       // height: 110,
      //       child: Container(
      //         // margin: EdgeInsets.only(top: 80),
      //         width: MediaQuery.of(context).size.width,
      //         child: Column(
      //           children: [
      //             _totalAmt(),
      //             _totalCcy(),
      //           ],
      //         ),
      //       ),
      //     ),
      //     preferredSize: Size(30, 150),
      //   ),
      // ),
      //整存整取
      _isLoading
          ? SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height - 180) / 4),
                child: HsgLoading(),
              ),
            )
          : _isDate
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
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
                        // height: 37,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(
                                rows[index].engName,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
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
                          go2Detail(rowList[index]);
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
    return CustomScrollView(
      slivers: SliverToBoxAdapters,
      controller: _scrollController,
    );
  }

  void go2Detail(DepositRecord deposit) {
    Navigator.pushNamed(context, pageDepositInfo, arguments: deposit);
  }

//获取定期存单列表
  Future<void> _loadDeopstData() async {
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    bool excludeClosed = true;
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      DepositDataRepository().getDepositRecordRows(
          DepositRecordReq(ciNo, '', excludeClosed, page, 10, ''),
          'getDepositRecord')
    }).then((value) {
      if (this.mounted) {
        setState(() {
          value.forEach((element) {
            if (element.rows.length != 0) {
              count = element.count;
              _isDate = true;
              totalAmt = element.totalAmt;
              _defaultCcy = element.defaultCcy;
              rowList.clear();
              rowList.addAll(element.rows);
              list.clear();
              list.addAll(rowList);
            } else {
              _isDate = false;
            }
          });
          _isLoading = false;
        });
      }
    });
  }

  //加载更多
  _getMore() {
    if (loadStatus == LoadingStatus.STATUS_IDEL) {
      if (this.mounted) {
        setState(() {
          loadStatus = LoadingStatus.STATUS_LOADING;
        });
      }
    }
    if (this.mounted) {
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

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }
}
