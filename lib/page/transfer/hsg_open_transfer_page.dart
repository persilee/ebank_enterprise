/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///预约转账页面
/// Author: wangluyao
/// Date: 2020-12-28
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
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
  String planName = ''; //输入的计划名称
  bool _switchValue = false; //判断开关按钮是否开启
  var payeeName = '';
  var payeeCardNo = '';
  String groupValue = '0'; //预约频率对应的type值
  String remark = '';
  double money = 0;
  String cardTotals = '';
  DateTime _endValue = DateTime.now().add(Duration(days: 1)); //转账时间
  DateTime _startValue = DateTime.now().add(Duration(days: 1)); //截止日期
  String _start = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示开始时间
  String _end = DateFormat('yyyy-MM-dd').format(DateTime.now()); //显示结束时间

  //预约频率集合
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

  //改变groupValue为选中预约频率的type值
  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }

//分割线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Divider(height: 0.5, color: HsgColors.divider),
    );
  }

//右箭头
  Widget _rightArrow() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.black,
    );
  }

//左侧文本
  Widget _leftText(String leftText) {
    return Container(
      width: (MediaQuery.of(context).size.width - 30) / 2,
      margin: EdgeInsets.only(left: 15),
      child: Text(
        leftText,
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

//显示选中时间
  Widget _selectedTime(String selectedTime) {
    return Text(
      selectedTime,
      style: TextStyle(fontSize: 13, color: Color(0xff262626)),
    );
  }

//开关按钮
  Widget _switch() {
    return Container(
      width: (MediaQuery.of(context).size.width - 30) / 2,
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width / 8,
        child: FittedBox(
          alignment: Alignment.centerRight,
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
        ),
      ),
    );
  }

//有效期
  Widget _termOfValidity() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        children: [
          _leftText(intl.S.current.valid_date_short),
          _switch(),
        ],
      ),
    );
  }

//选择按钮
  Widget _chooseBtn(
      String btnTitle, String btnType, Color btnColor, Color textColor) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      color: btnColor,
      onPressed: () {
        updateGroupValue(btnType);
        _clear();
      },
      child: Text(
        btnTitle,
        style: TextStyle(
            color: textColor, fontSize: 14.0, fontWeight: FontWeight.normal),
      ),
    );
  }

//计划名称输入框
  Widget _inputPlanName() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: EdgeInsets.only(right: 15),
        child: TextField(
          textAlign: TextAlign.right,
          autocorrect: false,
          autofocus: false,
          style: TextStyle(color: HsgColors.firstDegreeText, fontSize: 14.0),
          onChanged: (value) {
            print("输入的计划名称是:$value");
            planName = value;
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
      ),
    );
  }

//初始化开始时间、结束时间、转账时间和截止日期
  _clear() {
    setState(() {
      _endValue = DateTime.now().add(Duration(days: 1));
      _startValue = DateTime.now().add(Duration(days: 1));
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
          : DateFormat('yyyy-MM-dd').format(DateTime.parse(_start));
    });
  }

//选择转账时间
  Widget _transferDate(String transferDate, int i) {
    String language = Intl.getCurrentLocale();
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _leftText(groupValue == '1'
              ? intl.S.current.first_time_of_transfer
              : intl.S.current.time_of_transfer),
          //选择转账时间
          Container(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      _selectedTime(double.parse(groupValue) > 1
                          ? (groupValue == '2'
                              ? (language == 'zh_CN'
                                  ? intl.S.current.monthly_with_value +
                                      transferDate
                                  : transferDate +
                                      intl.S.current.monthly_with_value)
                              : (language == 'zh_CN'
                                  ? intl.S.current.yearly_with_value +
                                      transferDate
                                  : transferDate +
                                      intl.S.current.yearly_with_value))
                          : transferDate),
                      _rightArrow(),
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
    );
  }

//选择截止日期
  Widget _endDate(String endDate, int i) {
    return Container(
        color: Colors.white,
        child: _switchValue == true
            ? Row(
                children: [
                  _leftText(intl.S.current.deadline),
                  Container(
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: FlatButton(
                      color: Colors.white,
                      padding: EdgeInsets.all(0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _selectedTime(endDate),
                            _rightArrow(),
                          ]),
                      onPressed: () {
                        _endCupertinoPicker(i, context);
                      },
                    ),
                  ),
                ],
              )
            : Container());
  }

