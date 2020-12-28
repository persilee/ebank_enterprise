/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'dart:ui';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_rate.dart';
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

  var names = List<String>();

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
  Widget _getOneCloum(String name, double fontSize, double width, Color color) {
    return SizedBox(
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                S.current.time_deposit,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF333450),
                ),
              ),
            ),
            Container(
              child: Text(
                '${name} ${S.current.month}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

//获得单个的元素
  Widget _getBox(String name, double fontSize, double width, Color color) {
    name = name == null ? '' : name;
    return SizedBox(
        child: Container(
      width: width,
      height: 50,
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
    ));
  }

  //获得滑动的一行的所有元素
  Widget _getRowBoxList(List list, double fontSize, double width, Color color) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(
        child: _getBox(list[i], fontSize, width, color),
      ));
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
      _list.add(SizedBox(
        child: _getRowBoxList(list[i], fontSize, width, color),
      ));
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
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
              Container(
                child: Column(
                  children: [
                    //固定第一个
                    Container(
                      color: Color(0xFF333450),
                      child: _getBox(
                          S.current.time_deposit_type, 16, 120, Colors.white),
                    ),
                    //固定第一列
                    Container(
                      child: _getCloumnBoxList(names),
                    ),
                  ],
                ),
              ),
              //行
              Container(
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
              ),
            ],
          ),
        ),
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return SizedBox(
              child: Column(
            children: [
              Container(
                child: Row(
                  children: [],
                ),
              ),
            ],
          ));
        }, childCount: ebankInterestRateList.length))
      ],
    );
  }

  Future<void> _loadDeopstRateData() async {
    DepositDataRepository()
        .getDepositRate(GetDepositRate(), 'GetDepositRate')
        .then((data) {
      if (data.ebankInterestRateRspDTOList != null) {
        setState(() {
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
              //遍历拿出来的集合
              dataList.forEach((element) {
                String rate = element == null ? '--' : element.intRate;
                rateList.add(rate);
              });
              rateLists.add(rateList);
            }

            data.ebankInterestRateRspDTOList.forEach((element) {
              names.add(element.ebankInterestRateHead.auctCale);
            });
          }
        });
      }
    });
  }
}
