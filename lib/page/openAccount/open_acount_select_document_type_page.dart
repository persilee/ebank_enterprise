/// Copyright (c) 2021 深圳高阳寰球科技有限公司
/// 选择证件类型页面
/// Author: 李家伟
/// Date: 2021-03-18

import 'dart:ui';

import 'package:ebank_mobile/authentication/auth_identity.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/model/auth_identity_bean.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenAccountSelectDocumentTypePage extends StatefulWidget {
  const OpenAccountSelectDocumentTypePage({Key key}) : super(key: key);

  @override
  _OpenAccountSelectDocumentTypePageState createState() =>
      _OpenAccountSelectDocumentTypePageState();
}

class _OpenAccountSelectDocumentTypePageState
    extends State<OpenAccountSelectDocumentTypePage> {
  ///业务编号
  String _businessId = '';

  ///是否是快速开户
  bool _isQuick;

  ///按钮是否可以点击
  bool _isCanClick = true;

  @override
  Widget build(BuildContext context) {
    Map argumentsMap = ModalRoute.of(context).settings.arguments;

    _businessId = argumentsMap['businessId'];
    _isQuick = argumentsMap['isQuick'];

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(S.of(context).openAccout_documents_select),
      ),
      body: Container(
        width: size.width,
        color: HsgColors.commonBackground,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Text(
                  S.of(context).openAccout_documents_select_tip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: HsgColors.secondDegreeText,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: size.height - 88 - 79,
                child: listViewWidget(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listViewWidget(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List typeList = [
      {
        'iconName': 'images/openAccount/open_account_document_type_CN.png',
        'titleStr': S.of(context).openAccout_documentType_CN,
        'onClickFunction': _isCanClick == true
            ? () {
                print('中国大陆身份证识别');
                // Navigator.pushNamed(context, pageOpenAccountResults);
                _qianliyanSDK(context, '1');
              }
            : () {},
      },
      {
        'iconName': 'images/openAccount/open_account_document_type_HK.png',
        'titleStr': S.of(context).openAccout_documentType_HK,
        'onClickFunction': _isCanClick == true
            ? () {
                print('中国香港身份证识别');
                _qianliyanSDK(context, '2');
              }
            : () {},
      },
      {
        'iconName': 'images/openAccount/open_account_document_type_other.png',
        'titleStr': S.of(context).openAccout_documentType_other,
        'onClickFunction': _isCanClick == true
            ? () {
                print('护照识别\n (港澳台地区及境外护照)');
                _qianliyanSDK(context, '3');
              }
            : () {},
      }
    ];

    Widget cellViewWidget(Map data) {
      Function() onClickFunction = data['onClickFunction'];
      Widget contentWidget() {
        return Container(
          child: Row(
            children: [
              Container(
                color: HsgColors.blueTextColor,
                height: 100,
                width: 5.5,
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 20),
                child: Image(
                  image: AssetImage(data['iconName']),
                  width: 30,
                  height: 30,
                ),
              ),
              Expanded(
                child: Text(
                  data['titleStr'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: HsgColors.firstDegreeText,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 20),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: HsgColors.firstDegreeText,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Stack(
            children: [
              Container(
                width: size.width - 40,
                height: 100,
                decoration: BoxDecoration(
                  //阴影
                  boxShadow: [
                    BoxShadow(
                      color: HsgColors.color38C8C8C8,
                      blurRadius: 8,
                      offset: Offset(2.5, 2.5),
                    )
                  ],
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
              ),
              contentWidget(),
              Container(
                width: size.width - 40,
                height: 100,
                child: MaterialButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    onClickFunction();
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 15,
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20),
      itemCount: typeList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 115,
          child: cellViewWidget(typeList[index]),
        );
      },
    );
  }

  void _qianliyanSDK(BuildContext context, String documentType) async {
    String _language = Intl.getCurrentLocale();
    String lang = _language == 'en' ? 'en' : 'zh';
    String countryRegions = _language == 'zh_CN' ? 'CN' : 'TW';
    String tokId = 'passport002en';
    if (_language == 'zh_CN') {
      tokId = 'passport001zh';
    } else if (_language == 'zh_HK') {
      tokId = 'passport002ft';
    } else {
      tokId = 'passport002en';
    }
    final prefs = await SharedPreferences.getInstance();
    String userPhone = prefs.getString(ConfigKey.USER_PHONE);
    String businessId = _businessId + '-' + userPhone;

    // HSProgressHUD.show();

    if (mounted) {
      setState(() {
        // _isCanClick = false;
      });
    }

    AuthIdentity()
        .startAuth(
      new AuthIdentityReq(
          "DLEAED", businessId, lang, countryRegions, documentType,
          tokId: tokId),
    )
        .then((value) {
      print(value.toJson());
      HSProgressHUD.dismiss();

      ///通过判断证件号码不为空以及视频地址不为空来判断是否识别正确
      if (value.infoStr != null &&
          value.infoStr['IdNum'] != null &&
          value.infoStr['IdNum'] != '' &&
          (value.isSuccess == true ||
              (value.isSuccess == false &&
                  value.fileName != null &&
                  value.fileName != '' &&
                  value.outCode == '999'))) {
        if (mounted) {
          setState(() {
            _isCanClick = true;
          });
        }
        Navigator.pushNamed(
          context,
          pageOpenAccountIdentifySuccessful,
          arguments: {
            'valueData': value,
            'isQuick': _isQuick,
          },
        );
      } else if (value.outCode == '8' || value.outCode == '6') {
      } else {
        Navigator.pushNamed(
          context,
          pageOpenAccountIdentifyResultsFailure,
          arguments: {
            'businessId': _businessId,
            'isQuick': _isQuick,
            'documentType': documentType,
          },
        );
      }
    }).catchError((e) {
      HSProgressHUD.showToast(e);
      if (mounted) {
        setState(() {
          _isCanClick = true;
        });
      }
      Navigator.pushNamed(
        context,
        pageOpenAccountIdentifyResultsFailure,
        arguments: {
          'businessId': _businessId,
          'isQuick': _isQuick,
          'documentType': documentType,
        },
      );
    });
  }
}
