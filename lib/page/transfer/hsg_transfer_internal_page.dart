/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_general_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferInternalPage extends StatefulWidget {
  TransferInternalPage({Key key}) : super(key: key);

  @override
  _TransferInternalPageState createState() => _TransferInternalPageState();
}

class _TransferInternalPageState extends State<TransferInternalPage> {
  SliverToBoxAdapter _gaySliver = SliverToBoxAdapter(
    child: Container(
      height: 15,
    ),
  );

  String limitMoney = FormatUtil.formatSringToMoney('20000000.12946');
  String inpuntStr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transfer_type_0),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _gaySliver,
          TransferPayerWidget(
            'HKD',
            'HKD$limitMoney',
            inpuntStr,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              child: HsgBottomBtn('提交', () {
                print('提交');
              }),
            ),
          ),
        ],
      ),
    );
  }
}
