/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 个人中心
/// Author: hlx
/// Date: 2020-12-11
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/check_phone.dart';
import 'package:ebank_mobile/data/source/model/get_last_version.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/register_by_account.dart';
import 'package:ebank_mobile/data/source/model/send_sms_register.dart';
import 'package:ebank_mobile/data/source/model/logout.dart';
// import 'package:ebank_mobile/data/source/model/upload_avatar.dart';
// import 'package:ebank_mobile/data/source/upload_avatar_network.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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
  String _headPortraitUrl = "";
  var _imgPath;
  // var _headPortraitUrl = ''; // 头像地址
  bool _switchZhiWen = true; //指纹登录
  bool _switchFaceId = false; //faceID登录
  String lastVersionName = ""; //版本号
  String _userPhone = "";
  String _userType = "";
  String _register = ""; //用户是否注册
  String _areaCode = ""; //区号
  String _smsType = "register"; //短信类型(注册)
  String _sms = ""; //验证码
  String _password = "123456qwe~"; //密码
  String _registerAccount = "wly3"; //手机号注册（用户账号）

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
            image: AssetImage(
                'images/mine/mine-icon.png'), //'images/mine/mine-icon.png',
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
          _headerInfoWidget(),
        ],
      ),
    );
  }

  /// 中间内容的内容
  Widget _mineContendView(context) {
    ///指纹登录开关单元widget
    Widget touchIDUnitW = _switchUnitWidget(
        S.of(context).fingerprintLogin, _switchZhiWen, true, (bool value) {
      setState(() {
        _switchZhiWen = value;
      });
    });

    ///人脸登录开关单元widget
    Widget faceIDUintW = _switchUnitWidget(
        S.of(context).faceIdlogin, _switchFaceId, true, (bool value) {
      setState(() {
        _switchFaceId = value;
      });
    });

    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            child: Column(
              children: [
                touchIDUnitW,
                faceIDUintW,
              ],
            ),
          ),
          //修改登录密码
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).resetLoginPsw, true, () {
                  Navigator.pushNamed(context, changeLgPs);
                }),
                _flatBtnNuitWidget(S.of(context).changPayPws, true, () {
                  Navigator.pushNamed(context, changePayPS);
                }),
                _flatBtnNuitWidget(S.of(context).resetPayPwd, true, () {
                  Navigator.pushNamed(context, iDcardVerification);
                }),
              ],
            ),
          ),
          //
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).feedback, true, () {
                  Navigator.pushNamed(context, feedback);
                }),
                _flatBtnNuitWidget(S.of(context).aboutUs, true, () {
                  Navigator.pushNamed(context, aboutUs);
                }),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget('签里眼面签相关', true, () {
                  Navigator.pushNamed(context, pageQianliyanDemo);
                }),
              ],
            ),
          ),
          //退出按钮
          Container(
            height: 50,
            color: Colors.white,
            child: FlatButton(
              height: 50.0,
              onPressed: () {
                //退出登录
                _loginOut();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    S.of(context).loginOut,
                    style: TextStyle(color: HsgColors.redTextColor),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [_version(), _checkUserPhone()],
            ),
          ),
          Container(
            child: Row(
              children: [_smsRegister(), _registerByAccountBtn()],
            ),
          ),
          Container(
            height: 15,
          ),
        ],
      ),
    );
  }

  ///右侧switchp选项的单元widget
  Widget _switchUnitWidget(String textString, bool switchValue, bool isShowLine,
      Function(bool value) onChangedF) {
    Widget switchUnitW;
    switchUnitW = Container(
      child: Column(
        children: [
          Container(
            height: 50.0,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textString,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                CupertinoSwitch(
                  activeColor: HsgColors.theme,
                  value: switchValue,
                  onChanged: (value) {
                    //重新构建页面
                    onChangedF(value);
                  },
                ),
              ],
            ),
          ),
          isShowLine
              ? Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                      height: 1,
                      color: HsgColors.divider,
                      indent: 3,
                      endIndent: 3),
                )
              : Container(),
        ],
      ),
    );
    return switchUnitW;
  }

  ///按钮单元格，左文字，有箭头图标
  Widget _flatBtnNuitWidget(
      String leftString, bool isShowLine, VoidCallback onClick) {
    return Column(
      children: [
        FlatButton(
          height: 50.0,
          onPressed: onClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftString,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.navigate_next,
                  color: HsgColors.nextPageIcon,
                ),
              ),
            ],
          ),
        ),
        isShowLine
            ? Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                    height: 1,
                    color: HsgColors.divider,
                    indent: 3,
                    endIndent: 3),
              )
            : Container(),
      ],
    );
  }

