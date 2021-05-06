import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/set_transaction_password.dart';
/**
  @desc   设置交易密码
  @author hlx
 */
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_password.dart';
import 'package:ebank_mobile/page_route.dart';
import 'package:ebank_mobile/util/encrypt_util.dart';
import 'package:ebank_mobile/util/small_data_store.dart';
import 'package:ebank_mobile/widget/custom_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPayPage extends StatefulWidget {
  @override
  _SetPayPageState createState() => _SetPayPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SetPayPageState extends State<SetPayPage> {
  TextEditingController _newPwd = TextEditingController();
  TextEditingController _confimPwd = TextEditingController();

  var _certificateNo = '';
  var _certificateType = '';
  var _phoneNumber = '';
  var _userId = '';
  var _areaCode = '';
  var _userAccount = '';
  var _smsCode = '';

  @override
  void initState() {
    super.initState();
    _newPwd.addListener(() {
      setState(() {});
    });
    _confimPwd.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Map map = ModalRoute.of(context).settings.arguments;
      if (map != null) {
        _certificateNo = map['certificateNo'];
        _certificateType = map['certificateType'];
        _areaCode = map['areaCode'];
        _phoneNumber = map['phoneNumber'];
        _smsCode = map['smsCode'] ?? '';
      }
    });
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).resetPayPsd),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: HsgColors.commonBackground,
          child: Form(
            //绑定状态属性
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16, top: 16),
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          S.of(context).plaseSetPayPsd,
                          style:
                              TextStyle(color: Color(0xEE7A7A7A), fontSize: 13),
                        ),
                      ),
                      //新密码
                      InputList(S.of(context).newPayPwd,
                          S.of(context).placeNewPwd, _newPwd),
                      Divider(
                          height: 1,
                          color: HsgColors.divider,
                          indent: 3,
                          endIndent: 3),
                      //确认新密码
                      InputList(S.of(context).confimPayPwd,
                          S.of(context).placeConfimPwd, _confimPwd),
                    ],
                  ),
                ),
                //提交
                CustomButton(
                  margin: EdgeInsets.all(40),
                  text: Text(
                    S.of(context).next_step,
                    style: TextStyle(color: Colors.white),
                  ),
                  isEnable: _submit(),
                  clickCallback: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _submitData();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _submit() {
    if (_newPwd.text != '' && _confimPwd.text != '') {
      return true;
    } else {
      return false;
    }
  }

  //提交按钮
  _submitData() async {
    if (_newPwd.text == null || _newPwd.text == '') {
      HSProgressHUD.showToastTip(
        S.of(context).please_input_the_payment_password,
      );
      return;
    }
    if (_newPwd.text != _confimPwd.text) {
      HSProgressHUD.showToastTip(
        S.of(context).differentPwd,
      );
      return;
    }
    if (_newPwd.text.length != 6) {
      HSProgressHUD.showToastTip(
        S.of(context).set_pay_password_prompt,
      );
      return;
    }
    //是否是相同的数字
    bool isEqual = false;
    String firstNum = _newPwd.text.substring(0, 1);
    String tempText = _newPwd.text;
    for (var i = 0; i < _newPwd.text.length; i++) {
      String tempNum = tempText.substring(i, i + 1);
      print(i);
      if (tempNum == firstNum) {
        //相等
        firstNum = tempNum;
        isEqual = true;
      } else {
        //不想等
        isEqual = false;
        break;
      }
    }
    if (isEqual == true) {
      HSProgressHUD.showToastTip(
        S.current.set_pay_password_isEqual,
      );
      return;
    }

    //正则校验是否是连续的数字
    RegExp _regularnumber = new RegExp(
        r'[(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){2}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){2})\\d]'); //正则
    if (_regularnumber.hasMatch(_newPwd.text)) {
      Fluttertoast.showToast(
        msg: S.current.set_pay_password_regular,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    HSProgressHUD.show();
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString(ConfigKey.USER_ID);
    _userAccount = prefs.getString(ConfigKey.USER_ACCOUNT);
    String password = EncryptUtil.aesEncode(_confimPwd.text);
    print(password);
    HSProgressHUD.show();
    ApiClientPassword()
        .setTransactionPassword(
      SetTransactionPasswordReq(_certificateNo, _certificateType, password,
          _phoneNumber, _userId, _userAccount, false, _smsCode, '', ''),
    )
        .then((data) {
      HSProgressHUD.dismiss();
      prefs.setBool(ConfigKey.USER_PASSWORDENABLED, true);
      Navigator.of(context)..pop()..pop(); //..pop();
      // Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, pagePwdOperationSuccess);
    }).catchError((e) {
      HSProgressHUD.showToast(e.error);
    });
  }
}

//封装一行
class InputList extends StatelessWidget {
  InputList(this.labText, this.placeholderText, this.inputValue);
  final String labText;
  final String placeholderText;
  TextEditingController inputValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 180,
            child: Text(this.labText),
          ),
          Expanded(
            child: TextField(
              controller: this.inputValue,
              maxLines: 1, //最大行数
              keyboardType: TextInputType.number,
              autocorrect: true, //是否自动更正
              autofocus: true, //是否自动对焦
              obscureText: true, //是否是密码
              textAlign: TextAlign.right, //文本对齐方式
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")), //纯数字
                LengthLimitingTextInputFormatter(6), //限制长度
              ],
              onChanged: (text) {
                //内容改变的回调
                // print('change $text');
              },
              onSubmitted: (text) {
                //内容提交(按回车)的回调
                // print('submit $text');
              },
              enabled: true, //是否禁用
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.placeholderText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: HsgColors.textHintColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
