/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: lijiawei
/// Date: 2020-12-09

import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:flutter/services.dart';

// ignore: non_constant_identifier_names
Widget TransferPayerWidget(String ccy, String limitStr, String inputStr) {
  return SliverToBoxAdapter(
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  '转账金额',
                  style: TextStyle(color: HsgColors.describeText, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  '限额：$limitStr', //2,000,000.00',
                  style: TextStyle(color: HsgColors.describeText, fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
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
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
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
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                      ],
                      onChanged: (value) {
                        value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');
                        print("这个是 onChanged 时刻在监听，输出的信息是：$value");
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入转账金额',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: HsgColors.textHintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: HsgColors.divider,
            height: 0.5,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
