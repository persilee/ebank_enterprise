import 'package:ai_decimal_accuracy/ai_decimal_accuracy.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///预约转账页面
/// Author: wangluyao
/// Date: 2020-12-28
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/account/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/account/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/model/account/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/other/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/transfer/get_transfer_partner_list.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_openAccount.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_packaging.dart';
import 'package:ebank_mobile/page/transfer/data/transfer_order_data.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_account_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

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
  var cardNo = '';
  var cardNoList = List<String>();
  var payerBankCode = '';
  var payerName = '';
  var payerCardNo = '';
  var totalBalance = '0.0';
  var ccy = '';
  var ccyListOne = List<String>();
  var singleLimit = '';
  var _currBal;
  var _loacalCurrBal = '';
  var bals = [];
  var ccyList = ['CNY'];
  var tranferType;
  var accountSelect = '';
  List<String> ccyLists = [];
  List<CardBalBean> cardBal = [];
  String payeeNameForSelects;
  List<String> totalBalances = [];
  String _limitMoney = '';
  String _changedCcyTitle = '';
  int _position = 0;
  String _changedAccountTitle = '';
  String groupValue = '0'; //预约频率对应的type值
  String remark = '';
  double money = 0;
  String cardTotals = '';
  DateTime _endValue = DateTime.now().add(Duration(days: 1)); //转账时间
  DateTime _startValue = DateTime.now().add(Duration(days: 1)); //截止日期
  String _startTime =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
  String _endTime =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
  String _start = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示开始时间
  String _end = DateFormat('yyyy-MM-dd').format(DateTime.now()); //显示结束时间
  var _payeeNameController = TextEditingController();
  var _payeeAccountController = TextEditingController();
  // var _payeeBankCodeController = TextEditingController();
  var _planNameController = TextEditingController();
  String _payPassword = '';
  String _smsCode = '';

  String _payeeBankCode = '';
  //转入币种
  String _payCcy = '';
  List<String> _payCcyList = [];
  int _payIndex = 0;

  //支付币种
  String _transferCcy = '';
  int _transferIndex = 0;
  List<String> _transferCcyList = [];

  //本地币种
  String _localeCcy = '';

  //账户选择
  String _account = '';
  List<String> _accountList = [];
  int _accountIndex = 0;

  //余额
  String _balance = '';
  List<String> _balanceList = [];

  //预计收款金额
  String _amount = '0';

  //限额
  String _limit = '';

  //汇率
  String _xRate = '';

  var _focusNode = new FocusNode();

  var _transferMoneyController = new TextEditingController();

  var _remarkController = new TextEditingController();

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
    _transferMoneyController.addListener(() {
      if (_transferMoneyController.text.length == 0 ||
          _transferMoneyController.text == '0') {
        setState(() {
          _amount = '0';
          _xRate = '-';
        });
      } else if (_transferCcy != '') {
        _rateCalculate();
        // _focusNode.addListener(() {
        //   _rateCalculate();
        // });
      }
    });
    _actualNameReqData();
  }

  @override
  void dispose() {
    _payeeNameController.dispose();
    _planNameController.dispose();
    _remarkController.dispose();
    _transferMoneyController.dispose();
    _payeeAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: HsgColors.firstDegreeText,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, pageTransferPlan);
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _transferInfo(), // 计划信息
          ),
          _frequencyBtn(), //选择频率按钮
          SliverToBoxAdapter(
            //选择转账时间和截止日期
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: groupValue == '0'
                  ? _once(_start, 0)
                  : _manyTimes(_start, _end, 0, 1),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          //转账方法
          //转账金额和币种
          TransferAccount(
            payCcy: _payCcy,
            transferCcy: _transferCcy,
            limit: _limit,
            account: _account,
            balance: _balance,
            amount: _amount,
            rate: _xRate,
            transferMoneyController: _transferMoneyController,
            callback: _boolBut,
            payCcyDialog: payCcyDialog,
            transferCcyDialog: transferCcyDialog,
            accountDialog: _accountDialog,
            focusNode: _focusNode,
          ),
          //获取用户姓名及账号方法
          _payeeWidget(),
          //备注
          _remarkWidget(),
          //按钮
          _submitButton(),
        ],
      ),
    );
  }

  //附言
  Widget _remarkWidget() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: TextFieldContainer(
          title: S.current.transfer_postscript,
          hintText: S.current.transfer,
          keyboardType: TextInputType.text,
          controller: _remarkController,
          callback: _boolBut,
        ),
      ),
    );
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
      color: HsgColors.nextPageIcon,
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

