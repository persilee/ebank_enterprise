import 'dart:wasm';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 账户总览
/// Author: CaiTM
/// Date: 2020-12-07

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/account/get_account_overview_info.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list_bal_by_user.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_bill.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:ebank_mobile/page/approval/widget/not_data_container_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_error_page.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountOverviewNewPage extends StatefulWidget {
  @override
  _AccountOverviewNewPageState createState() => _AccountOverviewNewPageState();
}

class _AccountOverviewNewPageState extends State<AccountOverviewNewPage> {
  String totalAssets = '0.00';
  String netAssets = '0.00';
  String totalLiabilities = '0.00';
  String localCcy = '';
  String ddTotal = '0';
  String ddCcy = '';
  String tdTotal = '0';
  String lnTotal = '0';

  int pageSize = 10;
  String ddNextKey = '';
  String tdNextKey = '';
  String lnNextKey = '';
  bool isShowDD = true;
  bool isShowTD = false;
  bool isShowLN = false;

  List<CardListBal> ddList = [];
  List<TedpListBal> tdList = [];
  List<LnListBal> lnList = [];
  List<String> cardNoList = [];
  bool _isLoading = true;
  bool _isNegative = false;

  //判断是否是总资产
  bool isTotalAsset = true;

  RefreshController _refreshController;

  bool _isDDLoading = true;
  bool _isTDLoading = true;
  bool _isLNLoading = true;
  RefreshController _ddRefreshController;
  RefreshController _tdRefreshController;
  RefreshController _lnRefreshController;

  @override
  // ignore: must_call_super
  void initState() {
    _refreshController = RefreshController();

    _ddRefreshController = RefreshController();
    _tdRefreshController = RefreshController();
    _lnRefreshController = RefreshController();
    // 网络请求
    // setState(() {
    _loadAssets();
    _loadDDNetWork();
    // _getCardList();
    // });
  }

