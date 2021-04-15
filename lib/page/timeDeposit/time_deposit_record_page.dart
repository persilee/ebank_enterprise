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
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../page_route.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  var ccy = ''; //币种
  var totalAmt = ''; //定期存单总额
  var _defaultCcy = ''; //默认币种
  List<DepositRecord> rowList = []; //定期存单列表

  double conRate; //利率
  bool _isDate = false; //判断是否有数据
  // bool _isMoreData = false; //是否加载更多
  int _page = 1;
  int count = 0;
  ScrollController _scrollController;
  RefreshController _refreshController;
  bool _isLoading = false; //加载状态

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    //获取定期存单列表
    _loadDeopstData();

    //接收通知
    NotificationCenter.instance.addObserver('load', (object) {
      if (this.mounted) {
        setState(() {
          if (object) {
            _loadDeopstData();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _isLoading
          ? HsgLoading()
          : _isDate
              ? CustomRefresh(
                  controller: _refreshController,
                  onLoading: () {
                    _loadDeopstData(isLoadMore: true);
                    // //加载更多完成
                    // _refreshController.loadComplete();
                    // //显示没有更多数据
                    // if (_isMoreData) _refreshController.loadNoData();
                  },
                  onRefresh: () {
                    //刷新完成
                    _loadDeopstData();
                  },
                  content: ListView.builder(
                      itemCount: rowList.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return _recordList(rowList[index]);
                      }),
                )
              : notDataContainer(context, S.current.no_data_now),
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

  //存单列表信息
  Widget _recordList(DepositRecord rows) {
    String bal = FormatUtil.formatSringToMoney('${rows.bal}');

    double conRate = double.parse(rows.conRate);
    conRate = double.parse(FormatUtil.formatNum(conRate, 2));
    var endTime = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.due_date,
          style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
        ),
        Text(
          //到期时间
          rows.mtDate,
          style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
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
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
          ),
          Text(
            '$bal  ${rows.ccy}',
            style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
          )
        ],
      ),
      //利率
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.current.interest_rate,
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
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
            style: TextStyle(fontSize: 15, color: HsgColors.toDoDetailText),
          ),
          Text(
            //生效时间
            rows.valDate,
            style: TextStyle(fontSize: 15, color: HsgColors.aboutusTextCon),
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
                rows.engName,
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
          go2Detail(rows);
        },
        padding: EdgeInsets.only(bottom: 12),
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: taking,
        ));

    return raisedButton;
  }

  //跳转传值
  void go2Detail(DepositRecord deposit) {
    Navigator.pushNamed(context, pageDepositInfo, arguments: deposit);
  }

// //获取定期存单列表
//   Future<void> _loadDeopstData({bool isLoadMore = false}) async {
//     isLoadMore ? _page++ : _page = 1;
//     _isLoading = true;
//     final prefs = await SharedPreferences.getInstance();
//     bool excludeClosed = true;
//     String ciNo = prefs.getString(ConfigKey.CUST_ID);
//     Future.wait({
//       DepositDataRepository().getDepositRecordRows(
//           DepositRecordReq(ciNo, '', excludeClosed, _page, 10, ''),
//           'getDepositRecord')
//     }).then((value) {
//       if (this.mounted) {
//         setState(() {
//           value.forEach((element) {
//             if (element.rows.length != 0) {
//               _refreshController.refreshCompleted();
//               _refreshController.footerMode.value = LoadStatus.canLoading;
//               count = element.count;
//               _isDate = true;
//               totalAmt = element.totalAmt;
//               _defaultCcy = element.defaultCcy;
//               if (isLoadMore == false && _page == 1) {
//                 rowList.clear();
//               }

//               rowList.addAll(element.rows);
//             } else {
//               _isDate = false;
//             }
//             if (element.rows.length <= 10 && element.totalPage <= _page) {
//               _isMoreData = true;
//             }
//           });
//           _isLoading = false;
//         });
//       }
//     }).catchError((e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }

//       Fluttertoast.showToast(
//         msg: e.toString(),
//         gravity: ToastGravity.CENTER,
//       );
//       // HSProgressHUD.dismiss();
//     });
//   }

  //获取定期存单列表
  Future<void> _loadDeopstData({bool isLoadMore = false}) async {
    isLoadMore ? _page++ : _page = 1;
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    bool excludeClosed = true;
    String ciNo = prefs.getString(ConfigKey.CUST_ID);
    Future.wait({
      DepositDataRepository().getDepositRecordRows(
          DepositRecordReq(ciNo, '', excludeClosed, _page, 10, ''),
          'getDepositRecord')
    }).then((value) {
      if (this.mounted) {
        setState(() {
          value.forEach((element) {
            _refreshController.refreshCompleted();

            totalAmt = element.totalAmt;
            _defaultCcy = element.defaultCcy;

            if (element.page == 1) {
              _refreshController.footerMode.value = LoadStatus.canLoading;

              rowList = element.rows == null ? [] : element.rows;
            } else {
              rowList.addAll(element.rows);
            }

            if (element.rows.length < 10 || element.totalPage <= _page) {
              _refreshController.footerMode.value = LoadStatus.noMore;
            }

            if (rowList == null || rowList.length == 0) {
              _isDate = false;
            } else {
              _isDate = true;
            }
          });
          _isLoading = false;
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      // HSProgressHUD.dismiss();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }
}
