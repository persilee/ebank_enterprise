/// Copyright (c) 2021 深圳高阳寰球科技有限公司
///预约转账
/// Author: fangluyao
/// Date: 2021-04-15

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/forex_trading_repository.dart';
import 'package:ebank_mobile/data/source/model/approval/get_card_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/forex_trading.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:ebank_mobile/http/retrofit/api_client_openAccount.dart';
import 'package:ebank_mobile/page/transfer/data/transfer_order_data.dart';
import 'package:ebank_mobile/util/format_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class TransferOrderPage extends StatefulWidget {
  TransferOrderPage({Key key}) : super(key: key);

  @override
  _TransferOrderPageState createState() => _TransferOrderPageState();
}

class _TransferOrderPageState extends State<TransferOrderPage> {
  List<RemoteBankCard> cardList = [];

  var payeeBankCode = '';

  var payerBankCode = '';

  var payerName = '';

  var payeeName = '';

  var payeeCardNo = '';

  var _payerTransferController = new TextEditingController();

  var _focusNode = new FocusNode();

  var _payerTransferFocusNode = new FocusNode();

  var _payeeTransferFocusNode = new FocusNode();

  var _remarkController = new TextEditingController();

  var _payeeNameController = new TextEditingController();

  var _payeeAccountController = new TextEditingController();

  var _payeeTransferController = new TextEditingController();

  var _planNameController = TextEditingController();

  //付款方币种
  String _payerCcy = '';
  List<String> _payerCcyList = [];
  int _payerIndex = 0;

  //收款方币种
  String _payeeCcy = '';
  int _payeeIndex = 0;
  List<String> _payeeCcyList = [];

  //本地币种
  String _localeCcy = '';

  //账户选择
  String _payerAccount = '';
  List<String> _payerAccountList = [];
  int _payerAccountIndex = 0;

  //余额
  String _balance = '';
  List<String> _balanceList = [];

  //汇率
  String rate = '';

  //按钮是否能点击
  bool _isClick = false;
  var check = false;

  var _payeeAccountFocusNode = FocusNode();
  bool _isAccount = true; //账号是否存在
  var _opt = '';

  String groupValue = '0'; //预约频率对应的type值

  bool _switchValue = false; //判断开关按钮是否开启

  DateTime _endValue = DateTime.now().add(Duration(days: 1)); //转账时间
  DateTime _startValue = DateTime.now().add(Duration(days: 1)); //截止日期
  String _startTime =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
  String _endTime =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
  String _start = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示开始时间
  String _end = DateFormat('yyyy-MM-dd').format(DateTime.now()); //显示结束时间

