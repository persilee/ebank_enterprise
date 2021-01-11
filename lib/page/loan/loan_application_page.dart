/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款申请界面
/// Author: fangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
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
  String _deadline = S.current.please_select; //贷款期限
  String _goal = S.current.please_select; //贷款目的
  String _currency = S.current.please_select; //币种
  String _inputs = S.current.please_input; //请输入提示
  String _choose = S.current.please_select; //请选择提示
  String _notRequired = S.current.not_required; //非必填提示
  int groupValue = 0; //单选框默认值
  bool _isButton = false; //申请按钮是否能点击
  bool _checkBoxValue = false; //复选框默认值
  Color color = Colors.grey; //请选择文字的颜色
  var _contactsController = new TextEditingController(); //联系人文本监听器
  var _phoneController = new TextEditingController(); //联系人手机号码文本监听器
  var _moneyController = new TextEditingController(); //申请金额文本监听器
  var _remarkController = new TextEditingController(); //备注文本监听器
  String language = Intl.getCurrentLocale(); //获取当前语言
  List<String> _deadLineLists = [
    S.current.three_month,
    S.current.six_month,
    S.current.nine_month,
    S.current.twelemonth
  ]; //贷款期限列表
  int _index = 3; //贷款期限对应的几个月
  List<String> _goalLists = [
    S.current.project_loan,
    S.current.business_loan,
    S.current.purpose
  ]; //贷款目的列表
  String _custId = ''; //客户号
  List<String> passwordList = []; //密码列表
  var _payPassword = ''; //支付密码

  @override
  void initState() {
    super.initState();
    _custIdReqData();

    //输入框监听
    _contactsController.addListener(() {
      _isClick();
    });
    _phoneController.addListener(() {
      _isClick();
    });
    _moneyController.addListener(() {
      _isClick();
    });
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
    String _prdtCode = "LN000008";
    String _repaymentMethod = "EPI";
    String _termUnit = "MONTH";
    LoanDataRepository()
        .getLoanApplication(
            LoanApplicationReq(
                _currency,
                _custId,
                _contactsController.text,
                int.parse(_moneyController.text),
                _goal,
                _phoneController.text,
                _prdtCode,
                _remarkController.text,
                _repaymentMethod,
                _termUnit,
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
        padding: CONTENT_PADDING,
        child: Column(
          children: [
            //联系人
            _input(
              S.of(context).contact,
              _inputText(_inputs, _contactsController),
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
              _inputText(_inputs, _moneyController),
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
              _inputBottom(context, S.of(context).loan_purpose, _goalLists, 1),
            ),
            //备注
            _input(
              S.of(context).remark,
              _inputText(_notRequired, _remarkController),
            ),
            //复选框及协议文本内容
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [_roundCheckBox(), _textContent()],
              ),
            ),
            //申请按钮
            Container(
              margin: EdgeInsets.only(top: 40),
              child: HsgButton.button(title: "申请", click: _confirmButton()),
            ),
          ],
        ),
      ),
    );
  }

  //判断按钮能否使用
  _isClick() {
    if (_checkBoxValue &&
        _contactsController.text.length > 0 &&
        _phoneController.text.length > 0 &&
        _moneyController.text.length > 0 &&
        _deadline != _choose &&
        _goal != _choose &&
        _currency != _choose) {
      return setState(() {
        _isButton = true;
      });
    } else {
      setState(() {
        _isButton = false;
      });
    }
  }

  //确认按钮点击事件
  _confirmButton() {
    if (_isButton) {
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
              text: S.current.loan_application_agreement1,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement2, '99867'),
            TextSpan(
              text: S.current.loan_application_agreement3,
              style: AGREEMENT_TEXT_STYLE,
            ),
            _conetentJump(S.current.loan_application_agreement4, '99868'),
          ],
        ),
      ),
    );
  }

  //协议文本跳转内容
  _conetentJump(String text, String arguments) {
    return TextSpan(
      text: text,
      style: AGREEMENT_JUMP_TEXT_STYLE,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.pushNamed(context, pageUserAgreement, arguments: arguments);
        },
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
        style: FIRST_DEGREE_TEXT_STYLE,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: name,
          hintStyle: FIRST_DESCRIBE_TEXT_STYLE,
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
              fontSize: 14,
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
        _isClick();
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
              fontSize: 14,
              color: _currency == _choose
                  ? HsgColors.describeText
                  : HsgColors.aboutusTextCon,
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
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Text(
                name,
                style: FIRST_DEGREE_TEXT_STYLE,
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
          _checkBoxValue = !_checkBoxValue;
          _isClick();
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 25),
        child: _checkBoxValue
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
          _isClick();
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
