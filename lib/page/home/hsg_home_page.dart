import 'package:ebank_mobile/config/global_config.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

var _features = [
  {
    'title': '转账收款',
    'btnList': [
      {
        'btnIcon': 'images/home/listIcon/home_list_transfer.png',
        'btnTitle': '转账'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_transfer_record.png',
        'btnTitle': '转账记录'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_partner.png',
        'btnTitle': '收款范本'
      },
    ]
  },
  {
    'title': '定期服务',
    'btnList': [
      {
        'btnIcon': 'images/home/listIcon/home_list_time_deposit.png',
        'btnTitle': '定期开立'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_deposit_records.png',
        'btnTitle': '我的存单'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_deposit_rates.png',
        'btnTitle': '利率查看'
      },
    ]
  },
  {
    'title': '贷款服务',
    'btnList': [
      {
        'btnIcon': 'images/home/listIcon/home_list_loan_apply.png',
        'btnTitle': '贷款申请'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_loan_recoeds.png',
        'btnTitle': '贷款记录'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_loan_rate.png',
        'btnTitle': '贷款利率'
      },
    ]
  },
  {
    'title': '其他服务',
    'btnList': [
      {
        'btnIcon': 'images/home/listIcon/home_list_FOREX.png',
        'btnTitle': '外汇买卖'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_exchange.png',
        'btnTitle': '汇率查询'
      },
      {
        'btnIcon': 'images/home/listIcon/home_list_statement.png',
        'btnTitle': '电子结单'
      },
    ]
  }
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _opacity = 0;
  var _changeLangBtnTltle = 'English'; // S.current.english;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppbar(_opacity, _changeLangBtnTltle),
      body: Container(
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeaderView(),
            ),
            SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  _buildListItem,
                  childCount: _features.length,
                ),
                itemExtent: 153.5),
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

  Widget _buildListItem(BuildContext context, int index) {
    return ListTile(
      title: getFeatures(_features[index]),
      onTap: () {
        print('listView的单元格被点击了');
      },
    );
  }
}

// ignore: non_constant_identifier_names
Widget HomeAppbar(double opacity, String changeLangBtnTltle) {
  return XAppBar(
    child: Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
              image: AssetImage('images/home/navIcon/home_nav_message_has.png'),
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
                S.current.home,
                style: kNavTextFont,
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

class HomeHeaderView extends StatelessWidget {
  const HomeHeaderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _headerViewHeight = MediaQuery.of(context).size.width - 30.0;

    return Container(
      child: Stack(
        children: [
          Image(
            width: MediaQuery.of(context).size.width,
            image: AssetImage('images/home/heaerIcon/home_header_bg.png'),
          ),
          Container(
            // color: Colors.red,
            width: _headerViewHeight,
            height: 110.0,
            margin: EdgeInsets.only(top: 200, left: 15),
            decoration: HsgShadow(null),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _headerViewHeight / 2 - 5,
                  child: GraphicButtons(
                      '收支明细',
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
                  child: GraphicButtons(
                      '账户总览',
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
}

/**
 * 这是一个可以指定SafeArea区域背景色的AppBar
 * PreferredSizeWidget提供指定高度的方法
 * 如果没有约束其高度，则会使用PreferredSizeWidget指定的高度
 */
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

/**
 * 这里没有直接用SafeArea，而是用Container包装了一层
 * 因为直接用SafeArea，会把顶部的statusBar区域留出空白
 * 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
 */
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
          print('LanguageChangeBtn.title == ${widget.title}');
          _selectLanguage();
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

  _selectLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final oldLang = prefs.getString(ConfigKey.LANGUAGE) ?? '';
    print('0_______________------------- $oldLang');
    if (oldLang.isEmpty) {
      prefs.setString(ConfigKey.LANGUAGE, 'en');
      return;
    }

    Locale locale;
    print('1_______________------------- $oldLang');
    if (oldLang == 'en') {
      locale = Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN');
    } else {
      locale = Locale.fromSubtags(languageCode: 'en');
    }
    print('2_______________------------- $locale');
    setState(() {
      print('3_______________------------- ${locale.languageCode}');
      // HSGBankApp.setLocale(context, locale);
      if (locale.languageCode == 'en') {
        title = 'English'; //S.current.english;
      } else {
        title = '中文'; //S.current.simplifiedChinese;
      }
      HSGBankApp.setLocale(context, locale);
    });
    print('4_______________------------- ${locale.languageCode}');
    prefs.setString(ConfigKey.LANGUAGE, locale.languageCode);
    print('5_______________------------- $locale');
  }
}

class GraphicButtons extends StatefulWidget {
  GraphicButtons(this.title, this.iconName, this.iconWidth, this.onClick,
      {Key key})
      : super(key: key);

  final String title;
  final String iconName;
  final double iconWidth;
  final VoidCallback onClick;

  @override
  _GraphicButtonsState createState() => _GraphicButtonsState(
      this.title, this.iconName, this.iconWidth, this.onClick);
}

class _GraphicButtonsState extends State<GraphicButtons> {
  _GraphicButtonsState(this.title, this.iconName, this.iconWidth, this.onClick);

  final String title;
  final String iconName;
  final double iconWidth;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onClick,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image(
                image: AssetImage(this.iconName),
                width: this.iconWidth,
                height: this.iconWidth,
              ),
            ),
            Container(
              height: 8.0,
            ),
            Container(
              child: Text(
                this.title,
                style: TextStyle(
                  color: HsgColors.describeText,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getFeatures(Map data) {
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
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          '更多',
                          style: TextStyle(
                            color: HsgColors.describeText,
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
            height: 90,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: CraphicBtns(data),
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: dead_code
// ignore: non_constant_identifier_names
List<Widget> CraphicBtns(Map data) {
  List<Widget> btns = [];
  List dataList = data['btnList'];

  for (var i = 0; i < dataList.length; i++) {
    Map btnData = dataList[i];
    btns.add(
      Container(
        child: Row(
          children: [
            GraphicButtons(
              btnData['btnTitle'],
              btnData['btnIcon'],
              35.0,
              () {
                print('${btnData['btnTitle']}');
              },
            ),
            Container(
              //假装没有第三条竖线
              color:
                  (i < dataList.length - 1) ? HsgColors.divider : Colors.white,
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