  //预约频率集合
  List _frequency = [
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

  @override
  void initState() {
    super.initState();
    _loadLocalCcy();
    _loadTransferData();
    _actualNameReqData();

    _payeeAccountFocusNode.addListener(() {
      if (_payeeAccountController.text.length > 0) {
        _getCardByCardNo(_payeeAccountController.text);
      }
    });
    _payerTransferFocusNode.addListener(() {
      if (_payerTransferController.text.length > 0) {
        setState(() {
          _opt = 'S';
          _payeeTransferController.text = '';
          _rateCalculate();
        });
      }
      _boolBut();
    });

    _payeeTransferFocusNode.addListener(() {
      if (_payeeTransferController.text.length > 0) {
        setState(() {
          _opt = 'B';
          _payerTransferController.text = '';
          _rateCalculate();
        });
      }
      _boolBut();
    });
  }

  @override
  void dispose() {
    _payeeNameController.dispose();
    _payeeAccountController.dispose();
    _remarkController.dispose();
    _payerTransferController.dispose();
    _focusNode.dispose();
    _payerTransferFocusNode.dispose();
    _payeeTransferFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (_arguments != null && !check) {
        Rows rowPartner = _arguments;
        _payeeNameController.text = rowPartner.payeeName;
        _payeeAccountController.text = rowPartner.payeeCardNo;
        _remarkController.text = rowPartner.remark;
        payeeBankCode = rowPartner.bankCode;
        payerBankCode = rowPartner.payerBankCode;
        payeeName = rowPartner.payeeName;
        payerName = rowPartner.payerName;
        _payeeCcy = rowPartner.ccy;
        check = true;
        _isAccount = false;
        _boolBut();
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(intl.S.current.open_transfer),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15),
            child: InkWell(
              child: Text(
                intl.S.current.transfer_plan,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 3.0,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, pageTransferPlan);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _transferInfo(), // 计划信息
          _frequencyBtn(), //选择频率按钮
          //选择转账时间和截止日期
          Container(
            width: MediaQuery.of(context).size.width,
            child: groupValue == '0'
                ? _once(_start, 0)
                : _manyTimes(_start, _end, 0, 1),
          ),
          _payerWidget(),
          _payeeWidget(),
          // _transferWidget(),
          _remarkWiget(),
          _submitButton(),
        ],
      ),
    );
  }

  //选择频率按钮
  Widget _frequencyBtn() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 15),
      child: GridView.count(
        padding: EdgeInsets.only(left: 15, right: 15),
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1 / 0.35,
        children: _frequency.map((value) {
          return groupValue == value['type']
              ? _chooseBtn(value['title'], value['type'],
                  HsgColors.frequencyBtn, HsgColors.accent)
              : _chooseBtn(
                  value['title'],
                  value['type'],
                  HsgColors.notSelectedFrequencyBtn,
                  HsgColors.notSelectedFrequencyBtnText);
        }).toList(),
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

  //左侧文本
  Widget _leftText(String leftText) {
    return Container(
      width: (MediaQuery.of(context).size.width - 30) / 2,
      margin: EdgeInsets.only(left: 15),
      child: Text(
        leftText,
        style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 14),
      ),
    );
  }

  //选择按钮
  Widget _chooseBtn(
      String btnTitle, String btnType, Color btnColor, Color textColor) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      color: btnColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
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

