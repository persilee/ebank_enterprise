/*
 * Created Date: Friday, December 4th 2020, 10:08:07 am
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../page_route.dart';

class TimeDepositRecordPage extends StatefulWidget {
  TimeDepositRecordPage({Key key}) : super(key: key);

  @override
  _TimeDepositRecordPageState createState() => _TimeDepositRecordPageState();
}

class _TimeDepositRecordPageState extends State<TimeDepositRecordPage> {
  // var totalName = '存款总额';
  var ccy = '';
  var totalAmt = '';
  List<Rows> rowList = [];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });

    //网络请求
    _loadDeopstData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContent(rowList),
    );
  }

  Widget _getContent(List<Rows> rows) {
    var SliverToBoxAdapters = <Widget>[
      SliverAppBar(
        pinned: true,
        title: Text(S.current.deposit_record),
        centerTitle: true,
      ),
      SliverToBoxAdapter(
        child: Container(
          color: HsgColors.primary,
          padding: EdgeInsets.only(left: 0, top: 30, bottom: 10),
          child: Text(
            FormatUtil.formatSringToMoney('${totalAmt}'),
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1,
                fontSize: 40,
                backgroundColor: HsgColors.primary,
                color: Colors.white),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          color: HsgColors.primary,
          padding: EdgeInsets.only(left: 0, top: 10, bottom: 30),
          child: Text(
            ' ${S.current.receipts_total_amt} (HKD)',
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1,
                fontSize: 15,
                backgroundColor: HsgColors.primary,
                color: Colors.white54),
          ),
        ),
      ),
      //整存整取
      SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
        String bal = FormatUtil.formatSringToMoney('${rows[index].bal}');
        var endTime = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.current.due_date,
              style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
            ),
            Text(
              //到期时间
              rows[index].mtDate,
              style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
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
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                '$bal  ${rows[index].ccy}',
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              )
            ],
          ),
          //利率
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.interest_rate,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                //利率
                rows[index].conRate,
                style: TextStyle(fontSize: 15, color: Colors.red),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.effective_date,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                //生效时间
                rows[index].valDate,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
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
              Navigator.pushNamed(context, pageDepositInfo);
            },
            padding: EdgeInsets.only(bottom: 12),
            color: Colors.white,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: taking,
            ));
        return Container(
            margin: EdgeInsets.only(bottom: 12), child: raisedButton);
      }, childCount: rowList.length)),
    ];
    return CustomScrollView(slivers: SliverToBoxAdapters);
  }

  _loadDeopstData() {
    bool excludeClosed = true;
    String page = '1';
    String pageSize = '200';
    String ciNo = '50000067';
    String userId = '779295543468752896';
    Future.wait({
      DepositDataRepository().getDepositRecordRows(
          DepositRecordReq(excludeClosed, page, pageSize), 'getDepositRecord'),
      DepositDataRepository().getDepositByCardNo(
          DepositByCardReq(ccy, ciNo, userId), 'getDepositByCardNo')
    }).then((value) {
      value.forEach((element) {
        if (element is DepositRecordResp) {
          if (element.rows != null) {
            setState(() {
              rowList.clear();
              rowList.addAll(element.rows);
            });
          }
        } else if (element is DepositByCardResp) {
          setState(() {
            totalAmt = element.totalAmt;
          });
        }
      });
    });
  }
}
