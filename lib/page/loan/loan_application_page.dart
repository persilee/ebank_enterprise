/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款申请界面
/// Author: fangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class LoanApplicationPage extends StatefulWidget {
  @override
  _LoanApplicationState createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplicationPage> {
  var _deadline = ''; //贷款期限
  var _goal = ''; //贷款目的
  var _currency = ''; //币种
  String _inputs = ''; //请输入提示
  String _choose = ''; //请选择提示
  String _notRequired = ''; //非必填提示
  int groupValue = 0; //单选框默认值
  bool _isT = false; //申请按钮是否能点击
  var checkBoxValue = false; //复选框默认值
  Color color = Colors.grey; //请选择文字的颜色
  var _contactsController = new TextEditingController(); //联系人文本监听器
  var _phoneController = new TextEditingController(); //联系人手机号码文本监听器
  var _moneyController = new TextEditingController(); //申请金额文本监听器
  String language = Intl.getCurrentLocale(); //获取当前语言
  List<String> _deadLineLists = List(); //贷款期限列表
  List<String> _goalLists = List(); //贷款目的列表
//协议政策内容
  String _content1 = '';
  String _content2 = '';
  String _content3 = '';
  String _content4 = '';
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (language == 'zh_CN') {
      _deadline = _goal = _currency = _choose = '请选择';
      _inputs = "请输入";
      _notRequired = "非必填";
      _deadLineLists = ['三个月', '六个月', '九个月', '十二个月'];
      _goalLists = ['项目贷款', '经营贷款', '目的'];
      _content1 = "本人已阅读并同意签署";
      _content2 = "《企业用户服务及授权协议》";
      _content3 = "和";
      _content4 = "《用户服务协议及隐私政策》";
    } else {
      _deadline = _goal = _currency = _choose = 'Choose';
      _inputs = "Input";
      _notRequired = "Not Required";
      _deadLineLists = [
        'Three Months',
        'Six Months',
        'Nine Months',
        'Twelvemonth'
      ];
      _goalLists = ['Project Loan', 'Business Loans', 'Purpose'];
      _content1 = "I have read and agree to sign";
      _content2 = "《Enterprise User Services and Licensing Agreement》";
      _content3 = "and";
      _content4 = "《User Service Agreement and Privacy Policy》";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_apply),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(right: 15),
          child: Column(
            children: [
              _input(
                  S.of(context).contact,
                  _inputText(
                    _inputs,
                    _contactsController,
                  )),
              _input(S.of(context).contact_phone_num,
                  _inputText(_inputs, _phoneController)),
              _input(S.of(context).currency,
                  _inputDialog(context, ['HKD', 'USD', 'CND'])),
              _input(
                  S.of(context).apply_amount,
                  _inputText(
                    _inputs,
                    _moneyController,
                  )),
              _input(
                  S.of(context).loan_duration,
                  _inputBottom(
                      context, S.of(context).loan_duration, _deadLineLists, 0)),
              _input(
                  S.of(context).loan_purpose,
                  _inputBottom(
                      context, S.of(context).loan_purpose, _goalLists, 1)),
              _input(S.of(context).remark, _inputText(_notRequired, null)),
              Container(
                child: Row(
                  children: [_roundCheckBox(), _textContent()],
                ),
              ),
              _button(S.of(context).apply),
            ],
          )),
    );
  }

  //根据是否勾选协议判断按钮能否使用
  _isClick() {
    if (_isT) {
      return () {
        if (_contactsController.text.length > 0 &&
            RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
                .hasMatch(_phoneController.text) &&
            RegExp('^(([0-9]|([1-9][0-9]{0,9}))((\.[0-9]{1,2})?))\$')
                .hasMatch(_moneyController.text) &&
            _deadline != _choose &&
            _goal != _choose &&
            _currency != _choose) {
          Fluttertoast.showToast(msg: 'Application Approved');
        } else {
          Fluttertoast.showToast(msg: 'Incorrect input information!');
        }
      };
    } else {
      return null;
    }
  }

  //协议文本内容
  Widget _textContent() {
    return Expanded(
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: _content1,
              style: TextStyle(fontSize: 13, color: Colors.black)),
          TextSpan(
              text: _content2,
              style: TextStyle(fontSize: 13, color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Fluttertoast.showToast(msg: 'The jump is successful');
                }),
          TextSpan(
              text: _content3,
              style: TextStyle(fontSize: 13, color: Colors.black)),
          TextSpan(
              text: _content4,
              style: TextStyle(fontSize: 13, color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Fluttertoast.showToast(msg: 'The jump is successful');
                }),
        ]),
      ),
    );
  }

