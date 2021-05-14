/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 定期利率查看页面
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'dart:ui';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_rate.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class MyDepositRatePage extends StatefulWidget {
  MyDepositRatePage({Key key}) : super(key: key);

  @override
  _MyDepositRatePage createState() => _MyDepositRatePage();
}

class _MyDepositRatePage extends State<MyDepositRatePage> {
  var ccyList = List<String>();

  List<EbankInterestRateRspDTOList> ebankInterestRateList = [];
  var ccys = List<String>();

  var auctCale = '';

  var rateLists = List();

  var rates = List<String>();

  var names = List();

  @override
  void initState() {
    super.initState();

    //网络请求
    _loadDeopstRateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getContents(ebankInterestRateList),
    );
  }

  Widget _getContents(List<EbankInterestRateRspDTOList> rows) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(S.current.time_deposit_interest_rate),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              _getContentOne(),

              _getContentTwo(),
              //行
            ],
          ),
        ),
      ],
    );
  }

  //对第一列操作
  _getContentOne() {
    return Container(
      child: Column(
        children: [
          //固定第一个
          Container(
            color: Color(0xFF333450),
            child: _getBox(S.current.time_deposit_type, 16, 120, Colors.white),
          ),
          //固定第一列
          Container(
            child: _getCloumnBoxList(names),
          ),
        ],
      ),
    );
  }

  //对币种和利率操作
  _getContentTwo() {
    return Container(
      child: Column(
        children: [
          //获取币种
          Container(
            color: Color(0xFF333450),
            child: _getRowBoxList(ccys, 16, 80, Colors.white),
          ),
          //获取币种利率
          Container(
            child: _getAllBoxList(rateLists, 14, 80, Colors.black),
          )
        ],
      ),
    );
  }

  //获得固定的一列的所有元素
  Widget _getCloumnBoxList(List list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(child: _getOneCloum(list[i], 15, 120, Colors.black)));
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
    );
  }

  //获取第一列元素
  Widget _getOneCloum(List name, double fontSize, double width, Color color) {
    String auctCale = ''; //档期
    String accuPeriod = ''; //计提周期 1：日：2：月  3：季  4：半年  5:年
    auctCale = name[0];
    switch (name[1]) {
      case '1':
        accuPeriod = S.current.day;
        break;
      case '2':
        accuPeriod = S.current.month;
        break;
      case '3':
        accuPeriod = S.current.quarter;
        break;
      case '4':
        auctCale = '';
        accuPeriod = S.current.half_a_year;
        break;
      case '5':
        accuPeriod = S.current.year;
        break;
    }
    print(MediaQuery.of(context).size.height / 13);
    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
//        height: MediaQuery.of(context).size.height / 13,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                S.current.time_deposit,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF333450),
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              child: Text(
                auctCale + accuPeriod,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //获得币种单个的元素
  Widget _getBox(String name, double fontSize, double width, Color color) {
    name = name == null ? '' : name;
    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
//        height: MediaQuery.of(context).size.height / 13,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
      ),
    );
  }

  //获取利率单个元素
  Widget _getRateBox(String name, double fontSize, double width, Color color) {
    name = name == null ? '' : name;
    return SizedBox(
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
//        height: MediaQuery.of(context).size.height / 13,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Text(
          name = name != '--' ? '$name%' : '--',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
      ),
    );
  }

  //获得滑动的一行的所有元素
  Widget _getRowBoxList(List list, double fontSize, double width, Color color) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(
        SizedBox(
          child: _getBox(list[i], fontSize, width, color),
        ),
      );
    }
    return SizedBox(
      child: Row(
        children: _list,
      ),
    );
  }

  //获取利率滑动行所有数据
  Widget _getRowRateBoxList(
      List list, double fontSize, double width, Color color) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(
        SizedBox(
          child: _getRateBox(list[i], fontSize, width, color),
        ),
      );
    }
    return SizedBox(
      child: Row(
        children: _list,
      ),
    );
  }

  //获得所有滑动元素
  Widget _getAllBoxList(List list, double fontSize, double width, Color color) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(
        SizedBox(
          child: _getRowRateBoxList(list[i], fontSize, width, color),
        ),
      );
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
    );
  }

  _loadDeopstRateData() {
    // DepositDataRepository()
    ApiClientTimeDeposit().getDepositRate(GetDepositRate()).then(
      (data) {
        if (data.ebankInterestRateRspDTOList != null) {
          setState(
            () {
              if (data.ebankInterestRateRspDTOList != null) {
                ebankInterestRateList.clear();
                names.clear();
                ebankInterestRateList.addAll(data.ebankInterestRateRspDTOList);

                ccys.addAll(data.ccyList);

                // rates = [];
                for (int i = 0; i < ebankInterestRateList.length; i++) {
                  List<EbankInterestRateDOList> dataList =
                      ebankInterestRateList[i].ebankInterestRateDOList;
                  List<String> ccyList = [];
                  List<String> rateList = [];
                  for (int i = 0; i < dataList.length; i++) {
                    EbankInterestRateDOList doList = dataList[i];
                    ccyList.add(doList.ccy);
                  }
                  if (!ccyList.contains('CNY')) {
                    EbankInterestRateDOList doListNew;
                    dataList.insert(0, doListNew);
                  }
                  if (!ccyList.contains('USD')) {
                    EbankInterestRateDOList doListNew;
                    dataList.insert(1, doListNew);
                  }
                  if (!ccyList.contains('HKD')) {
                    EbankInterestRateDOList doListNew;
                    dataList.insert(2, doListNew);
                  }
                  for (int i = 0; i < ccyList.length; i++) {}
                  //遍历拿出来的集合
                  dataList.forEach(
                    (element) {
                      String rate = element == null ? '--' : element.intRate;
                      rateList.add(rate);
                    },
                  );
                  rateLists.add(rateList);
                }
                data.ebankInterestRateRspDTOList.forEach(
                  (element) {
                    var list = List<String>();
                    list.add(element.ebankInterestRateHead.auctCale);
                    list.add(element.ebankInterestRateHead.accuPeriod);
                    names.add(list);
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
