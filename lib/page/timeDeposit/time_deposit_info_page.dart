/*
 * Created Date: Wednesday, December 16th 2020, 5:20:48 pm
 * Author: pengyikang
 * 
 * Copyright (c) 2020 深圳高阳寰球科技有限公司
 */

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/deposit_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_early_contract.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_limit_by_con_no.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_record_info.dart';
import 'package:ebank_mobile/data/source/model/get_deposit_trial.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/generated/l10n.dart';

class PageDepositInfo extends StatefulWidget {
  final Rows deposit;
  PageDepositInfo({Key key, this.deposit}) : super(key: key);

  @override
  _PageDepositInfo createState() => _PageDepositInfo(deposit);
}

class _PageDepositInfo extends State<PageDepositInfo> {
  var ciNo = '';

  var ccy = '';

  var bal = '';

  var auctCale = '';

  var valDate = '';

  var mtDate = '';

  var conNos = '';

  var settDbAc = '';

  Rows deposit;
  //第二个接口所需变量
  var conMatAmt = '';

  var matAmt = '';

  //第三个接口所需变量
  var _isLoading = false;

  var eryInt = '';

  var eryRate = '';

  var hdlFee = '';

  var pnltFee = '';

  var settDdAc = '';

  var settBals = '';

  _PageDepositInfo(this.deposit);

  //获取网络请求
  @override
  void initState() {
    super.initState();
    _loadDepositData(deposit.conNo, double.parse(deposit.bal));
  }

  @override
  Widget build(BuildContext context) {
    deposit = ModalRoute.of(context).settings.arguments;
    String conMatAmts = FormatUtil.formatSringToMoney('${conMatAmt}');
    String matAmts = FormatUtil.formatSringToMoney('${matAmt}');

    Widget _unit(String leftText, String rightText, bool isShowLine) {
      return Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(child: Text(leftText)),
                Container(
                  child: Text(rightText),
                )
              ],
            ),
          ),
          isShowLine
              ? Container(
                  child: Divider(),
                  margin: EdgeInsets.only(top: 6),
                )
              : Container(),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.receipt_detail),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
              //付款账户
              child: Row(
                children: [
                  Expanded(child: Text(S.current.payment_account)),
                  Container(
                    child: Text(
                      FormatUtil.formatSpace4('${settDbAc}'),
                    ),
                  )
                ],
              ),
            ),
            //整存整取
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(S.current.deposit_taking,
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container()
                      ],
                    ),
                  ),
                  Container(height: 0.5, color: HsgColors.divider),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(16, 3, 16, 10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //合约号
                  _unit(S.current.contract_number, conNos, true),
                  //币种
                  _unit(S.current.currency, ccy, true),
                  //存入金额
                  _unit(S.current.deposit_amount,
                      FormatUtil.formatSringToMoney('${bal}'), true),
                  //存期
                  _unit(S.current.deposit_term, '${auctCale}${S.current.month}',
                      true),
                  //生效日期
                  _unit(S.current.effective_date, valDate, true),
                  //到期日期
                  _unit(S.current.due_date, mtDate, true),
                  //到期指示
                  Container(
                    child: Row(
                      children: [
                        Expanded(child: Text(S.current.due_date_indicate)),
                        Container(
                          child: Text(S.current.instruction_at_maturity_0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
                width: 3,
                height: 85,
                padding: EdgeInsets.fromLTRB(40, 20, 40, 15),
                child: RaisedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                            title: Text(S.current.confirm_to_early_settlement,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            children: <Widget>[
                              Container(
                                  height: 105,
                                  child: Column(
                                    children: [
                                      //预计到期总额
                                      _contractSettlement(
                                          S.current.contract_settlement_amt,
                                          '${ccy}${conMatAmts}'),

                                      //提前结清本息总额
                                      _contractSettlement(
                                          S.current.early_settlement_amt,
                                          '${ccy}${matAmts}'),

                                      Container(
                                        child: Divider(),
                                        margin: EdgeInsets.only(top: 3),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            //取消按钮
                                            Container(
                                                child: FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text(S.current.cancel),
                                              color: Colors.white,
                                            )),
                                            Container(
                                              //确定按钮
                                              child: FlatButton(
                                                onPressed: () {
                                                  _contractEarly(context);
                                                },
                                                child: Text(S.current.confirm),
                                                color: Colors.white,
                                                textColor: Colors.blue,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ]);
                      },
                    );
                  },
                  textColor: Colors.white,
                  color: Colors.blue[500],
                  child: (Text(S.current.repayment_type2)),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: (Text(
                S.current.deposit_declare,
                style: TextStyle(color: Color(0xFF8D8D8D), fontSize: 12),
              )),
            )
          ],
        ));
  }

  //提前结清
  _contractSettlement(String leftText, String rightText) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: Row(
        children: [
          Container(
              child: Text(
            leftText,
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          )),
          Container(
            child: Text(
              rightText,
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  _loadDepositData(String conNo, double settBal) {
    Future.wait({
      DepositDataRepository().getDepositLimitByConNo(
          GetDepositLimitByConNo(conNo), 'GetDepositLimitByConNo'),
      DepositDataRepository().getDepositTrial(
          GetDepositTrialReq(conNo, settBal), 'GetDepositTrialReq')
    }).then((value) {
      value.forEach((element) {
        if (element is DepositByLimitConNoResp) {
          setState(() {
            ciNo = element.ciNo;
            conNos = element.conNo;
            settDbAc = element.settDdAc;
            ccy = element.ccy;
            bal = element.bal;
            auctCale = element.auctCale;
            valDate = element.valDate;
            mtDate = element.mtDate;
          });
        } else if (element is DepositTrialResp) {
          setState(() {
            conMatAmt = element.conMatAmt;
            matAmt = element.matAmt;
            eryInt = element.eryInt;
            eryRate = element.eryRate;
            hdlFee = element.hdlFee;
            pnltFee = element.pnltFee;
            settBals = element.settBal;
            settDdAc = element.settDdAc;
          });
        }
      });
    });
  }

  _contractEarly(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    HSProgressHUD.show();

    DepositDataRepository()
        .getDepositEarlyContract(
            GetDepositEarlyContractReq(
                conNos,
                double.parse(eryInt),
                double.parse(eryRate),
                double.parse(hdlFee),
                double.parse(matAmt),
                double.parse(pnltFee),
                double.parse(settBals),
                settDdAc),
            'getDepositEarlyContract')
        .then((value) {
      HSProgressHUD.dismiss();
      _showContractSucceedPage(context);
      // _cleanDeposit(context, value);
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      HSProgressHUD.showError(status: '${e.toString()}');
    });
  }

  //结算成功-跳转页面
  _showContractSucceedPage(BuildContext context) async {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, pageDepositRecordSucceed);
  }
}
