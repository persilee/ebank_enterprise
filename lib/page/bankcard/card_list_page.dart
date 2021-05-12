import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: zhanggenhua
/// Date: 2020-11-04

import 'package:flutter/material.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// @auther zhanggenha
/// @date 2020-12-05
class CardListPage extends StatefulWidget {
  CardListPage({Key key}) : super(key: key);

  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  List<RemoteBankCard> cards = <RemoteBankCard>[];
  List<bool> _isShow = <bool>[];

  Map _cardLimitMap = <int, GetCardLimitByCardNoResp>{};
  Map _totalbalMap = <int, List<CardBalBean>>{};
  int _cardsLength = 0;
  bool _isLoading = false; //加载状态

  RefreshController _refreshController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.my_account),
        centerTitle: true,
        elevation: 1,
      ),
      body: _isLoading
          ? HsgLoading()
          : _cardsLength > 0
              ? Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 20),
                  child: CustomRefresh(
                    controller: _refreshController,
                    onLoading: () {
                      //加载更多完成
                      // _refreshController.loadComplete();
                      //显示没有更多数据
                      _refreshController.loadNoData();
                    },
                    onRefresh: () {
                      _loadData();
                      //刷新完成
                      // _refreshController.refreshCompleted();
                      // _refreshController.footerMode.value =
                      //     LoadStatus.canLoading;
                      print("刷新完成");
                    },
                    content: _getlistViewList(context),
                  ),
                )
              : notDataContainer(context, S.current.no_data_now),
    );
  }

