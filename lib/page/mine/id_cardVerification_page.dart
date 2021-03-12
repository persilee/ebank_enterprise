import 'package:ebank_mobile/config/hsg_text_style.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 重置交易密码--身份证验证
/// Author: hlx
/// Date: 2020-12-31
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/mine_checInformantApi.dart';
import 'package:ebank_mobile/data/source/model/get_public_parameters.dart';
import 'package:ebank_mobile/data/source/model/get_verificationByPhone_code.dart';
import 'package:ebank_mobile/data/source/model/set_transactionPassword.dart';
import 'package:ebank_mobile/data/source/public_parameters_repository.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_button.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';
import 'package:flutter/services.dart';

class IdIardVerificationPage extends StatefulWidget {
  @override
  _IdIardVerificationPageState createState() => _IdIardVerificationPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _IdIardVerificationPageState extends State<IdIardVerificationPage> {
  //第一部分
  TextEditingController _cardNo = TextEditingController(); //账号
  TextEditingController _certNo = TextEditingController(); //证件号
  TextEditingController _phoneNo = TextEditingController(); //预留手机号
  TextEditingController _realName = TextEditingController(); //真实姓名
  TextEditingController _smsCode = TextEditingController(); //短信验证码

  //第二部分
  TextEditingController _newPwd = TextEditingController(); //新密码
  TextEditingController _confimPwd = TextEditingController(); //确认新密码

  String _certType = '';
  bool isShowIdCheckout = true; //显示第一步身份证验证信息
  String _certTypeKey; //身份校验的key
  Timer _timer;
  int countdownTime = 0;
  TextEditingController userAccount = TextEditingController();
  List<String> _accList = []; //账号列表
  List<String> _accIcon = [];
  String _accNo = '';

  int _accNoId = 0;
  List<IdType> idInformationList = []; //证件类型信息
  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _phoneNo.addListener(() {
      //电话号码限制11位数
      String text = _phoneNo.text;
      int length = text.length;
      if (length > 11) {
        _phoneNo.text = text.substring(0, 11);
        _phoneNo.selection =
            TextSelection.collapsed(offset: _phoneNo.text.length);
      }
    });
    //交易密码，确认密码限制6位
    _newPwd.addListener(() {
      String text = _newPwd.text;
      int length = text.length;
      if (length > 6) {
        _newPwd.text = text.substring(0, 6);
        _newPwd.selection =
            TextSelection.collapsed(offset: _newPwd.text.length);
      }
    });
    _confimPwd.addListener(() {
      String text = _confimPwd.text;
      int length = text.length;
      if (length > 6) {
        _confimPwd.text = text.substring(0, 6);
        _confimPwd.selection =
            TextSelection.collapsed(offset: _confimPwd.text.length);
      }
    });
    _getUserCardList();
    _getIdCardList();
  }

