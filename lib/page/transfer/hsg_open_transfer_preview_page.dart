import 'package:ebank_mobile/data/source/model/add_transfer_plan.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///预约转账预览界面
/// Author: fangluyao
/// Date: 2021-03-15

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../page_route.dart';
import 'data/transfer_order_data.dart';

class TransferOrderPreviewPage extends StatefulWidget {
  TransferOrderPreviewPage({Key key}) : super(key: key);

  @override
  _TransferOrderPreviewPageState createState() =>
      _TransferOrderPreviewPageState();
}

class _TransferOrderPreviewPageState extends State<TransferOrderPreviewPage> {
  @override
  Widget build(BuildContext context) {
    TransferOrderData transferData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.transfer_the_preview3),
          centerTitle: true,
          elevation: 1,
        ),
        body: ListView(
          children: [
            _content(transferData),
            _explain(),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: HsgButton.button(
                title: S.current.confirm,
                click: () {
                  _loadData(transferData);
                },
                isColor: true,
              ),
            ),
          ],
        ));
  }

  Widget _content(TransferOrderData transferData) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.transfer_amount),
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  child: Text(
                    transferData.creditCurrency +
                        ' ' +
                        FormatUtil.formatSringToMoney(transferData.amount),
                    style: TextStyle(color: Color(0xff232323), fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffE1E1E1),
          ),
          _getRowContent('计划名称', transferData.planName),
          _getRowContent('预约频率', transferData.frequency),
          _getRowContent('首次转账时间', transferData.startDate),
          _getRowContent('截至日期', transferData.endDate),
          _getRowContent(S.current.transfer_from,
              FormatUtil.formatSpace4(transferData.payerCardNo)),
          _getRowContent(S.current.estimated_collection_amount,
              FormatUtil.formatSringToMoney(transferData.amount)),
          _getRowContent(S.current.rate_of_exchange, '1'),
          _getRowContent(
              S.current.payment_currency, transferData.debitCurrency),
          _getRowContent(S.current.receipt_side_name, transferData.payeeName),
          _getRowContent(S.current.receipt_side_account,
              FormatUtil.formatSpace4(transferData.payeeCardNo)),
          _getRowContent(
              S.current.transfer_from_ccy, transferData.debitCurrency),
          _getRowContent(
              S.current.transfer_postscript,
              transferData.remark == ''
                  ? S.current.transfer
                  : transferData.remark),
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
            S.current.preview_explain1,
            style: TextStyle(color: Color(0xffA9A8A8), fontSize: 13),
          ),
          Text(
            S.current.preview_explain2,
            style: TextStyle(color: Color(0xffA9A8A8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  //一行内容
  Widget _getRowContent(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                child: Text(
                  leftText,
                  style: TextStyle(color: Color(0xff262626), fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 40) / 2,
                child: Text(
                  rightText,
                  style: TextStyle(color: Color(0xff7A7A7A), fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _loadData(TransferOrderData transferData) async {
    String amount = transferData.amount;
    String availableBalance = transferData.availableBalance;
    String creditCurrency = transferData.creditCurrency;
    String day = transferData.day;
    String debitCurrency = transferData.debitCurrency;
    String endDate = transferData.endDate;
    String frequency = transferData.frequency;
    String payeeBankCode = transferData.payeeBankCode;
    String payeeCardNo = transferData.payeeCardNo;
    String payeeName = transferData.payeeName;
    String payerBankCode = transferData.payerBankCode;
    String payerCardNo = transferData.payerCardNo;
    String payerName = transferData.payerName;
    String planName = transferData.planName;
    String remark = transferData.remark;
    String startDate = transferData.startDate;
    HSProgressHUD.show();
    Future.wait({
      TransferDataRepository().addTransferPlan(
          AddTransferPlanReq(
            amount, //amount
            availableBalance, //availableBalance
            "", //bankSwift
            "", //city
            "", //costOptions
            creditCurrency, //creditCurrency
            day, //day
            debitCurrency, //debitCurrency
            "", //district
            false, //enabled
            endDate, //endDate
            0, //feeAmount
            frequency, //frequency
            "", //midBankSwift
            "", //month
            "L5o+WYWLFVSCqHbd0Szu4Q==", //payPassword
            "", //payeeAddress
            payeeBankCode, //payeeBankCode
            payeeCardNo, //payeeCardNo
            payeeName, //payeeName
            payerBankCode, //payerBankCode  AAAMFRP1XXX
            payerCardNo, //payerCardNo
            payerName, //payerName
            planName, //planName
            remark, //remark
            "", //remittancePurposes
            "", //remitterAddress
            "123456", //smsCode
            startDate, //startDate
            "0", //transferType
          ),
          'AddTransferPlanReq')
    }).then((value) {
      HSProgressHUD.dismiss();
      Navigator.pushNamed(context, pageDepositRecordSucceed,
          arguments: "advanceTransfer");
      // setState(() {});
    }).catchError((e) {
      print(e.toString());
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
