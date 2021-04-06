import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

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
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page/login/login_page.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebank_mobile/data/source/model/get_invitee_status_by_phone.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/main.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
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
  var _inviteeStatus = '0'; //用户受邀状态，是否是走快速开户，默认为0，不走

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
                color: HsgColors.mineInfoIcon,
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
            width: MediaQuery.of(context).size.width,
            height: 200,
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
                  Navigator.pushNamed(context, pageCardList);
                }),
                _flatBtnNuitWidget(S.current.password_management, true, () {
                  Navigator.pushNamed(context, pagePasswordManagement,
                      arguments: _belongCustStatus);
                }),
                _flatBtnNuitWidget(S.of(context).visa_interview, true, () {
                  //面签
                  Navigator.pushNamed(context, pageOpenAccountGetFaceSign);
                  // _inviteeStatus == '0'
                  //     ? Navigator.pushNamed(context, pageOpenAccountGetFaceSign)
                  //     : Navigator.pushNamed(context, pageOpenAccountBasicData);
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
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: EdgeInsets.only(bottom: 16),
          //   color: Colors.white,
          //   // padding: EdgeInsets.only(left: 20, right: 20),
          //   child: Column(
          //     children: [
          //       _flatBtnNuitWidget('签里眼面签相关', true, () {
          //         Navigator.pushNamed(context, pageQianliyanDemo);
          //       }),
          //     ],
          //   ),
          // ),
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
          // Container(
          //   margin: EdgeInsets.only(bottom: 10),
          //   child: Row(
          //     children: [_version(), _checkUserPhone()],
          //   ),
          // ),
          // Container(
          //   child: Row(
          //     children: [_smsRegister(), _registerByAccountBtn()],
          //   ),
          // ),
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
      height: 200,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 50),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 32, right: 24.0),
              child: _headPortrait(),
            ),
            onTap: () {
              _headerInfoTapClick(context);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                infoWidget,
                // Text(
                //   _userName,
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //       color: HsgColors.aboutusText,
                //       fontSize: 20.0,
                //       height: 1.5),
                // ),
                // Text(
                //   S.of(context).lastLoginTime + _lastLoginTime,
                //   style: TextStyle(
                //     color: HsgColors.aboutusText,
                //     fontSize: 12.0,
                //   ),
                // ),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.navigate_next,
                color: HsgColors.mineInfoIcon,
              ),
            ),
            onTap: () {
              //进入用户信息页面
              Navigator.pushNamed(context, pageUserInformation,
                      arguments: _userInfoResp)
                  .then((value) {
                setState(() {
                  _language = Intl.getCurrentLocale();
                });
                _changeUserInfoShow(_userInfoResp);
              });
            },
          ),
        ],
      ),
    );
  }

//用户信息-未开户
  Widget _userOffInfo() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _nameInfo((MediaQuery.of(context).size.width / 3 * 2 - 160)),
        CustomButton(
          margin: EdgeInsets.all(0),
          height: 35,
          borderRadius: BorderRadius.circular(50.0),
          text: Text(
            S.current.open_account_apply,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          clickCallback: () {
            print('开户申请');
            //判断受邀状态进入不同页面
            _openAccountClickFunction(context);
          },
        ),
      ],
    ));
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
      margin: EdgeInsets.only(top: 100),
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
    if (_inviteeStatus == '0') {
      // //前往填写面签码
      // Navigator.pushNamed(context, pageOpenAccountGetFaceSign);
      HsgShowTip.notOpenAccountGotoEbankTip(
        context: context,
        click: (value) {},
      );
    } else {
      //前往快速开户
      Navigator.pushNamed(context, pageOpenAccountBasicData);
    }
  }

  Future<void> _getInviteeStatusByPhoneNetwork() async {
    final prefs = await SharedPreferences.getInstance();
    String userAreaCode = prefs.getString(ConfigKey.USER_AREACODE);
    String userPhone = prefs.getString(ConfigKey.USER_PHONE);

    UserDataRepository()
        .getInviteeStatusByPhone(
      GetInviteeStatusByPhoneReq(userAreaCode, userPhone),
      'getInviteeStatusByPhone',
    )
        .then((data) {
      if (this.mounted) {
        setState(() {
          _inviteeStatus = data.inviteeStatus;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      print('${e.toString()}');
    });
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
        _belongCustStatus = model.userId == '989185387615485977'
            ? '5'
            : model.belongCustStatus; //用户状态(先临时数据判断是blk703显示为已开户)
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
        //, BaseBody(body: {})
        print(value);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      });

      // Uint8List _bytes = base64Decode(
      //   'data:image/jpeg;base64,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',
      // );
      // // Image image = Image.memory(_bytes);
      // // FileImage imageFile = FileImage(file)
      // // File filea = File(_bytes, 'certificate.jpg');
      // File filea = File.fromRawPath(_bytes);
      // // File file = File(_imgPath);
      // ApiClient().uploadBankIcon(BaseBody(body: {}), filea).then((value) {
      //   //, BaseBody(body: {})
      //   print(value);
      // }).catchError((e) {
      //   Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
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
      if (this.mounted) {
        _userInfoResp = data;
        _changeUserInfoShow(_userInfoResp);
      }

      if (['0', '1', '3'].contains(data.belongCustStatus)) {
        _getInviteeStatusByPhoneNetwork();
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
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
    // UserDataRepository()
    //     .getUserInfo(
    //   GetUserInfoReq(userID),
    //   'logout',
    // )
    HSProgressHUD.show();
    UserDataRepository()
        .logout(LogoutReq(userID, _userName), 'logout')
        .then((data) {
      HSProgressHUD.dismiss();
      if (this.mounted) {
        setState(() {
          // prefs.setString(ConfigKey.USER_ACCOUNT, '');
          // prefs.setString(ConfigKey.USER_ID, '');
          // prefs.setString(ConfigKey.NET_TOKEN, '');
          // Navigator.pushNamed(context, pageLogin);
          // Navigator.pushNamed(context, pageLogin);
          Future.delayed(Duration.zero, () {
            Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => new LoginPage()),
                (route) => false);
          });
          Fluttertoast.showToast(
              msg: S.of(context).logoutSuccess, gravity: ToastGravity.CENTER);
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      HSProgressHUD.dismiss();
      // print(e.toString());
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
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
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
