import 'dart:async';
import 'dart:ffi';

import 'package:ebank_mobile/util/format_util.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/generated/l10n.dart';

typedef _InputCallback = Function(String inputStr);
typedef _InputName = Function(String inputName);
typedef _InputAccount = Function(String inputAccount);
typedef _InputTransfer = Function(String inputTransfer);
// ignore: non_constant_identifier_names

Widget TransferPayerWidget(
    String ccy,
    String singleLimit,
    String inputStr,
    String totalBalance,
    String cardNo,
    String payeeBankCode,
    double money,
    String payeeName,
    String payeeCardNo,
    String remark,
    _InputCallback moneyChange,
    _InputName nameChange,
    _InputAccount accountChange,
    _InputTransfer transferChange) {
  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          //获取第一行
          _oneRow(S.current.transfer_amount,
              ' ${S.current.tran_limit_amt_with_value} ${singleLimit}'),
          //第二行
          _twoRow(
            ccy,
            money,
            S.current.int_input_tran_amount,
            moneyChange,
          ),

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
                _threeRowRight('$payeeBankCode  $cardNo',
                    ' ${S.current.balance_with_value}${totalBalance}'),
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
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.fromLTRB(0, 20, 15, 0),
            child: Column(
              children: [
                Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          S.current.receipt_side,
                          style: TextStyle(
                              color: HsgColors.describeText, fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ])),
                //姓名行
                Container(
                  child: Row(
                    children: [
                      _fiveRowLeft(S.current.name),

                      _fiveRowRight(
                          nameChange, S.current.hint_input_receipt_name),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      ),
                      Image(
                        image:
                            AssetImage('images/login/login_input_account.png'),
                        width: 20,
                        height: 20,
                      ),
                      //Image.asset('images/login/login_input_account.png'),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Divider(
                      color: HsgColors.divider,
                      height: 0.5,
                    )),
                //账号
                Container(
                  child: Row(
                    children: [
                      //获取账户
                      _fiveRowLeft(S.current.account_num),

                      _fiveRowRight(
                          accountChange, S.current.hint_input_receipt_account),

                      Container(
                        padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Divider(
                      color: HsgColors.divider,
                      height: 0.5,
                    )),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                Container(
                  child: Text(S.current.transfer_postscript),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 200),
                    child: TextField(
                        onChanged: (remark) {
                          transferChange(remark);
                          print('这是附言$remark');
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.current.transfer,
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: HsgColors.textHintColor,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _oneRow(String leftText, String rightText) {
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
            //FormatUtil.formatSringToMoney(rightText),
            rightText,
            //2,000,000.00',
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
    String ccys, double money, String hintText, Function moneyChanges) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Row(
      children: [
        Container(
          width: 75,
          height: 30,
          child: FlatButton(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Row(
              children: [
                Container(
                  child: Text(
                    ccys,
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
            onPressed: () {
              print('切换币种');
            },
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

                print("这个是 onChanged 时刻在监听，输 出的信息是：$money");
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

Widget _threeRowRight(String payeeBankCode, String balance) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        print('选择账号');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              payeeBankCode,
              style: TextStyle(
                color: HsgColors.firstDegreeText,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              balance,
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

Widget _fiveRowLeft(String name) {
  return Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Text(
      name,
      style: TextStyle(
        color: HsgColors.firstDegreeText,
        fontSize: 14,
      ),
    ),
  );
}

Widget _fiveRowRight(Function nameChanges, String hintText) {
  return Expanded(
    child: Container(
      child: TextField(
          //是否自动更正
          autocorrect: false,
          //是否自动获得焦点
          autofocus: false,
          onChanged: (payeeName) {
            nameChanges(payeeName);
            print("这个是 onChanged 时刻在监听，输出的信息是：$payeeName");
          },
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: HsgColors.textHintColor,
            ),
          )),
    ),
  );
}
