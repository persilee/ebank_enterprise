/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///转账方法
/// Author: lijiawei
/// Date: 2020-12-09
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';

Widget transferPayerWidget(
    BuildContext context,
    String _limitMoney,
    String _changedCcyTitle,
    String _changedRateTitle,
    String _changedAccountTitle,
    String ccy,
    String singleLimit,
    String totalBalance,
    String cardNo,
    String payeeBankCode,
    double money,
    Function(String inputStr) moneyChange,
    Function() getcardList,
    Function() _getCcy,
    Function(String cardNos) getCardTotals,
    [TextEditingController _transferMoneyController]) {
  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          //获取第一行
          _oneRow(S.current.transfer_amount, _limitMoney, singleLimit),
          //第二行
          _twoRow(ccy, _changedCcyTitle, money, S.current.int_input_tran_amount,
              moneyChange, _getCcy, context, _transferMoneyController),
          Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(
                color: HsgColors.divider,
                height: 0.5,
              )),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _threeRowLeft(context),
                _threeRowRight(
                    context,
                    ccy,
                    _changedCcyTitle,
                    cardNo,
                    '$payeeBankCode',
                    ' $totalBalance',
                    getcardList,
                    _changedAccountTitle,
                    _changedRateTitle,
                    getCardTotals),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _oneRow(String leftText, String rightText, String singleLimits) {
  rightText = rightText == '' ? singleLimits : rightText;
  return Container(
    padding: EdgeInsets.all(15),
    color: Colors.white,
    child: Row(
      children: [
        Container(
          child: Text(
            leftText,
            style: TextStyle(
                color: HsgColors.describeText,
                fontSize: 13,
                backgroundColor: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            '${S.current.tran_limit_amt_with_value} ${FormatUtil.formatSringToMoney(rightText)}',
            style: TextStyle(
                color: HsgColors.describeText,
                fontSize: 13,
                backgroundColor: Colors.white),
            textAlign: TextAlign.right,
          ),
        )
      ],
    ),
  );
}

Widget _twoRow(
    String ccy,
    String _changedCcyTitles,
    double money,
    String hintText,
    Function moneyChanges,
    Function _getCcy,
    BuildContext context,
    TextEditingController _transferMoneyController) {
  _changedCcyTitles = _changedCcyTitles == '' ? 'CNY' : _changedCcyTitles;
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 5,
          child: FlatButton(
            onPressed: () {
              print('切换币种');
              _getCcy();
            },
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 3),
                  child: Text(
                    _changedCcyTitles,
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_outlined,
                  color: HsgColors.firstDegreeText,
                )
              ],
            ),
          ),
        ),
        Container(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            child: TextField(
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: false,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                color: HsgColors.firstDegreeText,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              onChanged: (money) {
                money.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');
                moneyChanges(money);
              },
              controller: _transferMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.current.int_input_tran_amount,
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget _threeRowLeft(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width / 2.5,
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Text(
      S.current.transfer_from,
      style: TextStyle(color: HsgColors.firstDegreeText, fontSize: 14),
    ),
  );
}

Widget _threeRowRight(
    BuildContext context,
    String ccy,
    String _changedCcyTitles,
    String cardCodeOne,
    String payeeBankCode,
    String balance,
    Function getcardList,
    String _changedAccountTitle,
    String _changedRateTitle,
    Function(String _changedRateTitle) getCardTotals) {
  _changedAccountTitle =
      _changedAccountTitle == '' ? cardCodeOne : _changedAccountTitle;
  _changedRateTitle = _changedRateTitle == '' ? balance : _changedRateTitle;
  _changedCcyTitles = _changedCcyTitles == '' ? ccy : _changedCcyTitles;
  String account = FormatUtil.formatSpace4('$_changedAccountTitle');
  var _getAccount = [
    Container(
      height: MediaQuery.of(context).size.height / 30,
      width: MediaQuery.of(context).size.width / 1.95,
      child: Text(
        '$payeeBankCode  $account',
        style: TextStyle(
          color: HsgColors.firstDegreeText,
          fontSize: 14,
        ),
        textAlign: TextAlign.left,
      ),
    ),
    Container(
      height: MediaQuery.of(context).size.height / 30,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 20,
      child: Icon(
        Icons.arrow_forward_ios,
        color: HsgColors.firstDegreeText,
        size: 16,
      ),
    ),
  ];
  return Expanded(
    child: GestureDetector(
      onTap: () {
        getcardList();
        //选择卡号
        getCardTotals(_changedAccountTitle);
        print('选择账号');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //卡号
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: _getAccount,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 30,
            width: MediaQuery.of(context).size.width / 2.3,
            child: Text(
              '余额:(HKD)120.05',
              // '${S.current.balance_with_value}${_changedCcyTitles} ${FormatUtil.formatSringToMoney(_changedRateTitle)}',
              // ${_changedRateTitle},
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontSize: 13,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}
