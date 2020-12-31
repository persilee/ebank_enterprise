/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 个人中心
/// Author: hlx
/// Date: 2020-12-11
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  double _opacity = 0;
  ScrollController _sctrollController = ScrollController();
  String _lastLoginTime =
      DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  String _userName = "";
  bool _switchZhiWen = true; //指纹登录
  bool _switchFaceId = false; //faceID登录

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getUser();
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
              child: _mineHeaderView(),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: _mineContendView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///自定义导航条（包含联系客服、消息、标题）
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
                Navigator.pushNamed(context, pageContactCustomer);
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
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white.withOpacity(opacity),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      statusBarColor: HsgColors.primary.withOpacity(opacity),
    );
  }

  ///scrollview的顶部view，包含背景图、登录信息
  Widget _mineHeaderView() {
    return Container(
      child: Stack(
        children: [
          Image(
            width: MediaQuery.of(context).size.width,
            height: 180,
            image: AssetImage('images/mine/mine-icon.png'),
            fit: BoxFit.cover,
          ),
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(color: Color(0x90000000)),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 78.0, left: 32, right: 24.0, bottom: 78.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(28)),
                child: ClipOval(
                  child: Image.asset(
                    'images/mine/mine-icon.png',
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: HsgColors.aboutusText,
                          fontSize: 20.0,
                          height: 1.5),
                    ),
                    Text(S.of(context).lastLoginTime + _lastLoginTime,
                        style: TextStyle(
                            color: HsgColors.aboutusText, fontSize: 12.0))
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  /// 中间内容的内容
  Widget _mineContendView(context) {
    return Container(
        child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 16),
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).fingerprintLogin,
                ),
                Switch(
                  value: _switchZhiWen, //当前状态
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      _switchZhiWen = value;
                    });
                  },
                ),
              ],
            ),
            Divider(
                height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).faceIdlogin),
                Switch(
                  value: _switchFaceId, //当前状态
                  onChanged: (value) {
                    //重新构建页面
                    setState(() {
                      _switchFaceId = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      //修改登录密码
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 16),
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).resetLoginPsw),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, changeLgPs);
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: HsgColors.nextPageIcon,
                        ),
                      )),
                ],
              ),
            ),
            Divider(
                height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
            //修改支付密码
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).changPayPws),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, changePayPS);
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: HsgColors.nextPageIcon,
                        ),
                      )),
                ],
              ),
            ),
            Divider(
                height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).resetPayPwd),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, setPayPage);
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: HsgColors.nextPageIcon,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      //
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 16),
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).feedback),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, feedback);
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: HsgColors.nextPageIcon,
                        ),
                      )),
                ],
              ),
            ),
            Divider(
                height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).aboutUs),
                  Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          //调整关于我们
                          Navigator.pushNamed(context, aboutUs);
                        },
                        child: Icon(
                          Icons.navigate_next,
                          color: HsgColors.nextPageIcon,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      //退出按钮
      Container(
          height: 50,
          color: Colors.white,
          child: Center(
              child: InkWell(
            onTap: () {
              //调整关于我们
              _loginOut();
            },
            child: Text(S.of(context).loginOut,
                style: TextStyle(color: HsgColors.redTextColor)),
          )))
    ]));
  }

//获取用户信息
  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);

    UserDataRepository()
        .getUserInfo(
      GetUserInfoReq(userID),
      'getUserInfo',
    )
        .then((data) {
      setState(() {
        _userName = data.actualName; // 姓名
        // _lastLoginTime = data.lastLoginTime; // 上次登录时间
      });
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }

  //退出
  _loginOut() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(
      GetUserInfoReq(userID),
      'logout',
    )
        .then((data) {
      setState(() {
        // prefs.setString(ConfigKey.USER_ACCOUNT, '');
        // prefs.setString(ConfigKey.USER_ID, '');
        // prefs.setString(ConfigKey.NET_TOKEN, '');
        Navigator.pushNamed(context, pageLogin);

        HSProgressHUD.showInfo(status: S.of(context).logoutSuccess);
        //  S.of(context).please_input_password
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
      height: 100, //自动设置为系统appbar高度
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
