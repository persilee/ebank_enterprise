/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 查看电子结单详情
/// Author: CaiTM
/// Date: 2020-12-14

import 'dart:io';
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
      ),
      body: WebView(
        // initialUrl: data['filePath'],
        initialUrl: 'https://www.baidu.com/',
      ),
    );
  }
}
