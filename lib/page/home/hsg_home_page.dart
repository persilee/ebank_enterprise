/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/page/index_page/hsg_index_page.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';

import '../../page_route.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _opacity = 0;
  // var _changeLangBtnTltle = 'English';
  var _changeLangBtnTltle = S.current.language1;
  var _headPortraitUrl = ''; // 头像地址
  var _enterpriseName = ''; // 企业名称
  var _userName = '高阳银行企业用户'; // 姓名
  var _characterName = ''; // 角色名称
  var _belongCustStatus = '0'; //用户状态
  var _lastLoginTime = ''; // 上次登录时间
  String _language = Intl.getCurrentLocale();
  var _features = [];
  UserInfoResp _data;

  ScrollController _sctrollController = ScrollController();

  @override
  // ignore: must_call_super
  void initState() {
    // 监听滚动
    _sctrollController.addListener(
      () {
        setState(() {
          num opacity = _sctrollController.offset / 120;
          _opacity = opacity.abs();
          if (_opacity > 1) {
            _opacity = 1;
          } else if (_opacity < 0) {
            _opacity = 0;
          }
        });
      },
    );

    // 网络请求
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    _features = [
      {
        'title': S.current.transfer_collection,
        'bgColor': Color(0xFFF0F6F7),
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_transfer.png',
            'btnTitle': S.current.transfer
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_transfer_record.png',
            'btnTitle': S.current.transfer_record
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_partner.png',
            'btnTitle': S.current.transfer_model
          },
        ]
      },
      {
        'title': S.current.deposit_service,
        'bgColor': Color(0xFFF7F5F0),
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_time_deposit.png',
            'btnTitle': S.current.deposit_open
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_deposit_records.png',
            'btnTitle': S.current.deposit_record
          },
          // {
          //   'btnIcon': 'images/home/listIcon/home_list_deposit_rates.png',
          //   'btnTitle': S.current.deposit_rate
          // },
        ]
      },
      {
        'title': S.current.loan_service,
        'bgColor': Color(0xFFF2F0F7),
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_loan_apply.png',
            'btnTitle': S.current.loan_apply
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_loan_recoeds.png',
            'btnTitle': S.current.loan_record
          },
          // {
          //   'btnIcon': 'images/home/listIcon/home_list_loan_rate.png',
          //   'btnTitle': S.current.loan_rate
          // },
        ]
      },
