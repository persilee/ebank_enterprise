import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/model/time_deposits/get_deposit_record_info.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepositCloseInfoPage extends StatefulWidget {
  DepositCloseInfoPage({Key key}) : super(key: key);

  @override
  _DepositCloseInfoState createState() => _DepositCloseInfoState();
}

class _DepositCloseInfoState extends State<DepositCloseInfoPage> {
  DepositRecord deposit;

  @override
  Widget build(BuildContext context) {
    deposit = ModalRoute.of(context).settings.arguments;

    String _language = Intl.getCurrentLocale();
    String _nameStr = '';
    if (_language == 'zh_CN') {
      _nameStr = deposit.lclName ?? deposit.engName;
    } else if (_language == 'zh_HK') {
      _nameStr = deposit.lclName ?? deposit.engName;
    } else {
      _nameStr = deposit.engName;
    }
    String _termUnit = '';
    switch (deposit.accuPeriod) {
      case '1':
        _termUnit = S.current.tdContract_day;
        break;
      case '2':
        _termUnit = S.current.months;
        break;
      case '5':
        _termUnit = S.current.year;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.receipt_detail),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              //付款账户
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    S.current.payment_account,
                    style: FIRST_DEGREE_TEXT_STYLE,
                  )),
                  Container(
                    child: Text(
                      FormatUtil.formatSpace4(deposit.openDrAc),
                      style: FIRST_DEGREE_TEXT_STYLE,
                    ),
                  )
                ],
              ),
            ),
            //整存整取
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nameStr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: HsgColors.firstDegreeText,
                            ),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                  Container(height: 0.5, color: HsgColors.divider),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //合约号
                  _unit(S.current.contract_number, deposit.conNo, true, false),
                  //币种
                  _unit(S.current.currency, deposit.ccy, true, false),
                  //存入金额
                  _unit(S.current.deposit_amount,
                      FormatUtil.formatSringToMoney(deposit.bal), true, false),
                  //存期
                  _unit(S.current.deposit_term, deposit.auctCale + _termUnit,
                      true, false),
                  //生效日期
                  _unit(S.current.effective_date, deposit.valDate, true, false),
                  //到期日期
                  _unit(S.current.due_date, deposit.mtDate, true, false),
                  //状态
                  _unit(S.current.approve_state,
                      S.current.time_deposit_record_Status_C, true, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //右箭头图标
  Widget _rightArrow() {
    return Container(
      width: 20,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: HsgColors.nextPageIcon,
      ),
    );
  }

  Widget _unit(
      String leftText, String rightText, bool isShowLine, bool isOptional) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: (MediaQuery.of(context).size.width - 42) / 7 * 3,
                  child: Text(
                    leftText,
                    style: FIRST_DEGREE_TEXT_STYLE,
                  ),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width - 42) / 7 * 4,
                child: Text(
                  rightText,
                  style: FIRST_DEGREE_TEXT_STYLE,
                  textAlign: TextAlign.right,
                ),
              ),
              isOptional ? _rightArrow() : Container(),
            ],
          ),
        ),
        isShowLine
            ? Container(
                height: 1,
                child: Divider(),
              )
            : Container(),
      ],
    );
  }
}
