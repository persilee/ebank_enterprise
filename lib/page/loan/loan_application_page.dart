/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///贷款申请界面
/// Author: fangluyao
/// Date: 2020-12-14

import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/config/hsg_text_style.dart';
import 'package:ebank_mobile/data/source/loan_data_repository.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_user_info.dart';
import 'package:ebank_mobile/data/source/model/loan_application.dart';
import 'package:ebank_mobile/data/source/model/verify_trade_password.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/data/source/user_data_repository.dart';
import 'package:ebank_mobile/data/source/verify_trade_paw_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/hsg_general_widget.dart';
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
  int _ccyId = 0; //币种下标
  int _index = 3; //贷款期限对应的几个月
  String _deadLine = ''; //贷款期限
  String _goal = ""; //贷款目的
  String _currency = ""; //币种
  String _inputs = S.current.please_input; //请输入提示
  String _notRequired = S.current.not_required; //非必填提示
  String _custId = ''; //客户号
  String _language = Intl.getCurrentLocale(); //版本语言

  bool _isButton = false; //申请按钮是否能点击
  bool _checkBoxValue = false; //复选框默认值
  var _payPassword = ''; //交易密码
  var _contactsController = new TextEditingController(); //联系人文本监听器
  var _phoneController = new TextEditingController(); //联系人手机号码文本监听器
  var _moneyController = new TextEditingController(); //申请金额文本监听器
  var _remarkController = new TextEditingController(); //备注文本监听器

  List<String> _passwordList = []; //密码列表
  List<String> _ccyList = []; //币种列表'HKD', 'USD', 'CND'
  List<String> _deadLineLists = [
    // S.current.three_month,
    // S.current.six_month,
    // S.current.nine_month,
    // S.current.twelemonth
  ]; //贷款期限列表
  List<String> _goalLists = [
    // S.current.project_loan,
    // S.current.business_loan,
    // S.current.purpose
  ]; //贷款目的列表

  @override
  void initState() {
    super.initState();
    _custIdReqData();
    _getCcyList(); //获取币种
    _getLoanPurposeList(); //贷款目的
    _getLoanTimeList(); //获取贷款期限
  }

  // 获取币种列表
  Future _getCcyList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("CCY"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _ccyList.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          _ccyList.add(e.code);
        });
      }
    });
  }

  //获取贷款期限
  Future _getLoanTimeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("LOAN_TERM"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _deadLineLists.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN') {
            _deadLineLists.add(e.cname);
          } else {
            _deadLineLists.add(e.name);
          }
        });
      }
    });
  }

  //获取贷款目的
  Future _getLoanPurposeList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq("LOAN_PUR"), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        _goalLists.clear();
        data.publicCodeGetRedisRspDtoList.forEach((e) {
          if (_language == 'zh_CN') {
            _goalLists.add(e.cname);
          } else {
            _goalLists.add(e.name);
          }
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).loan_apply),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: HsgColors.commonBackground,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: CONTENT_PADDING,
                color: Colors.white,
                child: _formColumn(),
              ),
              //复选框及协议文本内容
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: CONTENT_PADDING,
                child: Row(
                  children: [_roundCheckBox(), _textContent()],
                ),
              ),
              //申请按钮
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: HsgButton.button(
                  title: S.current.apply,
                  click: _isButton ? _openBottomSheet : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _formColumn() {
    return Column(
      children: [
        //联系人
        TextFieldContainer(
          title: S.current.contact,
          hintText: _inputs,
          keyboardType: TextInputType.text,
          controller: _contactsController,
          callback: _isClick,
        ),
        //联系人手机号码
        TextFieldContainer(
          title: S.current.contact_phone_num,
          hintText: _inputs,
          keyboardType: TextInputType.number,
          controller: _phoneController,
          callback: _isClick,
        ),
        //币种
        SelectInkWell(
          title: S.current.debit_currency,
          item: _currency,
          onTap: () {
            _showDialog(_ccyId, _ccyList);
          },
        ),
        //申请金额
        TextFieldContainer(
          title: S.current.apply_amount,
          hintText: _inputs,
          keyboardType: TextInputType.number,
          controller: _moneyController,
          callback: _isClick,
        ),
        SelectInkWell(
          title: S.current.loan_duration,
          item: _deadLine,
          onTap: () {
            _select(S.current.loan_duration, _deadLineLists, 0);
          },
        ),
        SelectInkWell(
          title: S.current.loan_purpose,
          item: _goal,
          onTap: () {
            _select(S.current.loan_purpose, _goalLists, 1);
          },
        ),
        //备注
        TextFieldContainer(
          title: S.current.remark,
          hintText: _notRequired,
          keyboardType: TextInputType.text,
          controller: _remarkController,
        ),
      ],
    );
  }

  //判断按钮能否使用
  _isClick() {
    if (_checkBoxValue &&
        _contactsController.text != '' &&
        _phoneController.text != '' &&
        _moneyController.text != '' &&
        _deadLine != '' &&
        _goal != '' &&
        _currency != '') {
      return setState(() {
        _isButton = true;
      });
    } else {
      setState(() {
        _isButton = false;
      });
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
            _conetentJump(S.current.loan_application_agreement2, '98822'),
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

  //全局弹窗内容
  _showDialog(int index, List<String> list) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return HsgSingleChoiceDialog(
          title: S.of(context).currency_choice,
          items: list,
          positiveButton: S.of(context).confirm,
          negativeButton: S.of(context).cancel,
          lastSelectedPosition: index,
        );
      },
    );
    if (result != null && result != false) {
      setState(() {
        _ccyId = result;
        _currency = list[result];
        _isClick();
      });
    }
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
  _select(String title, List list, int i) {
    SinglePicker.showStringPicker(
      context,
      data: list,
      title: title,
      clickCallBack: (int index, var str) {
        setState(() {
          i == 0 ? _deadLine = str : _goal = str;
          _index = _index * (index + 1);
          _isClick();
        });
      },
    );
  }

  //交易密码窗口
  void _openBottomSheet() async {
    _passwordList = await showHsgBottomSheet(
      context: context,
      builder: (context) {
        return HsgPasswordDialog(
          title: S.current.input_password,
          resultPage: pageOperationResult,
        );
      },
    );
    // if (_passwordList != null) {
    //   if (_passwordList.length == 6) {
    //     _payPassword = EncryptUtil.aesEncode(_passwordList.join());
    //     _submitFormData();
    //   }
    // }
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
}
