import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 用户协议
/// Author: CaiTM
/// Date: 2020-12-24

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ebank_mobile/data/source/model/get_user_agreement.dart';
import 'package:ebank_mobile/data/source/user_agreement_repository.dart';

class UserAgreementPage extends StatefulWidget {
  final String pactId;
  UserAgreementPage({Key key, this.pactId}) : super(key: key);
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState(pactId);
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  String pactUrl = '';
  String pactId;
  String pactTitle = '';
  WebViewController _controller;
  _UserAgreementPageState(this.pactId);
  @override
  void initState() {
    super.initState();
    _getUserAgreement(pactId);
  }

  @override
  Widget build(BuildContext context) {
    print('~ ~ ~ ~ ~~ ~ ~ ~$pactUrl');

    return Scaffold(
        appBar: AppBar(
          title: Text(
            pactTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: WebView(
          initialUrl: pactUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            //Webview创建的时候
            _controller = controller;
          },
        ));
  }

  _getUserAgreement(String pactId) async {
    HSProgressHUD.show();
    ApiClientAccount().getUserPact(GetUserAgreementReq(pactId)).then((data) {
      String _language = Intl.getCurrentLocale();
      setState(() {
        if (_language == 'zh_CN') {
          //简体中文
          pactUrl = data.detailCnLink;
          pactTitle = data.pactNameCn;
        } else if (_language == 'zh_HK') {
          //繁体
          pactUrl = data.detailLocalLink;
          pactTitle = data.pactNameLocal;
        } else {
          //英文
          pactUrl = data.detailEnLink;
          pactTitle = data.pactNameEn;
        }
        _controller.loadUrl(pactUrl);
      });
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }
}
