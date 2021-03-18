/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///行内转账预览界面
/// Author: fangluyao
/// Date: 2021-03-15

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/transfer_internal_data.dart';

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
    TransferInternalData transferData =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('转账预览'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            _content(transferData),
            _explain(),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: HsgButton.button(
                title: '确认',
                click: () {
                  Navigator.of(context)..pop()..pop();
                },
              ),
            ),
          ],
        ));
  }

  Widget _content(TransferInternalData transferData) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('转账金额'),
                Text(
                  '— ' +
                      transferData.transferIntoCcy +
                      transferData.transferIntoAmount,
                  style: TextStyle(color: Color(0xff232323), fontSize: 30),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffE1E1E1),
          ),
          _getRowContent("转出账号", transferData.transferOutAccount),
          _getRowContent("转出金额", transferData.transferOutAmount),
          _getRowContent("支付币种", transferData.transferOutCcy),
          _getRowContent("收款方名称", transferData.transferIntoName),
          _getRowContent("转入账号", transferData.transferIntoAccount),
          _getRowContent("转入币种", transferData.transferIntoCcy),
          _getRowContent(
              "转账附言",
              transferData.transferRemark == ''
                  ? '转账'
                  : transferData.transferRemark),
        ],
      ),
    );
  }

  //说明
  Widget _explain() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '说明：',
            style: TextStyle(color: Color(0xffA9A8A8), fontSize: 13),
          ),
          Text(
            '具体转出金额以交易发生时的汇率计算所得金额为准',
            style: TextStyle(color: Color(0xffA9A8A8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  //一行内容
  Widget _getRowContent(String leftText, String rightText) {
    return Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftText,
                  style: TextStyle(color: Color(0xff262626), fontSize: 14),
                ),
                Text(
                  rightText,
                  style: TextStyle(color: Color(0xff7A7A7A), fontSize: 14),
                ),
              ],
            ),
          ],
        ));
  }
}
