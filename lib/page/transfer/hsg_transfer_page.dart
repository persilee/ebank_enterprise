/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';

import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/custom_refresh.dart';
import 'package:ebank_mobile/widget/hsg_loading.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransferPage extends StatefulWidget {
  TransferPage({Key key}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  var _partnerListData = [];
  var cards = [];
  String _language = Intl.getCurrentLocale();
  //是否显示无数据页面 true显示
  bool _isShowNoDataWidget = false;
  bool _isLoading = false;
  bool _headColor = true;
  RefreshController _refreshController;
  ScrollController _scrollController;

  //顶部网格数据
  List<Map<String, Object>> _gridFeatures = [
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_timely.png',
      'btnTitle': S.current.transfer_type_0,
    },
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_timely1.png',
      'btnTitle': S.current.transfer_type_1
    },
    {
      'btnIcon':
          'images/transferIcon/transfer_features_icon/transfer_features_record.png',
      'btnTitle': S.current.transfer_record
    },
  ];
  //网格下面列表数据

  List<Map<String, Object>> _listFeatures = [
    {
      'btnIcon': '',
      'btnTitle': S.current.transfer_type_1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _loadData();
    //滚动监听
    // _scrollController.addListener(() {
    //   setState(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       _headColor = false;
    //     } else {
    //       _headColor = true;
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _recently(),
          _isLoading
              ? Container(
                  margin: EdgeInsets.only(top: 50),
                  child: HsgLoading(),
                )
              : Expanded(
                  child: CustomRefresh(
                    controller: _refreshController,
                    onLoading: () {
                      //加载更多完成
                      _refreshController.loadComplete();
                      //显示没有更多数据
                      _refreshController.loadNoData();
                    },
                    onRefresh: () {
                      //刷新完成
                      _refreshController.refreshCompleted();
                      _refreshController.footerMode.value =
                          LoadStatus.canLoading;
                    },
                    content: ListView.builder(
                      // padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
                      itemCount: _partnerListData.length,
                      // controller: _scrollController,
                      itemBuilder: (context, index) {
                        return _partnerListItemWidget(_partnerListData[index]);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
    // Stack(
    // children: [
    //   Container(
    //     child:
    //     CustomScrollView(
    //       slivers: _sliversSection(_gridFeatures, _listFeatures),
    //       controller: _scrollController,
    //     ),
    //   ),
    // ],
    // ),
  }

  _appBar() {
    return AppBar(
      title: Text(S.of(context).transfer),
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
        // height: 110,
      ),
      bottom: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF1775BA),
              Color(0xFF3A9ED1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          // height: 50,
          width: double.infinity,
          // color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _graphicButton(
                _gridFeatures[0]['btnTitle'],
                _gridFeatures[0]['btnIcon'],
                35,
                () {
                  //行内转账
                  Navigator.pushNamed(context, pageTransferInternal);
                },
              ),
              _graphicButton(
                _gridFeatures[1]['btnTitle'],
                _gridFeatures[1]['btnIcon'],
                35,
                () {
                  //'跨行转账'
                  Navigator.pushNamed(context, pageTrasferInternational);
                },
              ),
              _graphicButton(
                _gridFeatures[2]['btnTitle'],
                _gridFeatures[2]['btnIcon'],
                35,
                () {
                  //转账记录
                  Navigator.pushNamed(context, pageTransferRecord);
                },
              ),
            ],
          ),
        ),
        preferredSize: Size(30, 110),
      ),
    );
  }

  List<Widget> _sliversSection(List gridData, List listData) {
    List<Widget> section = [];

    //导航栏
    section.add(
      SliverAppBar(
        title: Text(S.of(context).transfer),
        centerTitle: true,
        pinned: true,
        backgroundColor: Colors.yellowAccent[300],
        floating: true,
        expandedHeight: 170.0,
        elevation: 1,
        iconTheme: IconThemeData(
            color: _headColor ? Color(0xffFEFEFE) : Color(0xff262626)),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: _headColor ? Color(0xffFEFEFE) : Color(0xff262626),
            fontSize: 18,
            fontStyle: FontStyle.normal,
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF1775BA),
                Color(0xFF3A9ED1),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
            height: 110,
            //渐变内容
            child: Container(
              margin: EdgeInsets.only(top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _graphicButton(
                    gridData[0]['btnTitle'],
                    gridData[0]['btnIcon'],
                    35,
                    () {
                      //行内转账
                      Navigator.pushNamed(context, pageTransferInternal);
                    },
                  ),
                  _graphicButton(
                    gridData[1]['btnTitle'],
                    gridData[1]['btnIcon'],
                    35,
                    () {
                      //'跨行转账'
                      Navigator.pushNamed(context, pageTrasferInternational);
                    },
                  ),
                  _graphicButton(
                    gridData[2]['btnTitle'],
                    gridData[2]['btnIcon'],
                    35,
                    () {
                      //转账记录
                      Navigator.pushNamed(context, pageTransferRecord);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    ///功能网格
    // section.add(SliverGrid(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisSpacing: 0,
    //     mainAxisSpacing: 0,
    //     crossAxisCount: 3,
    //     childAspectRatio: 1,
    //   ),
    //   delegate: SliverChildBuilderDelegate(
    //     (BuildContext context, int index) {
    //       return Container(
    //         // color: Color(0xFF1775BA),
    //         // decoration: BoxDecoration(
    //         //   gradient: LinearGradient(colors: [
    //         //     Color(0xFF1775BA),
    //         //     Color(0xFF3A9ED1),
    //         //   ], begin: Alignment.centerLeft, end: Alignment.centerRight),
    //         // ),
    //         height: 110,
    //         child: _graphicButton(
    //           gridData[index]['btnTitle'],
    //           gridData[index]['btnIcon'],
    //           35,
    //           () {
    //             String title = gridData[index]['btnTitle'];
    //             if (S.current.transfer_type_0 == title) {
    //               //行内转账
    //               //  go2Detail(cards[1]);
    //               Navigator.pushNamed(context, pageTransferInternal);
    //             } else if (S.of(context).transfer_type_1 == title) {
    //               //'跨行转账'
    //               Navigator.pushNamed(context, pageTrasferInternational);
    //             } else if (S.current.transfer_record == title) {
    //               //转账记录
    //               Navigator.pushNamed(context, pageTransferRecord);
    //             }
    //           },
    //         ),
    //       );
    //     },
    //     childCount: gridData.length,
    //   ),
    // ));

    // section.add(SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (content, index) {
    //       // Navigator.pushNamed(context, pageInternational);

    //       return _featureListItemWidget('${listData[index]['btnTitle']}');
    //     },
    //     childCount: listData.length,
    //   ),
    // ));

    ///最近转账账号横条
    section.add(SliverToBoxAdapter(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: HsgColors.commonBackground,
              height: 10,
            ),
            Container(
              color: Colors.white,
              height: 40,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                S.of(context).recent_transfer_account,
                style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ],
        ),
      ),
    ));

    ///转账范本列表
    section.add(
      _isLoading
          ? SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                child: HsgLoading(),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (content, index) {
                  return _partnerListItemWidget(_partnerListData[index]);
                },
                childCount: _partnerListData.length,
              ),
            ),
      // : SliverToBoxAdapter(
      //     child: CustomRefresh(
      //       controller: _refreshController,
      //       onLoading: () {
      //         //加载更多完成
      //         _refreshController.loadComplete();
      //         //显示没有更多数据
      //         // _refreshController.loadNoData();
      //       },
      //       onRefresh: () {
      //         //刷新完成
      //         _refreshController.refreshCompleted();
      //         _refreshController.footerMode.value = LoadStatus.canLoading;
      //       },
      //       content: SliverList(
      //         delegate: SliverChildBuilderDelegate(
      //           (content, index) {
      //             return _partnerListItemWidget(_partnerListData[index]);
      //           },
      //           childCount: _partnerListData.length,
      //         ),
      //       ),
      //     ),
      //   ),
    );

    //没数据显示页面
    Widget _noDataWidget = Container(
      width: (MediaQuery.of(context).size.width),
      height: 270,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 45),
            child: Image(
              image: AssetImage('images/noDataIcon/no_data_person.png'),
              width: 159,
              height: 128,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              S.of(context).no_recent_transfer_account,
              style: TextStyle(color: HsgColors.describeText, fontSize: 15.0),
            ),
          ),
        ],
      ),
    );

    ///底部加长条，外带暂无数据显示widget
    section.add(SliverToBoxAdapter(
      child: Column(
        children: [
          _isShowNoDataWidget ? _noDataWidget : Container(),
          Container(
            height: 20,
          ),
        ],
      ),
    ));

    return section;
  }

  ///上图下文字的按钮
  Widget _graphicButton(
      String title, String iconName, double iconWidth, VoidCallback onClick) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.only(left: 2, right: 2),
        onPressed: onClick,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 28),
              child: Image(
                image: AssetImage(iconName),
                width: iconWidth,
                height: iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///功能列表单元widget
  Widget _featureListItemWidget(String textTitle) {
    return Container(
      height: 50,
      color: Colors.white,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                textTitle,
                style:
                    TextStyle(color: HsgColors.firstDegreeText, fontSize: 15),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: HsgColors.firstDegreeText,
              size: 18,
            ),
          ],
        ),
        //国际转账
        onPressed: () {
          Navigator.pushNamed(context, pageTrasferInternational);
        },
      ),
    );
  }

  ///最近转账账号列表单元widget
  Widget _partnerListItemWidget(Rows data) {
    //银行图标
    Widget _bankImgWidget = Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(46.0 / 2),
      ),
      child: ClipOval(
        child: (data.payeeBankImageUrl == null || data.payeeBankImageUrl == '')
            ? Image(
                image: AssetImage(
                  'images/transferIcon/transfer_head.png',
                ),
              )
            : FadeInImage.assetNetwork(
                fit: BoxFit.fitWidth,
                image: data.payeeBankImageUrl,
                placeholder:
                    'images/transferIcon/transfer_sample_placeholder.png',
              ),
      ),
    );

    //中间两行文字（收款人姓名，卡号）
    Widget _middleInfoWidget = Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 20,
            child: Text(
              data.payeeName,
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _language == 'zh_CN'
                ? data.payeeBankLocalName == null
                    ? '朗华银行'
                    : data.payeeBankLocalName
                : data.payeeBankEngName == null
                    ? 'Brillink bank'
                    : data.payeeBankEngName,
            // data.payeeBankLocalName == null ? '朗华银行' : data.payeeBankLocalName,
            style: TextStyle(fontSize: 13, color: HsgColors.describeText),
          ),
          Row(
            children: [
              data.payeeCardNo.length > 12
                  ? Container(
                      width: 100,
                      child: Text(
                        FormatUtil.formatSpace4(data.payeeCardNo),
                        style: TextStyle(
                          color: HsgColors.describeText,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      FormatUtil.formatSpace4(data.payeeCardNo),
                      style: TextStyle(
                        color: HsgColors.describeText,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: 1,
                  height: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: HsgColors.describeText),
                  ),
                ),
              ),
              Text(
                data.transferType == '0'
                    ? S.current.transfer_type_0_short
                    : S.current.transfer_type_1_short,
                style: TextStyle(fontSize: 13, color: HsgColors.describeText),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
    //右侧转出按钮
    FlatButton _transferToBtn = FlatButton(
      child: Text(
        S.of(context).transfer_out,
        style: TextStyle(
          color: Color(0xff3394D4),
          fontSize: 13,
        ),
      ),
      onPressed: () {
        print('转出');
        if (data.transferType == '2') {
          Navigator.pushNamed(context, pageTrasferInternational,
              arguments: data);
        } else if (data.transferType == '1') {
        } else {
          Navigator.pushNamed(context, pageTransferInternal, arguments: data);
        }
      },
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xff3394D4), width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    return Container(
      height: 80,
      decoration: BoxDecoration(
        //背景色
        color: Colors.white,
        //设置底部边框
        border: new Border(
          bottom: BorderSide(color: HsgColors.divider, width: 0.5),
        ),
      ),
      child: FlatButton(
        child: Row(
          children: [
            _bankImgWidget,
            Expanded(
              child: _middleInfoWidget,
            ),
            _transferToBtn,
          ],
        ),
        onPressed: () {
          print('转出1');
        },
      ),
    );
  }

  // void go2Detail(RemoteBankCard card) {
  //   Navigator.pushNamed(context, pageTransferInternal, arguments: card);
  // }

//最近转出横条
  _recently() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: HsgColors.commonBackground,
            height: 10,
          ),
          Container(
            color: Colors.white,
            height: 40,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              S.of(context).recent_transfer_account,
              style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: HsgColors.divider,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    _isLoading = true;
    // HSProgressHUD.show();
    TransferDataRepository()
        .getTransferPartnerList(
      GetTransferPartnerListReq(1, 10),
      'getTransferPartnerList',
    )
        .then((data) {
      print('$data');
      // setState(() {
      if (data.rows != null) {
        if (this.mounted) {
          setState(() {
            _partnerListData.clear();
            _partnerListData.addAll(data.rows);
            _isShowNoDataWidget = _partnerListData.length > 0 ? false : true;
            _isLoading = false;
          });
        }
        // HSProgressHUD.dismiss();
      }
      // });
    }).catchError((e) {
      // HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
      // HSProgressHUD.dismiss();
      _isLoading = false;
    });
  }
}
