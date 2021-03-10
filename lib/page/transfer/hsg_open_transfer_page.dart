/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///预约转账页面
/// Author: wangluyao
/// Date: 2020-12-28
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/model/add_transfer_plan.dart';
import 'package:ebank_mobile/data/source/model/get_card_limit_by_card_no.dart';
import 'package:ebank_mobile/data/source/model/get_card_list.dart';
import 'package:ebank_mobile/data/source/model/get_single_card_bal.dart';
import 'package:ebank_mobile/data/source/transfer_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/data/source/model/get_transfer_partner_list.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_other_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payee_widget.dart';
import 'package:ebank_mobile/page/transfer/widget/transfer_payer_widget.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:ebank_mobile/generated/l10n.dart' as intl;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  var ccyList = ['USD'];
  var tranferType;
  int _accountIndex = 0;
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
  String _startTime = '';
  String _endTime = '';
  String _start = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(Duration(days: 1))); //显示开始时间
  String _end = DateFormat('yyyy-MM-dd').format(DateTime.now()); //显示结束时间
  var _payeeNameController = TextEditingController();
  var _payeeAccountController = TextEditingController();
  var _payeeBankCodeController = TextEditingController();

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

  _transferInputChange(String transfer) {
    remark = transfer;
  }

  _amountInputChange(String title) {
    money = double.parse(title);
  }

  //选择货币方法
  _getCcy() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: S.current.currency_choice,
            items: ccyList,
            positiveButton: S.current.confirm,
            negativeButton: S.current.cancel,
            lastSelectedPosition: _position,
          );
        });

    if (result != null && result != false) {
      //货币种类
      setState(() {
        _position = result;
        _changedCcyTitle = ccyList[_position];
      });
      //余额
      _getCardTotals(_changedAccountTitle);
    }
  }

  _nameInputChange(String name) {
    payeeName = name;
  }

  _accountInputChange(String account) {
    payeeCardNo = account;
  }

  @override
  void initState() {
    super.initState();
    _payeeNameController.addListener(() {
      _nameInputChange(_payeeNameController.text); //输入框内容改变时调用
    });
    _payeeAccountController.addListener(() {
      _accountInputChange(_payeeAccountController.text); //输入框内容改变时调用
    });
    _loadTransferData();
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
          style: TextStyle(color: HsgColors.aboutusTextCon, fontSize: 14.0),
          onChanged: (value) {
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
      //选择每月转账时间只显示日，选择每年转账时间只显示月和日
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
            if (double.parse(groupValue) > 1) {
              if (groupValue == '2') {
                _start = DateFormat('dd').format(startDate);
              } else {
                _start = DateFormat('MM-dd').format(startDate);
              }
            } else {
              _start = DateFormat('yyyy-MM-dd').format(startDate);
            }
            //每月结束时间只显示月和日，每年结束时间只显年
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
          children: frequency.map((value) {
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

  Widget _getImage() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, pageTranferPartner, arguments: '0').then(
          (value) {
            if (value != null) {
              Rows rowListPartner = value;
              _payeeNameController.text = rowListPartner.payeeName;
              _payeeAccountController.text = rowListPartner.payeeCardNo;
              _payeeBankCodeController.text = rowListPartner.bankCode;
            } else {}
          },
        );
      },
      child: Image(
        image: AssetImage('images/login/login_input_account.png'),
        width: 20,
        height: 20,
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
          );
        });
    if (isPassword != null && isPassword == true) {
      _addTransferPlan();
      Navigator.pushNamed(context, pageDepositRecordSucceed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(intl.S.current.open_transfer),
        actions: <Widget>[
          Container(
            child: Text.rich(
              TextSpan(
                  text: intl.S.current.transfer_plan,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 3.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, pageTransferPlan);
                    }),
            ),
          )
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
          transferPayerWidget(
              context,
              _limitMoney,
              _changedCcyTitle,
              _currBal,
              _changedAccountTitle,
              ccy,
              singleLimit,
              totalBalance,
              cardNo,
              payerBankCode,
              money,
              _amountInputChange,
              _selectAccount,
              _getCcy,
              _getCardTotals),
          //获取用户姓名及账号方法
          transferPayeeWidget(
              payeeCardNo,
              payeeName,
              accountSelect,
              payeeNameForSelects,
              _getImage,
              context,
              intl.S.current.receipt_side,
              intl.S.current.company_name,
              intl.S.current.account_num,
              intl.S.current.please_input,
              intl.S.current.please_input,
              _nameInputChange,
              _accountInputChange,
              _payeeNameController,
              _payeeAccountController),
          //备注
          transferOtherWidget(context, '', _transferInputChange),
          SliverToBoxAdapter(
            child: _transferBtn(),
          ),
        ],
      ),
    );
  }

