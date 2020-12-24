/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 用户协议
/// Author: CaiTM
/// Date: 2020-12-24

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户协议'),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl:
            'http://161.189.8.160:7600/kont/pact/url/99867_CN.html?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20201224%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201224T065834Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=cb2ccadb3b50e24767b33b07c61d3ad01530d4d358ec8a1c0f2a99b28c9f3f16',
        // javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
