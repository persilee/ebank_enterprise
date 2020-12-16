/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///定期开立购买页面
/// Author: wangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeDepositContract extends StatefulWidget {
  TimeDepositContract({Key key}) : super(key: key);

  @override
  _TimeDepositContractState createState() => _TimeDepositContractState();
}

class _TimeDepositContractState extends State<TimeDepositContract> {
  List time = ["不计提", "日", "月", "季", "半年", "年"];
  List account = ["500000690001", "500070800654"];
  var _changedTermBtnTiTle = "不计提";
  var _changedAccountTitle = "500000690001";
  var _changedInstructionTitle = "等待客户指示";

  Widget _background() {
    return Container(
      color: HsgColors.backgroundColor,
      height: 15,
    );
  }

  // 产品描述
  Widget _remark() {
    return Container(
        color: HsgColors.backgroundColor,
        height: 40,
        child: Container(
          padding: EdgeInsets.only(top: 10.0, left: 15.0),
          height: 10,
          child: Text(
            '不可提前支取。',
            style: TextStyle(
              color: HsgColors.describeText,
              fontSize: 12.0,
            ),
          ),
        ));
  }

  //产品名称和年利率
  Widget _titleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //color: Colors.red,
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          padding: EdgeInsets.only(left: 40.0),
          height: 60,
          child: Column(children: [
            Text(
              S.current.product_name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
            ),
            SizedBox(height: 10.0),
            Text(
              '整存整取（HKD）',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          padding: EdgeInsets.only(left: 25.0),
          height: 60,
          child: Column(
            children: [
              SizedBox(
                width: 1,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: HsgColors.divider),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20.0),
          padding: EdgeInsets.only(left: 55.0),
          height: 60,
          child: Column(children: [
            Text(
              S.current.year_interest_rate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: HsgColors.secondDegreeText),
            ),
            SizedBox(height: 10.0),
            Text(
              '2.5%',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ]),
        ),
      ],
    );
  }

  // 选择存款期限按钮
  Widget _termChangeBtn() {
    return Container(
        child: FlatButton(
      onPressed: () {
        _selectTerm(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              S.current.deposit_time_limit,
              style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 14.0),
            ),
          ),
          SizedBox(
            width: 253.0,
          ),
          Container(
            child: Text(
              _changedTermBtnTiTle,
              style: TextStyle(
                color: HsgColors.aboutusTextCon,
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ));
  }

  _selectTerm(BuildContext context) async {
    List<String> terms = [
      '不计提 ',
      '日',
      '月',
      '季',
      '半年 ',
      '年',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: '存款期限',
              items: terms,
            ));
    String term;
    if (result != null && result != false) {
      switch (result) {
        case 0:
          term = '不计提 ';
          break;
        case 1:
          term = '日';
          break;
        case 2:
          term = '月';
          break;
        case 3:
          term = '季';
          break;
        case 4:
          term = '半年 ';
          break;
        case 5:
          term = '年';
          break;
      }
    } else {
      return;
    }
    setState(() {
      _changedTermBtnTiTle = terms[result];
    });
  }

  // 本金输入框
  Widget _inputPrincipal() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(left: 17.0),
          child: Row(
            children: [
              Container(
                child: Text(
                  'HKD',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextField(
                  autocorrect: false,
                  autofocus: false,
                  style: TextStyle(
                      color: HsgColors.firstDegreeText, fontSize: 15.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ],
                  onChanged: (value) {
                    value.replaceAll(RegExp('/^0*(0\.|[1-9])/'), '\$1');
                    print("输入的金额是:$value");
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '100.00起存',
                    hintStyle: TextStyle(
                      color: HsgColors.hintText,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 17.0, bottom: 10.0),
          child: Row(
            children: [
              Container(
                child: Text(
                  S.current.contract_principal_and_interest,
                  style: TextStyle(
                    color: HsgColors.secondDegreeText,
                    fontSize: 13.0,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                child: Text(
                  '币种:1222.00',
                  style: TextStyle(
                    color: HsgColors.secondDegreeText,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  //付款账户和到期指示
  Widget _accountsAndInstructions() {
    return Column(
      children: [
        //付款账户按钮
        Container(
            child: FlatButton(
          onPressed: () {
            _selectAccount(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  '付款账户',
                  style: TextStyle(
                      color: HsgColors.aboutusTextCon, fontSize: 14.0),
                ),
              ),
              SizedBox(
                width: 200.0,
              ),
              Container(
                child: Text(
                  _changedAccountTitle,
                  style: TextStyle(
                    color: HsgColors.aboutusTextCon,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        //到期指示按钮
        Container(
            child: FlatButton(
          onPressed: () {
            _selectInstruction(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  '到期指示',
                  style: TextStyle(
                      color: HsgColors.aboutusTextCon, fontSize: 14.0),
                ),
              ),
              SizedBox(
                width: 170.0,
              ),
              Container(
                child: Text(
                  _changedInstructionTitle,
                  style: TextStyle(
                    color: HsgColors.aboutusTextCon,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
      ],
    );
  }

  _selectAccount(BuildContext context) async {
    String account;
    List<String> accounts = [
      '500000690001 ',
      '500070800654',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(title: '付款账户', items: accounts));
    if (result != null && result != false) {
      switch (result) {
        case 0:
          account = '不计提 ';
          break;
        case 1:
          account = '日';
          break;
      }
    } else {
      return;
    }
    setState(() {
      _changedAccountTitle = accounts[result];
    });
  }

  _selectInstruction(BuildContext context) async {
    List<String> instructions = [
      '等待客户指示',
      '本金转期，利息支出',
      '本金+利息转期',
      '本金+利息一起支出',
    ];
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) => BottomMenu(
              title: '到期指示',
              items: instructions,
            ));
    String instruction;
    if (result != null && result != false) {
      switch (result) {
        case 0:
          instruction = '等待客户指示';
          break;
        case 1:
          instruction = '本金转期，利息支出';
          break;
        case 2:
          instruction = '本金+利息转期';
          break;
        case 3:
          instruction = '本金+利息一起支出';
          break;
      }
    } else {
      return;
    }
    setState(() {
      _changedInstructionTitle = instructions[result];
    });
  }

  //确认按钮
  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: HsgBottomBtn('确认 ', () {
        print('确认');
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('定期开立'),
        ),
        body: (ListView(
          children: [
            _background(),
            _titleSection(),
            _remark(),
            _termChangeBtn(),
            _background(),
            _inputPrincipal(),
            _background(),
            _accountsAndInstructions(),
            _submitButton(),
          ],
        )));
  }
}