//生成ListView
  Widget _getlistViewList(BuildContext context) {
    List<Widget> _list = new List();
    _list.add(_getListViewBuilder(_getHeader()));
    for (int i = 0; i < cards.length; i++) {
      _list.add(_getListViewBuilder(getRow(context, i)));
    }
    return new ListView(
      children: _list,
    );
  }

  Widget _getHeader() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        S.current.in_all +
            ' ' +
            _cardsLength.toString() +
            ' ' +
            S.current.accounts,
        style: TextStyle(
          color: HsgColors.hintText,
          fontSize: 13,
        ),
      ),
    );
  }

  //封装ListView.Builder
  Widget _getListViewBuilder(Widget function) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (BuildContext context, int position) {
          return function;
        });
  }

  Widget getRow(BuildContext context, int position) {
    return GestureDetector(
      key: GlobalKey(),
      child: Column(
        children: [
          getCard(cards[position], position),
          _isShow[position]
              ? _cardContent(cards[position], position)
              : Container(),
        ],
      ),
      onTap: () {
        // _showContent(cards[position].cardNo, position);
        for (int i = 0; i < _isShow.length; i++) {
          if (_isShow[i] == true) {
            _isShow[i] = false;
          }
        }
        // moveToSelectStore(position);
        _loadAndShowContent(cards[position].cardNo, position);
      },
    );
  }

  Widget _cardContent(RemoteBankCard card, int position) {
    List<Widget> contenttList = [];
    if (_totalbalMap.length > 0) {
      List<CardBalBean> balList = _totalbalMap[position];
      balList.forEach((element) {
        String ccy = element.ccy ?? '';
        String totalAmt = element.currBal ?? '';
        contenttList.add(
          _infoFrame("${S.current.account_balance}($ccy)",
              FormatUtil.formatSringToMoney(totalAmt, ccy)),
        );
      });
    }
    contenttList.add(
      _infoFrame(S.current.single_transfer_limit,
          FormatUtil.formatSringToMoney(_cardLimitMap[position].singleLimit)),
    );
    contenttList.add(
      _infoFrame(
          S.current.single_day_transfer_limit,
          FormatUtil.formatSringToMoney(
              _cardLimitMap[position].singleDayLimit)),
    );
    contenttList.add(
      _infoFrame(S.current.single_day_transfer_count_limit,
          _cardLimitMap[position].singleDayCountLimit.toString()),
    );
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 100),
      color: Colors.white,
      child: Column(
        children: contenttList,
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

  // 移动到指定的 index  对应某行
  void moveToSelectStore(index) async {
    var widgetOffset = Offset(0, 50 * index);
    _scrollController.position
        .moveTo(widgetOffset.dy, duration: Duration(milliseconds: 200));
  }

  _loadData() {
    if (_cardsLength == 0) {
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    }
    // CardDataRepository()
    ApiClientAccount().getCardList(GetCardListReq()).then((data) {
      if (data.cardList != null) {
        if (this.mounted) {
          setState(() {
            cards.clear();
            _totalbalMap.clear();
            _cardLimitMap.clear();
            cards.addAll(data.cardList);
            _cardsLength = cards.length;
            if (_isShow.length == 0) {
              _isShow = new List.filled(_cardsLength, false);
              // print(_isShow.toString());
            } else {
              for (int i = 0; i < _isShow.length; i++) {
                if (_isShow[i] == true) {
                  _isShow[i] = false;
                }
              }
            }
            _refreshController.refreshCompleted();
            _refreshController.footerMode.value = LoadStatus.canLoading;
            _isLoading = false;
          });
        }
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      HSProgressHUD.showToast(e.error);
    });
  }

  // _showContent(String cardNo, int position) {
  //   if (_isShow[position] == true) {
  //     setState(() {
  //       _isShow[position] = false;
  //     });
  //   } else {
  //     _loadContent(cardNo, position);
  //     setState(() {
  //       _isShow[position] = true;
  //     });
  //   }
  // }

  // _loadContent(String cardNo, int position) {
  //   HSProgressHUD.show();
  //   //如果没有请求过数据，则请求一遍
  //   if (_totalbal.length == 0) {
  //     for (int i = 0; i < cards.length; i++) {
  //       Future.wait({
  //         CardDataRepository().getCardLimitByCardNo(
  //             GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq'),
  //         CardDataRepository().getCardBalByCardNo(
  //             GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
  //       }).then((data) {
  //         data.forEach((element) {
  //           if (element is GetCardLimitByCardNoResp) {
  //             setState(() {
  //               _cardLimitList.insert(position, element);
  //             });
  //           } else if (element is GetSingleCardBalResp) {
  //             setState(() {
  //               Map map = <String, String>{};
  //               map["currBal"] = element.cardListBal[0].currBal;
  //               map["ccy"] = element.cardListBal[0].ccy;
  //               _totalbal.insert(position, map);
  //               print(_totalbal.toString());
  //             });
  //           }
  //         });
  //       });
  //     }
  //   }
  //   HSProgressHUD.dismiss();
  // }

  _loadAndShowContent(String cardNo, int position) async {
    if (_isShow[position] == true) {
      setState(() {
        _isShow[position] = false;
      });
    } else {
      //判断position是否加载过数据，加载过直接显示
      GetCardLimitByCardNoResp data = _cardLimitMap[position];
      // print(data);
      // print(data != null);
      if (data != null) {
        HSProgressHUD.show();
        setState(() {
          _isShow[position] = true;
        });
        HSProgressHUD.dismiss();
      } else {
        //没有加载过就进入这一步
        HSProgressHUD.show();
        Future.wait({
          // CardDataRepository()
          ApiClientAccount()
              .getCardLimitByCardNo(GetCardLimitByCardNoReq(cardNo)),
          // CardDataRepository()
          ApiClientAccount().getCardBalByCardNo(GetSingleCardBalReq(cardNo)),
        }).then((data) {
          print(data);
          data.forEach((element) {
            if (element is GetCardLimitByCardNoResp) {
              if (this.mounted) {
                setState(() {
                  //额度详情
                  _cardLimitMap[position] = element;
                  // _cardLimitList.insert(position, element);
                });
              }
            } else if (element is GetSingleCardBalResp) {
              if (this.mounted) {
                setState(() {
                  //余额+币种
                  if (element.cardListBal.length > 0) {
                    _totalbalMap[position] = element.cardListBal;
                  }

                  // _totalbalMap[position].currBal;
                  // Map map = <String, String>{};
                  // map["currBal"] = element.cardListBal[0].currBal;
                  // map["ccy"] = element.cardListBal[0].ccy;
                  // _totalbal.insert(position, map);
                });
              }
            }
          });
          _isShow[position] = true;
          HSProgressHUD.dismiss();
        }).catchError((e) {
          HSProgressHUD.dismiss();
          HSProgressHUD.showToast(e.error);
        });
      }
    }
  }

  // void go2Detail(RemoteBankCard card) {
  //   Navigator.pushNamed(context, pageCardDetail, arguments: card);
  // }
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
