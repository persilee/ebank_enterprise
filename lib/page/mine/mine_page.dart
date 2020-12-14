/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 个人中心
/// Author: hlx
/// Date: 2020-12-11
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_styles.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import '../../page_route.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  double _opacity = 0;
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
    // _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _mineAppbar(_opacity),
      body: Container(
        child: CustomScrollView(
          controller: _sctrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _homeHeaderView(),
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
  Widget _mineAppbar(double opacity) {
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
                  '我的',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(opacity),
                  ),
                ),
              ),
            ),
            //LanguageChangeBtn(changeLangBtnTltle),
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
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 88.0, left: 32),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(28)),
                child: ClipOval(
                  child: Image.asset(
                    'images/home/heaerIcon/home_header_person.png',
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
            ],
          )
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
          100, //自动设置为系统appbar高度
      width: 100,
      color: widget.statusBarColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: widget.child,
      ),
    );
  }
}

//个人信息
// Widget _userInfo(){
//   return Container(
//      //有时在不确定宽高的情况下需要设置Container的最大或最小宽高，可以通过Container的constraints属性来设置
//   constraints: new BoxConstraints.expand(),
//   child: ,
//   )
// }
