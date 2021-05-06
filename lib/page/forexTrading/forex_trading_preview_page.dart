/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///外汇买卖预览
/// Author: fangluyao
/// Date: 2021-04-28

import 'package:ebank_mobile/data/source/model/foreign_ccy.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_bill.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForexTradingPreviewPage extends StatefulWidget {
  ForexTradingPreviewPage({Key key}) : super(key: key);

  @override
  _ForexTradingPreviewPageState createState() =>
      _ForexTradingPreviewPageState();
}

class _ForexTradingPreviewPageState extends State<ForexTradingPreviewPage> {
  @override
  Widget build(BuildContext context) {
    Map _preview = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).transfer_the_preview4),
          centerTitle: true,
          elevation: 1,
        ),
        body: ListView(
          children: [
            _content(_preview),
            _explain(),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: HsgButton.button(
                title: S.current.confirm,
                click: () {
                  _loadData(_preview);
                },
                isColor: true,
              ),
            ),
          ],
        ));
  }

  Widget _content(Map _preview) {
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
                    _preview['buyCcy'] +
                        ' ' +
                        FormatUtil.formatSringToMoney(
                          _preview['buyAmt'],
                        ),
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
          _getRowContent(S.current.debit_accno,
              FormatUtil.formatSpace4(_preview['buyDac'])),
          _getRowContent(S.current.debit_currency, _preview['buyCcy']),
          _getRowContent(S.current.debit_amount,
              FormatUtil.formatSringToMoney(_preview['buyAmt'])),
          _getRowContent(S.current.credit_account,
              FormatUtil.formatSpace4(_preview['sellDac'])),
          _getRowContent(S.current.credit_currency, _preview['sellCcy']),
          _getRowContent(S.current.credit_amount,
              FormatUtil.formatSringToMoney(_preview['sellAmt'])),
          _getRowContent(S.current.rate_of_exchange, _preview['exRate']),
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

  Future _loadData(Map _preview) async {
    HSProgressHUD.show();
    Future.wait({
      ApiClientBill().foreignCcy(
        ForeignCcyReq(
          _preview['buyAmt'],
          _preview['buyCcy'],
          _preview['buyDac'],
          _preview['exRate'],
          _preview['exTime'],
          "",
          _preview['prodCd'],
          _preview['sellAmt'],
          _preview['sellCcy'],
          _preview['sellDac'],
          "",
        ),
      )
    }).then((value) {
      HSProgressHUD.dismiss();
      Navigator.pushNamed(context, pageTransferSuccess,
          arguments: "pageTransferSuccess");
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }
}
