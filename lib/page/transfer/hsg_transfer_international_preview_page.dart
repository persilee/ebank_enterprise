import 'package:ebank_mobile/data/source/model/get_international_transfer.dart';
import 'package:ebank_mobile/data/source/model/get_international_transfer_new.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///跨行（国际）转账预览界面
/// Author: fangluyao
/// Date: 2021-03-17

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.transfer_the_preview),
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
                Text(S.current.transfer_amount),
                Text(
                  transferData.transferIntoCcy +
                      FormatUtil.formatSringToMoney(
                          transferData.transferIntoAmount),
                  style: TextStyle(color: Color(0xff232323), fontSize: 30),
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xffE1E1E1),
          ),
          _getRowContent(S.current.transfer_from,
              FormatUtil.formatSpace4(transferData.transferOutAccount)),
          _getRowContent(S.current.to_amount, transferData.transferOutAmount),
          _getRowContent(
              S.current.payment_currency, transferData.transferOutCcy),
          _getRowContent(
              S.current.remitter_address1, transferData.transferOutAdress),
          _getRowContent(
              S.current.receipt_side_name, transferData.transferIntoName),
          _getRowContent(S.current.into_account,
              FormatUtil.formatSpace4(transferData.transferIntoAccount)),
          _getRowContent(
              S.current.transfer_into_currency, transferData.transferIntoCcy),
          _getRowContent(
              S.current.receiver_address, transferData.transferIntoAdress),
          _getRowContent(S.current.state_area, transferData.nation),
          _getRowContent(S.current.receipt_bank, transferData.bank),
          _getRowContent(S.current.bank_swift, transferData.bankSWIFT),
          _getRowContent(S.current.middle_bank_swift, transferData.centerSWIFI),
          _getRowContent(S.current.Transfer_fee, transferData.transferFee),
          _getRowContent(S.current.remittance_usage, transferData.purpose),
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
    String amount = transferData.transferIntoAccount;
    String transferOutCcy = transferData.transferOutCcy;
    String transferIntoCcy = transferData.transferIntoCcy;
    String payeeBankCode = transferData.payeeBankCode;
    String payeeCardNo = transferData.transferOutAccount;
    String payeeName = transferData.payeeName;
    String payerBankCode = transferData.payerBankCode;
    String payerCardNo = transferData.transferIntoAccount;
    String payerName = transferData.payerName;
    String remark = transferData.transferRemark;
    String costOptions = transferData.transferFee;
    String bankSwift = transferData.bankSWIFT;
    String remittancePurposes = transferData.purpose;
    String district = transferData.nation;
    String payerAddress = transferData.transferOutAdress;
    String payeeAddress = transferData.transferIntoAdress;
    String intermediateBankSwift = transferData.centerSWIFI;
    String countryCode = transferData.countryCode;
    TransferDataRepository()
        .getInternationalTransferNew(
            GetInternationalTransferNewReq(
              amount,
              "",
              "1,997,923.00",
              bankSwift,
              "1",
              costOptions,
              transferOutCcy,
              "818000000113",
              transferIntoCcy,
              countryCode,
              "100",
              "",
              "",
              intermediateBankSwift,
              "0.00",
              "L5o+WYWLFVSCqHbd0Szu4Q==",
              payeeAddress,
              payeeBankCode,
              "朗华银行",
              "朗华银行",
              payeeCardNo,
              payeeName,
              "",
              "",
              "",
              payerAddress,
              payerBankCode,
              payerCardNo,
              payerName,
              "3",
              "",
              remark,
              "",
              "123456",
              "123.00",
              "0",
            ),
            'getInternationalTransferNew')
        .then((data) {
      Navigator.pushReplacementNamed(context, pageOperationResult);
    }).catchError((e) {
      print(e.toString());
    });
    // TransferDataRepository()
    //     .getInterNationalTransfer(
    //         GetInternationalTransferReq(
    //           amount,
    //           bankSwift,
    //           costOptions,
    //           transferOutCcy,
    //           transferIntoCcy,
    //           district,
    //           intermediateBankSwift,
    //           payeeAddress,
    //           payeeBankCode,
    //           payeeCardNo,
    //           payeeName,
    //           payerAddress,
    //           payerBankCode,
    //           payerCardNo,
    //           payerName,
    //           remark,
    //           remittancePurposes,
    //         ),
    //         'getTransferByAccount')
    //     .then((value) {
    //   Navigator.pushReplacementNamed(context, pageOperationResult);
    // }).catchError((e) {
    //   print(e.toString());
    // });
  }
}
