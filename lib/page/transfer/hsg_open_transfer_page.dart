/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///预约转账页面
/// Author: wangluyao
/// Date: 2020-12-28
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:intl/intl.dart';

class OpenTransferPage extends StatefulWidget {
  OpenTransferPage({Key key}) : super(key: key);

  @override
  _OpenTransferPageState createState() => _OpenTransferPageState();
}

class _OpenTransferPageState extends State<OpenTransferPage> {
  bool _switchValue = false;
  var payeeName = '';
  var payeeCardNo = '';
  String groupValue = '0';
  String remark = '';
  double money = 0;
  String cardTotals = '';
  String time = intl.S.current.time_of_transfer;
  DateTime _nowDate = DateTime.now();
  String _start = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示开始时间
  String _end = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示结束时间

//预约频率
  List frequency = [
    {
      "title": intl.S.current.only_once,
      "type": "0",
    },
    {
      "title": intl.S.current.daily,
      "type": "1",
    },
    {
      "title": intl.S.current.monthly,
      "type": "2",
    },
    {
      "title": intl.S.current.yearly,
      "type": "3",
    }
  ];

  Function _transferInputChange(String transfer) {
    remark = transfer;
  }

  Function _amountInputChange(String title) {
    money = double.parse(title);
  }

  Function _getCardTotals(String title) {
    cardTotals = title;
  }

  Future<Function> _selectAccount() async {
    setState(() {});
  }

  Future<Function> _getCcy() async {
    setState(() {});
  }

  Function _nameInputChange(String name) {
    payeeName = name;
  }

  Function _accountInputChange(String account) {
    payeeCardNo = account;
  }

  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }

//初始化开始时间和结束时间
  void _clear() {
    setState(() {
      _start = double.parse(groupValue) > 1
          ? (groupValue == '2'
              ? DateFormat('dd').format(DateTime.now().add(Duration(days: 1)))
              : DateFormat('MM-dd')
                  .format(DateTime.now().add(Duration(days: 1))))
          : DateFormat('yyyy-MM-dd')
              .format(DateTime.now().add(Duration(days: 1)));
      _end = double.parse(groupValue) > 1
          ? (groupValue == '2'
              ? DateFormat('yyyy-MM').format(DateTime.now())
              : DateFormat('yyyy').format(DateTime.now()))
          : DateFormat('yyyy-MM-dd')
              .format(DateTime.now().add(Duration(days: 1)));
    });
  }

//选择开始时间
  _startCupertinoPicker(int i, BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(intl.S.current.confirm,
            style: TextStyle(color: Colors.black, fontSize: 16)),
        cancel: Text(intl.S.current.cancel,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      minDateTime: double.parse(groupValue) < 2
          ? DateTime.now().add(Duration(days: 1))
          : DateTime.parse((DateTime.now().year).toString() + '-01-01'),
      maxDateTime: groupValue == '2'
          ? DateTime.parse((DateTime.now().year).toString() +
              '-' +
              DateFormat('MM').format(DateTime.now()) +
              '-28')
          : DateTime.parse('2100-12-31'),
      initialDateTime: _nowDate,
      dateFormat: double.parse(groupValue) > 1
          ? (groupValue == '2' ? 'dd日' : 'MM月-dd日')
          : 'yyyy年-MM月-dd日',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(
          () {
            _nowDate = dateTime;
            DateTime nextMonth = DateTime.now();
            nextMonth = dateTime.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextMonth.year, nextMonth.month + 1, nextMonth.day);
            DateTime nextYear = DateTime.now();
            nextYear = dateTime.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextYear.year + 1, nextYear.month, nextYear.day);

            _start = double.parse(groupValue) > 1
                ? (groupValue == '2'
                    ? DateFormat('dd').format(dateTime)
                    : DateFormat('MM-dd').format(dateTime))
                : DateFormat('yyyy-MM-dd').format(dateTime);
            _end = double.parse(groupValue) > 1
                ? (groupValue == '2'
                    ? ((dateTime.isAfter(DateTime.now()))
                        ? DateFormat('yyyy-MM').format(DateTime.now())
                        : (DateFormat('yyyy-MM').format(nextMonth)))
                    : (dateTime.isAfter(DateTime.now())
                        ? DateFormat('yyyy').format(DateTime.now())
                        : DateFormat('yyyy').format(nextYear)))
                : DateFormat('yyyy-MM-dd')
                    .format(DateTime.now().add(Duration(days: 1)));
          },
        );
        (context as Element).markNeedsBuild();
      },
    );
  }

//选择结束时间
  _endCupertinoPicker(int i, BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(intl.S.current.confirm,
            style: TextStyle(color: Colors.black, fontSize: 16)),
        cancel: Text(intl.S.current.cancel,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      minDateTime: double.parse(groupValue) > 1
          ? (groupValue == '2'
              ? DateTime.parse(_end + '01')
              : DateTime.parse(_end + '01-01'))
          : DateTime.now().add(Duration(days: 1)),
      initialDateTime: _nowDate,
      dateFormat: double.parse(groupValue) > 1
          ? (groupValue == '2' ? 'yyyy年-MM月' : 'yyyy年')
          : 'yyyy年-MM月-dd日',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (dateTime, List<int> index) {
        setState(
          () {
            _nowDate = dateTime;
            i == 0
                ? _start = double.parse(groupValue) > 1
                    ? (groupValue == '2'
                        ? DateFormat('dd').format(dateTime)
                        : DateFormat('MM-dd').format(dateTime))
                    : DateFormat('yyyy-MM-dd').format(dateTime)
                : _end = double.parse(groupValue) > 1
                    ? (groupValue == '2'
                        ? DateFormat('yyyy-MM').format(dateTime)
                        : DateFormat('yyyy').format(dateTime))
                    : DateFormat('yyyy-MM-dd').format(dateTime);
          },
        );
        (context as Element).markNeedsBuild();
      },
    );
  }

