import 'package:ebank_mobile/http/retrofit/api_client_account.dart';

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

  _UserAgreementPageState(this.pactId);

  @override
  void initState() {
    super.initState();
    _getUserAgreement(pactId);
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
      body: pactUrl != ''
          ? WebView(
              initialUrl: pactUrl,
              javascriptMode: JavascriptMode.unrestricted,
            )
          : Container(),
    );
  }

  _getUserAgreement(String pactId) async {
    // UserAgreementRepository()
    ApiClientAccount().getUserPact(GetUserAgreementReq(pactId)).then((data) {
      setState(() {
        if (Intl.getCurrentLocale() == 'zh_CN') {
          pactUrl = data.detailCnLink;
          pactTitle = data.pactNameCn;
        } else {
          pactUrl = data.detailEnLink;
          pactTitle = data.pactNameEn;
        }
      });
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
