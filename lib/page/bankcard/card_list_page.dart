import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
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
import 'package:ebank_mobile/widget/progressHUD.dart';

/// @auther zhanggenha
/// @date 2020-12-05
class CardListPage extends StatefulWidget {
  CardListPage({Key key}) : super(key: key);

  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  List<RemoteBankCard> cards = <RemoteBankCard>[];
  var refrestIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<bool> _isShow = <bool>[];
  List<GetCardLimitByCardNoResp> _cardLimitList = <GetCardLimitByCardNoResp>[];

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
          centerTitle: true,
          elevation: 0,
        ),
        body: RefreshIndicator(
            key: refrestIndicatorKey,
            child: Container(
              color: Colors.white,
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
      child: Column(
        children: [
          getCard(cards[position], position),
          _isShow[position]
              ? _cardContent(cards[position], position)
              : Container(),
        ],
      ),
      onTap: () {
        // go2Detail(cards[position]);
        _loadCardLimit(cards[position].cardNo, position);
      },
    );
  }

  Widget _cardContent(RemoteBankCard card, int position) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 100),
      color: Colors.white,
      child: Column(
        children: [
          _infoFrame("${S.current.account_balance}(CNY)",
              FormatUtil.formatSringToMoney('50000')),
          // FormatUtil.formatSringToMoney(_cardLimitList[position].totalAmt)),
          _infoFrame(
              S.current.single_transfer_limit,
              FormatUtil.formatSringToMoney(
                  _cardLimitList[position].singleLimit)),
          _infoFrame(
              S.current.single_day_transfer_limit,
              FormatUtil.formatSringToMoney(
                  _cardLimitList[position].singleDayLimit)),
          _infoFrame(S.current.single_day_transfer_count_limit,
              _cardLimitList[position].singleDayCountLimit.toString()),
        ],
      ),
    );
  }

  //左边标题，右边内容
  Widget _infoFrame(String left, String right) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                child: Text(
                  left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _hintText(right),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Divider(
              height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
        ),
      ],
    );
  }

  //灰色文字
  Widget _hintText(String text) {
    return Container(
      width: 120,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: HsgColors.hintText,
          // color: Color(0xEE7A7A7A),
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> _loadData() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          cards.clear();
          cards.addAll(data.cardList);
          if (_isShow.length == 0 && _cardLimitList.length == 0) {
            for (int i = 0; i < cards.length; i++) {
              RemoteBankCard card = cards[i];
              _isShow.add(false);
            }
          }
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _loadCardLimit(String cardNo, int position) async {
    if (_isShow[position] == true) {
      setState(() {
        _isShow[position] = false;
      });
    } else {
      try {
        String test = _cardLimitList[position].toString();
        HSProgressHUD.show();
        setState(() {
          _isShow[position] = true;
        });
        HSProgressHUD.dismiss();
        print(test);
      } catch (error) {
        HSProgressHUD.show();
        CardDataRepository()
            .getCardLimitByCardNo(
                GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq')
            .then((limit) {
          setState(() {
            _cardLimitList.insert(position, limit);
            _isShow[position] = true;
          });
          HSProgressHUD.dismiss();
        }).catchError((e) {
          HSProgressHUD.dismiss();
          HSProgressHUD.showError(status: e.toString());
        });
      }
      // print(e.toString());
    }
  }

  void go2Detail(RemoteBankCard card) {
    Navigator.pushNamed(context, pageCardDetail, arguments: card);
  }
}

Widget getCard(RemoteBankCard card, int position) {
  final listTile = ListTile(
    // leading: Container(
    //   decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       image: DecorationImage(
    //           image: AssetImage(
    //             'images/ic_launcher.png',
    //           ),
    //           fit: BoxFit.cover)),
    //   width: 16,
    //   height: 36,
    // ),
    title: Text(
      FormatUtil.formatSpace4(card.cardNo),
      style: TextStyle(color: Colors.white),
    ),
    subtitle: Text(
      S.current.demand_deposit_account,
      style: TextStyle(color: Colors.white70),
    ),
  );

  return Container(
    margin: EdgeInsets.only(top: 3),
    decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(1.0),
      image: DecorationImage(
        image: AssetImage(
          position % 2 == 0
              ? "images/mine/card_background1.png"
              : "images/mine/card_background2.png",
        ),
        fit: BoxFit.fill,
      ),
    ),
    padding: EdgeInsets.only(left: 30, bottom: 40),
    child: listTile,
  );
}
