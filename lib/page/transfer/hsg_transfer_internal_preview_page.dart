import 'package:ebank_mobile/data/source/model/get_transfer_by_account.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';

/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///行内转账预览界面
/// Author: fangluyao
/// Date: 2021-03-15

import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../page_route.dart';
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
          title: Text(S.current.transfer_the_preview1),
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
          _getRowContent(S.current.estimated_collection_amount,
              FormatUtil.formatSringToMoney(transferData.transferOutAmount)),
          _getRowContent(S.current.rate_of_exchange, transferData.xRate),
          _getRowContent(
              S.current.payment_currency, transferData.transferOutCcy),
          _getRowContent(
              S.current.receipt_side_name, transferData.transferIntoName),
          _getRowContent(S.current.receipt_side_account,
              FormatUtil.formatSpace4(transferData.transferIntoAccount)),
          _getRowContent(
              S.current.transfer_from_ccy, transferData.transferIntoCcy),
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

  Future _loadData(TransferInternalData transferData) async {
    double money = double.parse(transferData.transferIntoAccount);
    String transferOutCcy = transferData.transferOutCcy;
    String transferIntoCcy = transferData.transferIntoCcy;
    String payeeBankCode = transferData.payeeBankCode;
    String payeeCardNo = transferData.transferOutAccount;
    String payeeName = transferData.payeeName;
    String payerBankCode = transferData.payerBankCode;
    String cardNo = transferData.transferIntoAccount;
    String payerName = transferData.payerName;
    String remark = transferData.transferRemark;
    String smsCode = '';
    String xRate = transferData.xRate;
    HSProgressHUD.show();
    TransferDataRepository()
        .getTransferByAccount(
            GetTransferByAccount(
              //转账金额
              money,
              //贷方货币
              transferOutCcy,
              //借方货币
              transferIntoCcy,
              //输入密码
              // 'L5o+WYWLFVSCqHbd0Szu4Q==',
              '',
              //收款方银行
              payeeBankCode,
              //收款方卡号
              payeeCardNo,
              //收款方姓名
              payeeName,
              //付款方银行
              payerBankCode,
              //付款方卡号
              cardNo,
              //付款方姓名
              payerName,
              //附言
              remark,
              //验证码
              smsCode,
              xRate,
            ),
            'getTransferByAccount')
        .then((data) {
      HSProgressHUD.dismiss();
      Navigator.pushReplacementNamed(context, pageOperationResult);
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