//显示选中时间
  Widget _selectedTime(String selectedTime) {
    return Text(
      selectedTime,
      style: TextStyle(fontSize: 13, color: HsgColors.aboutusTextCon),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      onPressed: () {
        updateGroupValue(btnType);
        _clear();
      },
      child: Text(
        btnTitle,
        style: TextStyle(
          color: textColor,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
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
          style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 14.0),
          onChanged: (value) {
            planName = value;
          },
          keyboardType: TextInputType.text,
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

//转账按钮
  Widget _transferBtn() {
    _startTime = DateFormat('yyyy-MM-dd').format(_startValue);
    _endTime = DateFormat('yyyy-MM-dd').format(_endValue);
    return Container(
      margin: EdgeInsets.fromLTRB(30, 40, 30, 40),
      child: ButtonTheme(
        minWidth: 5,
        height: 45,
        child: FlatButton(
          onPressed: (planName == '' ||
                  _startValue == DateTime(0, 0, 0) ||
                  _endValue == DateTime(0, 0, 0) ||
                  (money.toString()) == '' ||
                  // payerName == '' ||
                  // _changedAccountTitle == '' ||
                  _payeeNameController.text == '' ||
                  _payeeAccountController.text == '')
              ? null
              : () {
                  _openBottomSheet();
                },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: HsgColors.accent,
          disabledColor: HsgColors.btnDisabled,
          child: Text(
            S.current.transfer,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
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
                  child: Text(
                    intl.S.current.appointment_frequency,
                    style: TextStyle(
                      color: HsgColors.firstDegreeText,
                      fontSize: 15,
                    ),
                  ),
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
                // _payeeBankCode = rowListPartner.bankCode;
                _transferCcy =
                    _transferCcy == '' ? rowListPartner.ccy : _transferCcy;
              }
              _boolBut();
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

  //交易密码窗口
  void _openBottomSheet() async {
    final isPassword = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgPasswordDialog(
            title: S.current.input_password,
            resultPage: pageDepositRecordSucceed,
            arguments: 'advanceTransfer',
            isDialog: true,
          );
        });
    if (isPassword != null && isPassword == true) {
      // _addTransferPlan();
      Navigator.pushNamed(context, pageDepositRecordSucceed,
          arguments: "advanceTransfer");
    }
  }

  //收款方
  Widget _payeeWidget() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            _payeeName(),
            TextFieldContainer(
              title: S.of(context).receipt_side_name,
              hintText: S.of(context).hint_input_receipt_name,
              widget: _getImage(),
              keyboardType: TextInputType.text,
              controller: _payeeNameController,
              callback: _boolBut,
              isWidget: true,
              length: 35,
              // isRegEXp: true,
              // regExp: _language == 'zh_CN' ? '[\u4e00-\u9fa5]' : '[a-zA-Z]',
            ),
            TextFieldContainer(
              title: S.of(context).receipt_side_account,
              hintText: S.of(context).hint_input_receipt_account,
              keyboardType: TextInputType.number,
              controller: _payeeAccountController,
              callback: _boolBut,
              length: 20,
              isRegEXp: true,
              regExp: '[0-9]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _payeeName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            S.of(context).receipt_side,
            style: TextStyle(color: HsgColors.describeText, fontSize: 13),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  //按钮是否能点击
  _boolBut() {
    if (_transferMoneyController.text != '' &&
        _payeeNameController.text != '' &&
        _payeeAccountController.text != '' &&
        _transferCcy != '' &&
        _planNameController.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //币种弹窗
  Future payCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _payCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _payIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _payIndex = result;
        _payCcy = _payCcyList[result];
      });
      _loadData(_account);
    }
  }

  //提交按钮
  Widget _submitButton() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 50),
        child: HsgButton.button(
          title: S.current.next_step,
          click: _boolBut() ? _judgeDialog : null,
          isColor: _boolBut(),
        ),
      ),
    );
  }

  _judgeDialog() {
    // if (double.parse(_transferMoneyController.text) > double.parse(_limit) ||
    if (double.parse(_transferMoneyController.text) > double.parse(_balance)) {
      // if (double.parse(_limit) > double.parse(_balance)) {
      HSProgressHUD.showToastTip(
        S.current.tdContract_balance_insufficient,
      );
      // }
      // else {
      //   HSProgressHUD.showToastTip(
      //     "超过限额",
      //   );
      // }
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
          _transferMoneyController.text, //amount
          _balance, //availableBalance
          "", //bankSwift
          "", //city
          "", //costOptions
          _transferCcy, //creditCurrency
          "", //day
          _payCcy, //debitCurrency
          "", //district
          false, //enabled
          _endTime, //endDate
          0, //feeAmount
          frequency, //frequency
          "", //midBankSwift
          "", //month
          "", //payPassword
          "", //payeeAddress
          _payeeBankCode, //payeeBankCode
          _payeeAccountController.text, //payeeCardNo
          _payeeNameController.text, //payeeName
          payerBankCode, //payerBankCode
          _account, //payerCardNo
          payerName, //payerName
          _planNameController.text, //planName
          _remarkController.text, //remark
          "", //remittancePurposes
          "", //remitterAddress
          "", //smsCode
          _startTime, //startDate
          "0", //transferType
          _amount, //transferIntoAmount
          _xRate, //xRate
        ),
      );
    }
  }

  Future transferCcyDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: _transferCcyList,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: _transferIndex,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _transferIndex = result;
        _transferCcy = _transferCcyList[result];
      });
    }
    _rateCalculate();
  }

  //账号弹窗
  _accountDialog() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: _accountList,
            lastSelectedPosition: _accountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accountIndex = result;
        _account = _accountList[result];
      });
      _loadData(_account);
    }
  }

  _loadTransferData() {
    Future.wait({
      // CardDataRepository()
      ApiClientAccount().getCardList(GetCardListReq()),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          setState(() {
            //付款方卡号
            _account = element.cardList[0].cardNo;
            element.cardList.forEach((e) {
              _accountList.add(e.cardNo);
            });
            _accountList = _accountList.toSet().toList();
            _payeeBankCode = element.cardList[0].bankCode;
            payerBankCode = element.cardList[0].bankCode;
          });
          _loadData(_account);
        }
      });
    });
  }

  _loadData(String cardNo) async {
    final prefs = await SharedPreferences.getInstance();
    _localeCcy = prefs.getString(ConfigKey.LOCAL_CCY);
    // CardDataRepository()
    ApiClientAccount()
        .getCardBalByCardNo(GetSingleCardBalReq(cardNo))
        .then((element) {
      if (this.mounted) {
        setState(() {
          //初始币种和余额
          if (_payCcy == '' || _balance == '') {
            _payCcy = element.cardListBal[0].ccy;
            _balance = element.cardListBal[0].currBal;
            element.cardListBal.forEach((element) {
              if (element.ccy == _localeCcy) {
                _payCcy = element.ccy;
                _balance = element.currBal;
              }
            });
          }
          _payCcyList.clear();
          _balanceList.clear();
          _payIndex = 0;
          element.cardListBal.forEach((element) {
            _payCcyList.add(element.ccy);
            _balanceList.add(element.currBal);
          });
          if (_payCcyList.length == 0) {
            _payCcyList.add(_localeCcy);
            _balanceList.add('0.0');
          }
          if (_payCcyList.length > 1) {
            for (int i = 0; i < _payCcyList.length; i++) {
              if (_payCcy == _payCcyList[i]) {
                _balance = _balanceList[i];
                break;
              } else {
                _payIndex++;
              }
            }
          } else {
            _payCcy = _payCcyList[0];
            _balance = _balanceList[0];
          }
          if (!_payCcyList.contains(_payCcy)) {
            _payCcy = _payCcyList[0];
            _balance = _balanceList[0];
            _payIndex = 0;
          }
          // _getTransferCcySamePayCcy();
          _rateCalculate();
        });
      }
    }).catchError((e) {});
  }

  //收款方币种与转账币种相同
  _getTransferCcySamePayCcy() {
    setState(() {
      _transferIndex = 0;
      for (int i = 0; i < _transferCcyList.length; i++) {
        if (_transferCcyList[i] == _payCcy) {
          _transferCcy = _payCcy;
          break;
        } else {
          _transferIndex++;
        }
      }
    });
  }

  // 获取币种列表
  Future _loadLocalCcy() async {
    // PublicParametersRepository()
    ApiClientOpenAccount().getIdType(GetIdTypeReq("CCY")).then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _transferCcyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _transferCcyList.add(e.code);
        });
      }
    });
  }

  //汇率换算
  Future _rateCalculate() async {
    double _payerAmount = 0;
    if (_transferMoneyController.text == '') {
      if (this.mounted) {
        setState(() {
          _amount = '0';
          _xRate = '-';
        });
      }
    } else {
      _payerAmount =
          AiDecimalAccuracy.parse(_transferMoneyController.text).toDouble();
      // ForexTradingRepository()
      //     .transferTrial(
      //         TransferTrialReq(
      //             amount: _payerAmount,
      //             corrCcy: _transferCcy,
      //             defaultCcy: _payCcy),
      //         'TransferTrialReq')
      //     .then((data) {
      //   if (this.mounted) {
      //     setState(() {
      //       _amount = data.optExAmt;
      //       _xRate = data.optExRate;
      //     });
      //   }
      // }).catchError((e) {
      //   print(e.toString());
      // });
    }
  }

  //获取用户真实姓名
  Future<void> _actualNameReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    // UserDataRepository()
    ApiClientPackaging().getUserInfo(GetUserInfoReq(userID)).then((data) {
      if (this.mounted) {
        setState(() {
          payerName = data.actualName;
        });
      }
    }).catchError((e) {
      // HSProgressHUD.showToast(e);
    });
  }
}