  @override
  void dispose() {
    _refreshController.dispose();

    _ddRefreshController.dispose();
    _tdRefreshController.dispose();
    _lnRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _contentListView(),
      // body: Column(
      //   children: [
      //     _isLoading
      //         ? Expanded(
      //             child: HsgLoading(),
      //           )
      //         : Expanded(
      //             child: CustomRefresh(
      //               controller: _refreshController,
      //               onLoading: () {
      //                 //加载更多完成
      //                 _refreshController.loadComplete();
      //                 //显示没有更多数据
      //                 _refreshController.loadNoData();
      //               },
      //               onRefresh: () {
      //                 _refreshController.refreshCompleted();
      //                 _refreshController.footerMode.value =
      //                     LoadStatus.canLoading;
      //               },
      //               content: _contentListView(),
      //             ),
      //           ),
      //   ],
      // ),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(S.of(context).account_overview),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Color(0xffFEFEFE),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Color(0xffFEFEFE),
          fontSize: 18,
          fontStyle: FontStyle.normal,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF1775BA),
            Color(0xFF3A9ED1),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF1775BA),
              Color(0xFF3A9ED1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: Column(
            children: [
              _accountOverviewColumn(),
              Container(
                color: HsgColors.backgroundColor,
                height: 12,
              ),
              isTotalAsset ? _assetsTDAndDD(context) : _liabilitiesLn(context),
            ],
          ),
        ),
        preferredSize: Size(30, 200), //200//135
      ),
    );
  }

  _contentListView() {
    Widget _listView = ListView(
      children: [
        //  活期
        isTotalAsset
            ? Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Text(
                  S.current.demand_deposit,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: HsgColors.aboutusTextCon),
                ),
              )
            : Container(),
        //活期合计
        isTotalAsset
            ? Container(
                child: _ddTotalColumn(),
              )
            : Container(),
        //活期列表
        isTotalAsset
            ? Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ddList.length,
                  itemBuilder: (context, index) {
                    return _ddListView(index);
                  },
                ),
              )
            : Container(),
        isTotalAsset
            ? Container(
                height: 12,
              )
            : Container(),

        // 定期
        (tdTotal != '0')
            ? isTotalAsset
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text(
                      S.current.time_deposits,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: HsgColors.aboutusTextCon),
                    ))
                : Container()
            : Container(),
        (tdTotal != '0')
            ? isTotalAsset
                ? Container(
                    child: _tdTotalColumn(),
                  )
                : Container()
            : Container(),
        (tdTotal != '0')
            ? isTotalAsset
                ? Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tdList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _tdListView(index);
                      },
                    ),
                  )
                : Container()
            : Container(),
        isTotalAsset
            ? Container(
                height: 12,
              )
            : Container(),

        // 贷款
        (!isTotalAsset)
            ? (lnTotal != '0')
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text(
                      S.current.loan,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: HsgColors.aboutusTextCon),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'images/noDataIcon/no_data_record.png'),
                          width: 160,
                        ),
                        Text(
                          S.current.no_data_now,
                          style: FIRST_DEGREE_TEXT_STYLE,
                        )
                      ],
                    ),
                  )
            : Container(),
        (!isTotalAsset)
            ? (lnTotal != '0')
                ? Container(
                    child: _lnTotalColumn(),
                  )
                : Container()
            : Container(),
        (!isTotalAsset)
            ? (lnTotal != '0')
                ? Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lnList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _lnListView(index);
                      },
                    ),
                  )
                : Container()
            : Container(),

        Container(
          child: Container(
            height: 20,
          ),
        ),
      ],
    );

    Widget _headerAdapter = SliverToBoxAdapter(
      child: Container(
        height: 12,
      ),
    );

    double height = MediaQuery.of(context).size.height - 200 - 100;
    Widget _noDataWidget = SliverToBoxAdapter(
      child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(child: Container()),
            Image(
              image: AssetImage('images/noDataIcon/no_data_record.png'),
              width: 160,
            ),
            Text(
              S.current.no_data_now,
              style: FIRST_DEGREE_TEXT_STYLE,
            ),
          ],
        ),
      ),
    );

    Widget _ddSliverView = ddList.length > 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _ddListView(index);
            },
            childCount: ddList.length,
          ))
        : _noDataWidget;

    Widget _tdSliverView = tdList.length > 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _tdListView(index);
            },
            childCount: tdList.length,
          ))
        : _noDataWidget;

    Widget _lnSliverView = lnList.length > 0
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _lnListView(index);
            },
            childCount: lnList.length,
          ))
        : _noDataWidget;

    List<Widget> showSlivers = [];
    RefreshController refreshC;
    Widget contentW;

    if (isTotalAsset) {
      showSlivers.add(_headerAdapter);
      if (isShowDD) {
        showSlivers.add(_ddSliverView);
        refreshC = _ddRefreshController;
        contentW = _isDDLoading
            ? Expanded(
                child: HsgLoading(),
              )
            : CustomScrollView(slivers: showSlivers);
      } else {
        showSlivers.add(_tdSliverView);
        refreshC = _tdRefreshController;
        contentW = _isTDLoading
            ? Expanded(
                child: HsgLoading(),
              )
            : CustomScrollView(slivers: showSlivers);
      }
    } else {
      showSlivers.add(_headerAdapter);
      showSlivers.add(_lnSliverView);
      refreshC = _lnRefreshController;
      contentW = _isLNLoading
          ? Expanded(
              child: HsgLoading(),
            )
          : CustomScrollView(slivers: showSlivers);
    }

    Widget _scrollView = CustomRefresh(
      controller: refreshC,
      onRefresh: () async {
        // //刷新完成
        if (isTotalAsset) {
          if (isShowDD) {
            ddNextKey = '';
          } else {
            tdNextKey = '';
          }
        } else {
          lnNextKey = '';
        }

        await _loadListNetWorkEntr();
        refreshC.refreshCompleted();
        refreshC.footerMode.value = LoadStatus.canLoading;
      },
      onLoading: () async {
        await _loadListNetWorkEntr();
        // refreshC.loadComplete();
      },
      content: contentW,
    );

    return _scrollView;
    // return _listView;
  }

  //贷款列表
  Container _lnListView(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lnList[index].cardNo,
            //acNo
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            //unpaidPrincipal
            FormatUtil.formatSringToMoney(
                    lnList[index].currBal, lnList[index].ccy) +
                ' ' +
                lnList[index].ccy,
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _lnTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(lnTotal) + ' ' + localCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //定期列表
  Container _tdListView(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tdList[index].cardNo, //.cardNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(
                    tdList[index].currBal, tdList[index].ccy) +
                ' ' +
                tdList[index].ccy, //currbal
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _tdTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(tdTotal) + ' ' + localCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //活期列表
  Container _ddListView(int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 18),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ddList[index].cardNo,
            style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
          ),
          Text(
            FormatUtil.formatSringToMoney(
                    ddList[index].currBal, ddList[index].ccy) +
                ' ' +
                ddList[index].ccy,
            style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
          )
        ],
      ),
    );
  }

  Column _ddTotalColumn() {
    return Column(
      children: [
        Container(height: 0.5, color: HsgColors.divider),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.total,
                style: TextStyle(fontSize: 15, color: Color(0xFF8D8D8D)),
              ),
              Text(
                FormatUtil.formatSringToMoney(ddTotal) + ' ' + ddCcy,
                style: TextStyle(fontSize: 15, color: Color(0xFF262626)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _accountOverviewColumn() {
    Color colorOne;
    Color colorTwo;
    double bottomLeft;
    double bottomRight;
    Color hintColortone;
    Color hintColortwo;
    bool shoDowOne;
    bool shoDowTwo;
    //isTotalAsset ? hintColor = Colors.white : Colors.white54;
    if (isTotalAsset) {
      colorOne = Color(0xFF25BAFF);
      colorTwo = Color(0xFF2080C0);
      bottomLeft = 20;
      bottomRight = 0;
      hintColortone = Colors.white;
      hintColortwo = Colors.white54;
      shoDowOne = true;
      shoDowTwo = false;
    } else {
      colorOne = Color(0xFF2080C0);
      colorTwo = Color(0xFF25BAFF);
      bottomLeft = 0;
      bottomRight = 20;
      hintColortone = Colors.white54;
      hintColortwo = Colors.white;
      shoDowOne = false;
      shoDowTwo = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //净资产
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: _totalAssets(),
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //总资产
            InkWell(
              onTap: () {
                setState(() {
                  print('点击总资产');
                  isTotalAsset = true;
                  int showIndex = isShowDD ? 0 : 1;
                  changeShowJudge(showIndex);
                });
              },
              child: _netAssets(
                  S.current.total_assets,
                  localCcy,
                  netAssets, //总资产金额
                  colorOne,
                  0,
                  bottomRight,
                  colorTwo,
                  hintColortone,
                  shoDowOne,
                  true),
            ),

            //总负债
            InkWell(
              onTap: () {
                setState(() {
                  isTotalAsset = false;
                  changeShowJudge(2);
                  print("点击总负债 $isTotalAsset");
                });
              },
              child: _netAssets(
                  S.current.total_liability,
                  localCcy,
                  lnTotal, //总负债金额
                  colorTwo,
                  bottomLeft,
                  0,
                  colorOne,
                  hintColortwo,
                  shoDowTwo,
                  false),
            ),
          ],
        ),
      ],
    );
  }

  Column _totalLiability() {
    return Column(
      children: [
        Text(
          S.current.total_liability,
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
        Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
        Text(
          localCcy + ' ' + FormatUtil.formatSringToMoney(totalLiabilities),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Container _netAssets(
    String title,
    String localCcy,
    String netAssets, //金额
    Color color, //根据资产和负债传入颜色
    double bottomleftRadius, //底部左边距圆角
    double bottomrightRadius, //底部右边距圆角
    Color backgroundColor, //大的container背景色
    Color hintColor, //字体颜色
    bool isboxShadow,
    bool isflex, //阴影偏移量
  ) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              isboxShadow
                  ? BoxShadow(
                      color: Color(0XFF192A56),
                      offset: isflex
                          ? Offset(0.0, 0.0)
                          : Offset(5.0, 0.0), //阴影xy轴偏移量
                      blurRadius: 3.0, //阴影模糊程度
                    )
                  : BoxShadow(color: Color(0xFF2F323E), blurRadius: 0.0)
            ],
            color: color,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(bottomleftRadius),
                bottomRight: Radius.circular(bottomrightRadius))),
        child: Column(
          children: [
            //总资产
            Container(
              padding: EdgeInsets.only(left: 18, top: 9),
              width: MediaQuery.of(context).size.width / 2,
              //color: color,
              child: Text(
                title,
                style: TextStyle(fontSize: 13.5, color: Colors.white54),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 18, top: 7),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 22,
              child: Text(
                  localCcy + ' ' + FormatUtil.formatSringToMoney(netAssets),
                  style: TextStyle(fontSize: 11, color: hintColor)),
            ),
          ],
        ),
      ),
    );
  }

