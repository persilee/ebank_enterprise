/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///跨行（国际）转账预览界面
/// Author: fangluyao
/// Date: 2021-03-17

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/transfer_international_data.dart';

class TransferinternationalPreviewPage extends StatefulWidget {
  TransferinternationalPreviewPage({Key key}) : super(key: key);

  @override
  _TransferInternalPreviewPageState createState() =>
      _TransferInternalPreviewPageState();
}

class _TransferInternalPreviewPageState
    extends State<TransferinternationalPreviewPage> {
  @override
  Widget build(BuildContext context) {
    TransferInternationalData transferData =
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
              margin: EdgeInsets.only(top: 50, bottom: 50),
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

  Widget _content(TransferInternationalData transferData) {
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
          _getRowContent("汇款方地址", transferData.transferOutAdress),
          _getRowContent("收款方名称", transferData.transferIntoName),
          _getRowContent("转入账号", transferData.transferIntoAccount),
          _getRowContent("转入币种", transferData.transferIntoCcy),
          _getRowContent("收款方地址", transferData.transferIntoAdress),
          _getRowContent("国家地区", transferData.nation),
          _getRowContent("收款银行", transferData.bank),
          _getRowContent("银行SWIFT", transferData.bankSWIFT),
          _getRowContent("中间行SWIFT", transferData.centerSWIFI),
          _getRowContent("转账费用", transferData.transferFee),
          _getRowContent("汇款用途", transferData.purpose),
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
      ),
    );
  }
}
