/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款利率界面
/// Author: fangluyao
/// Date: 2020-12-07

import 'package:ebank_mobile/data/source/model/get_loan_rate.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_loan.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanInterestRatePage extends StatefulWidget {
  LoanInterestRatePage({Key key}) : super(key: key);

  @override
  _LoanInterestRatePageState createState() => _LoanInterestRatePageState();
}

class _LoanInterestRatePageState extends State<LoanInterestRatePage> {
  var ccys = List<String>();
  var prodMast = List<ProdMastList>();
  var rates = List<String>();
  var names = List<String>();
  var rateLists = List();
  // var flag = 0;
  String language = Intl.getCurrentLocale();

  @override
  void initState() {
    super.initState();

    // _loadData();
    _staticData();
  }

  //静态数据
  Future<void> _staticData() {
    ccys = ["CNY", "HKD", "USD"];
    if (language == 'zh_CN') {
      names = ["兴业贷", "闪电贷", "经营贷"];
    } else {
      names = ["Corporation Loan", "Lightning Loan", "Manage Loan"];
    }
    rateLists = [
      ["--", "8.5%", "6.7%"],
      ["6.8%", "6.5%", "--"],
      ["--", "5.8%", "7.6%"]
    ];
  }

  Future<void> _loadData() async {
    // LoanDataRepository()
    ApiClientLoan().getLoanRateList(GetLoanRateReq([])).then((data) {
      setState(() {
        ccys.clear();
        prodMast.clear();
        rates.clear();
        names.clear();
        rateLists.clear();

        // flag = 1;
        ccys.addAll(data.ccyList);
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
          if (e.engName != null || e.chnName != null) {
            if (language == 'zh_CN') {
              names.add(e.chnName);
            } else {
              names.add(e.engName);
            }
          }
        });
      });
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.loan_interest_rate_with_symbol),
          centerTitle: true,
          elevation: 0,
        ),
        body:
            // RefreshIndicator(
            Container(
          child: ListView(
            children: [
              Container(
                child: _getContent(),
              )
            ],
          ),
          // onRefresh:
          //     // _loadData
          //     _staticData
        ));
  }

//显示内容
  Widget _getContent() {
    // if (flag == 0) {
    //   return SizedBox();
    // } else {
    return SizedBox(
      child: Row(
        children: [
          Container(
              child: Column(
            children: [
              //固定的第一个元素
              Container(
                color: Color(0xFF333450),
                child: _getBox(S.current.loan_product_name_with_value, 16, 120,
                    Colors.white),
              ),
              //固定的所有元素
              Container(
                child: _getCloumnBoxList(names),
              ),
            ],
          )),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                child: Column(
              children: [
                //滚动的第一行
                Container(
                  color: Color(0xFF333450),
                  child: _getRowBoxList(ccys, 16, 80, Colors.white),
                ),
                //滚动的所有行
                Container(
                  child: _getAllBoxList(rateLists, 14, 80, Colors.black),
                )
              ],
            )),
          )),
        ],
      ),
    );
    // }
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

  //获得固定的一列的所有元素
  Widget _getCloumnBoxList(List list) {
    List<Widget> _list = new List();
    for (int i = 0; i < list.length; i++) {
      _list.add(SizedBox(
        child: _getBox(list[i], 15, 120, Colors.black),
      ));
    }
    return SizedBox(
      child: Column(
        children: _list,
      ),
    );
  }

//获得单个的元素
  Widget _getBox(String name, double fontSize, double width, Color color) {
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
}
