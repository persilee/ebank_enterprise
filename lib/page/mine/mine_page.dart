import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// desc: 个人中心
/// Author: hlx
/// Date: 2020-12-11
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/get_last_version.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/logout.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/version_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_packaging.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/screen_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  String _language = Intl.getCurrentLocale();
  double _opacity = 0;
  ScrollController _sctrollController = ScrollController();
  String _lastLoginTime =
      DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  String _userName = "";
  String _headPortraitUrl = "";
  var _imgPath;

  // var _headPortraitUrl = ''; // 头像地址
  // bool _switchZhiWen = true; //指纹登录
  // bool _switchFaceId = false; //faceID登录
  String lastVersionName = ""; //版本号
  var _enterpriseName = ''; // 企业名称
  var _characterName = ''; // 角色名称
  var _belongCustStatus = ''; //用户状态
  UserInfoResp _userInfoResp;

  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getUser();

    EventBusUtils.getInstance().on<GetUserEvent>().listen((event) {
      _getUser();
    });

    EventBusUtils.getInstance().on<ChangeHeadPortraitEvent>().listen((event) {
      if (event.state == 200 ||
          event.state == 100 ||
          event.state == 300 &&
              (event.headPortrait != null && event.headPortrait != '')) {
        setState(() {
          _headPortraitUrl = event.headPortrait;
        });
      }
    });

    EventBusUtils.getInstance().on<ChangeLanguage>().listen((event) {
      if ((event.state == 200 || event.state == 300) && _userInfoResp != null) {
        setState(() {
          _language = event.language;
          _changeUserInfoShow(_userInfoResp);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _mineAppbar(_opacity),
      body: Container(
        child: CustomScrollView(
          shrinkWrap: true,
          controller: _sctrollController,
          slivers: [
            SliverToBoxAdapter(
              child: GestureDetector(
                child: _mineHeaderView(),
                onTap: () {
                  //进入用户信息页面
                  Navigator.pushNamed(context, pageUserInformation,
                          arguments: _userInfoResp)
                      .then((value) {
                    setState(() {
                      _headPortraitUrl =
                          SpUtil.getString(ConfigKey.USER_AVATAR_URL);
                      _language = Intl.getCurrentLocale();
                    });
                    // _changeUserInfoShow(_userInfoResp);
                  });
                },
              ),
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
            // IconButton(
            //   icon: Image(
            //     image: AssetImage('images/home/navIcon/home_nav_service.png'),
            //     width: 18.5,
            //     height: 18.5,
            //     color: HsgColors.mineInfoIcon,
            //   ),
            //   onPressed: () {
            //     print('联系客服');
            //     Navigator.pushNamed(context, pageContactCustomer);
            //   },
            // ),
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
    Widget headerShowWidget = _welcomeWidget();
    switch (_belongCustStatus) {
      case '0': //未开户
      case '1': //未开户
      case '2': //审核中
      case '3': //已驳回
        headerShowWidget = _headerInfoWidget();
        break;
      case '4': //受限已开户
      case '5': //正常已开户
        headerShowWidget = _headerInfoWidget();
        break;
      default:
        headerShowWidget = _welcomeWidget();
    }
    // switch (_belongCustStatus) {
    //   case '0': //未开户
    //   case '1': //未开户
    //     headerShowWidget = _headerInfoWidget();
    //     break;
    //   case '2': //审核中
    //     headerShowWidget = _openAccInReview();
    //     break;
    //   case '3': //已驳回
    //     headerShowWidget = _openAccRejected();
    //     break;
    //   case '4': //受限已开户
    //   case '5': //正常已开户
    //     headerShowWidget = _headerInfoWidget();
    //     break;
    //   default:
    //     headerShowWidget = _welcomeWidget();
    // }
    return Container(
      child: Stack(
        children: [
          // Image(
          //   width: MediaQuery.of(context).size.width,
          //   height: 200,
          //   image: AssetImage(
          //       'images/mine/mine-icon.png'), //'images/mine/mine-icon.png',
          //   fit: BoxFit.cover,
          // ),
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                // decoration: BoxDecoration(color: Color(0xAA000000)),
                decoration: BoxDecoration(color: HsgColors.mineHeadBackground),
              ),
            ],
          ),
          // ClipRect(
          //   //使图片模糊区域仅在子组件区域中
          //   child: BackdropFilter(
          //     //背景过滤器
          //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), //设置图片模糊度
          //     child:
          Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            child: headerShowWidget,
          ),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 中间内容的内容
  Widget _mineContendView(context) {
    // ///指纹登录开关单元widget
    // Widget touchIDUnitW = _switchUnitWidget(
    //     S.of(context).fingerprintLogin, _switchZhiWen, true, (bool value) {
    //   setState(() {
    //     _switchZhiWen = value;
    //   });
    // });

    // ///人脸登录开关单元widget
    // Widget faceIDUintW = _switchUnitWidget(
    //     S.of(context).faceIdlogin, _switchFaceId, true, (bool value) {
    //   setState(() {
    //     _switchFaceId = value;
    //   });
    // });

    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Column(
        children: [
//          Container(
//            width: MediaQuery.of(context).size.width,
//            margin: EdgeInsets.only(bottom: 16),
//            color: Colors.white,
//            child: Column(
//              children: [
//                touchIDUnitW,
//                faceIDUintW,
//              ],
//            ),
//          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            // padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).my_account, true, () {
                  if (['0', '1', '2', '3', ''].contains(_belongCustStatus)) {
                    HsgShowTip.notOpenAccountTip(
                      context: context,
                      click: (value) {
                        if (value == true) {
                          _openAccountClickFunction(context);
                        }
                      },
                    );
                    return;
                  }
                  Navigator.pushNamed(context, pageCardList);
                }),
                _flatBtnNuitWidget(S.current.password_management, true, () {
                  Navigator.pushNamed(context, pagePasswordManagement,
                      arguments: _belongCustStatus);
                }),
                _flatBtnNuitWidget(S.of(context).visa_interview, true, () {
                  //面签
                  Navigator.pushNamed(context, pageOpenAccountGetFaceSign);
                }),
              ],
            ),
          ),
          //
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 16),
            color: Colors.white,
            child: Column(
              children: [
                _flatBtnNuitWidget(S.of(context).aboutUs, true, () {
                  Navigator.pushNamed(context, aboutUs);
                }),
                _flatBtnNuitWidget(S.of(context).customer_service, true, () {
                  Navigator.pushNamed(context, pageContactCustomer);
                }),
                _flatBtnNuitWidget(S.of(context).feedback, true, () {
                  Navigator.pushNamed(context, feedback);
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
                _showTypeTips();
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
            height: 15,
          ),
        ],
      ),
    );
  }

  // ///右侧switchp选项的单元widget
  // Widget _switchUnitWidget(String textString, bool switchValue, bool isShowLine,
  //     Function(bool value) onChangedF) {
  //   Widget switchUnitW;
  //   switchUnitW = Container(
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 50.0,
  //           padding: EdgeInsets.only(left: 15, right: 15),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 textString,
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               CupertinoSwitch(
  //                 activeColor: HsgColors.theme,
  //                 value: switchValue,
  //                 onChanged: (value) {
  //                   //重新构建页面
  //                   onChangedF(value);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         isShowLine
  //             ? Container(
  //                 padding: EdgeInsets.only(left: 15, right: 15),
  //                 child: Divider(
  //                     height: 1,
  //                     color: HsgColors.divider,
  //                     indent: 3,
  //                     endIndent: 3),
  //               )
  //             : Container(),
  //       ],
  //     ),
  //   );
  //   return switchUnitW;
  // }

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
      width: ScreenUtil.instance.width,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 32, right: 24.0),
            child: _headPortrait(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                infoWidget,
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.navigate_next,
              color: HsgColors.mineInfoIcon,
            ),
          ),
        ],
      ),
    );
  }