  //账户列表
  _getUserCardList() async {
    //获取账户列表
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          _accList.clear();
          _accIcon.clear();
          data.cardList.forEach((item) {
            _accList.add(item.cardNo);
            _accIcon.add(item.imageUrl);
          });
          _accNo = _accList[_accNoId];
        });
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  //获取证件类型
  _getIdCardList() async {
    PublicParametersRepository()
        .getIdType(GetIdTypeReq('CICID'), 'GetIdTypeReq')
        .then((data) {
      if (data.publicCodeGetRedisRspDtoList != null) {
        print('data.publicCodeGetRedisRspDtoList222222');
        print(data);
        idInformationList = data.publicCodeGetRedisRspDtoList;
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

//账户选择弹窗
  void _accountBottomSheet() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return HsgBottomSingleChoice(
            title: S.of(context).account_lsit,
            items: _accList,
            lastSelectedPosition: _accNoId,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accNoId = result;
        _accNo = _accList[_accNoId];
        _cardNo.text = _accList[_accNoId];
      });
    }
  }

  //证件类型选择弹窗
  void _idCardListBottomSheet() async {
    List<String> obj = [];
    List<String> indList = [];

    if (idInformationList != null) {
      idInformationList.forEach((element) {
        obj.add(element.cname);
        indList.add(element.code);
      });
    }
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.of(context).idType,
            items: obj,
          );
        });
    print('result$indList');
    if (result != null && result != false) {
      setState(() {
        _certType = obj[result];
        _certTypeKey = indList[result];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).iDCardVerification),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          height: double.infinity,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: SingleChildScrollView(
                child:
                    //三元运算符
                    isShowIdCheckout
                        ? Column(
                            //身份证验证信息
                            children: [
                              //账号
                              Container(
                                color: Colors.white,
                                padding: CONTENT_PADDING,
                                margin: EdgeInsets.only(bottom: 12),
                                child: SelectInkWell(
                                  title: S.current.account_number,
                                  item: _accNo,
                                  onTap: _accountBottomSheet,
                                ),
                              ),
                              //其他信息
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(bottom: 16),
                                padding: CONTENT_PADDING,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 1.0),
                                      child: Text(
                                        S
                                            .of(context)
                                            .pleaseFillInTheBankInformation,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    //姓名
                                    InputList(S.of(context).name,
                                        S.of(context).placeName, _realName),
                                    //证件类型
                                    Container(
                                      child: SelectInkWell(
                                        title: S.current.idType,
                                        item: _certType,
                                        onTap: _idCardListBottomSheet,
                                      ),
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: HsgColors.divider,
                                    ),
                                    //证件号码
                                    InputList(
                                        S.of(context).IdentificationNumber,
                                        S.of(context).placeIdNumber,
                                        _certNo),
                                    //预留手机号
                                    InputList(
                                        S.of(context).reservedMobilePhoneNumber,
                                        S.of(context).placeReveredMobilePhone,
                                        _phoneNo),

                                    //短信验证码
                                    Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Text(S.of(context).sendmsm),
                                          Expanded(
                                            child: otpTextField(),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10)),
                                          SizedBox(
                                            width: 90,
                                            height: 32,
                                            child: _otpButton(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //提交
                              Container(
                                margin: EdgeInsets.all(40), //外边距
                                height: 44.0,
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  child: Text(S.of(context).submit),
                                  onPressed: _submit()
                                      ? () {
                                          _updateLoginPassword();
                                        }
                                      : null,
                                  color: HsgColors.accent,
                                  textColor: Colors.white,
                                  disabledTextColor: Colors.white,
                                  disabledColor: Color(0xFFD1D1D1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5) //设置圆角
                                      ),
                                ),
                              )
                            ],
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 16),
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Column(
                              children: [
                                //新密码
                                InputList(S.of(context).newPayPwd,
                                    S.of(context).placeNewPwd, _newPwd,
                                    isPwd: true),
                                //确认新密码
                                InputList(S.of(context).confimPayPwd,
                                    S.of(context).placeConfimPwd, _confimPwd,
                                    isShowLine: false, isPwd: true),
                                //提交
                                HsgButton.button(
                                  title: S.current.confirm,
                                  click: _boolBut()
                                      ? () {
                                          submitChangePassword();
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
              )),
        ));
  }

  //验证码输入框
  TextField otpTextField() {
    return TextField(
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      controller: _smsCode,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(6), //限制长度
      ],
      decoration: InputDecoration.collapsed(
        // 边色与边宽度
        hintText: S.current.placeSMS,
        hintStyle: TextStyle(
          fontSize: 14,
          color: HsgColors.textHintColor,
        ),
      ),
    );
  }

  //获取验证码按钮
  OutlineButton _otpButton() {
    return OutlineButton(
      onPressed: countdownTime > 0
          ? null
          : () {
              _getVerificationCode();
            },
      //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
      padding: EdgeInsets.symmetric(horizontal: 8),
      //文字颜色
      textColor: HsgColors.blueTextColor,
      borderSide: BorderSide(color: HsgColors.blueTextColor, width: 0.5),
      //画圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      disabledTextColor: HsgColors.describeText,
      disabledBorderColor: HsgColors.describeText,
      child: Text(
        countdownTime > 0
            ? '${countdownTime}s'
            : S.of(context).getVerificationCode,
        style: TextStyle(fontSize: 14),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  bool _submit() {
    if (_realName.text != '' &&
        //_cardNo.text != '' &&
        _certType != '' &&
        _phoneNo.text != '' &&
        _smsCode.text != '') {
      print('打印数据true');
      return true;
    } else {
      print('打印数据false');
      return false;
    }
  }

  //倒计时方法
  _startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  //获取验证码接口
  _getVerificationCode() async {
    HSProgressHUD.show();
    final prefs = await SharedPreferences.getInstance();
    String userAcc = prefs.getString(ConfigKey.USER_ACCOUNT);
    print('获取验证码的账号，$userAcc');

    ///smsType (string, optional): 短信类型：register-注册,login-登录, bindCard-绑卡,
    ///authentication-身份认证,findAccount-找回账号,modifyPwd-修改密码,
    ///transactionPwd-交易密码，cardLimit-卡限额
    VerificationCodeRepository()
        .sendSmsByPhone(
            SendSmsByPhoneNumberReq(_phoneNo.text, 'transactionPwd'), 'sendSms')
        .then((data) {
      _startCountdown();
      setState(() {
        _smsCode.text = '123456';
      });
      HSProgressHUD.dismiss();
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.dismiss();
    });
  }

  //验证身份信息 提交数据
  _updateLoginPassword() async {
    // RegExp postalcode1 =
    //     new RegExp(r'(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x))$');
    // if (!postalcode1.hasMatch(_certNo.text)) {
    //   Fluttertoast.showToast(msg: '请输入正确的身份证!');
    //   return;
    // }
    RegExp postalcode2 = new RegExp(r'^\d{11}$');
    if (!postalcode2.hasMatch(_phoneNo.text)) {
      Fluttertoast.showToast(msg: '请输入正确的手机号!');
      return;
    }
    isShowIdCheckout = false;
    //不调用接口
    // HSProgressHUD.show();
    // ChecInformantApiRepository()
    //     .authentication(
    //         CheckoutInformantReq(_certNo.text, _accNo, _certTypeKey,
    //             _phoneNo.text, _realName.text, _smsCode.text,''),
    //         'authentication')
    //     .then((data) {
    //   if (data.enabled == true) {
    //     isShowIdCheckout = false;
    //   }
    //   HSProgressHUD.dismiss();
    //   Fluttertoast.showToast(msg: S.current.operate_success);
    // }).catchError((e) {
    //   Fluttertoast.showToast(msg: e.toString());
    //   HSProgressHUD.dismiss();
    // });
  }

  //验证新密码非空，且一致
  bool _boolBut() {
    if (_newPwd.text != '' && _confimPwd.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //提交修改密码表单
  submitChangePassword() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);
    if (_newPwd.text != _confimPwd.text) {
      Fluttertoast.showToast(msg: S.of(context).differentPwd);
      return;
    }
    RegExp postalcode1 = new RegExp(r'^\d{6}$');
    if (!postalcode1.hasMatch(_newPwd.text)) {
      Fluttertoast.showToast(msg: S.of(context).set_pay_password_prompt);
      return;
    }
    String password = EncryptUtil.aesEncode(_confimPwd.text);
    print(password);
    HSProgressHUD.show();
    ChecInformantApiRepository()
        .setTransactionPassword(
            SetTransactionPasswordReq(
                _realName.text,
                _accNo,
                _certNo.text,
                _certTypeKey,
                password,
                _phoneNo.text,
                userID,
                true,
                _smsCode.text),
            'setTransactionPassword')
        .then((data) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(msg: S.current.operate_success);
      // Navigator.pushNamed(context, minePage);
      Navigator.pop(context);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.dismiss();
    });
  }
}

// ignore: must_be_immutable
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue,
      {this.isShowLine = true, this.isPwd = false});
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();
  final bool isShowLine;
  final bool isPwd;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(this.labText),
                Expanded(
                  child: TextField(
                    controller: this.inputValue,
                    maxLines: 1, //最大行数
                    autocorrect: true, //是否自动更正
                    autofocus: false, //是否自动对焦
                    obscureText: this.isPwd, //是否是密码
                    textAlign: TextAlign.right, //文本对齐方式
                    onChanged: (text) {
                      //内容改变的回调
                      print('change $text');
                    },
                    onSubmitted: (text) {
                      //内容提交(按回车)的回调
                      print('submit $text');
                    },
                    enabled: true, //是否禁用
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: this.placeholderText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: HsgColors.textHintColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isShowLine)
              Divider(
                  height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
          ],
        ));
  }
}

class SelectInkWell extends StatelessWidget {
  final String title;
  final String item;
  final void Function() onTap;
  SelectInkWell({Key key, this.title, this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: item == ''
                      ? Text(S.current.please_select,
                          style: TextStyle(color: HsgColors.textHintColor))
                      : Text(item),
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
          ],
        ),
      ),
    );
  }
}