//      {
//        'title': S.current.other_service,
//        'btnList': [
//          {
//            'btnIcon': 'images/home/listIcon/home_list_FOREX.png',
//            'btnTitle': S.current.foreign_exchange
//          },
//          {
//            'btnIcon': 'images/home/listIcon/home_list_exchange.png',
//            'btnTitle': S.current.exchange_rate
//          },
//          {
//            'btnIcon': 'images/home/listIcon/home_list_statement.png',
//            'btnTitle': S.current.electronic_statement
//          },
//        ]
//      }
    ];
    List<Widget> slivers = [
      SliverToBoxAdapter(
        child: _homeHeaderView(),
      ),
    ];
    slivers.addAll(_getFeaturesNew(_features));
    slivers.add(
      SliverToBoxAdapter(
        child: Container(
          height: 20,
        ),
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _homeAppbar(_opacity, _changeLangBtnTltle),
      body: Container(
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: slivers,
          // [
          //   SliverToBoxAdapter(
          //     child: _homeHeaderView(),
          //   ),
          //   // _characterName != "企业复核员" &&
          //   //         _characterName != "Enterprise Auditor" &&
          //   //         _characterName != ""
          //   //     ? SliverFixedExtentList(
          //   //         delegate: SliverChildBuilderDelegate(
          //   //           _buildListItem,
          //   //           childCount: _features.length,
          //   //         ),
          //   //         itemExtent: 168.5,
          //   //       )
          //   //     : SliverToBoxAdapter(),
          //   // SliverGrid(
          //   //   delegate: SliverChildBuilderDelegate(
          //   //     (BuildContext context, int index) {
          //   //       return Container(
          //   //         alignment: Alignment.center,
          //   //         color: Colors.teal[100 * (index % 9)],
          //   //         child: Text('Grid Item $index'),
          //   //       );
          //   //     },
          //   //     childCount: 4,
          //   //   ),
          //   //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //   //     maxCrossAxisExtent: 200.0,
          //   //     mainAxisSpacing: 10.0,
          //   //     crossAxisSpacing: 10.0,
          //   //     childAspectRatio: 4.0,
          //   //   ),
          //   // ),
          //   // _getFeaturesNew(_features);
          //   SliverToBoxAdapter(
          //     child: Container(
          //       height: 20,
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }

  ///自定义导航条（包含联系客服、消息、标题、切换语言按钮）
  Widget _homeAppbar(double opacity, String changeLangBtnTltle) {
    return XAppBar(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Image(
                image: AssetImage('images/home/navIcon/home_nav_service.png'),
                width: 18.5,
                height: 18.5,
              ),
              onPressed: () {
                print('联系客服');
                Navigator.pushNamed(context, pageContactCustomer);
              },
            ),
            // IconButton(
            //   icon: Image(
            //     image:
            //         AssetImage('images/home/navIcon/home_nav_message_has.png'),
            //     width: 18.5,
            //     height: 18.5,
            //   ),
            //   onPressed: () {
            //     print('消息');
            //   },
            // ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  S.of(context).home,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(opacity),
                  ),
                ),
              ),
            ),
            _languageChangeBtn(),
            //LanguageChangeBtn(changeLangBtnTltle),
          ],
        ),
      ),
      statusBarColor: HsgColors.primary.withOpacity(opacity),
    );
  }

  //语言选择按钮
  Widget _languageChangeBtn() {
    return Container(
      // margin: EdgeInsets.only(right: 15),
      child: FlatButton(
        onPressed: () {
          _selectLanguage(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Text(
                _changeLangBtnTltle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectLanguage(BuildContext context) async {
    List<String> languages = [
      'English',
      '中文',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.current.select_language,
              items: languages,
            ));
    String language;
    if (result != null && result != false) {
      switch (result) {
        case 0:
          language = Language.EN;
          setState(() {
            _language = 'en';
          });
          break;
        case 1:
          language = Language.ZH_CN;
          setState(() {
            _language = 'zh_CN';
          });
          break;
      }
    } else {
      return;
    }

    Language.saveSelectedLanguage(language);
    setState(() {
      _changeLangBtnTltle = languages[result];
      HSGBankApp.setLocale(context, Language().getLocaleByLanguage(language));
      _changeUserInfoShow(_data);
    });
  }

  ///scrollview的顶部view，包含背景图、登录信息、账户总览和收支明细
  Widget _homeHeaderView() {
    final double _headerViewHeight = MediaQuery.of(context).size.width - 30.0;

    Widget headerShowWidget = Container();
    switch (_belongCustStatus) {
      case '0': //未开户
      case '3': //开立客户号失败
      case '4': //开立账户失败
        headerShowWidget = _headerInfoWidget();
        break;
      case '1': //审核中
      case '8': //待审核
        headerShowWidget = _openAccInReview();
        break;
      case '2': //已驳回
        headerShowWidget = _openAccRejected();
        break;
      case '5': //未激活
      case '6': //已激活
      case '7': //锁定
        headerShowWidget = _headerInfoWidget();
        break;
      default:
    }

    return Container(
      child: Stack(
        children: [
          Image(
            width: MediaQuery.of(context).size.width,
            image: AssetImage('images/home/heaerIcon/home_header_bg.png'),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   color: HsgColors.homeMask,
          // ),
          Container(
            margin: EdgeInsets.only(top: 60),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: headerShowWidget,
            //_openAccInReview(), //_openAccRejected(), // _headerInfoWidget(),
          ),
          Container(
            width: _headerViewHeight,
            height: 105.0,
            margin: EdgeInsets.only(top: 210, left: 15),
            decoration: HsgStyles.homeHeaderShadow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _headerViewHeight / 2 - 5,
                  child: _graphicButton(
                    S.of(context).transaction_details,
                    'images/home/heaerIcon/home_header_payment.png',
                    25.0,
                    (MediaQuery.of(context).size.width - 50) / 2,
                    () {
                      Navigator.pushNamed(context, pageDetailList);
                    },
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 40.0,
                  color: HsgColors.divider,
                ),
                Container(
                  width: _headerViewHeight / 2 - 5,
                  child: _graphicButton(
                    S.of(context).account_summary,
                    'images/home/heaerIcon/home_header_overview.png',
                    25.0,
                    (MediaQuery.of(context).size.width - 50) / 2,
                    () {
                      print('账户总览');
                      Navigator.pushNamed(context, pageAccountOverview);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //头像
  Widget _headPortrait() {
    return Container(
      // color: Colors.white,
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(55.0 / 2),
      ),
      padding: EdgeInsets.all(2.0),
      child: Container(
        child: ClipOval(
          child: (_headPortraitUrl == null || _headPortraitUrl == '')
              ? Image(
                  image: AssetImage(
                      'images/home/heaerIcon/home_header_person.png'),
                )
              : FadeInImage.assetNetwork(
                  fit: BoxFit.fitWidth,
                  image: _headPortraitUrl == null ? '' : _headPortraitUrl,
                  placeholder: 'images/home/heaerIcon/home_header_person.png',
                ),
        ),
      ),
    );
  }

  //企业信息
  Widget _enterpriseInfo() {
    return Container(
      constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width / 3 * 2 - 20)),
      height: 22,
      child: Text(
        _enterpriseName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  //用户名
  Widget _nameInfo() {
    return Container(
      constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width / 3 * 2 - 160)),
      child: Text(
        _userName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  //用户角色信息
  Widget _characterInfo() {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: Color(0xff5662fb).withOpacity(0.66), //HsgColors.accent,
        borderRadius: BorderRadius.circular(12.5), //
      ),
      padding: EdgeInsets.fromLTRB(5, 0, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Icon(
              Icons.star,
              color: Color(0xffffbc2e),
              size: 18,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 160,
            ),
            child: Text(
              _characterName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  //头部信息展示
  Widget _headerInfoWidget() {
    Widget infoWidget = Container();
    switch (_belongCustStatus) {
      case '0': //未开户
      case '3': //开立客户号失败
      case '4': //开立账户失败
        infoWidget = _userOffInfo();
        break;
      case '5': //未激活
      case '6': //已激活
      case '7': //锁定
        infoWidget = _userInfo();
        break;
      default:
    }
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 25),
            child: _headPortrait(),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 55 - 50 - 25,
            child: infoWidget,
          ),
        ],
      ),
    );
  }

//用户信息-未开户成功
  Widget _userOffInfo() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _nameInfo(),
          ),
          RaisedButton(
            onPressed: () {
              print('开户申请');
              Navigator.pushNamed(context, pageOpenAccountBasicData);
            },
            child: Text(
              S.of(context).open_account_apply,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            color: Color(0xFF4871FF),
            disabledColor: HsgColors.btnDisabled,
          ),
        ],
      ),
    );
  }

  //审核驳回
  Widget _openAccRejected() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 110,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        children: [
          Container(
            child: Text(
              S.of(context).open_account_rejected_tip,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            height: 35,
            child: RaisedButton(
              onPressed: () {
                print('重新申请');
              },
              child: Text(
                S.of(context).open_account_reapply,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              color: Color(0xFF4871FF),
              disabledColor: HsgColors.btnDisabled,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7),
            child: _timeInfo(),
          ),
        ],
      ),
    );
  }

  //审核中
  Widget _openAccInReview() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 110,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        children: [
          Container(
            child: Text(
              S.of(context).open_account_inReview_tip,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).open_account_inReview_content,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.only(top: 7),
            child: _timeInfo(),
          ),
        ],
      ),
    );
  }

//用户信息-已开户
  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enterpriseInfo(),
        Container(
          margin: EdgeInsets.only(top: 7),
          child: _nameInfo(),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _characterInfo(),
        ),
        Container(
          margin: EdgeInsets.only(top: 7),
          child: _timeInfo(),
        )
      ],
    );
  }

  //时间信息
  Widget _timeInfo() {
    return Text(
      S.current.last_login_time_with_value + _lastLoginTime,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }

  ///底下列表
  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: _getFeatures(_features[index]),
      onTap: () {
        print('listView的单元格被点击了');
      },
    );
  }

  ///列表单元格
  Widget _getFeatures(Map data) {
    //单元格详情
    Column _featuresDeatil = Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: 15),
          height: 45,
          child: Text(
            data['title'],
            style: TextStyle(
              color: HsgColors.firstDegreeText,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: HsgColors.divider,
          height: 0.5,
        ),
        Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _craphicBtns(data),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        shadowColor: Color(0x46529F2E),
        child: _featuresDeatil,
      ),
    );
  }

  List<Widget> _getFeaturesNew(List data) {
    List<Widget> _grids = [];
    data.forEach((element) {
      List<Map> btnList = element['btnList'];
      SliverToBoxAdapter adapter = SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 18, right: 18, top: 25, bottom: 15),
          child: Text(
            element['title'],
            style: TextStyle(
              color: HsgColors.firstDegreeText,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      SliverGrid grid = SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return _cellButton(
              btnList[index],
              element['bgColor'],
            );
          },
          childCount: btnList.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 3.5,
        ),
      );
      SliverPadding padding = SliverPadding(
        padding: EdgeInsets.only(left: 15, right: 15),
        sliver: grid,
      );
      _grids.add(adapter);
      _grids.add(padding);
    });

    return _grids;
  }

  //功能点击事件
  VoidCallback _featureClickFunction(String title) {
    return () {
      if (S.current.transfer == title) {
        //转账
        Navigator.pushNamed(context, pageTransfer);
      } else if (S.current.transfer_record == title) {
        //转账记录
        Navigator.pushNamed(context, pageTransferRecord);
      } else if (S.current.transfer_model == title) {
        //收款范本
        Navigator.pushNamed(context, pageTranferPartner);
      } else if (S.current.deposit_open == title) {
        //'定期开立'
        Navigator.pushNamed(context, pageTimeDepostProduct);
      } else if (S.current.deposit_record == title) {
        //'我的存单'
        Navigator.pushNamed(context, pageTimeDepositRecord);
      } else if (S.current.deposit_rate == title) {
        //'利率查看'
        Navigator.pushNamed(context, pageMyDepositRate);
      } else if (S.current.loan_apply == title) {
        //'贷款申请'
        Navigator.pushNamed(context, pageLoanApplication);
      } else if (S.current.loan_record == title) {
        //'贷款记录'
        Navigator.pushNamed(context, pageLimitDetails);
      } else if (S.current.loan_rate == title) {
        //'贷款利率'
        //Navigator.pushNamed(context, pageloanDemo);
        Navigator.pushNamed(context, pageLoanInterestRate);
      } else if (S.current.foreign_exchange == title) {
        //'外汇买卖'
        Navigator.pushNamed(context, pageForexTrading);
      } else if (S.current.exchange_rate == title) {
        //'汇率查询'
        Navigator.pushNamed(context, pageExchangeRateInquiry);
      } else if (S.current.electronic_statement == title) {
        //'电子结单'
        Navigator.pushNamed(context, pageElectronicStatement);
      }
    };
  }

  ///列表单元格的下面三个按钮和两条线
  List<Widget> _craphicBtns(Map data) {
    List<Widget> btns = [];
    List dataList = data['btnList'];

    for (var i = 0; i < dataList.length; i++) {
      Map btnData = dataList[i];
      btns.add(
        Container(
          child: Row(
            children: [
              _graphicButton(
                btnData['btnTitle'],
                btnData['btnIcon'],
                35.0,
                (MediaQuery.of(context).size.width - 50) /
                    (dataList.length > 0 ? dataList.length : 1),
                _featureClickFunction(btnData['btnTitle']),
              ),
              Container(
                //假装没有第三条竖线
                color: (i < dataList.length - 1)
                    ? HsgColors.divider
                    : Colors.white,
                height: 23,
                width: 0.5,
              )
            ],
          ),
        ),
      );
    }

    return btns;
  }

  ///上图下文字的按钮
  Widget _graphicButton(String title, String iconName, double iconWidth,
      double btnWidth, VoidCallback onClick) {
    return SizedBox(
      width: btnWidth, //(MediaQuery.of(context).size.width - 50) / 3,
      child: FlatButton(
        onPressed: onClick,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Image(
                image: AssetImage(iconName),
                width: iconWidth,
                height: iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            SizedBox(
              height: 32,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HsgColors.firstDegreeText,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cellButton(
    Map data,
    Color bgColor,
  ) {
    return Container(
      // margin: EdgeInsets.only(left: 15, right: 15),
      // padding: EdgeInsets.only(left: 5, right: 5),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: bgColor,
      ),
      child: FlatButton(
        onPressed: _featureClickFunction(data['btnTitle']),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 13),
              child: Image(
                image: AssetImage(data['btnIcon']),
                width: 24,
                height: 24,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 5),
                child: Text(
                  data['btnTitle'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeUserInfoShow(UserInfoResp model) {
    setState(() {
      _headPortraitUrl = model.headPortrait; //头像地址
      _enterpriseName = _language == 'zh_CN'
          ? model.custLocalName
          : model.custEngName; // 企业名称
      _userName = _language == 'zh_CN'
          ? model.localUserName
          : model.englishUserName; // 姓名
      _characterName = _language == 'zh_CN'
          ? model.roleLocalName
          : model.roleEngName; //用户角色名称
      _lastLoginTime = model.lastLoginTime; // 上次登录时间
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);

    UserDataRepository()
        .getUserInfo(
      GetUserInfoReq(userID),
      'getUserInfo',
    )
        .then((data) {
      print('$data');
      setState(() {
        _headPortraitUrl = data.headPortrait; //头像地址
        _enterpriseName = _language == 'zh_CN'
            ? data.custLocalName
            : data.custEngName; // 企业名称
        _userName = _language == 'zh_CN'
            ? data.localUserName
            : data.englishUserName; // 姓名
        _characterName = _language == 'zh_CN'
            ? data.roleLocalName
            : data.roleEngName; //用户角色名称
        _belongCustStatus = data.belongCustStatus; //用户状态
        _lastLoginTime = data.lastLoginTime; // 上次登录时间
        _data = data;
      });
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }
}

/// 这是一个可以指定SafeArea区域背景色的AppBar
/// PreferredSizeWidget提供指定高度的方法
/// 如果没有约束其高度，则会使用PreferredSizeWidget指定的高度
class XAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget child; //从外部指定内容
  final Color statusBarColor; //设置statusbar的颜色

  XAppBar({this.child, this.statusBarColor}) : super();

  @override
  State<StatefulWidget> createState() {
    return new _XAppBarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

/// 这里没有直接用SafeArea，而是用Container包装了一层
/// 因为直接用SafeArea，会把顶部的statusBar区域留出空白
/// 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
class _XAppBarState extends State<XAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          kToolbarHeight + MediaQuery.of(context).padding.top, //自动设置为系统appbar高度
      width: MediaQuery.of(context).size.width,
      color: widget.statusBarColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: widget.child,
      ),
    );
  }
}
