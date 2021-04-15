import 'dart:io';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 首页
/// Author: lijiawei
/// Date: 2020-12-04

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/model/logout.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/main.dart';

import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/util/status_bar_util.dart';

import '../../page_route.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 0;
  var _changeLangBtnTltle = '';
  var _headPortraitUrl = ''; // 头像地址
  var _enterpriseName = ''; // 企业名称
  var _userName = ''; // 姓名
  var _characterName = ''; // 角色名称
  var _belongCustStatus = ''; //用户状态
  var _lastLoginTime = ''; // 上次登录时间
  String _language = Intl.getCurrentLocale();
  var _features = [];
  UserInfoResp _data;
  DateTime _lastTime;

  ScrollController _sctrollController;

  changeLanguage(Locale locale) {
    setState(() {
      S.load(locale);
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    _sctrollController = ScrollController();
    // 监听滚动
    _sctrollController.addListener(
      () {
        if (this.mounted) {
          setState(() {
            num opacity = _sctrollController.offset / 120;
            // _opacity = opacity.abs();
            if (opacity > 1) {
              _opacity = 1;
            } else if (opacity < 0) {
              _opacity = 0;
            } else {
              _opacity = opacity;
            }
          });
        }
      },
    );

    // 网络请求
    _loadData();

    EventBusUtils.getInstance().on<GetUserEvent>().listen((event) {
      _loadData();
    });

    EventBusUtils.getInstance().on<ChangeHeadPortraitEvent>().listen((event) {
      if (event.state == 100 ||
          event.state == 300 &&
              (event.headPortrait != null && event.headPortrait != '')) {
        setState(() {
          _headPortraitUrl = event.headPortrait;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _sctrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    StatusBarUtil.setStatusBar(Brightness.light, color: Colors.transparent);
    String _language = Intl.getCurrentLocale();
    if (_language == 'zh_CN') {
      _changeLangBtnTltle = '中文（简体）';
    } else if (_language == 'zh_HK') {
      _changeLangBtnTltle = '中文（繁體）';
    } else {
      _changeLangBtnTltle = 'English';
    }

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
            'btnIcon':
                'images/home/listIcon/home_list_transfer_appointment.png',
            'btnTitle': S.current.open_transfer
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
      {
        'title': S.current.other_service,
        'bgColor': Color(0xFFF4F7F0),
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
    List<Widget> slivers = [
      SliverToBoxAdapter(
        child: _homeHeaderView(),
      ),
    ];
    slivers.addAll(_getFeaturesNew(context, _features));
    slivers.add(
      SliverToBoxAdapter(
        child: Container(
          height: 30,
        ),
      ),
    );
    return WillPopScope(
      onWillPop: () => _isExit(),
      // _showTypeTips(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _homeAppbar(_opacity, _changeLangBtnTltle),
        body: Container(
          child: CustomScrollView(
            shrinkWrap: true,
            controller: _sctrollController,
            slivers: slivers,
          ),
        ),
      ),
    );
  }

  Future<bool> _isExit() {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime) > Duration(milliseconds: 2500)) {
      _lastTime = DateTime.now();
      Fluttertoast.showToast(
        msg: "再次点击退出应用",
        gravity: ToastGravity.CENTER,
      );
      return Future.value(false);
    }
    Future.delayed(Duration.zero, () {
      exit(0);
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  //提示弹窗(提示语句，确认事件)
  // _showTypeTips() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return HsgAlertDialog(
  //           title: S.current.exit,
  //           message: S.current.loginOut_tips,
  //           positiveButton: S.current.confirm,
  //           negativeButton: S.current.cancel,
  //         );
  //       }).then((value) {
  //     if (value == true) {
  //       setState(() {
  //         _loginOut();
  //       });
  //     }
  //   });
  // }

  // _loginOut() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String userID = prefs.getString(ConfigKey.USER_ID);

  //   HSProgressHUD.show();
  //   UserDataRepository()
  //       .logout(LogoutReq(userID, _userName), 'logout')
  //       .then((data) {
  //     HSProgressHUD.dismiss();
  //     if (this.mounted) {
  //       setState(() {
  //         Future.delayed(Duration.zero, () {
  //           exit(0);
  //           // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //         });
  //         Fluttertoast.showToast(
  //           msg: S.of(context).logoutSuccess,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       });
  //     }
  //   }).catchError((e) {
  //     Fluttertoast.showToast(
  //       msg: e.toString(),
  //       gravity: ToastGravity.CENTER,
  //     );
  //     HSProgressHUD.dismiss();
  //     // print(e.toString());
  //   });
  // }

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
                // Navigator.pushNamed(
                //   context,
                //   pageOpenAccountSelectDocumentType,
                //   arguments: {
                //     'businessId': '123456987465312456',
                //     'isQuick': true,
                //   },
                // );
                Navigator.pushNamed(
                  context,
                  pageContactCustomer,
                );
              },
            ),
            _languageChangeBtn(),
          ],
        ),
      ),
      statusBarColor: HsgColors.primary.withOpacity(opacity),
    );
  }

  //语言选择按钮
  Widget _languageChangeBtn() {
    return Container(
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
      '中文（简体）',
      '中文（繁體）',
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
        case 2:
          language = Language.ZH_HK;
          setState(() {
            _language = 'zh_Hk';
          });
          break;
      }
    } else {
      return;
    }

    Language.saveSelectedLanguage(language);
    if (this.mounted) {
      setState(() {
        _changeLangBtnTltle = languages[result];
        HSGBankApp.setLocale(context, Language().getLocaleByLanguage(language));
        _changeUserInfoShow(_data);
      });
    }
  }

  ///scrollview的顶部view，包含背景图、登录信息、账户总览和收支明细
  Widget _homeHeaderView() {
    final double _headerViewHeight = MediaQuery.of(context).size.width - 30.0;

    Widget headerShowWidget = Container();
    switch (_belongCustStatus) {
      case '0': //未开户
      case '1': //未开户
        headerShowWidget = _headerInfoWidget();
        break;
      case '2': //审核中
        headerShowWidget = _openAccInReview();
        break;
      case '3': //已驳回
        headerShowWidget = _openAccRejected();
        break;
      case '4': //受限已开户
      case '5': //正常已开户
        headerShowWidget = _headerInfoWidget();
        break;
      default:
        headerShowWidget = _welcomeWidget();
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
                    _featureClickFunction(
                        context, S.of(context).transaction_details),
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
                    _featureClickFunction(
                        context, S.of(context).account_summary),
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
                  fit: BoxFit.cover,
                  image: AssetImage(
                      'images/home/heaerIcon/home_header_person.png'),
                )
              : FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
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
        _enterpriseName == null ? '' : _enterpriseName,
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
        _userName == null ? '' : _userName,
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
        color: Color(0xff3394D4).withOpacity(0.64),
        borderRadius: BorderRadius.circular(12.5),
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
              _characterName == null ? '' : _characterName,
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
      case '0': //受邀客户未开户
      case '1': //非受邀客户未开户
        infoWidget = _userOffInfo();
        break;
      case '4': //正常受限客户
      case '5': //正常正式客户
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

//用户信息-未开户
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
          CustomButton(
            margin: EdgeInsets.all(0),
            height: 40,
            borderRadius: BorderRadius.circular(50.0),
            text: Text(
              S.current.open_account_apply,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            clickCallback: () {
              print('开户申请');
              _openAccountClickFunction(context);
            },
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
            margin: EdgeInsets.only(top: 10, bottom: 12),
            height: 35,
            child: RaisedButton(
              onPressed: () {
                _openAccountClickFunction(context);
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
            margin: EdgeInsets.only(top: 5),
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

//默认欢迎页
  Widget _welcomeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 35),
      width: (MediaQuery.of(context).size.width - 50),
      child: Text(
        S.of(context).home_header_welcome_title,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 3,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
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
  List<Widget> _getFeaturesNew(BuildContext buildContext, List data) {
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
              buildContext,
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
  VoidCallback _featureClickFunction(BuildContext context, String title) {
    return () {
      // if (['0', '1', '2', '3', ''].contains(_belongCustStatus)) {
      //   HsgShowTip.notOpenAccountTip(
      //     context: context,
      //     click: (value) {
      //       if (value == true) {
      //         _openAccountClickFunction(context);
      //       }
      //     },
      //   );
      //   return;
      // }
      if (S.current.transaction_details == title) {
        //收支明细
        Navigator.pushNamed(context, pageDetailList);
      } else if (S.current.account_summary == title) {
        //账户总览
        Navigator.pushNamed(context, pageAccountOverview);
      } else if (S.current.transfer == title) {
        //转账
        Navigator.pushNamed(context, pageTransfer);
      } else if (S.current.transfer_record == title) {
        //转账记录
        Navigator.pushNamed(context, pageTransferRecord);
      } else if (S.current.open_transfer == title) {
        //预约转账
        // Navigator.pushNamed(context, pageOpenTransfer);
        Navigator.pushNamed(context, pageTransferOrder);
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
        // Navigator.pushNamed(context, pageLoanApplication);
        Navigator.pushNamed(context, pageLoanNewApplictionNav);
        //Navigator.pushNamed(context, pageLoanReference);
      } else if (S.current.loan_record == title) {
        //'贷款记录'
        Navigator.pushNamed(
            context, pageLimitDetails); //   pageLimitDetails  pageLoanReference
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

  //开户点击事件
  void _openAccountClickFunction(BuildContext context) {
    if (_belongCustStatus == '1') {
      ///提示，前往网银开户
      HsgShowTip.notOpenAccountGotoEbankTip(
        context: context,
        click: (value) {},
      );
    } else {
      //前往快速开户
      Navigator.pushNamed(context, pageOpenAccountBasicData);
    }
  }

  //校验是否提示设置交易密码
  void _verifyGotoTranPassword(BuildContext context, bool passwordEnabled) {
    if (passwordEnabled == true ||
        (['0', '1', '2', '3', ''].contains(_belongCustStatus))) {
      //已经设置交易密码，或者用户未开户，不做操作
      return;
    }
    HsgShowTip.shouldSetTranPasswordTip(
      context: context,
      click: (value) {
        if (value == true) {
          //前往设置交易密码
          Navigator.pushNamed(context, pageResetPayPwdOtp);
        }
      },
    );
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

  ///网格单元按钮
  Widget _cellButton(
    Map data,
    Color bgColor,
    BuildContext context,
  ) {
    return Container(
      // margin: EdgeInsets.only(left: 15, right: 15),
      // padding: EdgeInsets.only(left: 5, right: 5),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: bgColor,
      ),
      child: FlatButton(
        onPressed: _featureClickFunction(context, data['btnTitle']),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 8),
              child: Image(
                image: AssetImage(data['btnIcon']),
                width: 24,
                height: 24,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12, right: 5),
                child: Text(
                  data['btnTitle'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 14,
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
    if (this.mounted) {
      setState(() {
        _headPortraitUrl = model.headPortrait; //头像地址
        _enterpriseName =
            _language == 'en' ? model.custEngName : model.custLocalName; // 企业名称
        _userName = model.userAccount;
        // _language == 'en'
        //     ? model.englishUserName
        //     : model.localUserName; // 姓名
        // _userName = _userName == null ? model.userAccount : _userName;
        _characterName = _language == 'en'
            ? model.roleEngName
            : model.roleLocalName; //用户角色名称
        _belongCustStatus = model.belongCustStatus; //用户状态
        _lastLoginTime = model.lastLoginTime; // 上次登录时间
      });
    }
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
      // if (['0', '1', '3'].contains(data.belongCustStatus)) {
      //   _getInviteeStatusByPhoneNetwork();
      // }

      _verifyGotoTranPassword(context, data.passwordEnabled);

      if (this.mounted) {
        setState(() {
          _data = data;
          _changeUserInfoShow(_data);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      // HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }

  @override
  bool get wantKeepAlive => true;

  // Future<void> _getInviteeStatusByPhoneNetwork() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String userAreaCode = prefs.getString(ConfigKey.USER_AREACODE);
  //   String userPhone = prefs.getString(ConfigKey.USER_PHONE);

  //   UserDataRepository()
  //       .getInviteeStatusByPhone(
  //     GetInviteeStatusByPhoneReq(userAreaCode, userPhone),
  //     'getInviteeStatusByPhone',
  //   )
  //       .then((data) {
  //     if (this.mounted) {
  //       setState(() {
  //         _inviteeStatus = data.inviteeStatus;
  //       });
  //     }
  //   }).catchError((e) {
  //     Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER,);
  //     // HSProgressHUD.showError(status: e.toString());
  //     print('${e.toString()}');
  //   });
  // }
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
