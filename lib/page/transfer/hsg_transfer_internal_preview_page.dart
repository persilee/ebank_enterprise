import 'package:ebank_mobile/config/hsg_dimens.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferInternalPreviewPage extends StatefulWidget {
  TransferInternalPreviewPage({Key key}) : super(key: key);

  @override
  _TransferInternalPreviewPageState createState() =>
      _TransferInternalPreviewPageState();
}

class _TransferInternalPreviewPageState
    extends State<TransferInternalPreviewPage> {
  @override
  Widget build(BuildContext context) {
    // ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('行内转账预览'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _getRowContent("转账金额", "200"),
          _getRowContent("转出账号", "200"),
          _getRowContent("余额", "200"),
          _getRowContent("支付币种", "200"),
          _getRowContent("转出币种", "200"),
          _getRowContent("收款人姓名", "200"),
          _getRowContent("收款人账号", "200"),
          _getRowContent("转出金额", "200"),
          _getRowContent("转账附言", "200"),
          Container(
            margin: EdgeInsets.only(top: 100),
            child: HsgButton.button(
              title: '确认',
              click: () {
                Navigator.pushNamed(context, pageTransfer);
              },
            ),
          ),
        ],
      ),
    );
  }

  //一行内容
  Widget _getRowContent(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(leftText), Text(rightText)],
      ),
    );
  }
}
