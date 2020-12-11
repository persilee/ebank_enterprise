/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: 方璐瑶
/// Date: 2020-12-07

import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/loan_rate.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoanInterestRatePage extends StatefulWidget {
  LoanInterestRatePage({Key key}) : super(key: key);

  @override
  _LoanInterestRatePageState createState() => _LoanInterestRatePageState();
}

class _LoanInterestRatePageState extends State<LoanInterestRatePage> {
  var ccys = [];
  List<ProdMastList> prodMast = [];
  List rates = [];
  List engNames = [];
  List rateLists = [];
  @override
// ignore: must_call_super
  void initState() {
    super.initState();

    // 网络请求
    _loadData();
  }

  Future<void> _loadData() async {
    LoanDataRepository()
        .getLoanRateList(LoanRateReq([]), 'getLoanRateList')
        .then((data) {
      setState(() {
        ccys.clear();
        prodMast.clear();
        rates.clear();
        engNames.clear();
        rateLists.clear();
        ccys.addAll(data.ccyList);
        print(ccys.toString());
        prodMast.addAll(data.prodMastList);

        for (int i = 0; i < data.prodMastList.length; i++) {
          rates = [];
          data.prodMastList[i].prodCcyList.forEach((e) {
            if (e.fixedRate != null) {
              rates.add(e.fixedRate);
            }
          });
          rateLists.add(rates);
        }
        data.prodMastList.forEach((e) {
          if (e.engName != null) {
            engNames.add(e.engName);
          }
        });
      });
      Fluttertoast.showToast(msg: "网络请求成功");
      print('-----------------=======Yes======--------------------' + '$data');
    }).catchError((e) {
      // HSProgressHUD.showError(status: e.toString());
      Fluttertoast.showToast(msg: "网络请求失败");
      print('--------=======No=======----------');
      print('${e.toString()}');
      print('--------=======No=======----------');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Loan Interest Rate'),
          centerTitle: true,
          elevation: 0,
        ),
        body: RefreshIndicator(
            child: ListView(
              children: [
                Container(
                  child: _getContent(),
                )
              ],
            ),
            onRefresh: _loadData));
  }

//显示内容
  Widget _getContent() {
    return SizedBox(
      child: Row(
        children: [
          Container(
              child: Column(
            children: [
              Container(
                color: Color(0xFF333450),
                child: _getBox('Loan Product', 16, Colors.white),
                // width: 120,
              ),
              Container(
                child: _getCloumnBoxList(engNames),
                //  width: 120,
              ),
            ],
          )),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                child: Column(
              children: [
                Container(
                  color: Color(0xFF333450),
                  child: _getRowBoxList(ccys, 16, Colors.white),
                  //width: 60.0 * ccys.length,
                ),
                Container(
                  child: _getAllBoxList(rateLists),
                  //width: 60.0 * rateLists.length,
                )
              ],
            )),
          )),
        ],
      ),
    );
  }

  //获得所有滑动元素
  Widget _getAllBoxList(List list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(
        child: _getRowBoxList(list[i], 14, Colors.black),
      ));
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
    );
  }

  //获得滑动的一行的所有元素
  Widget _getRowBoxList(List list, double size, Color color) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(
        child: _getBox(list[i], size, color),
      ));
    }
    return SizedBox(
      child: Row(
        children: _list,
      ),
    );
  }

  //获得固定的一列的所有元素
  Widget _getCloumnBoxList(List list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(
        child: _getBox(list[i], 14, Colors.black),
      ));
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
    );
  }

//获得单个的元素
  Widget _getBox(String name, double size, Color color) {
    return SizedBox(
        child: Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
      ),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: size, color: color),
      ),
    ));
  }
}