//按钮
  Widget _button(String name) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 40),
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: _isClick(),
        child: Text(name),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

//文字输入框
  Widget _inputText(String name, TextEditingController controller) {
    return SizedBox(
      child: TextField(
        controller: controller,
        autocorrect: false,
        autofocus: false,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 15,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: name,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

//底部弹窗
  Widget _inputBottom(
      BuildContext context, String name, List<String> list, int i) {
    return InkWell(
      onTap: () {
        _select(name, list, i);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            i == 0 ? _deadline : _goal,
            style: TextStyle(
              color: (i == 0 ? _deadline : _goal) == _choose
                  ? color = Colors.grey
                  : color = Colors.black,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
          )
        ],
      ),
    );
  }

  //全局弹窗内容
  _showDialog(BuildContext context, List<String> list) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return HsgSingleChoiceDialog(
            title: S.of(context).currency_choice,
            items: list,
            positiveButton: S.of(context).confirm,
            negativeButton: S.of(context).cancel,
            lastSelectedPosition: groupValue,
          );
        });
    print('dialog result:$result');
    print(_currency);
    if (result != null && result != false) {
      groupValue = result;
      setState(() {
        _currency = list[result];
      });
    }
  }

//全局弹窗
  Widget _inputDialog(BuildContext context, List<String> list) {
    return InkWell(
        onTap: () {
          _showDialog(context, list);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _currency,
              style: TextStyle(
                color: _currency == _choose
                    ? color = Colors.grey
                    : color = Colors.black,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
            )
          ],
        ));
  }

//单行内容
  Widget _input(String name, Widget widget) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Expanded(
                child: widget,
              ),
            ],
          ),
        ),
        Divider(
          color: HsgColors.divider,
          height: 5,
        ),
      ],
    );
  }

//圆形复选框
  Widget _roundCheckBox() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            checkBoxValue = !checkBoxValue;
            _isT = checkBoxValue;
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 10, 25),
          child: checkBoxValue
              ? Image.asset(
                  "images/common/check_btn_common_checked.png",
                  height: 16,
                  width: 16,
                )
              : Image.asset(
                  "images/common/check_btn_common_no_check.png",
                  height: 16,
                  width: 16,
                ),
        ),
      ),
    );
  }

  //底部弹窗内容选择
  _select(String name, List list, int i) {
    _PickerTool.showStringPicker(context, data: list, title: name,
        clickCallBack: (int index, var str) {
      setState(() {
        i == 0 ? _deadline = str : _goal = str;
      });
    });
  }
}

//点击响应函数
typedef StringClickCallback = void Function(int selectIndex, Object selectStr);

//单列选择器封装
class _PickerTool {
  static void showStringPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    int normalIndex,
    PickerDataAdapter adapter,
    @required StringClickCallback clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: false),
        clickCallBack: (Picker picker, List<int> selecteds) {
      clickCallBack(selecteds[0], data[selecteds[0]]);
    }, selecteds: [normalIndex ?? 0], title: title);
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter adapter,
    String title,
    String name,
    List<int> selecteds,
    @required PickerConfirmCallback clickCallBack,
  }) {
    new Picker(
            adapter: adapter,
            title: new Text(title ?? name,
                style: TextStyle(color: Colors.grey, fontSize: 17)),
            selecteds: selecteds,
            cancelText: S.of(context).cancel,
            confirmText: S.of(context).confirm,
            cancelTextStyle: TextStyle(color: Colors.black, fontSize: 17),
            confirmTextStyle: TextStyle(color: Colors.black, fontSize: 17),
            textAlign: TextAlign.right,
            itemExtent: 40,
            height: 200,
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: clickCallBack)
        .showModal(context);
  }
}