//用户信息-未开户
  Widget _userOffInfo() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 7),
            child: _nameInfo((MediaQuery.of(context).size.width / 3 * 2 - 20)),
          ),
          Container(
            margin: EdgeInsets.only(top: 7),
            child: _timeInfo(),
          )
        ],
      ),
    );
  }

  //默认欢迎页
  Widget _welcomeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width - 50),
      ),
      child: Text(
        S.of(context).home_header_welcome_title,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 3,
        style: TextStyle(
          color: HsgColors.firstDegreeText,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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

//用户信息-已开户
  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enterpriseInfo(),
        Container(
          margin: EdgeInsets.only(top: 7),
          child: _nameInfo((MediaQuery.of(context).size.width / 3 * 2 - 20)),
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

  //企业信息
  Widget _enterpriseInfo() {
    String enterpriseNameShowStr =
        _enterpriseName == null ? '' : _enterpriseName;
    return Container(
      constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width / 3 * 2 - 20)),
      height: 22,
      child: Text(
        enterpriseNameShowStr,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: HsgColors.mineInfoText,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  //用户名
  Widget _nameInfo(double maxWidth) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: Text(
        _userName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: HsgColors.mineInfoText,
          fontSize: 14,
        ),
      ),
    );
  }

  //用户角色信息
  Widget _characterInfo() {
    String characterNameShowStr = _characterName == null ? '' : _characterName;
    return Container(
      height: 25,
      decoration: BoxDecoration(
        // color: Color(0xff3394d4).withOpacity(0.66), //HsgColors.accent,
        color: HsgColors.mineCharacterBackground, //HsgColors.accent,
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
                maxWidth: (MediaQuery.of(context).size.width / 3 * 2 - 100)),
            child: Text(
              characterNameShowStr,
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

  //时间信息
  Widget _timeInfo() {
    return Text(
      S.current.last_login_time_with_value + _lastLoginTime,
      style: TextStyle(
        color: HsgColors.mineInfoText,
        fontSize: 11,
      ),
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

  //修改语言显示
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

  //设置头像
  Widget _headPortraitImage() {
    Widget imagW;
    if (_imgPath != null && _imgPath != '') {
      imagW = Image(
        image: AssetImage('$_imgPath'),
        fit: BoxFit.cover,
      );
    } else {
      imagW = (_headPortraitUrl == null || _headPortraitUrl == '')
          ? Image(
              image: AssetImage('images/home/heaerIcon/home_header_person.png'),
              fit: BoxFit.cover,
            )
          : FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              image: _headPortraitUrl == null ? '' : _headPortraitUrl,
              placeholder: 'images/home/heaerIcon/home_header_person.png',
            );
    }

    return imagW;
  }

  //上传头像
  _uploadAvatar() async {
    if (_imgPath == null || _imgPath == '') {
      Fluttertoast.showToast(
        msg: S.of(context).select_image_error,
        gravity: ToastGravity.CENTER,
      );
    } else {
      File file = File(_imgPath);
      ApiClient().uploadAvatar(BaseBody(body: {}), file).then((value) {
        EventBusUtils.getInstance().fire(ChangeHeadPortraitEvent(
            headPortrait: value['headPortrait'], state: 100));
        print(value);
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

//获取用户信息
  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);

    // UserDataRepository()
    ApiClientPackaging()
        .getUserInfo(
      GetUserInfoReq(userID),
    )
        .then((data) {
      if (this.mounted) {
        _userInfoResp = data;
        _changeUserInfoShow(_userInfoResp);
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      print('${e.toString()}');
    });
  }

  //提示弹窗(提示语句，确认事件)
  _showTypeTips() {
    showDialog(
        context: context,
        builder: (context) {
          return HsgAlertDialog(
            title: S.current.exit,
            message: S.current.loginOut_tips,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
          );
        }).then((value) {
      if (value == true) {
        _loginOut();
      }
    });
  }

  //退出
  _loginOut() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    HSProgressHUD.show();
    // UserDataRepository()
    ApiClientPackaging().logout(LogoutReq(userID, _userName)).then((data) {
      HSProgressHUD.dismiss();
      if (this.mounted) {
        setState(() {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                pageLogin, ModalRoute.withName(""), //清除旧栈需要保留的栈 不清除就不写这句
                arguments: 'logout' //传值
                );
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     new MaterialPageRoute(builder: (context) => new LoginPage()),
            //     (route) => false);
          });
          Fluttertoast.showToast(
            msg: S.of(context).logoutSuccess,
            gravity: ToastGravity.CENTER,
          );
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
      HSProgressHUD.dismiss();
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
    if (image == null) {
      return;
    }

    setState(() {
      _imgPath = image.path;
      _uploadAvatar();
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
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
    // VersionDataRepository()
    ApiClientAccount()
        .getlastVersion(GetLastVersionReq('0', '1'))
        .then((value) {
      setState(() {
        lastVersionName = value.versionName;
      });
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
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
class _XAppBarState extends State<XAppBar> with AutomaticKeepAliveClientMixin {
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

  @override
  bool get wantKeepAlive => true;
}
