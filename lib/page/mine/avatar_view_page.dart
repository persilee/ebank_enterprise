import 'dart:typed_data';
import 'dart:io';

import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/event_bus_utils.dart';
import 'package:ebank_mobile/util/image_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class AvatarViewPage extends StatefulWidget {
  final String imgUrl;

  const AvatarViewPage({Key key, this.imgUrl}) : super(key: key);

  @override
  _AvatarViewPageState createState() => _AvatarViewPageState();
}

class _AvatarViewPageState extends State<AvatarViewPage> {
  Uint8List _memoryImage;
  bool _isClipImage = false;
  File _clipImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          S.current.avatar_title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _selectSaveImgPop(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.more_horiz),
            ),
          )
        ],
      ),
      body: Center(
        child: GestureDetector(
          // onLongPress: () => _saveImgPop(context),
          child: !_isClipImage
              ? FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  image: widget.imgUrl,
                  placeholder: 'images/home/heaerIcon/home_header_person.png',
                )
              : Image.file(
                  _clipImage,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  /// 长安图片弹窗
  _saveImgPop(BuildContext context) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              items: [S.current.avatar_save_phone],
            ));
    if (result != null && result != false) {
      print('result: $result');
      switch (result) {
        case 0:
          _saveImg(widget.imgUrl);
          break;
      }
    } else {
      return;
    }
  }

  /// 点击更多按钮弹窗
  _selectSaveImgPop(BuildContext context) async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              items: [
                S.current.avatar_select_from_your_phone_photo,
                // S.current.avatar_save_phone
              ],
            ));
    if (result != null && result != false) {
      print('result: $result');
      switch (result) {
        case 0:
          _getImage();
          break;
        // case 1:
        //   _saveImg(widget.imgUrl);
        //   break;
      }
    } else {
      return;
    }
  }

  ///保存图片到相册
  Future<void> _saveImg(String imgUrl) async {
    bool result = await saveNetworkImageToPhoto(imgUrl);
    print(result.toString() + imgUrl);
    HSProgressHUD.showToastTip(
      result
          ? S.current.avatar_picture_saved_successfully
          : S.current.avatar_picture_saved_failed,
    );
  }

  Future<void> _getImage() async {
    _memoryImage = await pickImage(context);
    if (_memoryImage.isNotEmpty) {
      Navigator.pushNamed(context, imageEditorPage,
          arguments: {'imageData': _memoryImage}).then((value) async {
        if (value != null) {
          try {
            var image =
                await ApiClient().uploadAvatar(BaseBody(body: {}), value);
            setState(() {
              _clipImage = value;
              _isClipImage = true;
            });
            HSProgressHUD.showToastTip(
              S.current.avatar_uploaded_successfully,
            );
            String _headPortrait = image['headPortrait'] ?? '';
            if (_headPortrait.isEmpty) {
              UserInfoResp data = await ApiClient().getUserInfo(GetUserInfoReq(
                  SpUtil.getString(ConfigKey
                      .USER_ID))); //SpUtil.getString(ConfigKey.CUST_ID)
              _headPortrait = data.headPortrait;
              SpUtil.putString(ConfigKey.USER_AVATAR_URL, data.headPortrait);
              EventBusUtils.getInstance().fire(ChangeHeadPortraitEvent(
                  headPortrait: _headPortrait, state: 300));
            } else {
              SpUtil.putString(ConfigKey.USER_AVATAR_URL, _headPortrait);
              EventBusUtils.getInstance().fire(ChangeHeadPortraitEvent(
                  headPortrait: image['headPortrait'], state: 300));
            }
          } catch (e) {
            print(e);
          }
        }
      });
    }
  }
}
