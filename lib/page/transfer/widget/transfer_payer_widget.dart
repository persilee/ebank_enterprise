/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';
import 'package:ebank_mobile/generated/l10n.dart';

Widget _getRegExp(double margins, double fontsizes, String allows,
    String replaceAlls, String input) {
  return Container(
    margin: EdgeInsets.only(left: margins),
    child: TextField(
      //是否自动更正
      autocorrect: false,
      //是否自动获得焦点
      autofocus: false,
      style: TextStyle(
        fontSize: 15,
        color: HsgColors.firstDegreeText,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(allows)),
      ],
      onChanged: (value) {
        value.replaceAll(RegExp(replaceAlls), '\$1');
        print("这个是 onChanged 时刻在监听，输出的信息是：$value");
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: input,
        hintStyle: TextStyle(
          fontSize: fontsizes,
          color: HsgColors.textHintColor,
        ),
      ),
    ),
  );
}

Widget TransferPayerWidget(String ccy, String limitStr, String inputStr) {
  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  child: Text(
                    '转账金额',
                    style: TextStyle(
                        color: HsgColors.describeText,
                        fontSize: 13,
                        backgroundColor: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    '限额：$limitStr', //2,000,000.00',
                    style: TextStyle(
                        color: HsgColors.describeText,
                        fontSize: 13,
                        backgroundColor: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
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
                            'HKD',
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
                    child: _getRegExp(
                        10, 20, '[0-9.]', '/^0*(0\.|[1-9])/', '请输入转账金额')),
              ],
            ),
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
                    '转出账号',
                    style: TextStyle(
                        color: HsgColors.firstDegreeText, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('选择账号');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            '老挝银行 (9999)',
                            style: TextStyle(
                              color: HsgColors.firstDegreeText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            '余额：LAK100000.00',
                            style: TextStyle(
                              color: HsgColors.secondDegreeText,
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 290),
                  child: Text(
                    '收款方',
                    style:
                        TextStyle(color: HsgColors.describeText, fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          '姓名',
                          style: TextStyle(
                            color: HsgColors.firstDegreeText,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 80),
                          child: TextField(
                              decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入收款人姓名',
                            hintStyle: TextStyle(
                              fontSize: 13.5,
                              color: HsgColors.textHintColor,
                            ),
                          )),
                        ),
                      ),
                      Image.asset('images/login/login_input_account.png'),
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
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          '账号',
                          style: TextStyle(
                            color: HsgColors.firstDegreeText,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 80),
                          child: TextField(
                              decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入收款人账号',
                            hintStyle: TextStyle(
                              fontSize: 13.5,
                              color: HsgColors.textHintColor,
                            ),
                          )),
                        ),
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
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Row(
              children: [
                Container(
                  child: Text("转账附言"),
                ),
                Expanded(
                  child: Text(
                    '转账', //2,000,000.00',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.right,
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