//选择开始时间弹窗
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

      maxDateTime: groupValue == '2' //选择每月转账时间的最大日期为每月28日
          ? DateTime.parse((DateTime.now().year).toString() +
              '-' +
              DateFormat('MM').format(DateTime.now()) +
              '-28')
          : DateTime.parse('2100-12-31'),
      initialDateTime: _startValue,
      //选择每月转账时间只显示日，选择每年转账时间只显示月和日
      dateFormat: double.parse(groupValue) > 1
          ? (groupValue == '2' ? 'dd日' : 'MM月-dd日')
          : 'yyyy年-MM月-dd日',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (startDate, List<int> index) {
        setState(
          () {
            _startValue = startDate;
            //当选择每月转账时间的日期在当前日期前，截止日期加一月
            DateTime nextMonth = DateTime.now();
            nextMonth = startDate.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextMonth.year, nextMonth.month + 1, nextMonth.day);
            //当选择每年转账时间的日期在当前日期前，截止日期加一年
            DateTime nextYear = DateTime.now();
            nextYear = startDate.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextYear.year + 1, nextYear.month, nextYear.day);
            //每月开始时间只显示日，每年开始时间只显示月和日
            _start = double.parse(groupValue) > 1
                ? (groupValue == '2'
                    ? DateFormat('dd').format(startDate)
                    : DateFormat('MM-dd').format(startDate))
                : DateFormat('yyyy-MM-dd').format(startDate);
            //每月结束时间只显示月和日，每年结束时间只显年
            _end = double.parse(groupValue) > 1
                ? (groupValue == '2'
                    ? ((startDate.isAfter(DateTime.now()))
                        ? DateFormat('yyyy-MM').format(DateTime.now())
                        : (DateFormat('yyyy-MM').format(nextMonth)))
                    : (startDate.isAfter(DateTime.now())
                        ? DateFormat('yyyy').format(DateTime.now())
                        : DateFormat('yyyy').format(nextYear)))
                : DateFormat('yyyy-MM-dd').format(startDate);
            if (groupValue == '0') {
              _endValue = _startValue; //仅1次转账时间等于截止日期
            } else if (groupValue == '2') {
              _endValue = (startDate.isAfter(DateTime.now()))
                  ? DateTime.now() //当选择每月转账时间的日期在当前日期前，
                  : nextMonth; //截止日期加一月
            } else if (groupValue == '3') {
              _endValue = (startDate.isAfter(DateTime.now()))
                  ? DateTime.now() //当选择每年转账时间的日期在当前日期前，
                  : nextYear; //截止日期加一年
            }
          },
        );
        (context as Element).markNeedsBuild();
      },
    );
  }

//选择结束时间弹窗
  _endCupertinoPicker(int i, BuildContext context) {
    //当选择每月转账时间的日期在当前日期前，截止日期加一月
    DateTime nextMonth = DateTime.now();
    nextMonth = _startValue.isAfter(DateTime.now())
        ? DateTime.now()
        : DateTime(nextMonth.year, nextMonth.month + 1, nextMonth.day);
//当选择每年转账时间的日期在当前日期前，截止日期加一年
    DateTime nextYear = DateTime.now();
    nextYear = _startValue.isAfter(DateTime.now())
        ? DateTime.now()
        : DateTime(nextYear.year + 1, nextYear.month, nextYear.day);

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
          ? (groupValue == '2' ? nextMonth : nextYear)
          : _startValue,
      initialDateTime: double.parse(groupValue) > 1 ? _endValue : _startValue,
      dateFormat: double.parse(groupValue) > 1
          ? (groupValue == '2' ? 'yyyy年-MM月' : 'yyyy年')
          : 'yyyy年-MM月-dd日',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (endDate, List<int> index) {
        setState(
          () {
            _endValue = double.parse(groupValue) > 1
                ? ((groupValue == '2'
                    ? DateTime(endDate.year, endDate.month,
                        _startValue.day) //选择每月转账日期时，截止日期为当前年月加选择的日
                    : DateTime(
                        endDate.year, _startValue.month, _startValue.day)))
                : endDate;

            i == 0
                ? _start = double.parse(groupValue) > 1
                    ? (groupValue == '2'
                        ? DateFormat('dd').format(_startValue)
                        : DateFormat('MM-dd').format(_startValue))
                    : DateFormat('yyyy-MM-dd').format(_startValue)
                : _end = double.parse(groupValue) > 1
                    ? (groupValue == '2'
                        ? DateFormat('yyyy-MM').format(endDate)
                        : DateFormat('yyyy').format(endDate))
                    : DateFormat('yyyy-MM-dd').format(endDate);
          },
        );
        (context as Element).markNeedsBuild();
      },
    );
  }

//转账按钮
  Widget _transferBtn() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 40, 30, 40),
      child: ButtonTheme(
          minWidth: 5,
          height: 45,
          child: FlatButton(
            onPressed: (planName == '' ||
                    _startValue == DateTime(0, 0, 0) ||
                    _endValue == DateTime(0, 0, 0))
                ? null
                : () {
                    print("开始时间:" +
                        DateFormat('yyyy-MM-dd 00:00:00').format(_startValue));
                    print("结束时间:" +
                        DateFormat('yyyy-MM-dd 23:59:59').format(_endValue));
                  },
            color: HsgColors.accent,
            disabledColor: HsgColors.btnDisabled,
            child: (Text(S.current.transfer,
                style: TextStyle(color: Colors.white))),
          )),
    );
  }

//选择频率按钮
  Widget _frequencyBtn() {
    return SliverToBoxAdapter(
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
                ? _chooseBtn(value['title'], value['type'], Color(0xFFDCF0FF),
                    HsgColors.accent)
                : _chooseBtn(value['title'], value['type'], Color(0xFFF3F3F3),
                    Color(0xFF868686));
          }).toList(),
        ),
      ),
    );
  }

//仅一次时间选择
  Widget _once(String startTime, int i) {
    return Column(
      children: [
        _line(),
        _transferDate(startTime, i),
        _line(),
      ],
    );
  }

//每日、每月、每年时间选择
  Widget _manyTimes(String startTime, String endTime, int i, int j) {
    return Column(
      children: [
        _line(),
        //选择转账时间
        _transferDate(startTime, i),
        _line(),
        //有效期
        _termOfValidity(),
        _line(),
        //选择截止日期
        _endDate(endTime, j),
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
            child: Row(
              children: [
                //计划名称
                _leftText(intl.S.current.plan_name),
                _inputPlanName(),
              ],
            ),
          ),
          _line(),
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
            _frequencyBtn(),
            SliverToBoxAdapter(
              child: groupValue == '0'
                  ? _once(_start, 0)
                  : _manyTimes(_start, _end, 0, 1),
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
              child: SizedBox(
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
              child: _transferBtn(),
            ),
          ],
        ));
  }
}
