import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/face_sign_businessid.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/util/format_text_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class OpenAccountGetFaceSignPage extends StatefulWidget {
  @override
  _OpenAccountGetFaceSignPageState createState() =>
      _OpenAccountGetFaceSignPageState(); //构造方法
}

class _OpenAccountGetFaceSignPageState
    extends State<OpenAccountGetFaceSignPage> {
  TextEditingController _codeSignTextF = TextEditingController(); //输入框
  bool _isShowErrorPage = false;
  Widget _hsgErrorPage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //获取屏幕的尺寸

    Widget contentW = Column(
      children: [
        Container(
          //文本
          padding: EdgeInsets.only(left: 30, right: 30, top: 22.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(S.of(context).face_sign_Interviews,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: HsgColors.secondDegreeText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        //输入框
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            children: [
              Container(
                height: 45,
                color: Color(0xFFF5F7F9),
                width: size.width - 60,
                child: TextField(
                  //是否自动更正
                  controller: _codeSignTextF,
                  // autocorrect: true,
                  //是否自动获得焦点
                  // autofocus: true,
                  decoration: InputDecoration(
                    //设置输入框的样式
                    contentPadding: EdgeInsets.only(left: 20), //设置占位文本距离左边的间距
                    border: InputBorder.none,
                    hintText: S.of(context).face_sign_placeholdText,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: HsgColors.textHintColor,
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9]")), //数字与字母的组合
                    LengthLimitingTextInputFormatter(6), //限制长度
                    UpperCaseTextFormatter(), //强制大写
                  ],
                ),
              ),
            ],
          ),
        ),
        //按钮
        Container(
          margin: EdgeInsets.only(top: 40),
          child: HsgButton.defaultButton(
            title: S.of(context).field_dialog_confirm,
            click: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
              _didFaceSignCommit();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 55),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(S.of(context).face_sign_TipsTitle,
                  maxLines: 100,
                  style: TextStyle(
                    color: Color(0xff9c9c9c),
                    fontSize: 13,
                  ),
                  strutStyle:
                      StrutStyle(forceStrutHeight: true, height: 1, leading: 1))
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, //防止像素进行溢出
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(S.of(context).face_sign_navTitle),
      ),
      body: Container(
        width: size.width,
        child: contentW,
      ),
    );
  }

  void _didFaceSignCommit() async {
    final prefs = await SharedPreferences.getInstance();
    String userPhone = prefs.getString(ConfigKey.USER_PHONE) ?? '';
    String areaCode = prefs.getString(ConfigKey.USER_AREACODE) ?? '';

    if (_codeSignTextF.text.length > 0 && userPhone.length > 0) {
      //根据电话以及输入文本这里去请求businessId

      HSProgressHUD.show();
      // OpenAccountRepository()
      ApiClientOpenAccount()
          .getFaceSignBusiness(
              FaceSignIDReq(userPhone, areaCode, _codeSignTextF.text))
          .then(
        (value) {
          HSProgressHUD.dismiss();
          if (value.businessId != '' && value.businessId != null) {
            //跳转证件选择界面
            Navigator.pushNamed(
              context,
              pageOpenAccountSelectDocumentType,
              arguments: {
                'businessId': value.businessId,
                'isQuick': false,
              },
            );
          } else {
            HsgShowTip.notFaceSignBusinessTip(
              //弹窗提示
              context: context,
              click: (value) {
                if (value == true) {}
              },
            );
          }
        },
      ).catchError((e) {
        HSProgressHUD.showToast(e);
      });
    }
  }
}
