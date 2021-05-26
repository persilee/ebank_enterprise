import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_international_transfer.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_transfer.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/pay_password_check.dart';
import 'package:ebank_mobile/util/small_data_store.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///跨行（国际）转账预览界面
/// Author: fangluyao
/// Date: 2021-03-17

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_show_tip.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

import '../../page_route.dart';
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

    print('transferDataBuild：${transferData.toString()}');
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.transfer_the_preview2),
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
                  // CheckPayPassword(context, () {
                  _loadData(transferData);
                  // });
                },
                isColor: true,
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
            margin: EdgeInsets.only(top: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.transfer_amount,
                  style: FIRST_DEGREE_TEXT_STYLE,
                ),
                Text(
                  transferData.transferOutCcy +
                      FormatUtil.formatSringToMoney(
                          transferData.transferOutAmount),
                  style: TextStyle(color: Color(0xff232323), fontSize: 20),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffE1E1E1),
          ),
          _getRowContent(S.current.transfer_from,
              FormatUtil.formatSpace4(transferData.transferOutAccount)),
          _getRowContent(S.current.transfer_from_name, transferData.payerName),
          _getRowContent(S.current.payer_currency, transferData.transferOutCcy),
          _getRowContent(S.current.estimated_collection_amount,
              transferData.transferIntoAmount),
          _getRowContent(S.current.rate_of_exchange, transferData.rate),
          // _getRowContent(
          //     S.current.remitter_address1, transferData.transferOutAdress),
          _getRowContent(S.current.receipt_side_account,
              FormatUtil.formatSpace4(transferData.transferIntoAccount)),
          _getRowContent(
              S.current.receipt_side_name, transferData.transferIntoName),
          _getRowContent(
              S.current.transfer_from_ccy, transferData.transferIntoCcy),
          _getRowContent(
              S.current.transfer_to_amount, transferData.transferIntoAmount),
          _getRowContent(
              S.current.receiver_address, transferData.transferIntoAdress),
          _getRowContent(S.current.state_area, transferData.nation),
          _getRowContent(S.current.receipt_bank, transferData.bank),
          _getRowContent(S.current.bank_swift, transferData.bankSWIFT),
          // _getRowContent(S.current.middle_bank_swift, transferData.centerSWIFI),
          _getRowContent(S.current.transfer_fee, transferData.transferFee),
          _getRowContent(S.current.approve_poundage, transferData.feeAmount),
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

  Future _loadData(TransferInternationalData transferData) async {
    final prefs = await SharedPreferences.getInstance();
    String custId = prefs.getString(ConfigKey.CUST_ID);
    String opt = transferData.opt;
    String debitAmount = transferData.transferOutAmount;
    String creditAmount = transferData.transferIntoAmount;
    String transferOutCcy = transferData.transferOutCcy;
    String transferIntoCcy = transferData.transferIntoCcy;
    String payeeBankCode = transferData.payeeBankCode;
    String payeeCardNo = transferData.transferIntoAccount;
    String payeeName = transferData.payeeName;
    String payerBankCode = transferData.payerBankCode;
    String payerCardNo = transferData.transferOutAccount;
    String payerName = transferData.payerName;
    String remark = transferData.transferRemark == ''
        ? S.current.transfer
        : transferData.transferRemark;
    String costOptions = transferData.transferFee;
    String costOptionsIndex = transferData.transferFeeIndex;
    String bankSwift = transferData.bankSWIFT;
    String payeeAddress = transferData.transferIntoAdress;
    String countryCode = transferData.countryCode;
    String rate = transferData.rate;
    String feeAmount = transferData.feeAmount;
    String feeCode = transferData.feeCode;
    HSProgressHUD.show();
    print('payeeNamePrint: $payeeName');
    Transfer()
        .getInterNationalTransfer(GetInternationalTransferReq(
      opt,
      //付款金额
      debitAmount,
      //收款金额
      creditAmount,
      //贷方货币
      transferIntoCcy,
      //借方货币
      transferOutCcy,
      "",
      payeeBankCode,
      payeeCardNo,
      payeeName,
      payerBankCode,
      payerCardNo,
      payerName,
      remark,
      "",
      rate,
      payeeAddress,
      bankSwift,
      countryCode, //countryCode,
      custId,
      costOptionsIndex,
      feeAmount,
      feeCode,
    ))
        .then((value) {
      HSProgressHUD.dismiss();
      Navigator.pushReplacementNamed(context, pageOperationResult);
    }).catchError((e) {
      HSProgressHUD.showToast(e);
    });
  }
}
