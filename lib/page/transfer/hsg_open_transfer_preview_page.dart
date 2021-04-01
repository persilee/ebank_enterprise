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
import 'data/transfer_internal_data.dart';
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
          title: Text(S.current.transfer_the_preview),
          centerTitle: true,
          elevation: 1,
        ),
        body: ListView(
          children: [
            // _content(transferData),
            _explain(),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: HsgButton.button(
                title: S.current.confirm,
                click: () {
                  // _loadData(transferData);
                },
                isColor: true,
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
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.transfer_amount),
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  child: Text(
                    transferData.transferIntoCcy +
                        ' ' +
                        FormatUtil.formatSringToMoney(
                            transferData.transferIntoAmount),
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
          _getRowContent(S.current.transfer_from,
              FormatUtil.formatSpace4(transferData.transferOutAccount)),
          _getRowContent(S.current.to_amount,
              FormatUtil.formatSringToMoney(transferData.transferOutAmount)),
          _getRowContent(
              S.current.payment_currency, transferData.transferOutCcy),
          _getRowContent(
              S.current.receipt_side_name, transferData.transferIntoName),
          _getRowContent(S.current.into_account,
              FormatUtil.formatSpace4(transferData.transferIntoAccount)),
          _getRowContent(
              S.current.transfer_into_currency, transferData.transferIntoCcy),
          _getRowContent(
              S.current.transfer_postscript,
              transferData.transferRemark == ''
                  ? S.current.transfer
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
    // String amount = transferData.transferIntoAccount;
    // String transferOutCcy = transferData.transferOutCcy;
    // String transferIntoCcy = transferData.transferIntoCcy;
    // String payeeBankCode = transferData.payeeBankCode;
    // String payeeCardNo = transferData.transferOutAccount;
    // String payeeName = transferData.payeeName;
    // String payerBankCode = transferData.payerBankCode;
    // String cardNo = transferData.transferIntoAccount;
    // String payerName = transferData.payerName;
    // String remark = transferData.transferRemark;
    // String smsCode = '';
    // String xRate = transferData.xRate;
    HSProgressHUD.show();
    Future.wait({
      TransferDataRepository().addTransferPlan(
          AddTransferPlanReq(
            "122.00", //amount
            "9,668,000.00", //availableBalance
            "", //bankSwift
            "", //city
            "", //costOptions
            "HKD", //creditCurrency
            "01", //day
            "HKD", //debitCurrency
            "", //district
            false, //enabled
            "2025-01-01", //endDate
            0, //feeAmount
            "2", //frequency
            "", //midBankSwift
            "", //month
            "L5o+WYWLFVSCqHbd0Szu4Q==", //payPassword
            "", //payeeAddress
            "AAAMFRP1XXX", //payeeBankCode
            "0101238000001538", //payeeCardNo
            "朗华银行", //payeeName
            "AAAMFRP1XXX", //payerBankCode
            "0101268000001878", //payerCardNo
            "朗华银行", //payerName
            "CESI", //planName
            "XXXXXX", //remark
            "", //remittancePurposes
            "", //remitterAddress
            "123456", //smsCode
            "2021-05-01", //startDate
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
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0x57272727),
        textColor: Color(0xffffffff),
      );
    });
  }
}
