/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';

import '../../page_route.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _opacity = 0;
  var _changeLangBtnTltle = 'English'; // S.current.english;
  var _headPortraitUrl = ''; // 头像地址
  var _enterpriseName = ''; // 企业名称
  var _userName = '高阳银行企业用户'; // 姓名
  var _characterName = '企业经办员'; // 角色名称
  var _lastLoginTime = '上次登录时间：'; // 上次登录时间

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _homeAppbar(_opacity, _changeLangBtnTltle),
      body: Container(
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _homeHeaderView(),
            ),
            SliverFixedExtentList(
              delegate: SliverChildBuilderDelegate(
                _buildListItem,
                childCount: 4, //_features.length,
              ),
              itemExtent: 168.5,
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 20,
              ),
            ),
          ],
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
              },
            ),
            IconButton(
              icon: Image(
                image:
                    AssetImage('images/home/navIcon/home_nav_message_has.png'),
                width: 18.5,
                height: 18.5,
              ),
              onPressed: () {
                print('消息');
              },
            ),
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
            LanguageChangeBtn(changeLangBtnTltle),
          ],
        ),
      ),
      statusBarColor: HsgColors.primary.withOpacity(opacity),
    );
  }

  ///scrollview的顶部view，包含背景图、登录信息、账户总览和收支明细
  Widget _homeHeaderView() {
    final double _headerViewHeight = MediaQuery.of(context).size.width - 30.0;

    return Container(
      child: Stack(
        children: [
          Image(
            width: MediaQuery.of(context).size.width,
            image: AssetImage('images/home/heaerIcon/home_header_bg.png'),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 120, left: 35),
                  child: _headPortrait(),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 15, top: 105),
                  child: _userInfo(),
                )
              ],
            ),
          ),
          Container(
            width: _headerViewHeight,
            height: 110.0,
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
                      40.0, () {
                    print('收支明细');
                    Navigator.pushNamed(context, pageDetailList);
                  }),
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
                      40.0, () {
                    print('账户总览');
                    Navigator.pushNamed(context, pageAccountOverview);
                  }),
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

  //用户信息
  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enterpriseInfo(),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _accountInfo(),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _timeInfo(),
        )
      ],
    );
  }

  //企业信息
  Widget _enterpriseInfo() {
    return Container(
      constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width / 3 * 2 - 20)),
      height: 20,
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

  //账号信息
  Widget _accountInfo() {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: Color(0xff5662fb).withOpacity(0.66), //HsgColors.accent,
        borderRadius: BorderRadius.circular(12.5), //
      ),
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Container(
            height: 20,
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
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Icon(
              Icons.star,
              color: Color(0xffffbc2e),
              size: 18,
            ),
          ),
          Text(
            _characterName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  //时间信息
  Widget _timeInfo() {
    return Text(
      _lastLoginTime,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }

  ///底下列表
  Widget _buildListItem(BuildContext context, int index) {
    var _features = [
      {
        'title': S.current.transfer_collection,
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
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_time_deposit.png',
            'btnTitle': S.current.deposit_open
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_deposit_records.png',
            'btnTitle': S.current.deposit_record
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_deposit_rates.png',
            'btnTitle': S.current.deposit_rate
          },
        ]
      },
      {
        'title': S.current.loan_service,
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_loan_apply.png',
            'btnTitle': S.current.loan_apply
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_loan_recoeds.png',
            'btnTitle': S.current.loan_record
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_loan_rate.png',
            'btnTitle': S.current.loan_rate
          },
        ]
      },
      {
        'title': S.current.other_service,
        'btnList': [
          {
            'btnIcon': 'images/home/listIcon/home_list_FOREX.png',
            'btnTitle': S.current.foreign_exchange
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_exchange.png',
            'btnTitle': S.current.exchange_rate
          },
          {
            'btnIcon': 'images/home/listIcon/home_list_statement.png',
            'btnTitle': S.current.electronic_statement
          },
        ]
      }
    ];

    return ListTile(
      title: _getFeatures(_features[index]),
      onTap: () {
        print('listView的单元格被点击了');
      },
    );
  }

  ///列表单元格
  Widget _getFeatures(Map data) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        shadowColor: Color(0x46529F2E),
        // clipBehavior: ,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['title'],
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlatButton(
                    height: 25,
                    color: Color(0xF3F3F3FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    onPressed: () {
                      print('更多');
                      Navigator.pushNamed(context, pageFeatureList);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            S.current.more,
                            style: TextStyle(
                              color: HsgColors.accent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8),
                          child: Image(
                            image: AssetImage(
                                'images/home/listIcon/home_list_more_arrow.png'),
                            width: 7,
                            height: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        ),
      ),
    );
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
                () {
                  print('${btnData['btnTitle']}');
                  String title = btnData['btnTitle'];
                  if (S.current.transfer == title) {
                    //转账
                    Navigator.pushNamed(context, pageTransfer);
                  } else if (S.current.transfer_record == title) {
                    //转账记录
                  } else if (S.current.transfer_model == title) {
                    //收款范本
                  } else if (S.current.deposit_open == title) {
                    //'定期开立'
                    Navigator.pushNamed(context, pageTimeDepostProduct);
                  } else if (S.current.deposit_record == title) {
                    //'我的存单'
                  } else if (S.current.deposit_rate == title) {
                    //'利率查看'
                  } else if (S.current.loan_apply == title) {
                    //'贷款申请'
                  } else if (S.current.loan_record == title) {
                    //'贷款记录'
                  } else if (S.current.loan_rate == title) {
                    //'贷款利率'
                  } else if (S.current.foreign_exchange == title) {
                    //'外汇买卖'
                  } else if (S.current.exchange_rate == title) {
                    //'汇率查询'
                  } else if (S.current.electronic_statement == title) {
                    //'电子结单'
                  }
                },
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
  Widget _graphicButton(
      String title, String iconName, double iconWidth, VoidCallback onClick) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 50) / 3,
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
                  color: HsgColors.describeText,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        _enterpriseName = '高阳寰球科技有限公司'; // 企业名称
        _userName = data.actualName; // 姓名
        _characterName = '企业经办员'; // 角色名称
        _lastLoginTime = '上次登录时间：2020-12-01'; // 上次登录时间
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

/// 语言选择按钮
// ignore: must_be_immutable
class LanguageChangeBtn extends StatefulWidget {
  String title;

  LanguageChangeBtn(this.title);

  @override
  _LanguageChangeBtnState createState() => _LanguageChangeBtnState(title);
}

class _LanguageChangeBtnState extends State<LanguageChangeBtn> {
  String title;

  _LanguageChangeBtnState(this.title);

  @override
  Widget build(BuildContext context) {
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
                title,
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
          break;
        case 1:
          language = Language.ZH_CN;
          break;
      }
    } else {
      return;
    }

    Language.saveSelectedLanguage(language);
    setState(() {
      title = languages[result];
      HSGBankApp.setLocale(context, Language().getLocaleByLanguage(language));
    });
  }
}