//头部信息展示
  Widget _headerInfoWidget() {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 78.0, left: 32, right: 24.0, bottom: 78.0),
              child: _headPortrait(),
            ),
            Expanded(
              child: Column(
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
                  Text(
                    S.of(context).lastLoginTime + _lastLoginTime,
                    style: TextStyle(
                      color: HsgColors.aboutusText,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _headerInfoTapClick(context);
      },
    );
  }

  ///头像
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
          child: _headPortraitImage(),
        ),
      ),
    );
  }

  //设置头像
  Widget _headPortraitImage() {
    Widget imagW;
    if (_imgPath != null && _imgPath != '') {
      imagW = Image(
        image: AssetImage('$_imgPath'),
      );
    } else {
      imagW = (_headPortraitUrl == null || _headPortraitUrl == '')
          ? Image(
              image: AssetImage('images/home/heaerIcon/home_header_person.png'),
            )
          : FadeInImage.assetNetwork(
              fit: BoxFit.fitWidth,
              image: _headPortraitUrl == null ? '' : _headPortraitUrl,
              placeholder: 'images/home/heaerIcon/home_header_person.png',
            );
    }

    return imagW;
  }

  //上传头像
  _uploadAvatar() async {
    if (_imgPath == null || _imgPath == '') {
      HSProgressHUD.showInfo(status: '图片异常，请重新选择');
    } else {
      // HSProgressHUD.show();
      // UploadAvatarRepository()
      //     .uploadAvatar(UploadAvatarReq(), _imgPath, 'uploadAvatar')
      //     .then((data) {
      //   setState(() {});
      //   HSProgressHUD.dismiss();
      // }).catchError((e) {
      //   Fluttertoast.showToast(msg: e.toString());
      //   HSProgressHUD.dismiss();
      // });
    }
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
        _headPortraitUrl = data.headPortrait; //头像
        // _lastLoginTime = data.lastLoginTime; // 上次登录时间
        _userType = data.userType; //用户类型
        _userPhone = data.userPhone; //用户手机号
        _areaCode = data.areaCode; //区号
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
    // UserDataRepository()
    //     .getUserInfo(
    //   GetUserInfoReq(userID),
    //   'logout',
    // )
    UserDataRepository()
        .logout(LogoutReq(userID, _userName), 'logout')
        .then((data) {
      setState(() {
        // prefs.setString(ConfigKey.USER_ACCOUNT, '');
        // prefs.setString(ConfigKey.USER_ID, '');
        // prefs.setString(ConfigKey.NET_TOKEN, '');
        // Navigator.pushNamed(context, pageLogin);
        Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => new LoginPage()),
              (route) => false);
        });

        HSProgressHUD.showInfo(status: S.of(context).logoutSuccess);
        //  S.of(context).please_input_password
      });
    }).catchError((e) {
      // Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.showError(status: e.toString());
      print('${e.toString()}');
    });
  }

  _headerInfoTapClick(BuildContext context) async {
    List<String> operations = [
      S.of(context).photos,
      S.of(context).camera,
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: S.of(context).photo_selection, //S.current.select_language,
              items: operations,
            ));
    if (result != null && result != false) {
      switch (result) {
        case 0:
          _openGallery();
          break;
        case 1:
          _takePhoto();
          break;
      }
    } else {
      return;
    }
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image.path;
      _uploadAvatar();
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image.path;
      _uploadAvatar();
    });
  }

  //版本更新按钮
  Widget _version() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      height: 50,
      color: Colors.blue[200],
      child: FlatButton(
        height: 50.0,
        onPressed: () {
          _getLastVersion();
        },
        child: Container(
          width: 90,
          child: Center(
            child: Text(
              '版本更新' + lastVersionName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //版本更新接口
  _getLastVersion() async {
    VersionDataRepository()
        .getlastVersion(GetLastVersionReq('0', '1'), 'getLastVersion')
        .then((value) {
      setState(() {
        lastVersionName = value.versionName;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

//校验用户是否注册按钮
  Widget _checkUserPhone() {
    return Container(
      height: 50,
      color: Colors.blue[200],
      child: FlatButton(
        height: 50.0,
        onPressed: () {
          _checkPhone();
        },
        child: Container(
          width: 90,
          child: Center(
            child: Text(
              '校验用户是否注册 ' + _register,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //校验用户是否注册接口
  _checkPhone() async {
    VersionDataRepository()
        .checkPhone(CheckPhoneReq(_userPhone, _userType), 'checkPhone')
        .then((value) {
      setState(() {
        _register = (value.register).toString();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //注册发送短信验证码按钮
  Widget _smsRegister() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      height: 50,
      color: Colors.blue[200],
      child: FlatButton(
        height: 50.0,
        onPressed: () {
          _sendSmsRegister();
        },
        child: Container(
          width: 90,
          child: Center(
            child: Text(
              '获取验证码',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //注册发送短信验证码接口
  _sendSmsRegister() async {
    VersionDataRepository()
        .sendSmsRegister(SendSmsRegisterReq(_areaCode, _userPhone, _smsType),
            'sendSmsRegister')
        .then((value) {
      setState(() {
        _sms = "123456";
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //手机号注册按钮
  Widget _registerByAccountBtn() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      height: 50,
      color: Colors.blue[200],
      child: FlatButton(
        height: 50.0,
        onPressed: () {
          _registerByAccount();
        },
        child: Container(
          width: 90,
          child: Center(
            child: Text(
              '手机号注册',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //手机号注册接口
  _registerByAccount() async {
    String password = EncryptUtil.aesEncode(_password);
    VersionDataRepository()
        .registerByAccount(
            RegisterByAccountReq(_areaCode, password, _registerAccount,
                _userPhone, _userType, _sms),
            'registerByAccount')
        .then((value) {
      setState(() {});
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
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
