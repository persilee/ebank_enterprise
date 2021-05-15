// Copyright (c) 2021 深圳高阳寰球科技有限公司
// 定期开立预览页面
// Author: 李家伟
// Date: 2021-05-10

import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/time_deposit_contract.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_timeDeposit.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/pay_password_check.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';

class TimeDepositContractPreviewPage extends StatefulWidget {
  @override
  _TimeDepositContractPreviewPageState createState() =>
      _TimeDepositContractPreviewPageState();
}

class _TimeDepositContractPreviewPageState
    extends State<TimeDepositContractPreviewPage> {
  @override
  Widget build(BuildContext context) {
    Map _data = ModalRoute.of(context).settings.arguments;
    TimeDepositContractReq _timeDepositReq = _data['reqData'];
    String _productName = _data['productName'];
    String _depositTerm = _data['depositTerm'];
    String _instructions = _data['instructions'];
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.transfer_the_preview1),
          centerTitle: true,
          elevation: 1,
        ),
        body: ListView(
          children: [
            _content(
                _timeDepositReq, _productName, _depositTerm, _instructions),
            // _explain(),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: HsgButton.button(
                title: S.current.confirm,
                click: () {
                  // CheckPayPassword(context, () {
                  _loadContractData(_timeDepositReq);
                  // });
                },
                isColor: true,
              ),
            ),
          ],
        ));
  }

  Widget _content(
    TimeDepositContractReq timeDepositReq,
    String productName,
    String depositTerm,
    String instructions,
  ) {
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
                  S.current.deposit_amount,
                  style: FIRST_DEGREE_TEXT_STYLE,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  child: Text(
                    timeDepositReq.ccy +
                        ' ' +
                        FormatUtil.formatSringToMoney(
                            timeDepositReq.bal.toString()),
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
          _getRowContent(S.current.product_name, productName),
          _getRowContent(S.current.year_interest_rate,
              timeDepositReq.annualInterestRate + '%'),
          _getRowContent(S.current.deposit_time_limit, depositTerm),
          _getRowContent(S.current.deposit_amount,
              FormatUtil.formatSpace4(timeDepositReq.bal.toString())),
          _getRowContent(
              S.current.approve_certificates_deposit_money, timeDepositReq.ccy),
          _getRowContent(S.current.approve_maturity_instructions, instructions),
          _getRowContent(S.current.approve_debit_account,
              FormatUtil.formatSpace4(timeDepositReq.oppAc)),
          _getRowContent(S.current.approve_settlement_account,
              FormatUtil.formatSpace4(timeDepositReq.settDdAc)),
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

  //立即存入接口
  Future<void> _loadContractData(TimeDepositContractReq req) async {
    // if (this.mounted) {
    //   setState(() {
    //     _isDeposit = true;
    //   });
    // }
    HSProgressHUD.show();
    // TimeDepositDataRepository()

    ApiClientTimeDeposit()
        .getTimeDepositContract(
      req,
    )
        .then((value) {
      if (this.mounted) {
        setState(() {
          HSProgressHUD.dismiss();
          // _isDeposit = false;
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pushNamed(pageDepositRecordSucceed,
                arguments: 'timeDepositProduct');
        });
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {
          // _isDeposit = false;
          HSProgressHUD.showToast(e);
        });
      }
    });
  }
}