//初始化开始时间、结束时间、转账时间和截止日期
  _clear() {
    setState(() {
      _endValue = DateTime.now().add(Duration(days: 1));
      _startValue = DateTime.now().add(Duration(days: 1));
      _startTime = DateFormat('yyyy-MM-dd').format(_startValue);
      _endTime = DateFormat('yyyy-MM-dd').format(_endValue);
      //开始时间
      if (double.parse(groupValue) > 1) {
        if (groupValue == '2') {
          _start =
              DateFormat('dd').format(DateTime.now().add(Duration(days: 1)));
        } else {
          _start =
              DateFormat('MM-dd').format(DateTime.now().add(Duration(days: 1)));
        }
      } else {
        _start = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: 1)));
      }
      //结束时间
      if (double.parse(groupValue) > 1) {
        if (groupValue == '2') {
          _end = DateFormat('yyyy-MM').format(DateTime.now());
        } else {
          _end = DateFormat('yyyy').format(DateTime.now());
        }
      } else {
        _end = DateFormat('yyyy-MM-dd').format(DateTime.parse(_start));
      }
    });
  }

  //改变groupValue为选中预约频率的type值
  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }

  //选择转账时间
  Widget _transferDate(String transferDate, int i) {
    String language = Intl.getCurrentLocale();
    //每月、每年中英文位置
    if (double.parse(groupValue) > 1) {
      if (groupValue == '2') {
        if (language == 'zh_CN') {
          transferDate = intl.S.current.monthly_with_value + transferDate;
        } else {
          transferDate = transferDate + intl.S.current.monthly_with_value;
        }
      } else {
        if (language == 'zh_CN') {
          transferDate = intl.S.current.yearly_with_value + transferDate;
        } else {
          transferDate = transferDate + intl.S.current.yearly_with_value;
        }
      }
    }
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
                      _selectedTime(transferDate),
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

  //右箭头
  Widget _rightArrow() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: HsgColors.nextPageIcon,
    );
  }

  //显示选中时间
  Widget _selectedTime(String selectedTime) {
    return Text(
      selectedTime,
      style: TextStyle(fontSize: 13, color: HsgColors.aboutusTextCon),
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
          : Container(),
    );
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
      //选择每月转账时间只显示日,选择每年转账时间只显示月和日
      dateFormat: double.parse(groupValue) > 1
          ? (groupValue == '2' ? 'dd日' : 'MM月-dd日')
          : 'yyyy年-MM月-dd日',
      locale: DateTimePickerLocale.zh_cn,
      //确定
      onConfirm: (startDate, List<int> index) {
        setState(
          () {
            _startValue = DateFormat('yyyy-MM-dd').format(startDate) == ''
                ? _startValue
                : startDate;
            //当选择每月转账时间的日期在当前日期前,截止日期加一月
            DateTime nextMonth = DateTime.now();
            nextMonth = startDate.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextMonth.year, nextMonth.month + 1, nextMonth.day);
            //当选择每年转账时间的日期在当前日期前,截止日期加一年
            DateTime nextYear = DateTime.now();
            nextYear = startDate.isAfter(DateTime.now())
                ? DateTime.now()
                : DateTime(nextYear.year + 1, nextYear.month, nextYear.day);
            //每月开始时间只显示日,每年开始时间只显示月和日
            if (double.parse(groupValue) > 1) {
              if (groupValue == '2') {
                _start = DateFormat('dd').format(startDate);
              } else {
                _start = DateFormat('MM-dd').format(startDate);
              }
            } else {
              _start = DateFormat('yyyy-MM-dd').format(startDate);
            }
            //每月结束时间只显示月和日,每年结束时间只显年
            if (double.parse(groupValue) > 1) {
              if (groupValue == '2') {
                _end = startDate.isAfter(DateTime.now())
                    ? DateFormat('yyyy-MM').format(DateTime.now())
                    : (DateFormat('yyyy-MM').format(nextMonth));
              } else {
                _end = startDate.isAfter(DateTime.now())
                    ? DateFormat('yyyy').format(DateTime.now())
                    : DateFormat('yyyy').format(nextYear);
              }
            } else {
              _end = DateFormat('yyyy-MM-dd').format(startDate);
            }

            if (groupValue == '0') {
              _endValue = _startValue; //仅1次转账时间等于截止日期
            } else if (groupValue == '2') {
              _endValue = (startDate.isAfter(DateTime.now()))
                  ? DateTime.now() //当选择每月转账时间的日期在当前日期前,
                  : nextMonth; //截止日期加一月
            } else if (groupValue == '3') {
              _endValue = (startDate.isAfter(DateTime.now()))
                  ? DateTime.now() //当选择每年转账时间的日期在当前日期前,
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
    //当选择每月转账时间的日期在当前日期前,截止日期加一月
    DateTime nextMonth = DateTime.now();
    nextMonth = _startValue.isAfter(DateTime.now())
        ? DateTime.now()
        : DateTime(nextMonth.year, nextMonth.month + 1, nextMonth.day);
//当选择每年转账时间的日期在当前日期前,截止日期加一年
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
            if (DateFormat('yyyy-MM-dd').format(endDate) == '') {
              _endValue = _endValue;
            } else {
              if (double.parse(groupValue) > 1) {
                if (groupValue == '2') {
                  _endValue =
                      DateTime(endDate.year, endDate.month, _startValue.day);
                } else {
                  _endValue = DateTime(
                      endDate.year, _startValue.month, _startValue.day);
                }
              } else {
                _endValue = endDate;
              }
            }

            if (i == 0) {
              if (double.parse(groupValue) > 1) {
                if (groupValue == '2') {
                  _start = DateFormat('dd').format(_startValue);
                } else {
                  _start = DateFormat('MM-dd').format(_startValue);
                }
              } else {
                _start = DateFormat('yyyy-MM-dd').format(_startValue);
              }
            } else {
              if (double.parse(groupValue) > 1) {
                if (groupValue == '2') {
                  _end = DateFormat('yyyy-MM').format(endDate);
                } else {
                  _end = DateFormat('yyyy').format(endDate);
                }
              } else {
                _end = DateFormat('yyyy-MM-dd').format(endDate);
              }
            }
          },
        );
        (context as Element).markNeedsBuild();
      },
    );
  }

  // 计划信息
  Widget _transferInfo() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFieldContainer(
                title: intl.S.current.plan_name,
                hintText: intl.S.current.hint_input_plan_name,
                controller: _planNameController,
                keyboardType: TextInputType.text,
                length: 30,
                callback: _boolBut,
              )),
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

  //付款方
  Widget _payerWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName(intl.S.of(context).transfer_from1),
          _payerAccountWidget(),
          Container(
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    intl.S.of(context).transfer_from_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    payerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Divider(
              color: HsgColors.divider,
              height: 0.5,
            ),
          ),
          Container(
            color: Colors.white,
            child: SelectInkWell(
              title: intl.S.of(context).payer_currency,
              item: _payerCcy == null ? '' : _payerCcy,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _payerCcyDialog();
              },
            ),
          ),
          TextFieldContainer(
            title: intl.S.current.to_amount,
            hintText: intl.S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payerTransferController,
            focusNode: _payerTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  //收款方
  Widget _payeeWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName(intl.S.of(context).receipt_side),
          TextFieldContainer(
            title: intl.S.of(context).receipt_side_account,
            hintText: intl.S.of(context).hint_input_receipt_account,
            widget: _getImage(),
            keyboardType: TextInputType.number,
            controller: _payeeAccountController,
            focusNode: _payeeAccountFocusNode,
            callback: _boolBut,
            length: 20,
            isRegEXp: true,
            regExp: '[0-9]',
            isWidget: true,
          ),
          TextFieldContainer(
            title: intl.S.of(context).receipt_side_name,
            hintText: intl.S.of(context).hint_input_receipt_name,
            keyboardType: TextInputType.text,
            controller: _payeeNameController,
            callback: _boolBut,
            length: 35,
            isRegEXp: true,
            regExp: '[\u4e00-\u9fa5a-zA-Z0-9 ]',
          ),
          Container(
            // padding: EdgeInsets.only(right: 15, left: 15),
            color: Colors.white,
            child: SelectInkWell(
              title: intl.S.current.transfer_from_ccy,
              item: _payeeCcy == null ? '' : _payeeCcy,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _payeeCcyDialog();
              },
            ),
          ),
          TextFieldContainer(
            title: intl.S.of(context).transfer_to_amount,
            hintText: intl.S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payeeTransferController,
            focusNode: _payeeTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  //转账金额
  Widget _transferWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          _titleName(intl.S.current.transfer_amount),
          TextFieldContainer(
            title: intl.S.current.to_amount + "（" + _payerCcy + "）",
            hintText: intl.S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payerTransferController,
            focusNode: _payerTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
          TextFieldContainer(
            title: intl.S.current.transfer_to_account + "（" + _payeeCcy + "）",
            hintText: intl.S.current.please_input,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _payeeTransferController,
            focusNode: _payeeTransferFocusNode,
            callback: _boolBut,
            isRegEXp: true,
            regExp: '[0-9.]',
            length: 11,
            isMoney: true,
          ),
        ],
      ),
    );
  }

  //附言
  Widget _remarkWiget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextFieldContainer(
        title: intl.S.current.transfer_postscript,
        hintText: intl.S.current.transfer,
        keyboardType: TextInputType.text,
        controller: _remarkController,
        callback: _boolBut,
      ),
    );
  }

  Widget _titleName(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(color: HsgColors.describeText, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  //付款账户
  _payerAccountWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            child: Text(
              intl.S.current.transfer_from_account,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _payerAccountDialog();
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _payerAccount,
                        style:
                            TextStyle(color: Color(0xff262626), fontSize: 14),
                      ),
                      Text(
                        intl.S.current.balance_with_value +
                            '：' +
                            _payerCcy +
                            ' ' +
                            FormatUtil.formatSringToMoney(_balance),
                        style:
                            TextStyle(color: Color(0xff7A7A7A), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Image(
                  color: HsgColors.firstDegreeText,
                  image: AssetImage(
                      'images/home/listIcon/home_list_more_arrow.png'),
                  width: 7,
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //增加转账伙伴图标
  Widget _getImage() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pushNamed(context, pageTranferPartner, arguments: '0').then(
          (value) {
            setState(() {
              if (value != null) {
                Rows rowListPartner = value;
                _payeeNameController.text = rowListPartner.payeeName;
                _payeeAccountController.text = rowListPartner.payeeCardNo;
                _remarkController.text = rowListPartner.remark;
                _payeeCcy = _payeeCcy == '' ? rowListPartner.ccy : _payeeCcy;
                _isAccount = false;
              }
              _boolBut();
              _rateCalculate();
            });
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Image(
          image: AssetImage('images/login/login_input_account1.png'),
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  //提交按钮
  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      child: HsgButton.button(
        title: intl.S.current.next_step,
        click: _isClick ? _judgeDialog : null,
        isColor: _isClick,
      ),
    );
  }

  _judgeDialog() {
    if (double.parse(_payerTransferController.text) > double.parse(_balance)) {
      Fluttertoast.showToast(
        msg: intl.S.current.tdContract_balance_insufficient,
        gravity: ToastGravity.CENTER,
      );
    } else if (_isAccount) {
      Fluttertoast.showToast(
        msg: intl.S.current.account_no_exist,
        gravity: ToastGravity.CENTER,
      );
    }
    if (_payeeCcy == _payerCcy &&
        _payerAccount == _payeeAccountController.text) {
      Fluttertoast.showToast(
        msg: intl.S.of(context).no_account_ccy_transfer,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Map frequency;
      _frequency.forEach((element) {
        Map data = element;
        if (data != null && data['type'] == groupValue) {
          frequency = data;
          return;
        }
      });
      _startTime = DateFormat('yyyy-MM-dd').format(_startValue);
      _endTime = DateFormat('yyyy-MM-dd').format(_endValue);
      Navigator.pushNamed(
        context,
        pageTransferOrderPreview,
        arguments: TransferOrderData(
          _payerTransferController.text, //amount
          _balance, //availableBalance
          "", //bankSwift
          "", //city
          "", //costOptions
          _payeeCcy, //creditCurrency
          "", //day
          _payerCcy, //debitCurrency
          "", //district
          false, //enabled
          _endTime, //endDate
          0, //feeAmount
          frequency, //frequency
          "", //midBankSwift
          "", //month
          "", //payPassword
          "", //payeeAddress
          payeeBankCode, //payeeBankCode
          _payeeAccountController.text, //payeeCardNo
          _payeeNameController.text, //payeeName
          payerBankCode, //payerBankCode
          _payerAccount, //payerCardNo
          payerName, //payerName
          _planNameController.text, //planName
          _remarkController.text, //remark
          "", //remittancePurposes
          "", //remitterAddress
          "", //smsCode
          _startTime, //startDate
          "0", //transferType
          _payeeTransferController.text, //transferIntoAmount
          rate, //xRate
        ),
      );
    }
  }

  //币种弹窗
  Future _payerCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: intl.S.of(context).currency_choice,
          items: _payerCcyList,
          positiveButton: intl.S.of(context).confirm,
          negativeButton: intl.S.of(context).cancel,
          lastSelectedPosition: _payerIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payerIndex = result;
        _payerCcy = _payerCcyList[result];
      });
      _loadData(_payerAccount);
    }
  }

  Future _payeeCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: intl.S.of(context).currency_choice,
          items: _payeeCcyList,
          positiveButton: intl.S.of(context).confirm,
          negativeButton: intl.S.of(context).cancel,
          lastSelectedPosition: _payeeIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payeeIndex = result;
        _payeeCcy = _payeeCcyList[result];
        _boolBut();
      });
    }
    _rateCalculate();
  }

  //账号弹窗
  _payerAccountDialog() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: intl.S.current.account_lsit,
            items: _payerAccountList,
            lastSelectedPosition: _payerAccountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _payerAccountIndex = result;
        _payerAccount = _payerAccountList[result];
      });
      _loadData(_payerAccount);
    }
  }

  //按钮是否能点击
  _boolBut() {
    if ((_payerTransferController.text != '' ||
            _payeeTransferController.text != '') &&
        _payeeNameController.text != '' &&
        _payeeAccountController.text != '' &&
        _payeeCcy != '') {
      return setState(() {
        _isClick = true;
      });
    } else {
      return setState(() {
        _isClick = false;
      });
    }
  }

  //分割线
  Widget _line() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Divider(height: 0.5, color: HsgColors.divider),
    );
  }

  //默认初始卡号
  _loadTransferData() async {
    Future.wait({
      CardDataRepository().getCardList('GetCardList'),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          if (this.mounted) {
            if (element != null &&
                element.cardList != null &&
                element.cardList.length > 0) {
              setState(() {
                //付款方卡号
                _payerAccount = element.cardList[0].cardNo;
                payerBankCode = payeeBankCode = element.cardList[0].bankCode;
                payerName = element.cardList[0].ciName;
                element.cardList.forEach((e) {
                  _payerAccountList.add(e.cardNo);
                });
                _payerAccountList = _payerAccountList.toSet().toList();
              });
            }
          }
          _loadData(_payerAccount);
        }
      });
    });
  }

  _loadData(String cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    _localeCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    CardDataRepository()
        .getCardBalByCardNo(GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq')
        .then((element) {
      if (this.mounted) {
        setState(() {
          //初始币种和余额
          if (_payerCcy == '' || _balance == '') {
            _payerCcy = element.cardListBal[0].ccy;
            _balance = element.cardListBal[0].currBal;
            element.cardListBal.forEach((element) {
              if (element.ccy == _localeCcy) {
                _payerCcy = element.ccy;
                _balance = element.currBal;
              }
            });
          }
          _payerCcyList.clear();
          _balanceList.clear();
          _payerIndex = 0;
          element.cardListBal.forEach((element) {
            _payerCcyList.add(element.ccy);
            _balanceList.add(element.currBal);
          });
          if (_payerCcyList.length == 0) {
            _payerCcyList.add(_localeCcy);
            _balanceList.add('0.0');
          }
          if (_payerCcyList.length > 1) {
            for (int i = 0; i < _payerCcyList.length; i++) {
              if (_payerCcy == _payerCcyList[i]) {
                _balance = _balanceList[i];
                break;
              } else {
                _payerIndex++;
              }
            }
          } else {
            _payerCcy = _payerCcyList[0];
            _balance = _balanceList[0];
          }
          if (!_payerCcyList.contains(_payerCcy)) {
            _payerCcy = _payerCcyList[0];
            _balance = _balanceList[0];
            _payerIndex = 0;
          }
          _rateCalculate();
        });
      }
    }).catchError((e) {});
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("CCY")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _payeeCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _payeeCcyList.add(e.code);
        });
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    if (_payeeCcy != '' &&
        _payerCcy != '' &&
        (_payeeTransferController.text != '' ||
            _payerTransferController.text != '')) {
      ForexTradingRepository()
          .transferTrial(
              TransferTrialReq(
                opt: _opt,
                buyCcy: _payerCcy,
                sellCcy: _payeeCcy,
                buyAmount: _payerTransferController.text == ''
                    ? '0'
                    : _payerTransferController.text,
                sellAmount: _payeeTransferController.text == ''
                    ? '0'
                    : _payeeTransferController.text,
              ),
              'TransferTrialReq')
          .then((data) {
        print(" opt: " +
            _opt +
            " sellCcy: " +
            _payeeCcy +
            " buyCcy: " +
            _payerCcy +
            " sellAmout: " +
            _payeeTransferController.text +
            " buyAmount: " +
            _payerTransferController.text);
        if (this.mounted) {
          setState(() {
            if (_opt == 'B') {
              _payerTransferController.text = data.optExAmt;
            }
            if (_opt == 'S') {
              _payeeTransferController.text = data.optExAmt;
            }
            rate = data.optExRate;
          });
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  //获取用户真实姓名
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(GetUserInfoReq(userID), "getUserInfo")
        .then((data) {
      if (this.mounted) {
        setState(() {
          payerName = data.actualName;
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    });
  }

  //根据账号查询名称
  Future _getCardByCardNo(String cardNo) async {
    TransferDataRepository()
        .getCardByCardNo(GetCardByCardNoReq(cardNo), 'getCardByCardNo')
        .then((data) {
      if (this.mounted) {
        setState(() {
          _payeeNameController.text = data.ciName;
          _isAccount = false;
          _boolBut();
        });
      }
    }).catchError((e) {
      if (this.mounted) {
        setState(() {
          _isAccount = true;
        });
      }
      Fluttertoast.showToast(
        msg: intl.S.current.no_account,
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
