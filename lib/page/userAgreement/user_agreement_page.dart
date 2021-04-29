import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/page/userAgreement/user_link_total_page.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 用户协议
/// Author: CaiTM
/// Date: 2020-12-24

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    // _getUserAgreement(pactId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            pactTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: WebView(
          initialUrl: generateConfigurationLink(pactId), //pactUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            //Webview创建的时候
            _controller = controller;
          },
          onPageFinished: (url) {
            //webView加载完成的时候
            _controller.evaluateJavascript("document.title").then((result) {
              setState(() {
                print(result);
                pactTitle = result;
              });
            });
          },
        )
        // body: pactUrl != ''
        //     ? WebView(
        //         initialUrl: generateConfigurationLink('userLink'), //pactUrl,
        //         javascriptMode: JavascriptMode.unrestricted,
        //       )
        //     : Container(),
        );
  }

  _getUserAgreement(String pactId) async {
    // UserAgreementRepository()
    ApiClientAccount().getUserPact(GetUserAgreementReq(pactId)).then((data) {
      setState(() {
        pactUrl =
            'http://47.57.236.20:5040/public/pact/url/privacyPolicy_Local.html';
        // http://68.79.26.61:9000/public/pact/url/privacyPolicy_Local.html
        pactTitle = data.pactNameCn;

        // if (Intl.getCurrentLocale() == 'zh_CN') {
        //   pactUrl = data.detailCnLink;
        //   pactTitle = data.pactNameCn;
        // } else {
        //   pactUrl = data.detailEnLink;
        //   pactTitle = data.pactNameEn;
        // }
      });
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
