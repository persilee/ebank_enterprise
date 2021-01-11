import 'package:ebank_mobile/config/hsg_text_style.dart';

/// Copyright (c) 2020 深圳高阳寰球科技有限公司
/// 重置支付密码--身份证验证
/// Author: hlx
/// Date: 2020-12-31
import 'package:ebank_mobile/data/source/card_data_repository.dart';
import 'package:ebank_mobile/data/source/mine_checInformantApi.dart';
import 'package:ebank_mobile/data/source/model/checkout_informant.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/hsg_dialog.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:ebank_mobile/data/source/model/get_verification_code.dart';
import 'package:ebank_mobile/data/source/verification_code_repository.dart';

class IdIardVerificationPage extends StatefulWidget {
  @override
  _IdIardVerificationPageState createState() => _IdIardVerificationPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _IdIardVerificationPageState extends State<IdIardVerificationPage> {
  TextEditingController _cardNo = TextEditingController(); //卡号
  TextEditingController _certNo = TextEditingController(); //证件号
  TextEditingController _certType = TextEditingController(); //证件类型
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _realName = TextEditingController();
  TextEditingController _smsCode = TextEditingController();
  Timer _timer;
  int countdownTime = 0;
  TextEditingController userAccount = TextEditingController();
  List<String> _accList = []; //账号列表
  List<String> _accIcon = [];
  String _accNo = '';
  int _accNoId = -1;

  //证件信息
  List<String> idInformation = ['身份证', '护照'];
  @override
  // ignore: must_call_super
  void initState() {
    // 网络请求
    _getUserCardList();
  }

  //账户列表
  _getUserCardList() async {
    CardDataRepository().getCardList('getCardList').then((data) {
      if (data.cardList != null) {
        setState(() {
          _accList.clear();
          _accIcon.clear();
          data.cardList.forEach((item) {
            _accList.add(item.cardNo);
            _accIcon.add(item.imageUrl);
          });
        });
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
            icons: _accIcon,
            lastSelectedPosition: _accNoId,
          );
        });
    if (result != null && result != false) {
      setState(() {
        _accNoId = result;
        _accNo = _accList[_accNoId];
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

  //选择国家地区
  _selectDocumentType() async {
    final result = await showHsgBottomSheet(
        context: context,
        builder: (context) {
          return BottomMenu(
            title: S.of(context).idType,
            items: idInformation,
          );
        });
    print('弹窗显示的结果');
    setState(() {
      _certType = result;
    });
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
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 50,
                      padding: CONTENT_PADDING,
                      margin: EdgeInsets.only(bottom: 12),
                      child: SelectInkWell(
                        title: S.current.account_number,
                        item: _accNo,
                        onTap: _accountBottomSheet,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 16),
                      padding: CONTENT_PADDING,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 10.0, bottom: 1.0),
                            child: Text(
                              S.of(context).pleaseFillInTheBankInformation,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          //姓名
                          InputList(S.of(context).name, S.of(context).placeName,
                              _realName),
                          //证件类型
                          InputList(S.of(context).idType,
                              S.of(context).placeIdType, _certType),

                          //证件类型
                          // Container(
                          // height: 50.0,
                          // child: Column(
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Text(S.of(context).idType),
                          //            Expanded(
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         _selectDocumentType();
                          //         print('选择账号');
                          //       },
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: [
                          //           Container(
                          //             margin: EdgeInsets.only(top: 5),
                          //             child: Text(
                          //               _certType.text == '' ? S.current.please_select : '请选择1',
                          //               style: '请选择证件' == S.current.please_select
                          //                   ? TextStyle(
                          //                       color: HsgColors.secondDegreeText,
                          //                       fontSize: 15,
                          //                     )
                          //                   : TextStyle(
                          //                       color: HsgColors.firstDegreeText,
                          //                       fontSize: 15,
                          //                     ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          //   Container(
                          //     margin: EdgeInsets.only(top: 7, left: 5),
                          //     child: Icon(
                          //       Icons.arrow_forward_ios,
                          //       color: HsgColors.firstDegreeText,
                          //       size: 16,
                          //     ),
                          //   ),
                          //       ],
                          //     ),
                          //     Divider(
                          //         height: 1, color: HsgColors.divider, indent: 3, endIndent: 3),
                          //   ],
                          // )),

                          //证件号码
                          InputList(S.of(context).IdentificationNumber,
                              S.of(context).placeIdNumber, _certNo),
                          //预留手机号
                          InputList(S.of(context).reservedMobilePhoneNumber,
                              S.of(context).placeReveredMobilePhone, _phoneNo),

                          //短信验证码
                          Container(
                            height: 50,
                            child: Row(
                              children: [
                                Text(S.of(context).sendmsm),
                                Expanded(
                                  child: otpTextField(),
                                ),
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
                            borderRadius: BorderRadius.circular(5) //设置圆角
                            ),
                      ),
                    )
                  ],
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
        _certType.text != '' &&
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
    VerificationCodeRepository()
        .sendSmsByAccount(
            SendSmsByAccountReq('modifyPwd', userAcc), 'SendSmsByAccountReq')
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

//                         _certNo = TextEditingController(); //证件号
//   TextEditingController _certType = TextEditingController(); //证件类型
//   TextEditingController _phoneNo = TextEditingController();
//   TextEditingController _realName = TextEditingController();
//   TextEditingController _smsCode = TextEditingController();
  //验证身份信息
  _updateLoginPassword() async {
    print('object');
    //  TextEditingController _certType = TextEditingController(); //证件类型
    // TextEditingController _phoneNo = TextEditingController();
    // TextEditingController _realName = TextEditingController();
    // TextEditingController _smsCode = TextEditingController();
    print('1111_certType,$_certType.text');
    HSProgressHUD.show();
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString(ConfigKey.USER_ID);

    //         @JsonKey(name: 'certNo') //证件号
    // String certNo;
    // @JsonKey(name: 'cardNo') //卡号
    // String cardNo;
    // @JsonKey(name: 'certType') //证件类型
    // String certType;
    //  @JsonKey(name: 'phoneNo')
    // String phoneNo;
    // @JsonKey(name: 'realName')
    // String realName;
    // @JsonKey(name: 'smsCode')

    ChecInformantApiRepository()
        .authentication(
            CheckoutInformantReq(_certNo.text, '卡号', _certType.text,
                _phoneNo.text, _realName.text, _smsCode.text),
            'authentication')
        .then((data) {
      HSProgressHUD.dismiss();
      Fluttertoast.showToast(msg: S.current.operate_success);
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      HSProgressHUD.dismiss();
    });
    //
  }
}

// ignore: must_be_immutable
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue);
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();

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
                    obscureText: false, //是否是密码
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
                image:
                    AssetImage('images/home/listIcon/home_list_more_arrow.png'),
                width: 7,
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
