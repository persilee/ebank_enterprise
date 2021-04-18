import 'dart:io';

import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 用户信息页面
/// Author: zhangqirong
/// Date: 2021-03-16

import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';

import '../../page_route.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  String _language = Intl.getCurrentLocale();
  var _changeLangBtnTltle = '';
  String _headPortraitUrl = ""; //头像地址
  var _imgPath;
  var _enterpriseName = ''; // 企业名称
  var _userName = ''; // 姓名
  var _characterName = ''; // 角色名称
  var _belongCustStatus = ''; //用户状态
  String _userPhone = "";
  UserInfoResp _data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _language = Intl.getCurrentLocale();
    if (_language == 'zh_CN') {
      _changeLangBtnTltle = '中文（简体）';
    } else if (_language == 'zh_HK') {
      _changeLangBtnTltle = '中文（繁體）';
    } else {
      _changeLangBtnTltle = 'English';
    }

    UserInfoResp arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      setState(() {
        _data = arguments;
        _userPhone = arguments.userPhone != null ? arguments.userPhone : '';
        _headPortraitUrl =
            arguments.headPortrait != null ? arguments.headPortrait : ''; //头像地址
        _belongCustStatus = arguments.belongCustStatus != null
            ? arguments.belongCustStatus
            : '';
      });
      _changeUserInfoShow(_data);
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_information),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            selectFrame(S.current.head_portrait, _headPortrait(), () {
              _headerInfoTapClick(context);
            }, 70),
            _infoFrame(S.current.user_name, _userName),
            _infoFrame(S.current.phone_num, _userPhone),
            (_belongCustStatus == '5' || _belongCustStatus == '6')
                ? _infoFrame(S.current.character, _characterName)
                : Container(),
            (_belongCustStatus == '5' || _belongCustStatus == '6')
                ? _infoFrame(S.current.company_name, _enterpriseName)
                : Container(),
            selectFrame(
                S.current.language_switch, _hintText(_changeLangBtnTltle), () {
              _selectLanguage(context);
            }, 50),
          ],
        ),
      ),
    );
  }

  ///头像
  Widget _headPortrait() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(55.0 / 2),
      ),
      padding: EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, avatarViewPage, arguments: {'imgUrl': _headPortraitUrl});
        },
        child: Container(
          child: ClipOval(
            child: _headPortraitImage(),
          ),
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

  //通用框(传入左边内容和右边文字)
  Widget _infoFrame(String left, String right) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                child: Text(
                  left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _hintText(right),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Divider(
              height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
        ),
      ],
    );
  }

  //通用框(传入左边文字和右边内容，右边带有next_icon)
  Widget selectFrame(
      String left, Widget right, VoidCallback ontap, double height) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            height: height,
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: Text(
                    left,
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    right,
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Image(
                      color: HsgColors.nextPageIcon,
                      image: AssetImage(
                          'images/home/listIcon/home_list_more_arrow.png'),
                      width: 10,
                      height: 10,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: ontap,
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Divider(
              height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
        ),
      ],
    );
  }

  //灰色文字
  Widget _hintText(String text) {
    return Container(
      width: 150,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          // color: HsgColors.hintText,
          color: Color(0xEE7A7A7A),
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
    setState(() {
      _changeLangBtnTltle = languages[result];
      HSGBankApp.setLocale(context, Language().getLocaleByLanguage(language));
      _changeUserInfoShow(_data);
    });

    EventBusUtils.getInstance()
        .fire(ChangeLanguage(language: _language, state: 300));
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

  //上传头像
  _uploadAvatar() async {
    if (_imgPath == null || _imgPath == '') {
      HSProgressHUD.showInfo(status: S.of(context).select_image_error);
    } else {
      File file = File(_imgPath);
      ApiClient().uploadAvatar(BaseBody(body: {}), file).then((value) {
        EventBusUtils.getInstance().fire(ChangeHeadPortraitEvent(
            headPortrait: value['headPortrait'], state: 300));
        print(value);
      }).catchError((e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

  void _changeUserInfoShow(UserInfoResp model) {
    setState(() {
      _enterpriseName = _language != 'en'
          ? model.custLocalName != null
              ? model.custLocalName
              : ''
          : model.custEngName != null
              ? model.custEngName
              : ''; // 企业名称
      _userName = _language != 'en'
          ? model.localUserName != null
              ? model.localUserName
              : ''
          : model.englishUserName != null
              ? model.englishUserName
              : ''; // 姓名
      _characterName = _language != 'en'
          ? model.roleLocalName != null
              ? model.roleLocalName
              : ''
          : model.roleEngName != null
              ? model.roleEngName
              : ''; //用户角色名称
    });
  }
}
