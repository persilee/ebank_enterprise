/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 转账伙伴页面
/// Author: zhangqirong
/// Date: 2020-12-24

// import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class TransferPartner extends StatefulWidget {
  @override
  _TransferPartnerState createState() => _TransferPartnerState();
}

class _TransferPartnerState extends State<TransferPartner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('转账伙伴'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, pageAddPartner);
            },
            padding: EdgeInsets.only(right: 15),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        
      ),
    );
  }
}
