import 'dart:async';
import 'dart:ffi';

import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/util/format_util.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/generated/l10n.dart';

Widget TransferPayerWidget(
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
) {
  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          //获取第一行
          _oneRow(S.current.transfer_amount, _limitMoney, singleLimit),
          //第二行
          _twoRow(ccy, _changedCcyTitle, money, S.current.int_input_tran_amount,
              moneyChange, _getCcy),
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
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(
                    S.current.transfer_from,
                    style: TextStyle(
                        color: HsgColors.firstDegreeText, fontSize: 14),
                  ),
                ),
                _threeRowRight(
                    ccy,
                    _changedCcyTitle,
                    cardNo,
                    '$payeeBankCode',
                    ' ${totalBalance}',
                    getcardList,
                    _changedAccountTitle,
                    _changedRateTitle,
                    getCardTotals),
                Container(
                  margin: EdgeInsets.only(top: 3, left: 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: HsgColors.firstDegreeText,
                    size: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                ),
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

Widget _twoRow(String ccy, String _changedCcyTitles, double money,
    String hintText, Function moneyChanges, Function _getCcy) {
  _changedCcyTitles = _changedCcyTitles == '' ? 'CNY' : _changedCcyTitles;
  return Container(
    color: Colors.white,
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Row(
      children: [
        Container(
          width: 75,
          height: 30,
          child: FlatButton(
            onPressed: () {
              print('切换币种');
              _getCcy();
            },
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Row(
              children: [
                Container(
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
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: TextField(
              //是否自动更正
              autocorrect: false,
              //是否自动获得焦点
              autofocus: false,
              style: TextStyle(
                fontSize: 18,
                color: HsgColors.firstDegreeText,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              //onSubmit
              onChanged: (money) {
                money.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');

                moneyChanges(money);

                print("这个是 onChanged 时刻在监听，输出的信息是：$money");
              },
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

Widget _threeRowRight(
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
  String account = FormatUtil.formatSpace4('${_changedAccountTitle}');
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
            child: Text(
              '${payeeBankCode}  ${account}',
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              '${S.current.balance_with_value}${_changedCcyTitles} ${FormatUtil.formatSringToMoney(_changedRateTitle)}',
              // ${_changedRateTitle},
              style: TextStyle(
                color: HsgColors.secondDegreeText,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