//仅一次时间选择
  Widget _once(String name, int i, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 215,
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  intl.S.current.time_of_transfer,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              //选择转账时间
              Container(
                margin: EdgeInsets.all(5),
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff262626)),
                          ),
                          Container(
                            width: 8,
                            height: 7,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _startCupertinoPicker(i, context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
      ],
    );
  }

//每日、每月、每年时间选择
  Widget _manyTimes(
      String startTime, String endTime, int i, int j, BuildContext context) {
    String language = Intl.getCurrentLocale();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        //选择转账时间
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 215,
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  groupValue == '1'
                      ? intl.S.current.first_time_of_transfer
                      : time,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            double.parse(groupValue) > 1
                                ? (groupValue == '2'
                                    ? (language == 'zh_CN'
                                        ? intl.S.current.monthly_with_value +
                                            startTime
                                        : startTime +
                                            intl.S.current.monthly_with_value)
                                    : (language == 'zh_CN'
                                        ? intl.S.current.yearly_with_value +
                                            startTime
                                        : startTime +
                                            intl.S.current.yearly_with_value))
                                : startTime,
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff262626)),
                          ),
                          Container(
                            width: 8,
                            height: 7,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _startCupertinoPicker(i, context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        //有效期
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 270,
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  intl.S.current.valid_date_short,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _switchValue,
                        activeColor: HsgColors.blueTextColor,
                        trackColor: HsgColors.textHintColor,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(height: 0.5, color: HsgColors.divider),
        ),
        //选择截止日期
        Container(
            color: Colors.white,
            child: _switchValue == true
                ? Row(
                    children: [
                      Container(
                        width: 215,
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          intl.S.current.deadline,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Container(
                        width: 150,
                        margin: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              color: Colors.white,
                              child: Row(children: [
                                Text(
                                  endTime,
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xff262626)),
                                ),
                                Container(
                                  width: 8,
                                  height: 7,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                              onPressed: () {
                                _endCupertinoPicker(j, context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container()),
      ],
    );
  }

// 计划信息
  Widget _transferInfo() {
    String groupValue = '1';
    return Container(
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                //计划名称
                Container(
                  child: Text(
                    intl.S.current.plan_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: TextField(
                    textAlign: TextAlign.right,
                    autocorrect: false,
                    autofocus: false,
                    style: TextStyle(
                        color: HsgColors.firstDegreeText, fontSize: 14.0),
                    onChanged: (value) {
                      print("输入的计划名称是:$value");
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: intl.S.current.hint_input_plan_name,
                      hintStyle: TextStyle(
                        color: HsgColors.hintText,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.5, color: HsgColors.divider),
          ),
          //预约频率
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  child: Text(intl.S.current.appointment_frequency),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(intl.S.current.open_transfer),
          actions: <Widget>[
            Container(
              child: Text.rich(TextSpan(
                  text: intl.S.current.transfer_plan,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 3.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      debugPrint(intl.S.current.transfer_plan);
                    })),
            )
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _transferInfo(),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 15),
                child: GridView.count(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1 / 0.4,
                  children: frequency.map((value) {
                    return groupValue == value['type']
                        ? FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Color(0xFFDCF0FF),
                            onPressed: () {
                              print('切换${value}');
                              updateGroupValue(value['type']);
                            },
                            child: Text(
                              value['title'],
                              style: TextStyle(
                                  color: HsgColors.accent,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              print('切换${value}');
                              updateGroupValue(value['type']);
                              _clear();
                            },
                            color: Color(0xFFF3F3F3),
                            child: Text(
                              value['title'],
                              style: TextStyle(
                                  color: Color(0xFF868686),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                  }).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: groupValue == '0'
                  ? _once(_start, 0, context)
                  : _manyTimes(_start, _end, 0, 1, context),
            ),
            TransferPayeeWidget(
                intl.S.current.receipt_side,
                intl.S.current.name,
                intl.S.current.account_num,
                intl.S.current.please_input,
                intl.S.current.please_input,
                _nameInputChange,
                _accountInputChange),
            SliverToBoxAdapter(
              child: Container(
                height: 20,
              ),
            ),
            TransferPayerWidget(
                '5000.00',
                'LAK',
                '',
                '高阳寰球500000674001',
                'LAK',
                '',
                '',
                '2351',
                '',
                0.0,
                _amountInputChange,
                _selectAccount,
                _getCcy,
                _getCardTotals),
            TransferOtherWidget('转账', _transferInputChange),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 75, 30, 0),
                child: ButtonTheme(
                    minWidth: 5,
                    height: 45,
                    child: FlatButton(
                      onPressed: () {
                        print('转账');
                      },
                      color: HsgColors.accent,
                      child:
                          (Text('转账', style: TextStyle(color: Colors.white))),
                    )),
              ),
            ),
          ],
        ));
  }
}
