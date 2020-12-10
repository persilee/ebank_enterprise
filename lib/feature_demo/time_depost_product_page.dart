/*
 * Filename: d:\work\flutter\ebank_mobile_enterprise\lib\feature_demo\time_depost_product_page.dart
 * Path: d:\work\flutter\ebank_mobile_enterprise\lib\feature_demo
 * Created Date: Thursday, December 3rd 2020, 11:34:30 am
 * Author: wangluyao
 * 
 * Copyright (c) 2020 Your Company
 */
//import 'dart:html';

import 'package:ebank_mobile/data/source/model/time_deposit_product.dart';
import 'package:ebank_mobile/data/source/time_deposit_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class TimeDepostProduct extends StatefulWidget {
  TimeDepostProduct({Key key}) : super(key: key);

  @override
  _TimeDepostProductState createState() => _TimeDepostProductState();
}

class _TimeDepostProductState extends State<TimeDepostProduct> {
  List<TdepProducDTOList> productList = [];

  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    BorderSide _lineBorderSide() {
      return BorderSide(
        // 设置单侧边框的样式
        color: HsgColors.divider,
        width: 0.5,
        style: BorderStyle.solid,
      );
    }

    List<Widget> _titleSection(List<TdepProducDTOList> tdepProducDTOList) {
      List<Widget> section = [];
      section.add(SliverAppBar(
        pinned: false,
        title: Text('定期产品'),
        actions: <Widget>[
          Text(
            S.current.my_deposit_certificate,
            style: TextStyle(
              fontSize: 17.0,
              height: 2.5,
            ),
          ),
        ],
        // flexibleSpace: FlexibleSpaceBar(
        //   background: Image.asset(
        //     'images/time_depost/time_depost_product.png',
        //     width: 500.0,
        //     height: 120.0,
        //     fit: BoxFit.cover,
        //   ),
        // ),
      ));
      section.add(
        SliverToBoxAdapter(
          child: Image.asset(
            'images/time_depost/time_depost_product.png',
            width: 500.0,
            height: 120.0,
            fit: BoxFit.cover,
          ),
        ),
        // SliverList(
        //   delegate:SliverChildBuilderDelegate((context, index{
        //   return Container(
        //     child:  Image.asset(
        //       'images/time_depost/time_depost_product.png',
        //       width: 500.0,
        //       height: 120.0,
        //       fit: BoxFit.cover,
        //     ),
        //   );
        // })))
      );
      section.add(SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    color: HsgColors.commonBackground,
                    height: 15,
                  ),
                  Container(
                    // height: 115,
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: Border(
                        top: _lineBorderSide(),
                        bottom: _lineBorderSide(),
                      ), //Border.all(width: 1, color: Colors.red),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40.0,
                          alignment: Alignment.centerLeft,
                          child: Text('The CDS'
                              //tdepProducHeadDTO.lclName,
                              // style: TextStyle(),
                              ),
                        ),
                        Divider(height: 0.5, color: HsgColors.divider),
                        Container(
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // tdepProducDTOList.
                                '2.8~3.4',
                                // tdepProducHeadDTO.minRate +
                                //     '~' +
                                //     tdepProducHeadDTO.maxRate,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.red[500]),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 30) /
                                        2 *
                                        1,
                                child: Text(
                                  'Surprise deposit interest rate',
                                  // tdepProducHeadDTO.remark,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: HsgColors.firstDegreeText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.current.annual_interest_rate,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: HsgColors.describeText,
                                ),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 30) /
                                        2 *
                                        1,
                                child: Text(
                                  S.current.from_hundred,
                                  //tdepProducHeadDTO.minAmt,
                                  //S.current.from_hundred,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HsgColors.describeText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Text(
                              //   S.current.from_hundred,
                              //   style: TextStyle(
                              //     fontSize: 15,
                              //     color: HsgColors.describeText,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }, childCount: tdepProducDTOList.length)));
      return section;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: _titleSection(productList),
      ),
    );
  }

  Future<void> _loadData() async {
    TimeDepositDataRepository()
        .getGetTimeDepositProduct('getGetTimeDepositProduct')
        .then((data) {
      // products.clear();
      //products.addAll();
      print('$data');
      // productList.clear();
      // productList.addAll(data.tdepProducDTOList);
      print('-------------------------------$productList');

      setState(() {});
    }).catchError((e) {
      print('========================$e');
      // Fluttertoast.showToast(msg: e.toString());
    });
  }
}