//资产定期和活期列表的选项卡
  Widget _assetsTDAndDD(BuildContext context) {
    Widget _contentWidget = Row(
      children: [
        _assetsWidget(
          context,
          isShowDD,
          S.current.demand_deposit,
          ddCcy + ' ' + FormatUtil.formatSringToMoney(ddTotal),
          () {
            if (isShowDD == true) {
              return;
            }
            changeShowJudge(0);
          },
        ),
        _assetsWidget(
          context,
          isShowTD,
          S.current.time_deposits,
          localCcy + ' ' + FormatUtil.formatSringToMoney(tdTotal),
          () {
            if (isShowTD == true) {
              return;
            }
            changeShowJudge(1);
          },
        ),
        Container(
          height: 10,
        ),
      ],
    );

    Widget _assetsTDDDWidget = Container(
      color: Color(0xFFE2E8EC),
      child: _contentWidget,
    );

    return _assetsTDDDWidget;
  }

  //负债贷款列表的选项卡
  Widget _liabilitiesLn(BuildContext context) {
    Widget _contentWidget = Row(
      children: [
        _assetsWidget(
          context,
          isShowLN,
          S.current.loan,
          localCcy + ' ' + FormatUtil.formatSringToMoney(lnTotal),
          () {
            if (isShowLN == true) {
              return;
            }
            changeShowJudge(2);
          },
        ),
        // _assetsWidget(
        //   context,
        //   false,
        //   S.current.credit_card,
        //   localCcy + ' ' + FormatUtil.formatSringToMoney(tdTotal),
        // ),
        Container(
          height: 10,
        ),
      ],
    );

    Widget _liabilitiesLnWidget = Container(
      color: Color(0xFFE2E8EC),
      child: _contentWidget,
    );

    return _liabilitiesLnWidget;
  }

