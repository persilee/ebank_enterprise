/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 查看电子结单详情
/// Author: CaiTM
/// Date: 2020-12-14

import 'dart:io';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ElectronicStatementDetailPage extends StatefulWidget {
  ElectronicStatementDetailPage({Key key}) : super(key: key);

  @override
  _ElectronicStatementDetailPageState createState() =>
      _ElectronicStatementDetailPageState();
}

class _ElectronicStatementDetailPageState
    extends State<ElectronicStatementDetailPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(data['date']),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onPressed: () {
              _moreSction();
              print('点击了按钮！');
            },
          )
        ],
      ),
      body: WebView(
        initialUrl: data['filePath'],
        // initialUrl: 'https://www.baidu.com/',
      ),
    );
  }

  Future<void> _moreSction() async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
              color: HsgColors.backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(S.current.share),
              ),
              Container(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _weChatColumn(),
                    _momentsColumn(),
                    _downloadColumn(),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  color: Colors.white,
                  child: Text(S.current.cancel),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
        );
      },
    );
  }

  Column _weChatColumn() {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image(
              image: AssetImage('images/tabbar/tabbar_we_chat.png'),
            ),
          ),
          onTap: () {
            print('微信');
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            S.current.we_chat,
            style: TextStyle(color: HsgColors.secondDegreeText),
          ),
        )
      ],
    );
  }

  Column _momentsColumn() {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image(
              image: AssetImage('images/tabbar/tabbar_wechat_moments.png'),
            ),
          ),
          onTap: () {
            print('朋友圈');
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            S.current.moments,
            style: TextStyle(color: HsgColors.secondDegreeText),
          ),
        )
      ],
    );
  }

  Column _downloadColumn() {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image(
              image: AssetImage('images/tabbar/tabbar_download.png'),
            ),
          ),
          onTap: () {
            print('下载到本地');
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            S.current.download,
            style: TextStyle(color: HsgColors.secondDegreeText),
          ),
        )
      ],
    );
  }
}
