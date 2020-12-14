/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 收支明细
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_pay_collect_detail.dart';
import 'package:ebank_mobile/data/source/pay_collect_detail_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../page_route.dart';

class DetailListPage extends StatefulWidget {
  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  List<RevenueHistoryDTOList> revenueHistoryList = [];

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getRevenueByCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.transaction_details),
        centerTitle: true,
        // elevation: 0,
      ),
      body: Container(
        color: HsgColors.backgroundColor,
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2020-12-01'),
                  Text('全部账户'),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: _sliversSection(revenueHistoryList),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _sliversSection(List data) {
    List<Widget> section = [];

    for (var item in data) {
      RevenueHistoryDTOList listData = item;
      List<DdFinHistDOList> ddFinHistList = listData.ddFinHistDOList;

      section.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: 15, top: 10),
            color: Colors.white,
            child: Text(listData.transDate),
          ),
        ),
      );

      section.add(
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Column(
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 23, 15, 20),
                    color: Colors.white,
                    child: _getRow(ddFinHistList, index),
                  ),
                  onTap: () {
                    _goToDetail(ddFinHistList[index]);
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 70, right: 13),
                  child: Divider(height: 0.5, color: HsgColors.divider),
                ),
              ],
            );
          }, childCount: listData.ddFinHistDOList.length),
        ),
      );

      section.add(
        SliverToBoxAdapter(
          child: Container(
            color: HsgColors.commonBackground,
            height: 10,
          ),
        ),
      );
    }
    return section;
  }

  Row _getRow(List<DdFinHistDOList> ddFinHistList, int index) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 13),
          child: ClipOval(
            child: Image.asset(
              'images/home/listIcon/home_list_card_bank.png',
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    child: Text(
                      ddFinHistList[index].acNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
                    ),
                  ),
                  Container(
                    child: Text(
                      ddFinHistList[index].drCrFlg == 'C'
                          ? '+ ' +
                              ddFinHistList[index].txCcy +
                              ' ' +
                              ddFinHistList[index].txAmt
                          : '- ' +
                              ddFinHistList[index].txCcy +
                              ' ' +
                              ddFinHistList[index].txAmt,
                      style: TextStyle(fontSize: 15, color: Color(0xFF222121)),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    child: Text(
                      ddFinHistList[index].txDateTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Color(0xFFACACAC)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _goToDetail(DdFinHistDOList ddFinHist) {
    Navigator.pushNamed(context, pageDetailInfo, arguments: ddFinHist);
  }

  _getRevenueByCards() async {
    PayCollectDetailRepository()
        .getRevenueByCards(
            GetRevenueByCardsReq(
                localDateStart: '2020-11-01', cards: ['500000674001']),
            'GetRevenueByCardsReq')
        .then((data) {
      if (data.revenueHistoryDTOList != null) {
        setState(() {
          revenueHistoryList = data.revenueHistoryDTOList;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
