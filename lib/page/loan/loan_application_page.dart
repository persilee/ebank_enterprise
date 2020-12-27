import 'dart:math';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款申请界面
/// Author: fangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

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
  var _remarkController = new TextEditingController(); //备注文本监听器
  String language = Intl.getCurrentLocale(); //获取当前语言
  List<String> _deadLineLists = List(); //贷款期限列表
  int _index = 3; //贷款期限对应的几个月
  List<String> _goalLists = List(); //贷款目的列表
  String _custId = ''; //客户号
//协议政策内容
  String _content1 = '';
  String _content2 = '';
  String _content3 = '';
  String _content4 = '';
  @override
  void initState() {
    super.initState();
    _loadData();
    _custIdReqData();
    _reqData();
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

  Future<void> _custIdReqData() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    UserDataRepository()
        .getUserInfo(GetUserInfoReq(userID), "getUserInfo")
        .then((data) {
      setState(() {
        _custId = data.custId;
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future<void> _reqData() async {
    LoanDataRepository()
        .getLoanApplication(
            LoanApplicationReq(
                _currency,
                _custId,
                _contactsController.text,
                int.parse(_moneyController.text),
                _goal,
                _phoneController.text,
                "LN000008",
                _remarkController.text,
                "EPI",
                "MONTH",
                _index),
            "getLoanApplication")
        .then((data) {})
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
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
              _input(S.of(context).remark,
                  _inputText(_notRequired, _remarkController)),
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

  //判断按钮能否使用
  _isClick() {
    if (_isT &&
        _contactsController.text.length > 0 &&
        _phoneController.text.length > 0 &&
        _moneyController.text.length > 0 &&
        _deadline != _choose &&
        _goal != _choose &&
        _currency != _choose) {
      return () {
        _reqData();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  child: PasswordInputBox(),
                );
              });
        });
      };
      // return () {
      //   _reqData();
      // };
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
        _index = _index * (index + 1);
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

/// 自定义密码输入框 使用画笔画出单个的框
class CustomJPasswordField extends StatelessWidget {
  //  传入当前密码
  String data;
  CustomJPasswordField(this.data);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyCustom(data),
    );
  }
}

//  继承CustomPainter ，来实现自定义图形绘制
class MyCustom extends CustomPainter {
  //  传入的密码，通过其长度来绘制圆点
  String pwdLength;
  MyCustom(this.pwdLength);

  //  此处Sizes是指使用该类的父布局大小
  @override
  void paint(Canvas canvas, Size size) {
    // 密码画笔
    Paint mPwdPaint;
    Paint mRectPaint;

    // 初始化密码画笔
    mPwdPaint = new Paint();
    mPwdPaint..color = Colors.black;

//   mPwdPaint.setAntiAlias(true);
    // 初始化密码框
    mRectPaint = new Paint();
    mRectPaint..color = Color(0xff707070);

    //  圆角矩形的绘制
    RRect r = new RRect.fromLTRBR(0.0, 0.0, size.width, size.height,
        new Radius.circular(size.height / 12));

    //  画笔的风格
    mRectPaint.style = PaintingStyle.stroke;
    canvas.drawRRect(r, mRectPaint);

    //  将其分成六个 格子（六位支付密码）
    var per = size.width / 6.0;
    var offsetX = per;
    while (offsetX < size.width) {
      canvas.drawLine(new Offset(offsetX, 0.0),
          new Offset(offsetX, size.height), mRectPaint);
      offsetX += per;
    }

    //  画实心圆
    var half = per / 2;
    var radio = per / 8;
    mPwdPaint.style = PaintingStyle.fill;

    //  当前有几位密码，画几个实心圆
    for (int i = 0; i < pwdLength.length && i < 6; i++) {
      canvas.drawArc(
          new Rect.fromLTRB(i * per + half - radio, size.height / 2 - radio,
              i * per + half + radio, size.height / 2 + radio),
          0.0,
          2 * pi,
          true,
          mPwdPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

///  自定义 键盘 按钮
class CustomKbBtn extends StatefulWidget {
  ///  按钮显示的文本内容
  Widget text;
  int i = 0;
  CustomKbBtn({Key key, this.text, this.callback, this.i}) : super(key: key);

  ///  按钮 点击事件的回调函数
  final callback;
  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<CustomKbBtn> {
  ///回调函数执行体
  var backMethod;

  void back() {
    widget.callback('$backMethod');
  }

  @override
  Widget build(BuildContext context) {
    /// 获取当前屏幕的总宽度，从而得出单个按钮的宽度
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    return new Container(
        height: 50.0,
        width: _screenWidth / 3,
        child: new OutlineButton(
          // 直角
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(0.0)),
          // 边框颜色
          borderSide: new BorderSide(color: Color(0x10333333)),
          child: widget.text,
          // 按钮点击事件
          onPressed: back,
        ));
  }
}

// 自定义密码键盘
class MyKeyboard extends StatefulWidget {
  final callback;

  MyKeyboard(this.callback);

  @override
  State<StatefulWidget> createState() {
    return new MyKeyboardStat();
  }
}

class MyKeyboardStat extends State<MyKeyboard> {
  //定义确定按钮接口暴露给调用方
  //回调函数执行体
  var backMethod;

  void onOneChange(BuildContext cont) {
    widget.callback(new KeyEvent("1"));
  }

  void onTwoChange(BuildContext cont) {
    widget.callback(new KeyEvent("2"));
  }

  void onThreeChange(BuildContext cont) {
    widget.callback(new KeyEvent("3"));
  }

  void onFourChange(BuildContext cont) {
    widget.callback(new KeyEvent("4"));
  }

  void onFiveChange(BuildContext cont) {
    widget.callback(new KeyEvent("5"));
  }

  void onSixChange(BuildContext cont) {
    widget.callback(new KeyEvent("6"));
  }

  void onSevenChange(BuildContext cont) {
    widget.callback(new KeyEvent("7"));
  }

  void onEightChange(BuildContext cont) {
    widget.callback(new KeyEvent("8"));
  }

  void onNineChange(BuildContext cont) {
    widget.callback(new KeyEvent("9"));
  }

  void onZeroChange(BuildContext cont) {
    widget.callback(new KeyEvent("0"));
  }

  /// 点击删除
  void onDeleteChange() {
    widget.callback(new KeyEvent("del"));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 200.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          //  键盘主体
          Column(
            children: <Widget>[
              ///  第一行
              new Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onOneChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onTwoChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onThreeChange(context)),
                ],
              ),

              ///  第二行
              new Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: Text(
                        '4',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onFourChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '5',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onFiveChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '6',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onSixChange(context)),
                ],
              ),

              ///  第三行
              new Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: Text(
                        '7',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onSevenChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '8',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onEightChange(context)),
                  CustomKbBtn(
                      text: Text(
                        '9',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onNineChange(context)),
                ],
              ),
              // 第四行
              Row(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    child: CustomKbBtn(text: null, callback: null),
                  ),
                  CustomKbBtn(
                      text: Text(
                        '0',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF222222),
                        ),
                      ),
                      callback: (val) => onZeroChange(context)),
                  Container(
                    color: Colors.grey,
                    child: CustomKbBtn(
                      text: Icon(
                        Icons.backspace_outlined,
                        size: 25,
                      ),
                      callback: (val) => onDeleteChange(),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

///  支符密码用于密码输入框和键盘之间进行通信
class KeyEvent {
  ///  当前点击的按钮所代表的值
  String key;
  KeyEvent(this.key);

  bool isDelete() => this.key == "del";
}

//自定义密码输入框
class PasswordInputBox extends StatefulWidget {
  @override
  PasswordInputBoxState createState() => PasswordInputBoxState();
}

class PasswordInputBoxState extends State<PasswordInputBox> {
  // 用户输入的密码
  String pwdData = '';

  @override
  void initState() {
    super.initState();
  }

  _isPassword(String pwd) {
    if (pwdData == pwd) {
      Navigator.pushNamed(context, pageOperationResult);
    } else {
      Fluttertoast.showToast(msg: "密码错误，请重新输入");
      pwdData = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    return new Container(
      width: double.maxFinite,
      height: 400.0,
      color: Color(0xffffffff),
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 130),
                    child: Text(
                      '输入支付密码',
                      style: new TextStyle(
                          fontSize: 16.0, color: Color(0xff333333)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.clear,
                      ),
                    ),
                  ),
                ],
              )),
          Divider(
            color: HsgColors.divider,
          ),
          //密码框
          new Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: _buildPwd(pwdData),
          ),
          //键盘框
          new Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: MyKeyboard(_onKeyDown),
          ),
        ],
      ),
    );
  }

  /// 密码键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(KeyEvent data) {
// 如果点击了删除按钮，则将密码进行修改
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    }
//点击了数字按钮时将密码进行完整的拼接
    else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      //如果数字有六位则进行密码校验
      if (pwdData.length == 6) {
        _isPassword("111111");
      }
      setState(() {});
    }
  }

  // 构建密码输入框定义了其宽度和高度
  Widget _buildPwd(var pwd) {
    return new GestureDetector(
      child: new Container(
        width: 250.0,
        height: 45.0,
        child: CustomJPasswordField(pwd),
      ),
    );
  }
}
