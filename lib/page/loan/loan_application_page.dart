/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款申请界面
/// Author: fangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_password_dialog.dart';
import 'package:ebank_mobile/widget/hsg_single_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page_route.dart';

class LoanApplicationPage extends StatefulWidget {
  @override
  _LoanApplicationState createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplicationPage> {
  var _deadline = S.current.please_select; //贷款期限
  var _goal = S.current.please_select; //贷款目的
  var _currency = S.current.please_select; //币种
  String _inputs = S.current.please_input; //请输入提示
  String _choose = S.current.please_select; //请选择提示
  String _notRequired = S.current.not_required; //非必填提示
  int groupValue = 0; //单选框默认值
  bool _isButton = false; //申请按钮是否能点击
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
  List<String> passwordList = []; //密码列表
  var _payPassword = ''; //支付密码

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
  }

  Future<void> _loadData() async {
    if (language == 'zh_CN') {
      _deadLineLists = ['三个月', '六个月', '九个月', '十二个月'];
      _goalLists = ['项目贷款', '经营贷款', '目的'];
      _content1 = "本人已阅读并同意签署";
      _content2 = "《企业用户服务及授权协议》";
      _content3 = "和";
      _content4 = "《用户服务协议及隐私政策》";
    } else {
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

  //获取客户号
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

  //贷款申请请求
  _reqData() {
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
              //联系人
              _input(
                S.of(context).contact,
                _inputText(
                  _inputs,
                  _contactsController,
                ),
              ),
              //联系人手机号码
              _input(
                S.of(context).contact_phone_num,
                _inputText(_inputs, _phoneController),
              ),
              //币种
              _input(
                S.of(context).currency,
                _inputDialog(context, ['HKD', 'USD', 'CND']),
              ),
              //申请金额
              _input(
                S.of(context).apply_amount,
                _inputText(
                  _inputs,
                  _moneyController,
                ),
              ),
              //贷款期限
              _input(
                S.of(context).loan_duration,
                _inputBottom(
                    context, S.of(context).loan_duration, _deadLineLists, 0),
              ),
              //贷款目的
              _input(
                S.of(context).loan_purpose,
                _inputBottom(
                    context, S.of(context).loan_purpose, _goalLists, 1),
              ),
              //备注
              _input(
                S.of(context).remark,
                _inputText(_notRequired, _remarkController),
              ),
              //复选框及协议文本内容
              Container(
                child: Row(
                  children: [_roundCheckBox(), _textContent()],
                ),
              ),
              //申请按钮
              _applicationButton(S.of(context).apply),
            ],
          )),
    );
  }

  //判断按钮能否使用
  _isClick() {
    if (_isButton &&
        _contactsController.text.length > 0 &&
        _phoneController.text.length > 0 &&
        _moneyController.text.length > 0 &&
        _deadline != _choose &&
        _goal != _choose &&
        _currency != _choose) {
      return () {
        _openBottomSheet();
      };
    } else {
      return null;
    }
  }

  //协议文本内容
  Widget _textContent() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: _content1,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            TextSpan(
              text: _content2,
              style: TextStyle(fontSize: 13, color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, pageUserAgreement,
                      arguments: '99867');
                },
            ),
            TextSpan(
              text: _content3,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            TextSpan(
              text: _content4,
              style: TextStyle(fontSize: 13, color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, pageUserAgreement,
                      arguments: '99868');
                },
            ),
          ],
        ),
      ),
    );
  }

  //申请按钮
  Widget _applicationButton(String name) {
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
                  ? Colors.grey
                  : Colors.black,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
          ),
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
      },
    );
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
          ),
        ],
      ),
    );
  }

//单行内容
  Widget _input(String name, Widget widget) {
    return Column(
      children: [
        Row(
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
        Divider(
          color: HsgColors.divider,
          height: 5,
        ),
      ],
    );
  }

//圆形复选框
  Widget _roundCheckBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          checkBoxValue = !checkBoxValue;
          _isButton = checkBoxValue;
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 10, 25),
        child: checkBoxValue
            ? _ckeckBoxImge("images/common/check_btn_common_checked.png")
            : _ckeckBoxImge("images/common/check_btn_common_no_check.png"),
      ),
    );
  }

  //圆形复选框是否选中图片
  Widget _ckeckBoxImge(String imgurl) {
    return Image.asset(
      imgurl,
      height: 16,
      width: 16,
    );
  }

  //底部弹窗内容选择
  _select(String name, List list, int i) {
    SinglePicker.showStringPicker(
      context,
      data: list,
      title: name,
      clickCallBack: (int index, var str) {
        setState(() {
          i == 0 ? _deadline = str : _goal = str;
          _index = _index * (index + 1);
        });
      },
    );
  }

  //交易密码窗口
  void _openBottomSheet() async {
    passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
        );
      },
    );
    if (passwordList != null) {
      if (passwordList.length == 6) {
        _payPassword = EncryptUtil.aesEncode(passwordList.join());
        _submitFormData();
      }
    }
  }

  //提交响应数据
  _submitFormData() {
    VerifyTradePawRepository()
        .verifyTransPwdNoSms(
            VerifyTransPwdNoSmsReq(_payPassword), 'VerifyTransPwdNoSmsReq')
        .then((data) {
      _reqData();
      Navigator.pushNamed(context, pageOperationResult);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
