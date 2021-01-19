/**
  @desc   重置支付密码
  @author hlx
 */
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetPayPage extends StatefulWidget {
  @override
  _SetPayPageState createState() => _SetPayPageState();
}

//表单状态
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
class _SetPayPageState extends State<SetPayPage> {
  TextEditingController _newPwd = TextEditingController();
  TextEditingController _confimPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).resetPayPsd),
          elevation: 15.0,
        ),
        body: Container(
          color: HsgColors.commonBackground,
          child: Form(
              //绑定状态属性
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(S.of(context).plaseSetPayPsd),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
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
                  Container(
                    margin: EdgeInsets.all(40), //外边距
                    height: 44.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text(S.of(context).submit),
                      onPressed: _submit()
                          ? () {
                              _submitData();
                            }
                          : null,
                      color: HsgColors.accent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5) //设置圆角
                          ),
                    ),
                  )
                ],
              )),
        ));
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
    if (_newPwd.text != _confimPwd.text) {
      Fluttertoast.showToast(msg: S.of(context).differentPwd);
    } else {
      HSProgressHUD.show();
      // final prefs = await SharedPreferences.getInstance();
      // String userID = prefs.getString(ConfigKey.USER_ID);
      // PaymentPwdRepository()
      //     .updateTransPassword(
      //   SetPaymentPwdReq(_oldPwd.text, _newPwd.text, userID, _sms.text),
      //   'updateTransPassword',
      // )
      //     .then((data) {
      //   HSProgressHUD.showError(status: '密码修改成功');
      //   Navigator.pop(context);
      //   HSProgressHUD.dismiss();
      // }).catchError((e) {
      //   // Fluttertoast.showToast(msg: e.toString());
      //   HSProgressHUD.showError(status: e.toString());
      //   print('${e.toString()}');
      // });
    }
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
          Text(this.labText),
          Expanded(
            child: TextField(
              controller: this.inputValue,
              maxLines: 1, //最大行数
              autocorrect: true, //是否自动更正
              autofocus: true, //是否自动对焦
              obscureText: true, //是否是密码
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
