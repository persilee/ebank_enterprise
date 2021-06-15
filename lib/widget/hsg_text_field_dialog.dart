import 'package:ebank_mobile/config/hsg_colors.dart';
import 'package:ebank_mobile/data/source/model/account/check_sms.dart';
import 'package:ebank_mobile/generated/l10n.dart';
import 'package:ebank_mobile/http/retrofit/api/api_client_account.dart';
import 'package:ebank_mobile/widget/hsg_otp_button.dart';
import 'package:ebank_mobile/widget/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HsgTipsDialog extends StatelessWidget {
  final Widget title;
  final Widget child;
  final VoidCallback confirmCallback;

  HsgTipsDialog({this.title, this.child, this.confirmCallback});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Center(
        child: this.title ??
            Text(
              S.current.prompt,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
          child: Center(
            child: this.child ?? Text('this is content'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey.withOpacity(0.3), width: 1.0)),
          ),
          child: Row(
            children: [
              Expanded(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.current.field_dialog_cancel,
                  style: TextStyle(fontSize: 14.0, color: Colors.black38),
                ),
              )),
              Expanded(
                  child: TextButton(
                onPressed: this.confirmCallback,
                child: Text(
                  S.current.field_dialog_confirm,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: HsgColors.accent,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

class HsgTextFieldDialog extends StatelessWidget {
  final String areaCode;
  final String phoneNum;
  final TextEditingController editingController;
  final Function(String otpStr) returnOtpStrFunc;

  const HsgTextFieldDialog({
    Key key,
    this.areaCode,
    this.phoneNum,
    @required this.editingController,
    this.returnOtpStrFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String showPhone = this.phoneNum != null ? this.phoneNum : '';
    String showAreaCode = this.areaCode != null ? this.areaCode : '';
    bool isClickOtpBtn = false;

    ///校验短信验证码
    _checkSms() async {
      HSProgressHUD.show();
      //请求验证手机号验证码，成功后跳转到身份验证界面
      RegExp number_6 = new RegExp(r'^\d{6}$');
      if (!number_6.hasMatch(this.editingController.text)) {
        HSProgressHUD.showToastTip(
          S.current.sms_error,
        );
      } else {
        //校验短信验证码
        ApiClientAccount()
            .checkSms(CheckSmsReq(
                showPhone, 'modifyPwd', this.editingController.text, 'MB'))
            .then((data) {
          HSProgressHUD.dismiss();
          this.returnOtpStrFunc(this.editingController.text ?? '');
          Navigator.pop(context);
        }).catchError((e) {
          HSProgressHUD.showToast(e);
        });
      }
    }

    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Center(
        child: Text(
          S.current.field_dialog_title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: HsgColors.firstDegreeText,
          ),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: [
                  Text(
                    S.current.field_dialog_phone_number,
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    '+' + showAreaCode + ' ' + showPhone,
                    style: TextStyle(fontSize: 14.0, color: Colors.black38),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.6), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: this.editingController,
                        onChanged: (String input) {
                          print(input);
                        },
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w300,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9]")), //纯数字
                          LengthLimitingTextInputFormatter(6),
                        ],
                        //输入文本的样式
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          border: InputBorder.none,
                          hintText: S.current.field_dialog_hint_text,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 14),
                    ),
                    HSGOTPButton(
                      'sendSms',
                      isCutdown: true,
                      otpCallback: () {
                        isClickOtpBtn = true;
                      },
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       print('发送验证码');
                    //     },
                    //     child: Text(
                    //       S.current.field_dialog_send,
                    //       style: TextStyle(
                    //         color: Colors.blueAccent,
                    //         fontSize: 15,
                    //       ),
                    //     ))
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 26)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.grey.withOpacity(0.3), width: 1.0)),
          ),
          child: Row(
            children: [
              Expanded(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.current.field_dialog_cancel,
                  style: TextStyle(fontSize: 14.0, color: Colors.black38),
                ),
              )),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    print('校验验证码');
                    if (isClickOtpBtn) {
                      _checkSms();
                    } else {
                      HSProgressHUD.showToastTip(
                        S.of(context).place_get_otp_tip,
                      );
                    }
                  },
                  child: Text(
                    S.current.field_dialog_confirm,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: HsgColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
