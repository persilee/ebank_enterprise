import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 用户信息页面
/// Author: zhangqirong
/// Date: 2021-03-16

import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/main.dart';
import 'package:ebank_mobile/util/language.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  String _language = Intl.getCurrentLocale();
  var _changeLangBtnTltle = S.current.language1;
  String _headPortraitUrl = ""; //头像地址
  var _imgPath;
  var _enterpriseName = ''; // 企业名称
  var _userName = '高阳银行企业用户'; // 姓名
  var _characterName = ''; // 角色名称
  String _userPhone = "";
  UserInfoResp _data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoResp _arguments = ModalRoute.of(context).settings.arguments;
    if (_arguments != null) {
      _data = _arguments;
      _userPhone = _arguments.userPhone;
      _changeUserInfoShow(_data);
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_information),
        centerTitle: true,
        elevation: 0,
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
            _infoFrame(S.current.character, _characterName),
            _infoFrame(S.current.company_name, _enterpriseName),
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
    });
  }
}