//选择账号方法
  _selectAccount() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.current.account_lsit,
            items: cardNoList,
            lastSelectedPosition: _accountIndex,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accountIndex = result;
        _changedAccountTitle = cardNoList[_accountIndex];
      });
      _getCardTotals(_changedAccountTitle);
    }
  }

  _loadTransferData() {
    Future.wait({
      CardDataRepository().getCardList('GetCardList'),
    }).then((value) {
      value.forEach((element) {
        //通过绑定手机号查询卡列表接口POST
        if (element is GetCardListResp) {
          setState(() {
            //付款方卡号
            cardNo = element.cardList[0].cardNo;
            element.cardList.forEach((e) {
              cardNoList.add(e.cardNo);
            });
            //付款方银行名字
            payerBankCode = element.cardList[0].ciName;
            //付款方姓名
            //  payerName = element.cardList[0].ciName;
            //付款方卡号
            payerCardNo = element.cardList[0].ciName;
          });
          _getCardTotal(cardNo);
        }
      });
    });
  }

  _getCardTotal(String cardNo) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(cardNo), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(cardNo), 'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        if (element is GetSingleCardBalResp) {
          setState(() {
            //余额
            element.cardListBal.forEach((element) {
              ccyListOne.clear();
              ccyListOne.add(element.ccy);
              if (element.ccy == 'USD') {
                _currBal = element.currBal;
                _changedCcyTitle = 'USD';
                _loacalCurrBal = _currBal;
              }
            });
          });
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            //单次限额
            singleLimit = element.singleLimit;
          });
        }
      });
    });
  }

  _addTransferPlan() {
    Future.wait({
      TransferDataRepository().addTransferPlan(
          AddTransferPlanReq(
            money,
            '',
            '',
            '',
            'HKD', // _changedCcyTitle,
            'HKD',
            '',
            false,
            _endTime,
            0,
            groupValue,
            '',
            '',
            _payeeBankCodeController.text,
            _payeeAccountController.text,
            _payeeNameController.text,
            payerBankCode,
            _changedAccountTitle,
            payerName,
            '',
            planName,
            remark,
            '',
            '',
            _startTime,
            '0',
          ),
          'AddTransferPlanReq')
    }).then((value) {
      setState(() {});
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //选择货币和余额
  _getCardTotals(String _changedAccountTitle) {
    Future.wait({
      CardDataRepository().getCardBalByCardNo(
          GetSingleCardBalReq(_changedAccountTitle), 'GetSingleCardBalReq'),
      CardDataRepository().getCardLimitByCardNo(
          GetCardLimitByCardNoReq(_changedAccountTitle),
          'GetCardLimitByCardNoReq'),
    }).then((value) {
      value.forEach((element) {
        // 通过卡号查询余额
        if (element is GetSingleCardBalResp) {
          ccyLists.clear();
          ccyList.clear();
          _currBal = '';
          _position = 0;
          element.cardListBal.forEach((bals) {
            totalBalances.add(bals.avaBal);
          });
          // var cardListB = new List();
          element.cardListBal.forEach((cardBalBean) {
            if (cardBalBean.ccy != '') {
              ccyList.add(cardBalBean.ccy);
            }
            if (_changedCcyTitle == cardBalBean.ccy) {
              _currBal = cardBalBean.currBal.toString();
            }
          });
          if (ccyList.length > 1) {
            if (_changedCcyTitle == 'USD') {
              _position = 2;
            } else if (_changedCcyTitle == 'CNY') {
              _position = 0;
            }
          } else {
            _position = 0;
          }
          if (_changedCcyTitle != 'USD' &&
              ccyList.length < 3 &&
              ccyList.length > 0) {
            _changedCcyTitle = 'USD';
            _currBal = _loacalCurrBal;
          }
          if (element.cardListBal.length == 0) {
            _currBal = '';
            _changedCcyTitle = 'CNY';
            ccyList.add('CNY');
            _position = 0;
          }
        }
        //查询额度
        else if (element is GetCardLimitByCardNoResp) {
          setState(() {
            _limitMoney = element.singleLimit;
          });
        }
      });
    });
  }
}
