import 'dart:ui';

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class OpenAccountSelectDocumentTypePage extends StatelessWidget {
  const OpenAccountSelectDocumentTypePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('联络信息'),
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
                  '请选择证件识别类型',
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
        'titleStr': '中国大陆身份证识别',
        'onClickFunction': () {
          print('中国大陆身份证识别');
        },
      },
      {
        'iconName': 'images/openAccount/open_account_document_type_HK.png',
        'titleStr': '中国香港身份证识别',
        'onClickFunction': () {
          print('中国香港身份证识别');
        },
      },
      {
        'iconName': 'images/openAccount/open_account_document_type_other.png',
        'titleStr': '护照识别 \n(港澳台地区及境外护照)',
        'onClickFunction': () {
          print('护照识别 (港澳台地区及境外护照)');
        },
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
}