//活期和定期列表的选项卡模板
  Widget _assetsWidget(
    BuildContext context,
    bool isSelect,
    String titleStr,
    String contentStr,
    VoidCallback callback,
  ) {
    Widget _showConttentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            titleStr,
            style: TextStyle(
              color: isSelect ? Color(0xFF3497CD) : HsgColors.secondDegreeText,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            contentStr,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: isSelect ? Color(0xFF3497CD) : HsgColors.secondDegreeText,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          height: 3,
          // color: Color(0xFF3497CD),
          decoration: BoxDecoration(
            color: isSelect ? Color(0xFF3497CD) : Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(1.5),
            ),
          ),
        ),
      ],
    );

    Widget _btnWidget = FlatButton(
      onPressed: () {
        callback();
      },
      child: Container(),
    );
    Widget _assetsWidget = Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Stack(
        children: [
          _showConttentWidget,
          _btnWidget,
        ],
      ),
    );

    return _assetsWidget;
  }

  //净资产
  Column _totalAssets() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            S.current.net_assets,
            style: TextStyle(fontSize: 18, color: Colors.white54),
          ),
          alignment: Alignment.topLeft,
        ),
        Container(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            _isNegative
                ? localCcy + ' -' + FormatUtil.formatSringToMoney(totalAssets)
                : localCcy + ' ' + FormatUtil.formatSringToMoney(totalAssets),
            style: TextStyle(
                fontSize: 22.5,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }

  Column _dividingLine() {
    return Column(
      children: [
        SizedBox(
          width: 1,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _getCardList() async {
    // CardDataRepository()
    // setState(() {
    //   _isLoading = true;
    // });
    ApiClientAccount().getCardList(GetCardListReq()).then((data) {
      if (data.cardList != null) {
        // if (mounted) {
        //   setState(() {
        data.cardList.forEach((item) {
          cardNoList.add(item.cardNo);
        });
        // });
        // }
        _getAccountOverviewInfo();
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }

  _getAccountOverviewInfo() async {
    _isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);

    // setState(() {
    localCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    // });
    // 一个接口拿活期，定期总额
    // DepositDataRepository()
    ApiClientBill()
        .getCardListBalByUser(
      GetCardListBalByUserReq(
        '',
        custID,
      ),
    )
        .then((data) {
      if (data.cardListBal != null) {
        if (mounted) {
          setState(() {
            //总资产
            netAssets = data.totalAmt;
            //活期列表
            ddList = data.cardListBal;
            if (data.ddTotalAmt != '0') {
              //活期合计
              ddTotal = data.ddTotalAmt;
            }
            //定期列表
            tdList = data.tedpListBal;
            if (data.tdTotalAmt != '0') {
              //定期合计
              tdTotal = data.tdTotalAmt;
            }
            //总负债
            lnTotal = data.lnTotalAmt;
            //贷款列表
            lnList = data.lnListBal;

            ddCcy = data.defaultCcy == null ? localCcy : data.defaultCcy;
            //净资产
            var netAssetCompute = double.parse(netAssets);
            var lnTotalCompute = double.parse(lnTotal);
            //判断是否为负数
            if (lnTotalCompute > netAssetCompute) {
              _isNegative = true;
            }
            double totalAssetsCompute = netAssetCompute - lnTotalCompute;
            print('totalAssetsCompute=$totalAssetsCompute');
            totalAssets = totalAssetsCompute.toStringAsFixed(2);
            _isLoading = false;
          });
        }
      }
    }).catchError((e) {
      _isLoading = false;
      HSProgressHUD.showToast(e);
    });
  }

  void changeShowJudge(int showIndex) {
    if (isTotalAsset) {
      isShowDD = false;
      isShowTD = false;
    } else {
      isShowLN = false;
    }

    switch (showIndex) {
      case 0:
        isShowDD = true;
        if (_isDDLoading == true) {
          _loadListNetWorkEntr();
        }
        break;
      case 1:
        isShowTD = true;
        if (_isTDLoading == true) {
          _loadListNetWorkEntr();
        }
        break;
      case 2:
        isShowLN = true;
        if (_isLNLoading == true) {
          _loadListNetWorkEntr();
        }
        break;
      default:
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadAssets() async {
    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);
    localCcy = prefs.getString(ConfigKey.LOCAL_CCY);

    try {
      GetTotalAssetsResp resp =
          await ApiClientBill().getTotalAssets(GetTotalAssetsReq(custID));
      setState(() {
        totalAssets = resp.totalAssets;
        netAssets = resp.netAssets;
        totalLiabilities = resp.totalLiability;
        ddTotal = resp.ddTotal;
        tdTotal = resp.tdTotal;
        lnTotal = resp.lnTotal;
        // //判断是否为负数
        //     if (lnTotalCompute > netAssets) {
        //       _isNegative = true;
        //     }
      });
    } catch (e) {
      HSProgressHUD.showToast(e);
    }
  }

  Future<void> _loadListNetWorkEntr() async {
    // 0 DD 1 TD 2 LN
    int currentlyShowIndex = 0;
    if (isTotalAsset) {
      if (isShowDD) {
        currentlyShowIndex = 0;
      } else {
        currentlyShowIndex = 1;
      }
    } else {
      // if (isShowLN) {
      currentlyShowIndex = 2;
      // } else {
      // currentlyShowIndex = 2;
      // }
    }

    switch (currentlyShowIndex) {
      case 0:
        return _loadDDNetWork();
        break;
      case 1:
        return _loadTDNetWork();
        break;
      case 2:
        return _loadLNNetWork();
        break;
      default:
    }
  }

  Future<void> _loadDDNetWork() async {
    try {
      GetCardListBalByUserResp resp = await _loadListNetWork('SA', ddNextKey);
      if (mounted) {
        setState(() {
          _isDDLoading = false;
          if (ddNextKey == '' || ddNextKey == null) {
            ddList = resp.cardListBal;
          } else {
            ddList.addAll(resp.cardListBal);
          }
          ddNextKey = resp.nextKey;

          _ddRefreshController.loadComplete();
          if (resp.nextKey == null || resp.nextKey == '') {
            _ddRefreshController.loadNoData();
          } else {
            _ddRefreshController.footerMode.value = LoadStatus.canLoading;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLNLoading = false;
        });
      }
      HSProgressHUD.showToast(e);
    }
  }

  Future<void> _loadTDNetWork() async {
    try {
      GetCardListBalByUserResp resp = await _loadListNetWork('TD', tdNextKey);
      if (mounted) {
        setState(() {
          _isTDLoading = false;
          if (tdNextKey == '' || tdNextKey == null) {
            tdList = resp.tedpListBal;
          } else {
            tdList.addAll(resp.tedpListBal);
          }
          tdNextKey = resp.nextKey;

          _tdRefreshController.loadComplete();
          if (resp.nextKey == null || resp.nextKey == '') {
            _tdRefreshController.loadNoData();
          } else {
            _tdRefreshController.footerMode.value = LoadStatus.canLoading;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLNLoading = false;
        });
      }
      HSProgressHUD.showToast(e);
    }
  }

  Future<void> _loadLNNetWork() async {
    try {
      GetCardListBalByUserResp resp = await _loadListNetWork('LN', lnNextKey);
      if (mounted) {
        setState(() {
          _isLNLoading = false;
          if (lnNextKey == '' || lnNextKey == null) {
            lnList = resp.lnListBal;
          } else {
            lnList.addAll(resp.lnListBal);
          }
          lnNextKey = resp.nextKey;

          _tdRefreshController.loadComplete();
          if (resp.nextKey == null || resp.nextKey == '') {
            _lnRefreshController.loadNoData();
          } else {
            _lnRefreshController.footerMode.value = LoadStatus.canLoading;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLNLoading = false;
        });
      }
      HSProgressHUD.showToast(e);
    }
  }

  Future<GetCardListBalByUserResp> _loadListNetWork(
      String accountType, String nextKey) async {
    //SA：储蓄账户，CA往来账户，TD定期账户，LN贷款账户，不传查所有

    final prefs = await SharedPreferences.getInstance();
    String custID = prefs.getString(ConfigKey.CUST_ID);
    return ApiClientBill().getCardListBalByUser(GetCardListBalByUserReq(
      accountType,
      custID,
      nextKey: nextKey,
    ));
  }
}
