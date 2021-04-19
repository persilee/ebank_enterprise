import 'dart:typed_data';
import 'dart:io';

import 'package:ebank_mobile/http/retrofit/api_client.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/image_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AvatarViewPage extends StatefulWidget {
  final String imgUrl;

  const AvatarViewPage({Key key, this.imgUrl}) : super(key: key);

  @override
  _AvatarViewPageState createState() => _AvatarViewPageState();
}

class _AvatarViewPageState extends State<AvatarViewPage> {
  Uint8List _memoryImage;

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
          '头像',
          style: TextStyle(color: Colors.white),
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
          onLongPress: () => _saveImgPop(context),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            image: widget.imgUrl,
            placeholder: 'images/home/heaerIcon/home_header_person.png',
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
              items: ['保存到手机'],
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
              items: ['从手机相册选择', '保存到手机'],
            ));
    if (result != null && result != false) {
      print('result: $result');
      switch (result) {
        case 0:
          _getImage();
          break;
        case 1:
          _saveImg(widget.imgUrl);
          break;
      }
    } else {
      return;
    }
  }

  ///保存图片到相册
  Future<void> _saveImg(String imgUrl) async {
    bool result = await saveNetworkImageToPhoto(imgUrl);
    print(result.toString() + imgUrl);
    Fluttertoast.showToast(
      msg: result ? '图片保存成功' : '图标保存失败',
      gravity: ToastGravity.CENTER,
    );
  }

  Future<void> _getImage() async {
    _memoryImage = await pickImage(context);
    if (_memoryImage.isNotEmpty) {
      Navigator.pushNamed(context, imageEditorPage,
          arguments: {'imageData': _memoryImage}).then((value) async {
            if(value != null) {
              var image = await ApiClient().uploadAvatar(BaseBody(body: {}), value);
              print('image: ${image['headPortrait']}');
            }
      });
    }
  }
}
