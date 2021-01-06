/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账详情界面
/// Author: fangluyao
/// Date: 2020-12-24

import 'package:ebank_mobile/data/source/model/get_transfer_record.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class TransferDetailPage extends StatefulWidget {
  @override
  _TransferDetailPageState createState() => _TransferDetailPageState();
}

class _TransferDetailPageState extends State<TransferDetailPage> {
  @override
  Widget build(BuildContext context) {
    TransferRecord _transferHistory = ModalRoute.of(context).settings.arguments;
    print(_transferHistory.toString);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transfer_detail),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 20, 17, 15),
        child: _transfer(_transferHistory),
      ),
    );
  }

//转账内容
  Widget _transfer(TransferRecord _transferHistory) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _transferAccount(_transferHistory),
        _rowWidget(S.of(context).payee_name, _transferHistory.receiveName),
        _rowWidget(S.of(context).transfer_from_account,
            _transferHistory.receiveCardNo),
        _rowWidget(
            S.of(context).transfer_to_account, _transferHistory.paymentCardNo),
        _rowWidget(
            S.of(context).transaction_time, _transferHistory.transactionHour),
        _differentContent(_transferHistory),
        _rowWidget(S.of(context).remark, _transferHistory.remark),
      ],
    );
  }

  //国内国外转账不同部分
  Widget _differentContent(TransferRecord _transferHistory) {
    return _transferHistory.transferType == "0"
        ? Container()
        : Column(
            children: [
              _rowWidget(
                  S.of(context).state_area, _transferHistory.countryOrRegion),
              _rowWidget(S.of(context).remitter_address,
                  _transferHistory.remitterAddress),
              _rowWidget(
                  S.of(context).payee_address, _transferHistory.payeeAddress),
              _rowWidget(S.of(context).bank_swift, _transferHistory.bankSwift),
              _rowWidget(S.of(context).middle_bank_swift, ""),
              _rowWidget(S.of(context).other_fee, _transferHistory.costOptions),
              _rowWidget(S.of(context).remittance_usage,
                  _transferHistory.remittancePurposes),
            ],
          );
  }

  //转账金额
  Widget _transferAccount(TransferRecord _transferHistory) {
    return Column(
      children: [
        Text(
          S.of(context).transfer_amount,
          style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 40),
          child: Text(
            _transferHistory.debitCurrency +
                " " +
                FormatUtil.formatSringToMoney(_transferHistory.amount),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }

//单行内容
  Widget _rowWidget(String left, String rifht) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              left,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Expanded(
              child: Text(
                rifht,
                style: TextStyle(fontSize: 14, color: Color(0xFF9C9C9C)),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        //下划线
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Divider(height: 1, color: Color(0xFFF5F5F5)),
        ),
      ],
    );
  }
}
