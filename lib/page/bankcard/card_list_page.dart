import 'package:ebank_mobile/generated/l10n.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-11-04

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';

/// @auther zhanggenha
/// @date 2020-12-05
class CardListPage extends StatefulWidget {
  CardListPage({Key key}) : super(key: key);

  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  var cards = [];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // 初次加载显示loading indicator, 会自动调用_loadData
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refrestIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.my_account),
        ),
        body: RefreshIndicator(
            key: refrestIndicatorKey,
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int position) {
                    return getRow(context, position);
                  }),
            ),
            onRefresh: _loadData));
  }

  Widget getRow(BuildContext context, int position) {
    return GestureDetector(
      child: getCard(cards[position]),
      onTap: () {
        go2Detail(cards[position]);
      },
    );
  }

  Future<void> _loadData() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          cards.clear();
          cards.addAll(data.cardList);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  void go2Detail(RemoteBankCard card) {
    Navigator.pushNamed(context, pageCardDetail, arguments: card);
  }
}

Widget getCard(RemoteBankCard card) {
  final listTile = ListTile(
    leading: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(
                'images/ic_launcher.png',
              ),
              fit: BoxFit.cover)),
      width: 36,
      height: 36,
    ),
    title: Text(
      FormatUtil.formatSpace4(card.cardNo),
      style: TextStyle(color: Colors.white),
    ),
    subtitle: Text(
      S.current.demand_deposit_account,
      style: TextStyle(color: Colors.white70),
    ),
  );

  return Card(
    color: Colors.redAccent,
    child: Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: listTile,
    ),
  );
}
